Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D79D45C5EF;
	Tue, 23 Jan 2024 01:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974361; cv=none; b=s7hT2Ogeygw2GQLcNf6K1FHkKO7T3uuMdY27sNPa4FE7l5suKAANGlbkZOUavp28vxCUMeqg9PIhaJJZ5hoJD3fyaQeLDAltCEDEB9flnJgF6gkPKeU7EgGIgzw06kNrXKd3OBZvk2r4VNTpRFmSs1fDRIwgPYUrCUiIYQuMyhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974361; c=relaxed/simple;
	bh=khOPx1ttPv9ZWuTLz1t4ipbbC/JsLb/H1mAdKKZQbHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cz/0vCGspOWORzjzLYjhNTj/HESXDr2z/1iHBGj5igw8n/tr3nwrBr2QRt5amGvBAOn2+DQc+Hc1M/pkrV+INYn0ZRiUBp7NiaEW4wtVS+9mfKdFV6GzCGMxXk+UOihX0R4GzK2CiXABB2NYNV+yFuWuVQ3BLh8ei+APa2MYY8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C/eL2Xvg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C/eL2Xvg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A289C433F1;
	Tue, 23 Jan 2024 01:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974361;
	bh=khOPx1ttPv9ZWuTLz1t4ipbbC/JsLb/H1mAdKKZQbHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C/eL2Xvg85f7F500LM8nsMCLckbyaw8drsUqfZy/LDv9cct0Jc4yYvKRQMqau/LgB
	 vulAF4yFO2McIUIl/TXEu3SVa5+/GjuKtd+LV0R76xie8jY1Ye05t4Ksi1fwNCl9J7
	 05u4jlo3avB78en3F8dreBRrdbmCFskDo59BNZC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 192/374] drm/msm/mdp4: flush vblank event on disable
Date: Mon, 22 Jan 2024 15:57:28 -0800
Message-ID: <20240122235751.291132128@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit c6721b3c6423d8a348ae885a0f4c85e14f9bf85c ]

Flush queued events when disabling the crtc. This avoids timeouts when
we come back and wait for dependencies (like the previous frame's
flip_done).

Fixes: c8afe684c95c ("drm/msm: basic KMS driver for snapdragon")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/569127/
Link: https://lore.kernel.org/r/20231127215401.4064128-1-dmitry.baryshkov@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/mdp4/mdp4_crtc.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/msm/disp/mdp4/mdp4_crtc.c b/drivers/gpu/drm/msm/disp/mdp4/mdp4_crtc.c
index 169f9de4a12a..3100957225a7 100644
--- a/drivers/gpu/drm/msm/disp/mdp4/mdp4_crtc.c
+++ b/drivers/gpu/drm/msm/disp/mdp4/mdp4_crtc.c
@@ -269,6 +269,7 @@ static void mdp4_crtc_atomic_disable(struct drm_crtc *crtc,
 {
 	struct mdp4_crtc *mdp4_crtc = to_mdp4_crtc(crtc);
 	struct mdp4_kms *mdp4_kms = get_kms(crtc);
+	unsigned long flags;
 
 	DBG("%s", mdp4_crtc->name);
 
@@ -281,6 +282,14 @@ static void mdp4_crtc_atomic_disable(struct drm_crtc *crtc,
 	mdp_irq_unregister(&mdp4_kms->base, &mdp4_crtc->err);
 	mdp4_disable(mdp4_kms);
 
+	if (crtc->state->event && !crtc->state->active) {
+		WARN_ON(mdp4_crtc->event);
+		spin_lock_irqsave(&mdp4_kms->dev->event_lock, flags);
+		drm_crtc_send_vblank_event(crtc, crtc->state->event);
+		crtc->state->event = NULL;
+		spin_unlock_irqrestore(&mdp4_kms->dev->event_lock, flags);
+	}
+
 	mdp4_crtc->enabled = false;
 }
 
-- 
2.43.0



