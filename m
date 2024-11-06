Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94811E1037;
	Wed,  6 Nov 2024 12:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897577; cv=none; b=HlUQY97cDePI+b9HF3TcsinfbVd5f69BjJH7/xPEVzhxHz+FcdOrEHkHCWucxhqK0NVIPG9Ym47v9C5cT+2k3Yjgs8ghzm400kpbhmCCf7dj7s3QgM+psCW6umd4/7HluNlvYBUjlwHzkbgfyMR+KJ1AcdRnq5/p9liVfh2F/sU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897577; c=relaxed/simple;
	bh=4m4WENZWwyr01K6itWog8klejy0MOmEL3nO4ZjXH2Mk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZJFJiI9Jp81RhCeif+pzes7TE4qpLlfsEtBwBRmp8+aIjajmPIxmq8guWU+MmgggJTgHSbczFfEn8jPmjyvRnhIRBYF2OZ93VYuXKjM/WlI6NsP4bF9DZhKPsAeNnzdVWjXzRxNeYmERkXhfgDlBMqRrzmXVkH0AnW5y/1AaSu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cQZ/dgsB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cQZ/dgsB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3132AC4CECD;
	Wed,  6 Nov 2024 12:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897577;
	bh=4m4WENZWwyr01K6itWog8klejy0MOmEL3nO4ZjXH2Mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cQZ/dgsBojDo/jPkvy9EUFCmBwry1EK5fW0p1bMvUIbtrl+oktm13Ilb38uEX5HZJ
	 C0+rB60cNMDwWMbis/hnyqH1YJA/TkI2LGIo+kmzt0TlRtrpHeTzVwxMF5AGHWFTI0
	 XA6b7fwQYCVn13vwgcGPoS6z5u7BXS5m0i6wQ4Yc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 100/151] iio: light: veml6030: fix microlux value calculation
Date: Wed,  6 Nov 2024 13:04:48 +0100
Message-ID: <20241106120311.625985643@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit 63dd163cd61dda6f38343776b42331cc6b7e56e0 upstream.

The raw value conversion to obtain a measurement in lux as
INT_PLUS_MICRO does not calculate the decimal part properly to display
it as micro (in this case microlux). It only calculates the module to
obtain the decimal part from a resolution that is 10000 times the
provided in the datasheet (0.5376 lux/cnt for the veml6030). The
resulting value must still be multiplied by 100 to make it micro.

This bug was introduced with the original implementation of the driver.

Only the illuminance channel is fixed becuase the scale is non sensical
for the intensity channels anyway.

Cc: stable@vger.kernel.org
Fixes: 7b779f573c48 ("iio: light: add driver for veml6030 ambient light sensor")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20241016-veml6030-fix-processed-micro-v1-1-4a5644796437@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/veml6030.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/light/veml6030.c
+++ b/drivers/iio/light/veml6030.c
@@ -522,7 +522,7 @@ static int veml6030_read_raw(struct iio_
 			}
 			if (mask == IIO_CHAN_INFO_PROCESSED) {
 				*val = (reg * data->cur_resolution) / 10000;
-				*val2 = (reg * data->cur_resolution) % 10000;
+				*val2 = (reg * data->cur_resolution) % 10000 * 100;
 				return IIO_VAL_INT_PLUS_MICRO;
 			}
 			*val = reg;


