Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3203D35C6B2;
	Sat, 12 Sep 2026 09:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205798; cv=none; b=ABW65m+zyBEa3pp0Ds0V0ZjmYVCXMWLE9vU43zXiK/bOHBjVdSD95V5LUPiX+HWXPAIIopOTQXlNNCHlK+Stvye0xhol6jywYbWsyaaYNMtYoatGsYXZGXP/HV8DrpFwGqHmF77lYAUZNZa3h5GJLBGBFiy0IUfC+3v6Pb+NL5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205798; c=relaxed/simple;
	bh=J8CIQJCSc541944EI5ihb0ifxqtTliS/XpruO1bCK/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aO1dXHZL/1o+ZjLH8KYsG43WCp99YbwgkglYdchlmT+nY3qT0Fp1OKimKa4ppXUG5ZAQvw6olIAKSRZDeONjFyx4m7cvdrfkfe0/l959/EPn9L03u7tWHSXLcEEWJvr/CEU2j48bvOdSz4fxrjKw/4W0zF+97cpPpi75CK7JWKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TE4TvEn0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TE4TvEn0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29FDC1F000FF;
	Sat, 12 Sep 2026 09:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205797;
	bh=FPZVA4/NiOyuLYOw42K6xwUZ2AIdPQMIs39gpsQJs2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TE4TvEn0Gc6QUH+toUEK2nRWek9eNGXn+gglVZk+3U9AvoO/qNaDKuFuj/8gBoZXM
	 2a6X/nS8/5QXqtCL4DJCGXM8Wrr6J6zXmpgRIyTfDyR754aSrfyvknlKZ2rWEjfxxy
	 HGfgjOfMUxppVth/OU9DL1MHAyeQy24HmPK3dbZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Muhammad Bilal <meatuni001@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0074/1518] staging: sm750fb: fix mono image source stride mismatch in lynxfb_ops_imageblit()
Date: Sat, 12 Sep 2026 08:37:23 +0200
Message-ID: <20260912065625.134328037@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Muhammad Bilal <meatuni001@gmail.com>

[ Upstream commit cc7cd2a9228175c975f62ad56ed7c767701cb4fa ]

sm750_hw_imageblit() advances its monochrome source pointer by
src_delta per scanline, and computes the correct rounded-up stride
internally as:

        bytes_per_scan = (width + start_bit + 7) / 8;

Its only caller, lynxfb_ops_imageblit(), instead passed src_delta as
image->width >> 3. For widths not a multiple of 8 this under-counted
the stride, so the source pointer fell further behind the real
per-scanline layout on every line, corrupting the rendered image.

Rather than just fixing the caller's calculation, remove src_delta
as a parameter entirely and have sm750_hw_imageblit() advance by the
bytes_per_scan it already computes for itself. There has only ever
been one caller, and that caller was passing an out-of-sync
derivative of the same width/start_bit values sm750_hw_imageblit()
already has, so keeping stride as a separate parameter served no
purpose beyond letting the two calculations drift apart, which is
exactly what happened here.

Rounding up, rather than down, is the direction consistent with the
rest of the fbdev core: struct fb_image mono bitmap data (the same
image->data this driver receives) is walked elsewhere with byte
strides derived from a ceiling division of width by 8. The generic
mono bit iterator in drivers/video/fbdev/core/fb_imageblit.h advances
scanlines with "iter->data += BITS_TO_BYTES(iter->width)", and
BITS_TO_BYTES() (include/linux/bitops.h) is a ceiling division.
sm750_hw_imageblit()'s own "(width + start_bit + 7) / 8" is that same
ceiling division with an added start_bit offset, so the caller's
">> 3" (floor) was the one calculation out of step with how this data
layout is handled everywhere else.

Found by code review of sm750_hw_imageblit()'s internal stride
calculation against what its only caller was passing in, and
confirmed with a clean -Werror build. I do not have this hardware,
so this has not been exercised at runtime on real sm750 silicon.

