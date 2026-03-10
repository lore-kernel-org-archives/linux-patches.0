Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 575F73803EA;
	Tue, 10 Mar 2026 11:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141967; cv=none; b=aJEz5KH/uqdeLeNmYl5keZcxvCexq3x8m3xw5vysNsABec6vbsFEeafXuQdKCWrxg/oegpyC7P1ko4I6NR9NYcOednqEC3AG4NYc6HmaycNTR6jxD8YcrIdddaC20tiK1huVg+NiSo5KsDWTifAKfBb0xiqdx5E9UlshBWc5OFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141967; c=relaxed/simple;
	bh=jTSiQC9oqbGfXKaSWS6H02vRGlzbFECj8Q/rj0mZThc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EJQzCsGXZqcvrA41W1paB41cYImFsmUhqmsGNpMDukNThemYrbKzdlw1+kK5y21hkYCa5FLzdyUBJp9AHxL/jEMLJthsOOqkE/mRqgy+ghJunwt9pZzBw9RTCLG+hY7rySy5VemP1i1fl7pKJuQT8DTIQlSut0MAjl+tnJGKEAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H8rd/wjt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H8rd/wjt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 949F8C2BC86;
	Tue, 10 Mar 2026 11:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141967;
	bh=jTSiQC9oqbGfXKaSWS6H02vRGlzbFECj8Q/rj0mZThc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H8rd/wjty3U7qb4aEpaRIWNqPUlemXrbqVDp5M97HSm1lQAPa7mzFGs/02A02JhCU
	 YRoqjP2b4Abyd8HGQ4WU67/t7JxQRu6ecz3bYwBrUHmN1kv8/m5uk9UDEmvKO/Diq+
	 rAwPxTDeNaQyPi9+xh5hDm1dPgCb3LOsFhjCGC1B3NWKjf3NdYHHfiF1IcHAHQvsDZ
	 6WZkVJ4cEMp220LTKJHX8XdfFExk5+XmRjwiFMHE4pr4SzObuisB14jKCXCvNn0Mkn
	 aJMtLavenodSBOCf1CfsflbBHgWxDY0o4YmrNUZ0r7Zs54Z50gdCwtfFHuOiN6pzux
	 annt3wo+NpZCQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zilin Guan <zilin@seu.edu.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 091/314] media: tegra-video: Fix memory leak in __tegra_channel_try_format()
Date: Tue, 10 Mar 2026 07:15:50 -0400
Message-ID: <4b9f633e072523b4419c6a69372abb5bfb412d8e.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit 43e5302d22334f1183dec3e0d5d8007eefe2817c ]

The state object allocated by __v4l2_subdev_state_alloc() must be freed
with __v4l2_subdev_state_free() when it is no longer needed.

In __tegra_channel_try_format(), two error paths return directly after
v4l2_subdev_call() fails, without freeing the allocated 'sd_state'
object. This violates the requirement and causes a memory leak.

Fix this by introducing a cleanup label and using goto statements in the
error paths to ensure that __v4l2_subdev_state_free() is always called
before the function returns.

Fixes: 56f64b82356b7 ("media: tegra-video: Use zero crop settings if subdev has no get_selection")
Fixes: 1ebaeb09830f3 ("media: tegra-video: Add support for external sensor capture")
Cc: stable@vger.kernel.org
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/tegra-video/vi.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/media/tegra-video/vi.c b/drivers/staging/media/tegra-video/vi.c
index c9276ff76157f..14b327afe045e 100644
--- a/drivers/staging/media/tegra-video/vi.c
+++ b/drivers/staging/media/tegra-video/vi.c
@@ -438,7 +438,7 @@ static int __tegra_channel_try_format(struct tegra_vi_channel *chan,
 		.target = V4L2_SEL_TGT_CROP_BOUNDS,
 	};
 	struct v4l2_rect *try_crop;
-	int ret;
+	int ret = 0;
 
 	subdev = tegra_channel_get_remote_source_subdev(chan);
 	if (!subdev)
@@ -482,8 +482,10 @@ static int __tegra_channel_try_format(struct tegra_vi_channel *chan,
 		} else {
 			ret = v4l2_subdev_call(subdev, pad, get_selection,
 					       NULL, &sdsel);
-			if (ret)
-				return -EINVAL;
+			if (ret) {
+				ret = -EINVAL;
+				goto out_free;
+			}
 
 			try_crop->width = sdsel.r.width;
 			try_crop->height = sdsel.r.height;
@@ -495,14 +497,15 @@ static int __tegra_channel_try_format(struct tegra_vi_channel *chan,
 
 	ret = v4l2_subdev_call(subdev, pad, set_fmt, sd_state, &fmt);
 	if (ret < 0)
-		return ret;
+		goto out_free;
 
 	v4l2_fill_pix_format(pix, &fmt.format);
 	chan->vi->ops->vi_fmt_align(pix, fmtinfo->bpp);
 
+out_free:
 	__v4l2_subdev_state_free(sd_state);
 
-	return 0;
+	return ret;
 }
 
 static int tegra_channel_try_format(struct file *file, void *fh,
-- 
2.51.0

