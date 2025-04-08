Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA3EE268C79;
	Tue,  8 Apr 2025 11:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111559; cv=none; b=J5T29Pi2i+N+ElmS897eEwCIXayqfgfLRMvSO6GzD7xYpvrAK4aS+O55qk488Nzbg8YsNiHJOf0JcJVY7lVFQct85JBN18wBOGOYeHykGBQpy2c9YMUxW0syOJYoxleJ9wxivvomFkDMTLUgUhFluUXq4aaRKHM508aupM4KOA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111559; c=relaxed/simple;
	bh=C2d3qwvgSyj0Rn6WFNxFuEvGbp+8yTaPgofXDTmiZmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V3npE4rvWY3Fm43RYojQvFM9SOEm/RUxQWpXgy4MHjGk27+9rnRrHZLuc/BnCf/RhHijQiPYZgJBrVlgZU26Qq1X9El53etrligsPFpGjMO+XDlVoky4ydqx34HOltZSRfp/b9w79jxb96v9rs3ZiDzNYbmt4z6+mvvhJSm3tPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kM0nsa0Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kM0nsa0Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5359CC4CEE5;
	Tue,  8 Apr 2025 11:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111559;
	bh=C2d3qwvgSyj0Rn6WFNxFuEvGbp+8yTaPgofXDTmiZmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kM0nsa0QU3uTR1IDlINhdIwbPh4mBAvdJ625Q3dPI17yDOKtkmHYYY1LlIsLNz6Lm
	 /3gy0aAx2sJZoRzWJ/DjOYaKg1oGhO+kGGz/QKnxOmIYkiaoDXYkpTzLPSeW2iqnDH
	 DDOvUv6gyY2rkGs+oata1gLect77UU59z0/hAEk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 476/731] iio: adc: ad7192: Grab direct mode for calibration
Date: Tue,  8 Apr 2025 12:46:13 +0200
Message-ID: <20250408104925.349704052@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@baylibre.com>

[ Upstream commit 08808b3ef384974b1eaf4975de707f93f8cda62d ]

While a calibration is running, better don't make the device do anything
else.

To enforce that, grab direct mode during calibration.

Fixes: 42776c14c692 ("staging: iio: adc: ad7192: Add system calibration support")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Link: https://patch.msgid.link/8aade802afca6a89641e24c1ae1d4b8d82cff58d.1740655250.git.u.kleine-koenig@baylibre.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7192.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/iio/adc/ad7192.c b/drivers/iio/adc/ad7192.c
index cfaf8f7e0a07d..1ebb738d99f57 100644
--- a/drivers/iio/adc/ad7192.c
+++ b/drivers/iio/adc/ad7192.c
@@ -256,6 +256,9 @@ static ssize_t ad7192_write_syscalib(struct iio_dev *indio_dev,
 	if (ret)
 		return ret;
 
+	if (!iio_device_claim_direct(indio_dev))
+		return -EBUSY;
+
 	temp = st->syscalib_mode[chan->channel];
 	if (sys_calib) {
 		if (temp == AD7192_SYSCALIB_ZERO_SCALE)
@@ -266,6 +269,8 @@ static ssize_t ad7192_write_syscalib(struct iio_dev *indio_dev,
 					      chan->address);
 	}
 
+	iio_device_release_direct(indio_dev);
+
 	return ret ? ret : len;
 }
 
-- 
2.39.5



