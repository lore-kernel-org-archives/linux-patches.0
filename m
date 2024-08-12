Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82BB1134AC;
	Mon, 12 Aug 2024 16:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480110; cv=none; b=jofKf9vGG06WQsmL6hQnfEjAn4cVKU5fw+ZQ0ZWnhZr17YLiVPHUbN2EQfyEMSLvBjDMmUnxKZy/kw8Vk5i4ifHOcTzs2ZZSmu3rHZTfTRfMxIQgdL2ri1lZMzywLYwWb/glu3ApmlwUQDH8qUeAMpApFSi2Qtr519Ikz3yvUOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480110; c=relaxed/simple;
	bh=6p9W4erdNBzD9Z3NmA61PVDDHqsMxHZZJq21Nk/1ofQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W9IXwizyh7iRfaNrnYW56TXE/Pix1j3T5sGuESd+6wPXHlrlrb+1uzAswzFGHgvwT7IITOf1NrJpL1lGB8kivOlWioH49WGgzG7mJHuaLPhHtatSrQ7e5uID6O0e1Pd+QHdaWjSV3j1BNXGX45lb/fwwe/Afn43kmMd6eUiJAJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tkdUxypO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tkdUxypO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5448C32782;
	Mon, 12 Aug 2024 16:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480110;
	bh=6p9W4erdNBzD9Z3NmA61PVDDHqsMxHZZJq21Nk/1ofQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tkdUxypOZ2QJaMJxvTPbmgai8Vai11iD5xHUQ8yE6W7REmMiALLPfet6qUE6Z68WT
	 AQwNKNfCxeZGRghf1NCYVV8SI6Vp9EHwhPqa74uVS5y9zcPkFP7Od5ZSbv0poWS4oQ
	 Ko83H/TnSWQVPw4x8DJWcdjuWOl8D6n988sj16A8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@nxp.com>,
	Sebastian Fricke <sebastian.fricke@collabora.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 100/263] media: amphion: Remove lock in s_ctrl callback
Date: Mon, 12 Aug 2024 18:01:41 +0200
Message-ID: <20240812160150.371608023@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Qian <ming.qian@nxp.com>

[ Upstream commit 065927b51eb1f042c3e026cebfd55e72ccc26093 ]

There is no need to add a lock in s_ctrl callback, it has been
synchronized by the ctrl_handler's lock, otherwise it may led to
a deadlock if the driver calls v4l2_ctrl_s_ctrl().

Signed-off-by: Ming Qian <ming.qian@nxp.com>
Signed-off-by: Sebastian Fricke <sebastian.fricke@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/amphion/vdec.c | 2 --
 drivers/media/platform/amphion/venc.c | 2 --
 2 files changed, 4 deletions(-)

diff --git a/drivers/media/platform/amphion/vdec.c b/drivers/media/platform/amphion/vdec.c
index a57f9f4f3b876..6a38a0fa0e2d4 100644
--- a/drivers/media/platform/amphion/vdec.c
+++ b/drivers/media/platform/amphion/vdec.c
@@ -195,7 +195,6 @@ static int vdec_op_s_ctrl(struct v4l2_ctrl *ctrl)
 	struct vdec_t *vdec = inst->priv;
 	int ret = 0;
 
-	vpu_inst_lock(inst);
 	switch (ctrl->id) {
 	case V4L2_CID_MPEG_VIDEO_DEC_DISPLAY_DELAY_ENABLE:
 		vdec->params.display_delay_enable = ctrl->val;
@@ -207,7 +206,6 @@ static int vdec_op_s_ctrl(struct v4l2_ctrl *ctrl)
 		ret = -EINVAL;
 		break;
 	}
-	vpu_inst_unlock(inst);
 
 	return ret;
 }
diff --git a/drivers/media/platform/amphion/venc.c b/drivers/media/platform/amphion/venc.c
index 4eb57d793a9c0..16ed4d21519cd 100644
--- a/drivers/media/platform/amphion/venc.c
+++ b/drivers/media/platform/amphion/venc.c
@@ -518,7 +518,6 @@ static int venc_op_s_ctrl(struct v4l2_ctrl *ctrl)
 	struct venc_t *venc = inst->priv;
 	int ret = 0;
 
-	vpu_inst_lock(inst);
 	switch (ctrl->id) {
 	case V4L2_CID_MPEG_VIDEO_H264_PROFILE:
 		venc->params.profile = ctrl->val;
@@ -579,7 +578,6 @@ static int venc_op_s_ctrl(struct v4l2_ctrl *ctrl)
 		ret = -EINVAL;
 		break;
 	}
-	vpu_inst_unlock(inst);
 
 	return ret;
 }
-- 
2.43.0



