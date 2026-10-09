Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D5234D598B;
	Fri,  9 Oct 2026 14:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556839; cv=none; b=jfJcb/5xr59TKuX6lkwjc7reXzCnoG3Ikt6SJEKW3woAYRe9i5yXj2c/lZ2UJ6jAdz/0vQB2nhm/zg8KRtRrRtQXcf1Xsksz0trfv68d4zDdLq4x2qtrIJ+WNrwYpFtLNk5HuBE8dHjmAA4NfaDug5IIO/eW2edACRbmvLZ6gpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556839; c=relaxed/simple;
	bh=jLvQGKsEa+kpxDhZrWqoYRx/bvK29Rm4iEklhglDYX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sC1qYl9V0gzcC/U1xPGbmwDKSvPZSe3Yno8jlydR/bxTj9dI7A1pjRg59t36rF1wx9GrF3G1NWPxMEV0IShcTUKgRBIkHPbuwKrfsqFRVfTiXboJSUEjbG4xQvQv5xa1EJ00CCbZvV57cFTLreM8w5vQKT+DA1THbRM/mXNiHys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wl0CxEBg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wl0CxEBg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6EA21F00893;
	Fri,  9 Oct 2026 14:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556838;
	bh=ApaorIqW2Milsv7B6Ntt90C2fwVa/4j+j+cV6Qx7AyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wl0CxEBgf6p3O7GYlZS8CeRT3dVmGqzx3oGnCuRux83acU7s5rXeuqG9sFxv+6bcZ
	 xQuTyKqIiOIx5xfGwy2Z8mGFrjc4B4Sw4zL3aRPqec1n4x2/3yUAr8RMGFOMcMM0QZ
	 qcsGWyc1O1tSwnX/hP8qFKERvUqtbR7UGEww/JrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcelo Schmitt <marcelo.schmitt@analog.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 301/403] iio: adc: ad7173: Fix digital filter configuration
Date: Fri,  9 Oct 2026 16:11:02 +0200
Message-ID: <20261009140959.250358998@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcelo Schmitt <marcelo.schmitt@analog.com>

commit 9ec6ecc95dda6d91fa6f671cd972dd4bfc05ba38 upstream.

Filter enable and filter type selection masks were swapped on data
preparation for filter configuration register write. Use the correct masks
to set each property of post filter configuration.

Fixes: ff06b39be1a1 ("iio: adc: ad7173: support changing filter type")
Signed-off-by: Marcelo Schmitt <marcelo.schmitt@analog.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7173.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iio/adc/ad7173.c
+++ b/drivers/iio/adc/ad7173.c
@@ -776,9 +776,9 @@ static int ad7173_load_config(struct ad7
 
 	return ad_sd_write_reg(&st->sd, AD7173_REG_FILTER(free_cfg_slot), 2,
 			       FIELD_PREP(AD7173_FILTER_SINC3_MAP, 0) |
-			       FIELD_PREP(AD7173_FILTER_ENHFILT_MASK,
-					  post_filter_enable) |
 			       FIELD_PREP(AD7173_FILTER_ENHFILTEN,
+					  post_filter_enable) |
+			       FIELD_PREP(AD7173_FILTER_ENHFILT_MASK,
 					  post_filter_select) |
 			       FIELD_PREP(AD7173_FILTER_ORDER, 0) |
 			       FIELD_PREP(AD7173_FILTER_ODR_MASK,


