Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2E22475F7;
	Thu, 16 Jul 2026 13:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209117; cv=none; b=FF6Z0otR8Ax0e91VCa+r4cyUhD/DtmOFEEMefA0yIym68W+xB65n+IVt5fthCh2czCKyoDtJ7PQgny65Zav/pXaiVXzZv3yIOyCj7NQv3hA5QFN2rQ0FsQ0c78c1mcIJCBi68N1gabwO4S0brgrZ6V1Guwn6L4Xe5qNupAiEAMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209117; c=relaxed/simple;
	bh=/PJij+h5a3Grjkb/r+XoBVlPujuQKB8ngHWsb/4ep84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ATpdzpssSz7FRZx4zj/GdFDGBKhVibvGCuwUugT5G2shZvPBbUVwmi6ux7NETpaNscVdhjmQ4CJJiiOJ3UL15QfCDurd0wrt3LloaxuGbRIWBldTkPELluUleuQz9+5x4z9FRho9S/HWTiB3CPX77470yEohjyL6lxAlt4TQZQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=skP2RUqy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="skP2RUqy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A36451F000E9;
	Thu, 16 Jul 2026 13:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209116;
	bh=unozpeWtl+yghvwbo+la5MS9MFHiRSMCvL/WzUkp93s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=skP2RUqy/awW0DPIpWPDpSHeWmo9V5gG6pmiNqC5Et50IEa6YFMUwH8DIOL0cORYK
	 eY493dZ+9yaCyiSwTQfmil858NK2mAuD6+4zeql9TdSQmvTG+pWHdb4W/oGe5wJLHw
	 ptbWXuriEU4Q3h+0FP8jmdGCMDwVmFd5YXaG6oe0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vidhu Sarwal <vidhu.linux@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 7.1 062/518] iio: light: al3010: fix incorrect scale for the highest gain range
Date: Thu, 16 Jul 2026 15:25:30 +0200
Message-ID: <20260716133049.138954204@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vidhu Sarwal <vidhu.linux@gmail.com>

commit aa411adc6ce40ad1a55ebc965f255a4cfc0005f8 upstream.

al3010_scales[] encodes the highest gain range as {0, 1187200}.
For IIO_VAL_INT_PLUS_MICRO, the fractional part must be less than
1000000, so the scale 1.1872 should instead be represented as
{ 1, 187200 }.

Since write_raw() compares the value from userspace against this
table, writing the advertised 1.1872 scale never matches the malformed
entry and returns -EINVAL. As a result, the highest gain range cannot
be selected. Reading the scale in that state also reports the malformed
value.

Fixes: c36b5195ab70 ("iio: light: add Dyna-Image AL3010 driver")
Signed-off-by: Vidhu Sarwal <vidhu.linux@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/al3010.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/light/al3010.c
+++ b/drivers/iio/light/al3010.c
@@ -42,7 +42,7 @@ enum al3xxxx_range {
 };
 
 static const int al3010_scales[][2] = {
-	{0, 1187200}, {0, 296800}, {0, 74200}, {0, 18600}
+	{ 1, 187200 }, { 0, 296800 }, { 0, 74200 }, { 0, 18600 },
 };
 
 static const struct regmap_config al3010_regmap_config = {


