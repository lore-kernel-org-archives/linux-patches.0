Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 273E32D879A;
	Tue, 11 Nov 2025 01:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823664; cv=none; b=OORZGkeDUYb2EuEsCy26AWoNvSuZJ1/WOUTPw3xBTN4CcC/h1TriSVpQqfZjkwPWrz1H7iGYXKpvrWsUCtlQgblNi1Jv0mNIE/3WQ6xBqZGi/WDa6SCaVpcNDn7cGgp/n2LFVSS3X7JNFyb+yR81pYuI8TJQp+hzBWygFIzEjYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823664; c=relaxed/simple;
	bh=jtxYzvAgkU1aYeFweweuQhJ/wkMuiLxdGK9ZqW6XIb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EEIrSjq+rtjP95pm6t8YOZ+lDtcZumgmOBaI9iHEGKIl1jYppKVRYlSm2Kp6kZucabG6bojdBgB9Qd/13cqaj97GetUfkb4LWdeOpL07zPoAT0VxK5QosliKxrb/uAonW3wVZT8RhDb0oBSD2Nc1wtir5auzUDeHjZkCKIgtYak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FNLWgiIw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FNLWgiIw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE052C4CEF5;
	Tue, 11 Nov 2025 01:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823664;
	bh=jtxYzvAgkU1aYeFweweuQhJ/wkMuiLxdGK9ZqW6XIb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FNLWgiIwwM0VBeqW+0b1db6laq/DGDQ2kpCKQPA+VLpOsT3V7kZnbSlvYntSIlKII
	 57VOYrnRWB+2nHiO+kDkLbGHv9OBFYMXR/MvKP7i6qZHt7UYzYOG7rQGw2gisfL9Em
	 ieZWhqaLDY7ee08HHoE5TSaoGUI5n9GXMPbAxhiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Kocialkowski <paulk@sys-base.io>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 296/565] media: verisilicon: Explicitly disable selection api ioctls for decoders
Date: Tue, 11 Nov 2025 09:42:32 +0900
Message-ID: <20251111004533.536878234@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Kocialkowski <paulk@sys-base.io>

[ Upstream commit 73d50aa92f28ee8414fbfde011974fce970b82cc ]

Call the dedicated v4l2_disable_ioctl helper instead of manually
checking whether the current context is an encoder for the selection
api ioctls.

Signed-off-by: Paul Kocialkowski <paulk@sys-base.io>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/verisilicon/hantro_drv.c  | 2 ++
 drivers/media/platform/verisilicon/hantro_v4l2.c | 6 ++----
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/verisilicon/hantro_drv.c b/drivers/media/platform/verisilicon/hantro_drv.c
index 05bbac853c4fd..137ca13eeed7c 100644
--- a/drivers/media/platform/verisilicon/hantro_drv.c
+++ b/drivers/media/platform/verisilicon/hantro_drv.c
@@ -918,6 +918,8 @@ static int hantro_add_func(struct hantro_dev *vpu, unsigned int funcid)
 		vpu->decoder = func;
 		v4l2_disable_ioctl(vfd, VIDIOC_TRY_ENCODER_CMD);
 		v4l2_disable_ioctl(vfd, VIDIOC_ENCODER_CMD);
+		v4l2_disable_ioctl(vfd, VIDIOC_G_SELECTION);
+		v4l2_disable_ioctl(vfd, VIDIOC_S_SELECTION);
 	}
 
 	video_set_drvdata(vfd, vpu);
diff --git a/drivers/media/platform/verisilicon/hantro_v4l2.c b/drivers/media/platform/verisilicon/hantro_v4l2.c
index 62d3962c18d99..c847c8284ab54 100644
--- a/drivers/media/platform/verisilicon/hantro_v4l2.c
+++ b/drivers/media/platform/verisilicon/hantro_v4l2.c
@@ -633,8 +633,7 @@ static int vidioc_g_selection(struct file *file, void *priv,
 	struct hantro_ctx *ctx = fh_to_ctx(priv);
 
 	/* Crop only supported on source. */
-	if (!ctx->is_encoder ||
-	    sel->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
+	if (sel->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
 		return -EINVAL;
 
 	switch (sel->target) {
@@ -666,8 +665,7 @@ static int vidioc_s_selection(struct file *file, void *priv,
 	struct vb2_queue *vq;
 
 	/* Crop only supported on source. */
-	if (!ctx->is_encoder ||
-	    sel->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
+	if (sel->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
 		return -EINVAL;
 
 	/* Change not allowed if the queue is streaming. */
-- 
2.51.0



