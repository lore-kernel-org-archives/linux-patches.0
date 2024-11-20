Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2334C1AAE3F;
	Wed, 20 Nov 2024 12:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107551; cv=none; b=nwMpMqoqj9auRiKr+/rQTAPNmkAU9eDsmMjYqSV3/CTEZleMx0ULBdkOAABZ55ciKmTPNCx6pu8nNUFo3zS8NkHCn70DIPyZSyYPTJ4f5d6YfKyfgKmyj/MtCBk/A/US0pO/PFq96Kg8/+qRGc0itsmnkkE9t+Q6fZIUz5LAoDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107551; c=relaxed/simple;
	bh=TuEr/KKC6oX8R7UP+aw6GUVQ+vAANldc/0Yfnb718tY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XpUhRHjVmyJYmxFKPl+Yr5O1ERW/BMfHTvnL2iqf1WVrrnYNAZcK7T5rSGPs90GmKT4ogsUkmshLRT8JFJn7Wqi5YIpGmsEaxtbPTIgkvfStjpDot4eIB/mOqnMiBDOd/piZ6LUeDKDj/H+RdDHH9s7MI/gmPDx9W1RqyL6aPjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KV9oyBKv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KV9oyBKv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6297C4CECD;
	Wed, 20 Nov 2024 12:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107551;
	bh=TuEr/KKC6oX8R7UP+aw6GUVQ+vAANldc/0Yfnb718tY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KV9oyBKvlCizSGOoU3bL3v2OFpnTNxpEISqAbItdMErvVttYWlWoHA7Xd/yVJSbBw
	 t0M19D74Pq5KtC1OTK8KWkslmdrUSwQFGM/HAb1O3fK0K+beNJlnB4B16E5EXTmRfO
	 yLDfUCuiYyGeXbkMfZgy2ffGOApZGaJA7alG6PuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lyude Paul <lyude@redhat.com>,
	Dave Airlie <airlied@redhat.com>
Subject: [PATCH 6.11 091/107] nouveau/dp: handle retries for AUX CH transfers with GSP.
Date: Wed, 20 Nov 2024 13:57:06 +0100
Message-ID: <20241120125631.763362305@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit 9776c0a75a1a86b753b2dc7c1ecc3baa048a8dec upstream.

eb284f4b3781 drm/nouveau/dp: Honor GSP link training retry timeouts

tried to fix a problem with panel retires, however it appears
the auxch also needs the same treatment, so add the same retry
wrapper around it.

This fixes some eDP panels after a suspend/resume cycle.

Fixes: eb284f4b3781 ("drm/nouveau/dp: Honor GSP link training retry timeouts")
Cc: stable@vger.kernel.org
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241111034126.2028401-2-airlied@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../gpu/drm/nouveau/nvkm/engine/disp/r535.c   | 59 +++++++++++--------
 1 file changed, 35 insertions(+), 24 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/disp/r535.c b/drivers/gpu/drm/nouveau/nvkm/engine/disp/r535.c
index 8f9aa3463c3c..99110ab2f44d 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/disp/r535.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/disp/r535.c
@@ -1060,33 +1060,44 @@ r535_dp_aux_xfer(struct nvkm_outp *outp, u8 type, u32 addr, u8 *data, u8 *psize)
 	NV0073_CTRL_DP_AUXCH_CTRL_PARAMS *ctrl;
 	u8 size = *psize;
 	int ret;
+	int retries;
 
-	ctrl = nvkm_gsp_rm_ctrl_get(&disp->rm.objcom, NV0073_CTRL_CMD_DP_AUXCH_CTRL, sizeof(*ctrl));
-	if (IS_ERR(ctrl))
-		return PTR_ERR(ctrl);
+	for (retries = 0; retries < 3; ++retries) {
+		ctrl = nvkm_gsp_rm_ctrl_get(&disp->rm.objcom, NV0073_CTRL_CMD_DP_AUXCH_CTRL, sizeof(*ctrl));
+		if (IS_ERR(ctrl))
+			return PTR_ERR(ctrl);
 
-	ctrl->subDeviceInstance = 0;
-	ctrl->displayId = BIT(outp->index);
-	ctrl->bAddrOnly = !size;
-	ctrl->cmd = type;
-	if (ctrl->bAddrOnly) {
-		ctrl->cmd = NVDEF_SET(ctrl->cmd, NV0073_CTRL, DP_AUXCH_CMD, REQ_TYPE, WRITE);
-		ctrl->cmd = NVDEF_SET(ctrl->cmd, NV0073_CTRL, DP_AUXCH_CMD,  I2C_MOT, FALSE);
+		ctrl->subDeviceInstance = 0;
+		ctrl->displayId = BIT(outp->index);
+		ctrl->bAddrOnly = !size;
+		ctrl->cmd = type;
+		if (ctrl->bAddrOnly) {
+			ctrl->cmd = NVDEF_SET(ctrl->cmd, NV0073_CTRL, DP_AUXCH_CMD, REQ_TYPE, WRITE);
+			ctrl->cmd = NVDEF_SET(ctrl->cmd, NV0073_CTRL, DP_AUXCH_CMD,  I2C_MOT, FALSE);
+		}
+		ctrl->addr = addr;
+		ctrl->size = !ctrl->bAddrOnly ? (size - 1) : 0;
+		memcpy(ctrl->data, data, size);
+
+		ret = nvkm_gsp_rm_ctrl_push(&disp->rm.objcom, &ctrl, sizeof(*ctrl));
+		if ((ret == -EAGAIN || ret == -EBUSY) && ctrl->retryTimeMs) {
+			/*
+			 * Device (likely an eDP panel) isn't ready yet, wait for the time specified
+			 * by GSP before retrying again
+			 */
+			nvkm_debug(&disp->engine.subdev,
+				   "Waiting %dms for GSP LT panel delay before retrying in AUX\n",
+				   ctrl->retryTimeMs);
+			msleep(ctrl->retryTimeMs);
+			nvkm_gsp_rm_ctrl_done(&disp->rm.objcom, ctrl);
+		} else {
+			memcpy(data, ctrl->data, size);
+			*psize = ctrl->size;
+			ret = ctrl->replyType;
+			nvkm_gsp_rm_ctrl_done(&disp->rm.objcom, ctrl);
+			break;
+		}
 	}
-	ctrl->addr = addr;
-	ctrl->size = !ctrl->bAddrOnly ? (size - 1) : 0;
-	memcpy(ctrl->data, data, size);
-
-	ret = nvkm_gsp_rm_ctrl_push(&disp->rm.objcom, &ctrl, sizeof(*ctrl));
-	if (ret) {
-		nvkm_gsp_rm_ctrl_done(&disp->rm.objcom, ctrl);
-		return ret;
-	}
-
-	memcpy(data, ctrl->data, size);
-	*psize = ctrl->size;
-	ret = ctrl->replyType;
-	nvkm_gsp_rm_ctrl_done(&disp->rm.objcom, ctrl);
 	return ret;
 }
 
-- 
2.47.0



