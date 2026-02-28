Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C60175A6B;
	Sat, 28 Feb 2026 17:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301379; cv=none; b=IjlY4x/APq07+ug5BzQzjZJiI/vusd/qyHxaeVGTvwmLau9eo9f2/gIQtt2+jURu8JQJHEklvojreZzkbDSJz7zjP0tfADqYDWBRvAi3EfYB+u5bCpdoccNrVLSkfdWOsA1ADATjAuDtbmQPi6sPp1J3bQb/+nhn6orqFqVpap4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301379; c=relaxed/simple;
	bh=a3hJZWNgWrZVYYiJy1QzV0Kdi9O6boZGC5OsX+v2Esk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GcDwOPHpeE51vCRzsqSDXsLwxncKn9u88l5n7TjCdSTZy1+wsN4/toQJU+NLc8l17kPkki/x97iLjU/QZk0E3m4YV2DaANa/C5de1SG6+H5C07hYPkVBN17mli5IGqj+tHO04LIzYx9E+UbjjnJupNcztVkVfGg2uK6cuQe4V8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tuxASwoV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tuxASwoV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99E17C19424;
	Sat, 28 Feb 2026 17:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301379;
	bh=a3hJZWNgWrZVYYiJy1QzV0Kdi9O6boZGC5OsX+v2Esk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tuxASwoVmBPSMZk3R/UUxbynpzjcIf9SR4x1c5V/8HeNT15vmQ2x3+OrRBUPk1Jpw
	 0eiYDR7U4cL87iGGtS0H4Ji6sRCEFsmHmFUJ9DzGCFWoCws3+7eswuhwlA4/yvKRx6
	 d7BRgmrY9ZQRDvx0pWHQNEMCz8Jqxm3ByHyRA4d3fnAkYN38cKbu9jkdusujSaNw/L
	 2tmJ1t0/Nr1n7EFXGrD0OqhP5vEbBxxRu71/drl3UHf6cQRMS4pfFJ/jv83/6Y/fDJ
	 AQRiaKUTRv1imAtr5E/TavfdSoG8gSGA/7WUhVZZAGQVXW9Zi8vPXhZl5V4/iNxGhb
	 RJNzxIzCHoINw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ricardo Ribalda <ribalda@chromium.org>,
	Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>,
	stable@vger.kernel.org,
	Bryan O'Donoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 568/752] media: iris: Fix fps calculation
Date: Sat, 28 Feb 2026 12:44:39 -0500
Message-ID: <20260228174750.1542406-568-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit 71fe80364a6584f404556ac9a6a4aca4ab80fb5b ]

iris_venc_s_param() uses do_div to divide two 64 bits operators, this is
wrong. Luckily for us, both of the operators fit in 32 bits, so we can use
a normal division.

Now that we are at it, mark the fps smaller than 1 as invalid, the code
does not seem to handle them properly.

The following cocci warning is fixed with this patch:
./platform/qcom/iris/iris_venc.c:378:1-7: WARNING: do_div() does a 64-by-32 division, please consider using div64_u64 instead

Fixes: 4ff586ff28e3 ("media: iris: Add support for G/S_PARM for encoder video device")
Reviewed-by: Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/iris/iris_venc.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/qcom/iris/iris_venc.c b/drivers/media/platform/qcom/iris/iris_venc.c
index 099bd5ed4ae02..c11ed778cc9e9 100644
--- a/drivers/media/platform/qcom/iris/iris_venc.c
+++ b/drivers/media/platform/qcom/iris/iris_venc.c
@@ -345,8 +345,7 @@ int iris_venc_s_param(struct iris_inst *inst, struct v4l2_streamparm *s_parm)
 	struct v4l2_fract *timeperframe = NULL;
 	u32 default_rate = DEFAULT_FPS;
 	bool is_frame_rate = false;
-	u64 us_per_frame, fps;
-	u32 max_rate;
+	u32 fps, max_rate;
 
 	int ret = 0;
 
@@ -368,23 +367,19 @@ int iris_venc_s_param(struct iris_inst *inst, struct v4l2_streamparm *s_parm)
 			timeperframe->denominator = default_rate;
 	}
 
-	us_per_frame = timeperframe->numerator * (u64)USEC_PER_SEC;
-	do_div(us_per_frame, timeperframe->denominator);
-
-	if (!us_per_frame)
+	fps = timeperframe->denominator / timeperframe->numerator;
+	if (!fps)
 		return -EINVAL;
 
-	fps = (u64)USEC_PER_SEC;
-	do_div(fps, us_per_frame);
 	if (fps > max_rate) {
 		ret = -ENOMEM;
 		goto reset_rate;
 	}
 
 	if (is_frame_rate)
-		inst->frame_rate = (u32)fps;
+		inst->frame_rate = fps;
 	else
-		inst->operating_rate = (u32)fps;
+		inst->operating_rate = fps;
 
 	if ((s_parm->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE && vb2_is_streaming(src_q)) ||
 	    (s_parm->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE && vb2_is_streaming(dst_q))) {
-- 
2.51.0

