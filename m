Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 380541F8F11;
	Wed,  6 Nov 2024 12:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897245; cv=none; b=BlHhHnxokWi+ko2rwC0SWWeP8g8dkCIAuwperk2tj7JNAjzyCw6gXaMrLY6rV4HnmUl/8NOF7WEMHHdgq+EfINF7iMb9No79EIqbueT3TLdskHP2rzYQBrhbM/zBkFSLkQnqAhYbGLhh8YP7dHSun3OdRAdR0gY6DPNmO9yMoZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897245; c=relaxed/simple;
	bh=yN9L43B7hiE0Ez3YZoHBVQZbecXrfibceZCVtuPc+a4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YnsNLWlR06SWJakl0Nc0Gf7iHidjWENMa5G1InKAKgDTieO5XdJNC5PGrH/rnNH1xD/Nv+DiXnG97uMMmrVPigcTBa00JUkiL8qaOwJvCG9fStCDfOD/K/Q5LiMyPJTlcEn+ZHO1aSZlLzAMtQ2/9bfz23YqfrytMzmXT6HxuH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gagWKh1R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gagWKh1R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56021C4CECD;
	Wed,  6 Nov 2024 12:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897244;
	bh=yN9L43B7hiE0Ez3YZoHBVQZbecXrfibceZCVtuPc+a4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gagWKh1RaP302XW7JA+m8SKhwfiA33Ld/gE6A1u7S/cedkTYCKUoYmYz51wIw6Ejw
	 457rM+FvbbuhiscTAscQ+M5HHvZYK3/u4E90uq7byWRLskFHW99qRMrsmjBYGmWATu
	 82gVYcVM6dDRwXECiP4mcly1Z+1MDmC5OGgmNF0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 078/126] iio: light: veml6030: fix microlux value calculation
Date: Wed,  6 Nov 2024 13:04:39 +0100
Message-ID: <20241106120308.191625975@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


