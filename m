Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBFB0186295;
	Mon, 12 Aug 2024 16:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723478797; cv=none; b=hH5S/0yLGtHR0HM29XeUtynwF4ph4x12YUJ6hNYJFilmL4ENcOobv2rehcsqs39WEVqoi8KhrQ7LnyDaR7PDS73v+XCEX/0ogJF+SUy0CfSEMHDWQ5pMscNYciLghQQDlrApedq9GsKpgM7wcnCpE02NaRO/sBTn3P6/nx2mLOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723478797; c=relaxed/simple;
	bh=P5EHO6njLgsFXTB9qjWAj5+GAfxOZvkVJMW8PKVOe0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=inbR03lQpGS7cp7+7LcniTFenU5x/srLsB6IjfcRsFnD7lWHhCaooaD7hTWjBbBWcld/6GNwjryOAeJZQ6I5e2IgXArzplBdGxID3vpNoCu+qZT98kKkAiUWvEgEWw+bKqbFVEH1N4FIsteVfA4OhelTlPBgMM+JGoy732tl9CE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z39+ndPz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z39+ndPz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 398D0C32782;
	Mon, 12 Aug 2024 16:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723478796;
	bh=P5EHO6njLgsFXTB9qjWAj5+GAfxOZvkVJMW8PKVOe0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z39+ndPztREF/aF05Ja7Vb4oM/hcaswBRjiyx4x+HEzploiDwU680m8vbF4/ogOd9
	 yOHh/OGkYh/tJsi6IPx50Ct3GbeWekuuq58tOZzjduqr5FRjizIGHUjjKNAcw4MsII
	 Kw04vbZa5inX8oo3nPVAQS6WoyHgpMBNEV5Oaq88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@nxp.com>,
	Sebastian Fricke <sebastian.fricke@collabora.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 040/150] media: amphion: Remove lock in s_ctrl callback
Date: Mon, 12 Aug 2024 18:02:01 +0200
Message-ID: <20240812160126.711144856@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index dc35a87e628ec..2bfab4467b81c 100644
--- a/drivers/media/platform/amphion/vdec.c
+++ b/drivers/media/platform/amphion/vdec.c
@@ -145,7 +145,6 @@ static int vdec_op_s_ctrl(struct v4l2_ctrl *ctrl)
 	struct vdec_t *vdec = inst->priv;
 	int ret = 0;
 
-	vpu_inst_lock(inst);
 	switch (ctrl->id) {
 	case V4L2_CID_MPEG_VIDEO_DEC_DISPLAY_DELAY_ENABLE:
 		vdec->params.display_delay_enable = ctrl->val;
@@ -157,7 +156,6 @@ static int vdec_op_s_ctrl(struct v4l2_ctrl *ctrl)
 		ret = -EINVAL;
 		break;
 	}
-	vpu_inst_unlock(inst);
 
 	return ret;
 }
diff --git a/drivers/media/platform/amphion/venc.c b/drivers/media/platform/amphion/venc.c
index 1df2b35c1a240..c9cfef16c5b92 100644
--- a/drivers/media/platform/amphion/venc.c
+++ b/drivers/media/platform/amphion/venc.c
@@ -528,7 +528,6 @@ static int venc_op_s_ctrl(struct v4l2_ctrl *ctrl)
 	struct venc_t *venc = inst->priv;
 	int ret = 0;
 
-	vpu_inst_lock(inst);
 	switch (ctrl->id) {
 	case V4L2_CID_MPEG_VIDEO_H264_PROFILE:
 		venc->params.profile = ctrl->val;
@@ -589,7 +588,6 @@ static int venc_op_s_ctrl(struct v4l2_ctrl *ctrl)
 		ret = -EINVAL;
 		break;
 	}
-	vpu_inst_unlock(inst);
 
 	return ret;
 }
-- 
2.43.0



