Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0D64268C6F;
	Tue,  8 Apr 2025 11:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111557; cv=none; b=QaxMa55w3W2fHdbH837ABdRnJSnvQBnWX2SAZc3whcHYbltB/9PpbVVkMIozg05mQBU9fF5lEJYfsF2ANroS4TtwIPowWVXoVa7hVMA6U6N7R/gpZFPSRc0xBNPkO7SxIBc4ZBlw0j4aCvl7KyMOfsHbmAw4H7hHI6oRTlmRKdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111557; c=relaxed/simple;
	bh=ZWxebfR+gUINz4kshKB2wQ2AwX3RYOTtoyOe+BKMYR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fwr84Ptck2elC9nOxrYROHtQsBb2VH/y6xZtLFoeidvSX7csUpeaDJm+4u4SQuWbf+j+R5R+YSB1H1cu7yNrKScdMuwWGYKU72bOHdp0xrkLJbIbn85iNpHRup4nK1KakwO9XrDW+IYEqJDP3GuT6S3WEFk2pz9E+pDQNYjM/Oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MJdC20ND; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MJdC20ND"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4329C4CEE5;
	Tue,  8 Apr 2025 11:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111557;
	bh=ZWxebfR+gUINz4kshKB2wQ2AwX3RYOTtoyOe+BKMYR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MJdC20NDZiVZ8nUhhrxGgwwH83k5d9rxO1ktzMnOBUD//0aTA/p0DuTznxnzgopZn
	 +Dsh6UsiYyjyClnJcnNvJmmYc2EzXgQvw1wMd70Iz2Th8Ru9UAP94VeGVJ6q4SZW8b
	 qrLCLvGb3hk4o8exc9GiXU0qPQekqjxfMK0Y6WuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 475/731] iio: adc: ad7173: Grab direct mode for calibration
Date: Tue,  8 Apr 2025 12:46:12 +0200
Message-ID: <20250408104925.327287170@linuxfoundation.org>
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

[ Upstream commit 7021d97fb89b216557561ca8cdf68144c016993b ]

While a calibration is running, better don't make the device do anything
else.

To enforce that, grab direct mode during calibration.

Fixes: 031bdc8aee01 ("iio: adc: ad7173: add calibration support")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Link: https://patch.msgid.link/8319fa2dc881c9899d60db4eba7fe8e984716617.1740655250.git.u.kleine-koenig@baylibre.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7173.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/iio/adc/ad7173.c b/drivers/iio/adc/ad7173.c
index 6c4ed10ae580d..6645a811764fd 100644
--- a/drivers/iio/adc/ad7173.c
+++ b/drivers/iio/adc/ad7173.c
@@ -559,6 +559,9 @@ static ssize_t ad7173_write_syscalib(struct iio_dev *indio_dev,
 	if (ret)
 		return ret;
 
+	if (!iio_device_claim_direct(indio_dev))
+		return -EBUSY;
+
 	mode = st->channels[chan->channel].syscalib_mode;
 	if (sys_calib) {
 		if (mode == AD7173_SYSCALIB_ZERO_SCALE)
@@ -569,6 +572,8 @@ static ssize_t ad7173_write_syscalib(struct iio_dev *indio_dev,
 					      chan->address);
 	}
 
+	iio_device_release_direct(indio_dev);
+
 	return ret ? : len;
 }
 
-- 
2.39.5



