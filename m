Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F0DE17E90E;
	Mon, 27 May 2024 19:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837220; cv=none; b=M0MM2+kxZ8dorj1/+Agz71Sm870Ogq0MmDUBRjTs4jMaDB7XybAaZG2rXqWm6FzsE74GUmhaD/REC1QzwIkWRRnqtUysfRfssI2Hhdb+RHZRyPiqKPmWqQcciKVyeVTtE0qk8DT2YBap2I5QMhrYtRxIqijTu3/LHcIJ/Q3kltI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837220; c=relaxed/simple;
	bh=bQKdAmVog69FzqQtoo5rL66oKVvEEf8xWFrsOCuupLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e4IB7Xmrjod2KI9qWJUTti6VWEDvROwnkkeXgVBWBVJjCrxGcRAhwU7TbW5eMmAPPVUResmVhZtZxlKiIIdPE4aNlimtSLiDpwVx24cURzT8DAorDNl+5+01HCdY8Nm7zreKqUL7eNxrvH+rb7Abg9gUZK6wNxPfRdU1MH0XPbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lXhPoUQ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lXhPoUQ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B85B9C2BBFC;
	Mon, 27 May 2024 19:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837220;
	bh=bQKdAmVog69FzqQtoo5rL66oKVvEEf8xWFrsOCuupLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lXhPoUQ6U1ck+Bh8RMvBZjLk3+w4ocWc8UpR0Cek6e+f5IR0ZcahrXjcYY/HflHx1
	 UyuG/tM0gCs3l4ElfPATxQZ03NnxB/xapR+R7i9qdNRevFl9rhdsGhI253nN9SBD31
	 xALQMG30Uj1k3c5AOoxVipkp6kcOJnf2+gITRgZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Guenter Roeck <groeck@chromium.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 319/427] drm/msm/dp: Avoid a long timeout for AUX transfer if nothing connected
Date: Mon, 27 May 2024 20:56:06 +0200
Message-ID: <20240527185631.490961011@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 5d1a7493343cc00d9019880b686e4e0a0f649531 ]

As documented in the description of the transfer() function of
"struct drm_dp_aux", the transfer() function can be called at any time
regardless of the state of the DP port. Specifically if the kernel has
the DP AUX character device enabled and userspace accesses
"/dev/drm_dp_auxN" directly then the AUX transfer function will be
called regardless of whether a DP device is connected.

For eDP panels we have a special rule where we wait (with a 5 second
timeout) for HPD to go high. This rule was important before all panels
drivers were converted to call wait_hpd_asserted() and actually can be
removed in a future commit.

For external DP devices we never checked for HPD. That means that
trying to access the DP AUX character device (AKA `hexdump -C
/dev/drm_dp_auxN`) would very, very slowly timeout. Specifically on my
system:
  $ time hexdump -C /dev/drm_dp_aux0
  hexdump: /dev/drm_dp_aux0: Connection timed out
  real    0m8.200s
We want access to the drm_dp_auxN character device to fail faster than
8 seconds when no DP cable is plugged in.

Let's add a test to make transfers fail right away if a device isn't
plugged in. Rather than testing the HPD line directly, we have the
dp_display module tell us when AUX transfers should be enabled so we
can handle cases where HPD is signaled out of band like with Type C.

Fixes: c943b4948b58 ("drm/msm/dp: add displayPort driver support")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Guenter Roeck <groeck@chromium.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/583127/
Link: https://lore.kernel.org/r/20240315143621.v2.1.I16aff881c9fe82b5e0fc06ca312da017aa7b5b3e@changeid
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_aux.c     | 20 ++++++++++++++++++++
 drivers/gpu/drm/msm/dp/dp_aux.h     |  1 +
 drivers/gpu/drm/msm/dp/dp_display.c |  4 ++++
 3 files changed, 25 insertions(+)

