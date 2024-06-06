Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69274198824;
	Thu,  6 Jun 2024 14:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683333; cv=none; b=rXKw0Pg1zC05Ig10o5SoPhad4kBCePOsHfqu4dkqCznKD3LR75oM5s4FKIl1oGGuN+oCSQW5zM4Cte3Q9JXCvAXB6CrBGlxwr2rcCXoEde4AVRZAquUims6krrhE7xjiG+P6kUNTGdBpqjV4jBOuPR6TKj9Z9GhnGypKeB6Kgic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683333; c=relaxed/simple;
	bh=dje0Mxf+NJOcRjqMOncE1A6u9VnfrChxhwZ1gIa9LsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nLpbryV4nJA51MkQhZz3YTJEgzBNTqMMADtsaacq5X/kzPJaqXYddGOt5A7RCUeLf3qsMF1uHnVgW/gY2pu5+r56WIfS3j1nSAEgMOPx2RrjXrdNfGYB3hJuKq6eMVcOUO90GpF3qoySFFJhpZ+mFV2AFHjfGYqdlsgjBkX9gQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TTXFa+OG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TTXFa+OG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49672C2BD10;
	Thu,  6 Jun 2024 14:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683333;
	bh=dje0Mxf+NJOcRjqMOncE1A6u9VnfrChxhwZ1gIa9LsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TTXFa+OGMIBqtYIPKCi7AJr49Z5Lo7YHnkZpTnMjEj2eWkl8KkxZhWzwN7xw2c1xV
	 VSb0V4tBKRHNmoPa6QjMn4jbbBiD4q6aeXe2KEe/0mFaiwepyKn0uq74TiZeh8YuVM
	 ixVdV0ELUr/mPUzvWOKqoqZ6Y/r2CdSAqqSIQ6T8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Kuogee Hsieh <quic_khsieh@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 215/473] drm/msm/dp: Return IRQ_NONE for unhandled interrupts
Date: Thu,  6 Jun 2024 16:02:24 +0200
Message-ID: <20240606131707.016500949@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit bfc12020e63d017ea8f85cda9c39cbd1314ecd77 ]

If our interrupt handler gets called and we don't really handle the
interrupt then we should return IRQ_NONE. The current interrupt
handler didn't do this, so let's fix it.