Fixes: 81dee67e215b2 ("staging: sm750fb: add sm750 to staging")
Cc: stable@vger.kernel.org
Reviewed-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
Link: https://patch.msgid.link/20260901113031.161610-1-meatuni001@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ Adapted the patch to the older sm750fb variable names. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/sm750fb/sm750.c       |    2 +-
 drivers/staging/sm750fb/sm750.h       |    2 +-
 drivers/staging/sm750fb/sm750_accel.c |    6 ++----
 drivers/staging/sm750fb/sm750_accel.h |    4 +---
 4 files changed, 5 insertions(+), 9 deletions(-)

--- a/drivers/staging/sm750fb/sm750.c
+++ b/drivers/staging/sm750fb/sm750.c
@@ -273,7 +273,7 @@ static void lynxfb_ops_imageblit(struct
 	spin_lock(&sm750_dev->slock);
 
 	sm750_dev->accel.de_imageblit(&sm750_dev->accel,
-				      image->data, image->width >> 3, 0,
+				      image->data, 0,
 				      base, pitch, bpp,
 				      image->dx, image->dy,
 				      image->width, image->height,
--- a/drivers/staging/sm750fb/sm750.h
+++ b/drivers/staging/sm750fb/sm750.h
@@ -73,7 +73,7 @@ struct lynx_accel {
 			   u32 rop2);
 
 	int (*de_imageblit)(struct lynx_accel *accel, const char *p_srcbuf,
-			    u32 src_delta, u32 start_bit, u32 d_base, u32 d_pitch,
+			    u32 start_bit, u32 d_base, u32 d_pitch,
 			    u32 byte_per_pixel, u32 dx, u32 dy, u32 width,
 			    u32 height, u32 f_color, u32 b_color, u32 rop2);
 
--- a/drivers/staging/sm750fb/sm750_accel.c
+++ b/drivers/staging/sm750fb/sm750_accel.c
@@ -300,8 +300,6 @@ static unsigned int deGetTransparency(st
  * sm750_hw_imageblit
  * @accel: Acceleration device data
  * @pSrcbuf: pointer to start of source buffer in system memory
- * @srcDelta: Pitch value (in bytes) of the source buffer, +ive means top down
- *	      and -ive mean button up
  * @startBit: Mono data can start at any bit in a byte, this value should be
  *	      0 to 7
  * @dBase: Address of destination: offset in frame buffer
@@ -316,7 +314,7 @@ static unsigned int deGetTransparency(st
  * @rop2: ROP value
  */
 int sm750_hw_imageblit(struct lynx_accel *accel, const char *pSrcbuf,
-		       u32 srcDelta, u32 startBit, u32 dBase, u32 dPitch,
+		       u32 startBit, u32 dBase, u32 dPitch,
 		       u32 bytePerPixel, u32 dx, u32 dy, u32 width,
 		       u32 height, u32 fColor, u32 bColor, u32 rop2)
 {
@@ -405,7 +403,7 @@ int sm750_hw_imageblit(struct lynx_accel
 			write_dpPort(accel, *(unsigned int *)ajRemain);
 		}
 
-		pSrcbuf += srcDelta;
+		pSrcbuf += ulBytesPerScan;
 	}
 
 	return 0;
--- a/drivers/staging/sm750fb/sm750_accel.h
+++ b/drivers/staging/sm750fb/sm750_accel.h
@@ -220,8 +220,6 @@ int sm750_hw_copyarea(struct lynx_accel
 /**
  * sm750_hw_imageblit
  * @pSrcbuf: pointer to start of source buffer in system memory
- * @srcDelta: Pitch value (in bytes) of the source buffer, +ive means top down
- *>-----      and -ive mean button up
  * @startBit: Mono data can start at any bit in a byte, this value should be
  *>-----      0 to 7
  * @dBase: Address of destination: offset in frame buffer
@@ -236,7 +234,7 @@ int sm750_hw_copyarea(struct lynx_accel
  * @rop2: ROP value
  */
 int sm750_hw_imageblit(struct lynx_accel *accel, const char *pSrcbuf,
-		       u32 srcDelta, u32 startBit, u32 dBase, u32 dPitch,
+		       u32 startBit, u32 dBase, u32 dPitch,
 		       u32 bytePerPixel, u32 dx, u32 dy, u32 width,
 		       u32 height, u32 fColor, u32 bColor, u32 rop2);
 


