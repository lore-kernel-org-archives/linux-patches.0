Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3456624A07D;
	Tue, 29 Apr 2025 17:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947521; cv=none; b=Ig0XV03XZzzx7Db5uIBA8EZTtrFBOrSheEMGN+Lyw4S4Tjwy3odwJJPFN2D5ZS+8pDIiiWfzgZlBBc4L9Nuhvg4xB6WiqKTsjT/cmKt2krA0/4h5yFfw5j/iPKqF/dLA9xVO50ee1Yh2pW4lPi72kPl8clNu/EWgeJDUBf2N3e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947521; c=relaxed/simple;
	bh=4ldphUXRr9kIfu+WEqbBLKyTgqoQ2rGDav7VPt75wX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L/w77dQXhGQdXPjrkhc1VP7Nr8bllVBMTtXVbp220R4sl8TDnRxr2Z49LPCfdA2Q0YJlOo5Tv7PqMxc/oFaAzQVSm1s+tLk+g7xFDtU567SojFvZQ9oQyl7176MubUYfLna5zJ4i7ocRvDr1kOBreNUfkNEW5wC9T9bmX4dJxpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y9/F+wWw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y9/F+wWw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90507C4CEE3;
	Tue, 29 Apr 2025 17:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947521;
	bh=4ldphUXRr9kIfu+WEqbBLKyTgqoQ2rGDav7VPt75wX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y9/F+wWwGTOBUmjzi0ZGjJut8mGu5rKXIrrB+rW18EJ7GIuTzDaJ6y3DmjZju9xOf
	 2W31p2TLdTKv6O5K9J4mcRZmVht2uZjgK+BlVJyz0TumyAto07lFmSSyirJnbXcWq/
	 g7UT3H8lv3QcIyjlNlfQDl/Xtjk8BKK1cXAYTajE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 021/280] iio: adc: ad7768-1: Move setting of val a bit later to avoid unnecessary return value check
Date: Tue, 29 Apr 2025 18:39:22 +0200
Message-ID: <20250429161115.962267533@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit 0af1c801a15225304a6328258efbf2bee245c654 ]

The data used is all in local variables so there is no advantage
in setting *val = ret with the direct mode claim held.
Move it later to after error check.

Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Link: https://patch.msgid.link/20250217141630.897334-13-jic23@kernel.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: 8236644f5ecb ("iio: adc: ad7768-1: Fix conversion result sign")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7768-1.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/iio/adc/ad7768-1.c b/drivers/iio/adc/ad7768-1.c
index 6f8816483f1a0..c78243a68b6e0 100644
--- a/drivers/iio/adc/ad7768-1.c
+++ b/drivers/iio/adc/ad7768-1.c
@@ -370,12 +370,11 @@ static int ad7768_read_raw(struct iio_dev *indio_dev,
 			return ret;
 
 		ret = ad7768_scan_direct(indio_dev);
-		if (ret >= 0)
-			*val = ret;
 
 		iio_device_release_direct_mode(indio_dev);
 		if (ret < 0)
 			return ret;
+		*val = ret;
 
 		return IIO_VAL_INT;
 
-- 
2.39.5



