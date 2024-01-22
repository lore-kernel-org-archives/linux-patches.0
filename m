Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 965F16775D;
	Tue, 23 Jan 2024 02:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975305; cv=none; b=OxLPwSGXBVqt3UrvKB3Cop1cMj24k5q/gLwbu9YpT5R13eSdZgxARsT9kxnP1GG7TXrHwUV73Al4ZP7DDQ1j7p/lZ1CKJ8ErgKpD/mnk4mvUghKWS5Ckm6JIL8m/6OV5OhpxwR/AWhHywQ74j9l9jPadzBHlrt30uUDyCFAJkKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975305; c=relaxed/simple;
	bh=4HfOw+1VPwyCo8OUQ5m+5xXFTDTGtGm8OPRiHrcfZwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bEYxgU/VLWDuXh1GASbBIxjNCrotz7uT9nyyR00gke+IuHRbISpDHxv2Pz8WauBsJ5qG+dG6MAKZ5C5ErtapGF0TAYc8u3B2o8mFHuqJ6PJcD2oFsnUtILX3xl98dwl75RIQvxhkS6D8IZBynf8Hswc52KAtWNjb/9gCXmIwXqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ksVqWCvc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ksVqWCvc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EFCBC433C7;
	Tue, 23 Jan 2024 02:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975305;
	bh=4HfOw+1VPwyCo8OUQ5m+5xXFTDTGtGm8OPRiHrcfZwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ksVqWCvcKQkhUI0WfFIfJHRlcbAjGME4ot7bM0xpydHBAm4on/PTVPMC6ott98uMf
	 LeFjyd+QOM3o/T1V1+zNyD/b8/f4ThFmDIfUzyp/k9qCgt2TlkkQgpvezTd3QC/z/N
	 /N8zMRj84oQetOSNesXH5d94QpVqsnMZjmHOKVA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 268/583] media: bttv: start_streaming should return a proper error code
Date: Mon, 22 Jan 2024 15:55:19 -0800
Message-ID: <20240122235820.201572322@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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



