Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC01633
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:47:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78EBDC433C1;
	Wed,  2 Nov 2022 03:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667360874;
	bh=4ZUFj+dRzHGKVZyeomkZuS2/yNCTEOIZeDudOqzK1qU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rTOIinhPXwOoT5tLog+Y8kD5KBXcparYWRqiLp5mQb//yd7kkzFik2y/RY5OEy1Zs
	 stRgOla7516AC0nAohaijagdvWwpxTev9sDJN7lNR6mmm5mvXlvOh5Sy+nKTGNoYtA
	 2i01c1/z4qJ2E+bZQKpLvYldvRgzTWjSo+Mjc7zU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 35/44] media: vivid: dev->bitmap_cap wasnt freed in all cases
Date: Wed,  2 Nov 2022 03:35:21 +0100
Message-Id: <20221102022050.296981432@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022049.017479464@linuxfoundation.org>
References: <20221102022049.017479464@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit 1f65ea411cc7b6ff128d82a3493d7b5648054e6f ]

Whenever the compose width/height values change, the dev->bitmap_cap
vmalloc'ed array must be freed and dev->bitmap_cap set to NULL.

This was done in some places, but not all. This is only an issue if
overlay support is enabled and the bitmap clipping is used.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Fixes: ef834f7836ec ([media] vivid: add the video capture and output parts)
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/vivid/vivid-vid-cap.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index a32910ac90bd..198b26687b57 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -455,6 +455,12 @@ void vivid_update_format_cap(struct vivid_dev *dev, bool keep_controls)
 	tpg_reset_source(&dev->tpg, dev->src_rect.width, dev->src_rect.height, dev->field_cap);
 	dev->crop_cap = dev->src_rect;
 	dev->crop_bounds_cap = dev->src_rect;
+	if (dev->bitmap_cap &&
+	    (dev->compose_cap.width != dev->crop_cap.width ||
+	     dev->compose_cap.height != dev->crop_cap.height)) {
+		vfree(dev->bitmap_cap);
+		dev->bitmap_cap = NULL;
+	}
 	dev->compose_cap = dev->crop_cap;
 	if (V4L2_FIELD_HAS_T_OR_B(dev->field_cap))
 		dev->compose_cap.height /= 2;
@@ -863,6 +869,8 @@ int vivid_vid_cap_s_selection(struct file *file, void *fh, struct v4l2_selection
 	struct vivid_dev *dev = video_drvdata(file);
 	struct v4l2_rect *crop = &dev->crop_cap;
 	struct v4l2_rect *compose = &dev->compose_cap;
+	unsigned orig_compose_w = compose->width;
+	unsigned orig_compose_h = compose->height;
 	unsigned factor = V4L2_FIELD_HAS_T_OR_B(dev->field_cap) ? 2 : 1;
 	int ret;
 
@@ -979,17 +987,17 @@ int vivid_vid_cap_s_selection(struct file *file, void *fh, struct v4l2_selection
 			s->r.height /= factor;
 		}
 		v4l2_rect_map_inside(&s->r, &dev->fmt_cap_rect);
-		if (dev->bitmap_cap && (compose->width != s->r.width ||
-					compose->height != s->r.height)) {
-			vfree(dev->bitmap_cap);
-			dev->bitmap_cap = NULL;
-		}
 		*compose = s->r;
 		break;
 	default:
 		return -EINVAL;
 	}
 
+	if (dev->bitmap_cap && (compose->width != orig_compose_w ||
+				compose->height != orig_compose_h)) {
+		vfree(dev->bitmap_cap);
+		dev->bitmap_cap = NULL;
+	}
 	tpg_s_crop_compose(&dev->tpg, crop, compose);
 	return 0;
 }
-- 
2.35.1