NOTE: for some of the cases it's clear that we should return IRQ_NONE
and some cases it's clear that we should return IRQ_HANDLED. However,
there are a few that fall somewhere in between. Specifically, the
documentation for when to return IRQ_NONE vs. IRQ_HANDLED is probably
best spelled out in the commit message of commit d9e4ad5badf4 ("Document
that IRQ_NONE should be returned when IRQ not actually handled"). That
commit makes it clear that we should return IRQ_HANDLED if we've done
something to make the interrupt stop happening.

The case where it's unclear is, for instance, in dp_aux_isr() after
we've read the interrupt using dp_catalog_aux_get_irq() and confirmed
that "isr" is non-zero. The function dp_catalog_aux_get_irq() not only
reads the interrupts but it also "ack"s all the interrupts that are
returned. For an "unknown" interrupt this has a very good chance of
actually stopping the interrupt from happening. That would mean we've
identified that it's our device and done something to stop them from
happening and should return IRQ_HANDLED. Specifically, it should be
noted that most interrupts that need "ack"ing are ones that are
one-time events and doing an "ack" is enough to clear them. However,
since these interrupts are unknown then, by definition, it's unknown
if "ack"ing them is truly enough to clear them. It's possible that we
also need to remove the original source of the interrupt. In this
case, IRQ_NONE would be a better choice.

Given that returning an occasional IRQ_NONE isn't the absolute end of
the world, however, let's choose that course of action. The IRQ
framework will forgive a few IRQ_NONE returns now and again (and it
won't even log them, which is why we have to log them ourselves). This
means that if we _do_ end hitting an interrupt where "ack"ing isn't
enough the kernel will eventually detect the problem and shut our
device down.

Signed-off-by: Douglas Anderson <dianders@chromium.org>
Tested-by: Kuogee Hsieh <quic_khsieh@quicinc.com>
Reviewed-by: Kuogee Hsieh <quic_khsieh@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/520660/
Link: https://lore.kernel.org/r/20230126170745.v2.2.I2d7aec2fadb9c237cd0090a47d6a8ba2054bf0f8@changeid
[DB: reformatted commit message to make checkpatch happy]
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Stable-dep-of: 5d1a7493343c ("drm/msm/dp: Avoid a long timeout for AUX transfer if nothing connected")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_aux.c     | 12 +++++++-----
 drivers/gpu/drm/msm/dp/dp_aux.h     |  2 +-
 drivers/gpu/drm/msm/dp/dp_ctrl.c    | 10 ++++++++--
 drivers/gpu/drm/msm/dp/dp_ctrl.h    |  2 +-
 drivers/gpu/drm/msm/dp/dp_display.c |  8 +++++---
 5 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_aux.c b/drivers/gpu/drm/msm/dp/dp_aux.c
index 84f9e3e5f9642..8e3b677f35e64 100644
--- a/drivers/gpu/drm/msm/dp/dp_aux.c
+++ b/drivers/gpu/drm/msm/dp/dp_aux.c
@@ -368,14 +368,14 @@ static ssize_t dp_aux_transfer(struct drm_dp_aux *dp_aux,
 	return ret;
 }
 
-void dp_aux_isr(struct drm_dp_aux *dp_aux)
+irqreturn_t dp_aux_isr(struct drm_dp_aux *dp_aux)
 {
 	u32 isr;
 	struct dp_aux_private *aux;
 
 	if (!dp_aux) {
 		DRM_ERROR("invalid input\n");
-		return;
+		return IRQ_NONE;
 	}
 
 	aux = container_of(dp_aux, struct dp_aux_private, dp_aux);
@@ -384,11 +384,11 @@ void dp_aux_isr(struct drm_dp_aux *dp_aux)
 
 	/* no interrupts pending, return immediately */
 	if (!isr)
-		return;
+		return IRQ_NONE;
 
 	if (!aux->cmd_busy) {
 		DRM_ERROR("Unexpected DP AUX IRQ %#010x when not busy\n", isr);
-		return;
+		return IRQ_NONE;
 	}
 
 	/*
@@ -420,10 +420,12 @@ void dp_aux_isr(struct drm_dp_aux *dp_aux)
 		aux->aux_error_num = DP_AUX_ERR_NONE;
 	} else {
 		DRM_WARN("Unexpected interrupt: %#010x\n", isr);
-		return;
+		return IRQ_NONE;
 	}
 
 	complete(&aux->comp);
+
+	return IRQ_HANDLED;
 }
 
 void dp_aux_reconfig(struct drm_dp_aux *dp_aux)
diff --git a/drivers/gpu/drm/msm/dp/dp_aux.h b/drivers/gpu/drm/msm/dp/dp_aux.h
index e930974bcb5b9..511305da4f66d 100644
--- a/drivers/gpu/drm/msm/dp/dp_aux.h
+++ b/drivers/gpu/drm/msm/dp/dp_aux.h
@@ -11,7 +11,7 @@
 
 int dp_aux_register(struct drm_dp_aux *dp_aux);
 void dp_aux_unregister(struct drm_dp_aux *dp_aux);
-void dp_aux_isr(struct drm_dp_aux *dp_aux);
+irqreturn_t dp_aux_isr(struct drm_dp_aux *dp_aux);
 void dp_aux_init(struct drm_dp_aux *dp_aux);
 void dp_aux_deinit(struct drm_dp_aux *dp_aux);
 void dp_aux_reconfig(struct drm_dp_aux *dp_aux);
diff --git a/drivers/gpu/drm/msm/dp/dp_ctrl.c b/drivers/gpu/drm/msm/dp/dp_ctrl.c
index 2c501261f2323..bd1343602f553 100644
--- a/drivers/gpu/drm/msm/dp/dp_ctrl.c
+++ b/drivers/gpu/drm/msm/dp/dp_ctrl.c
@@ -1973,27 +1973,33 @@ int dp_ctrl_off(struct dp_ctrl *dp_ctrl)
 	return ret;
 }
 
-void dp_ctrl_isr(struct dp_ctrl *dp_ctrl)
+irqreturn_t dp_ctrl_isr(struct dp_ctrl *dp_ctrl)
 {
 	struct dp_ctrl_private *ctrl;
 	u32 isr;
+	irqreturn_t ret = IRQ_NONE;
 
 	if (!dp_ctrl)
-		return;
+		return IRQ_NONE;
 
 	ctrl = container_of(dp_ctrl, struct dp_ctrl_private, dp_ctrl);
 
 	isr = dp_catalog_ctrl_get_interrupt(ctrl->catalog);
 
+
 	if (isr & DP_CTRL_INTR_READY_FOR_VIDEO) {
 		drm_dbg_dp(ctrl->drm_dev, "dp_video_ready\n");
 		complete(&ctrl->video_comp);
+		ret = IRQ_HANDLED;
 	}
 
 	if (isr & DP_CTRL_INTR_IDLE_PATTERN_SENT) {
 		drm_dbg_dp(ctrl->drm_dev, "idle_patterns_sent\n");
 		complete(&ctrl->idle_comp);
+		ret = IRQ_HANDLED;
 	}
+
+	return ret;
 }
 
 struct dp_ctrl *dp_ctrl_get(struct device *dev, struct dp_link *link,
diff --git a/drivers/gpu/drm/msm/dp/dp_ctrl.h b/drivers/gpu/drm/msm/dp/dp_ctrl.h
index 9f29734af81ca..c3af06dc87b17 100644
--- a/drivers/gpu/drm/msm/dp/dp_ctrl.h
+++ b/drivers/gpu/drm/msm/dp/dp_ctrl.h
@@ -25,7 +25,7 @@ int dp_ctrl_off_link_stream(struct dp_ctrl *dp_ctrl);
 int dp_ctrl_off_link(struct dp_ctrl *dp_ctrl);
 int dp_ctrl_off(struct dp_ctrl *dp_ctrl);
 void dp_ctrl_push_idle(struct dp_ctrl *dp_ctrl);
-void dp_ctrl_isr(struct dp_ctrl *dp_ctrl);
+irqreturn_t dp_ctrl_isr(struct dp_ctrl *dp_ctrl);
 void dp_ctrl_handle_sink_request(struct dp_ctrl *dp_ctrl);
 struct dp_ctrl *dp_ctrl_get(struct device *dev, struct dp_link *link,
 			struct dp_panel *panel,	struct drm_dp_aux *aux,
diff --git a/drivers/gpu/drm/msm/dp/dp_display.c b/drivers/gpu/drm/msm/dp/dp_display.c
index d16c12351adb6..e0551ad7a4252 100644
--- a/drivers/gpu/drm/msm/dp/dp_display.c
+++ b/drivers/gpu/drm/msm/dp/dp_display.c
@@ -1193,7 +1193,7 @@ static int dp_hpd_event_thread_start(struct dp_display_private *dp_priv)
 static irqreturn_t dp_display_irq_handler(int irq, void *dev_id)
 {
 	struct dp_display_private *dp = dev_id;
-	irqreturn_t ret = IRQ_HANDLED;
+	irqreturn_t ret = IRQ_NONE;
 	u32 hpd_isr_status;
 
 	if (!dp) {
@@ -1221,13 +1221,15 @@ static irqreturn_t dp_display_irq_handler(int irq, void *dev_id)
 
 		if (hpd_isr_status & DP_DP_HPD_UNPLUG_INT_MASK)
 			dp_add_event(dp, EV_HPD_UNPLUG_INT, 0, 0);
+
+		ret = IRQ_HANDLED;
 	}
 
 	/* DP controller isr */
-	dp_ctrl_isr(dp->ctrl);
+	ret |= dp_ctrl_isr(dp->ctrl);
 
 	/* DP aux isr */
-	dp_aux_isr(dp->aux);
+	ret |= dp_aux_isr(dp->aux);
 
 	return ret;
 }
-- 
2.43.0