diff --git a/drivers/gpu/drm/msm/dp/dp_aux.c b/drivers/gpu/drm/msm/dp/dp_aux.c
index adbd5a367395c..f98d089ea5b1a 100644
--- a/drivers/gpu/drm/msm/dp/dp_aux.c
+++ b/drivers/gpu/drm/msm/dp/dp_aux.c
@@ -38,6 +38,7 @@ struct dp_aux_private {
 	bool no_send_stop;
 	bool initted;
 	bool is_edp;
+	bool enable_xfers;
 	u32 offset;
 	u32 segment;
 
@@ -304,6 +305,17 @@ static ssize_t dp_aux_transfer(struct drm_dp_aux *dp_aux,
 		goto exit;
 	}
 
+	/*
+	 * If we're using DP and an external display isn't connected then the
+	 * transfer won't succeed. Return right away. If we don't do this we
+	 * can end up with long timeouts if someone tries to access the DP AUX
+	 * character device when no DP device is connected.
+	 */
+	if (!aux->is_edp && !aux->enable_xfers) {
+		ret = -ENXIO;
+		goto exit;
+	}
+
 	/*
 	 * For eDP it's important to give a reasonably long wait here for HPD
 	 * to be asserted. This is because the panel driver may have _just_
@@ -436,6 +448,14 @@ irqreturn_t dp_aux_isr(struct drm_dp_aux *dp_aux)
 	return IRQ_HANDLED;
 }
 
+void dp_aux_enable_xfers(struct drm_dp_aux *dp_aux, bool enabled)
+{
+	struct dp_aux_private *aux;
+
+	aux = container_of(dp_aux, struct dp_aux_private, dp_aux);
+	aux->enable_xfers = enabled;
+}
+
 void dp_aux_reconfig(struct drm_dp_aux *dp_aux)
 {
 	struct dp_aux_private *aux;
diff --git a/drivers/gpu/drm/msm/dp/dp_aux.h b/drivers/gpu/drm/msm/dp/dp_aux.h
index f47d591c1f54e..4f65e892a8076 100644
--- a/drivers/gpu/drm/msm/dp/dp_aux.h
+++ b/drivers/gpu/drm/msm/dp/dp_aux.h
@@ -12,6 +12,7 @@
 int dp_aux_register(struct drm_dp_aux *dp_aux);
 void dp_aux_unregister(struct drm_dp_aux *dp_aux);
 irqreturn_t dp_aux_isr(struct drm_dp_aux *dp_aux);
+void dp_aux_enable_xfers(struct drm_dp_aux *dp_aux, bool enabled);
 void dp_aux_init(struct drm_dp_aux *dp_aux);
 void dp_aux_deinit(struct drm_dp_aux *dp_aux);
 void dp_aux_reconfig(struct drm_dp_aux *dp_aux);
diff --git a/drivers/gpu/drm/msm/dp/dp_display.c b/drivers/gpu/drm/msm/dp/dp_display.c
index ffbfde9225898..36a0ef1cdc1b9 100644
--- a/drivers/gpu/drm/msm/dp/dp_display.c
+++ b/drivers/gpu/drm/msm/dp/dp_display.c
@@ -555,6 +555,8 @@ static int dp_hpd_plug_handle(struct dp_display_private *dp, u32 data)
 	int ret;
 	struct platform_device *pdev = dp->dp_display.pdev;
 
+	dp_aux_enable_xfers(dp->aux, true);
+
 	mutex_lock(&dp->event_mutex);
 
 	state =  dp->hpd_state;
@@ -620,6 +622,8 @@ static int dp_hpd_unplug_handle(struct dp_display_private *dp, u32 data)
 	u32 state;
 	struct platform_device *pdev = dp->dp_display.pdev;
 
+	dp_aux_enable_xfers(dp->aux, false);
+
 	mutex_lock(&dp->event_mutex);
 
 	state = dp->hpd_state;
-- 
2.43.0



