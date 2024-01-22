Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1733423D6;
	Tue, 23 Jan 2024 00:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969524; cv=none; b=qxuDO0pQdhCjdAgxYfOYsIUxYeqz4p3c01xKde36jF55awRX5aEFtpfB5jzoIhkAw45D6OWpwQj3fpBd4LvDYrF0pJBULVtXsBoys7a6k+rNvaYoOtLQNDVjEHLXA57BaVxV5BJb6jxl2MHXGCu4R2bKzLudZkMUmX/Zxsdssb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969524; c=relaxed/simple;
	bh=bpZJk6ZuMbOWU2y2UynCErRiVUSLHm7OLgwql3K1s0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WlmOJUvfhP6HIsJnn2jZbflgduVz3h9sLVf/MejDw6hTL8JR1uHjPHMmIXGG+WtuJGkPLTX1dhMWYJTxxiycgQ3rodJDShOz8Vr44+LlJLPKCj55dRmYt827igCILuQWxSm3I7EeCJF3RpfLm849zD0H7xooQxZQBJLvD9NSbBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aFKUmg76; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aFKUmg76"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49EF4C433B1;
	Tue, 23 Jan 2024 00:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969523;
	bh=bpZJk6ZuMbOWU2y2UynCErRiVUSLHm7OLgwql3K1s0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aFKUmg76ugOPE1t4c3nAypkt87ARATNLsSIWuFYc2STvzp/J01k9HlGXtHm6gzSQu
	 2Q91s23u+kXUI4RoddDvps8N0h2L7Usp8rgu3RgbzzGYuQZkaH+zGT755Rv/VTfT7l
	 TT9RP4o/ybUWycaVIN954FPpc2t/Bt8v2JNGUP3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 304/641] media: bttv: start_streaming should return a proper error code
Date: Mon, 22 Jan 2024 15:53:28 -0800
Message-ID: <20240122235827.424210389@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit 0d75bb6ae127f5e3fd0e2239714908fd2038193d ]

The start_streaming callback returned 0 or 1 instead of a
proper error code. Fix that.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Fixes: b7ec3212a73a ("media: bttv: convert to vb2")
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/bt8xx/bttv-driver.c | 6 ++----
 drivers/media/pci/bt8xx/bttv-vbi.c    | 8 +++-----
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index 09a193bb87df..8e8c9dada67a 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -1536,13 +1536,11 @@ static void buf_cleanup(struct vb2_buffer *vb)
 
 static int start_streaming(struct vb2_queue *q, unsigned int count)
 {
-	int ret = 1;
 	int seqnr = 0;
 	struct bttv_buffer *buf;
 	struct bttv *btv = vb2_get_drv_priv(q);
 
-	ret = check_alloc_btres_lock(btv, RESOURCE_VIDEO_STREAM);
-	if (ret == 0) {
+	if (!check_alloc_btres_lock(btv, RESOURCE_VIDEO_STREAM)) {
 		if (btv->field_count)
 			seqnr++;
 		while (!list_empty(&btv->capture)) {
@@ -1553,7 +1551,7 @@ static int start_streaming(struct vb2_queue *q, unsigned int count)
 			vb2_buffer_done(&buf->vbuf.vb2_buf,
 					VB2_BUF_STATE_QUEUED);
 		}
-		return !ret;
+		return -EBUSY;
 	}
 	if (!vb2_is_streaming(&btv->vbiq)) {
 		init_irqreg(btv);
diff --git a/drivers/media/pci/bt8xx/bttv-vbi.c b/drivers/media/pci/bt8xx/bttv-vbi.c
index ab213e51ec95..e489a3acb4b9 100644
--- a/drivers/media/pci/bt8xx/bttv-vbi.c
+++ b/drivers/media/pci/bt8xx/bttv-vbi.c
@@ -123,14 +123,12 @@ static void buf_cleanup_vbi(struct vb2_buffer *vb)
 
 static int start_streaming_vbi(struct vb2_queue *q, unsigned int count)
 {
-	int ret;
 	int seqnr = 0;
 	struct bttv_buffer *buf;
 	struct bttv *btv = vb2_get_drv_priv(q);
 
 	btv->framedrop = 0;
-	ret = check_alloc_btres_lock(btv, RESOURCE_VBI);
-	if (ret == 0) {
+	if (!check_alloc_btres_lock(btv, RESOURCE_VBI)) {
 		if (btv->field_count)
 			seqnr++;
 		while (!list_empty(&btv->vcapture)) {
@@ -141,13 +139,13 @@ static int start_streaming_vbi(struct vb2_queue *q, unsigned int count)
 			vb2_buffer_done(&buf->vbuf.vb2_buf,
 					VB2_BUF_STATE_QUEUED);
 		}
-		return !ret;
+		return -EBUSY;
 	}
 	if (!vb2_is_streaming(&btv->capq)) {
 		init_irqreg(btv);
 		btv->field_count = 0;
 	}
-	return !ret;
+	return 0;
 }
 
 static void stop_streaming_vbi(struct vb2_queue *q)
-- 
2.43.0



