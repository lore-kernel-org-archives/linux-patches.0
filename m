Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADAEE178CE4;
	Mon, 12 Aug 2024 16:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479350; cv=none; b=d4COVzc4Nq3haRchaN7zHb7vysIXncNCaAggY9b1iMES21U8oe9tEVOAwywkUNaYcn5G4XjOIfePg63q8WzxUunNB1jn89DPi01BuuPJgDQaqrs3/0fVmGMeJa1xu6Xb/yxxY/OBGqNz76yEWhI4NCZzri8YvQJGwZQSvHi+U40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479350; c=relaxed/simple;
	bh=1jgJYuE+wWlDh05ODolRNdYH/gHBuoJymtVGmtw70Ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Imlzbjc9brDjYDEzHEmU63wGuni0ckZhX1fSI+luHGfW1LJTvFccvqQy1iAIly5o7QuVq1Ojb+CqR/wrXKZmO4TBl8NrUvjFspUU+NHmxhr7qqt0HW19AseQUQSnVh5Txx4nO7w9hsnUDsc1L3TgIAIt9EQR4aN0XK80sGOfpcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fziH1Hk6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fziH1Hk6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33740C4AF0D;
	Mon, 12 Aug 2024 16:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479350;
	bh=1jgJYuE+wWlDh05ODolRNdYH/gHBuoJymtVGmtw70Ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fziH1Hk6YJFqsxF2y92lDkmPKrLFo7ExzUaWVXAFaxUq76/gOCY67lNMrDXG73fB4
	 kglw6GSYtDb8QKc4LzUh43aZqoUic/MLPDVoGszITWmsDj9OkEzhz1CK/mrqm7o9v0
	 1WVEEC5kGrWW4oRSfR43O1hF2l8fuQy/b0oEVRtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@nxp.com>,
	Sebastian Fricke <sebastian.fricke@collabora.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 058/189] media: amphion: Remove lock in s_ctrl callback
Date: Mon, 12 Aug 2024 18:01:54 +0200
Message-ID: <20240812160134.378191650@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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
index 133d77d1ea0c3..4f438eaa7d385 100644
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



