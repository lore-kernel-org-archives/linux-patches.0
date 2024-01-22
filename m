Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6EB48CFD;
	Tue, 23 Jan 2024 00:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971475; cv=none; b=R9ICkP+/9dwNKCVeJozszdWqPP7CQn99CuXrAmf8BwU/h0ADeE75eig19KbZIMPAlBEUg4IE2++VIxble9IXBjdt4JJv/DSPySragRR7m1Jq7lbA5M5dadsGrA9fvZuEssQ4JNzEXRQ91kiz15jmoqH5iOp6RCvy+B1qqoq1ois=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971475; c=relaxed/simple;
	bh=tuZN3/aRluOYILGRzdLE7HXZrLtZEoWGMvp9pQXWNJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fD+nY6ZprmGOBF3hcNbfokjNQaeZ9Hsumm5YiAMvI7GI0Ebz09ulFawxED2fKAFupOPQG3BFlQqnaCDDTol/Kr2TUsJl+TY17q3uWXU5ZZbamWKGRyXD7yDneYuWjCgHj8+Rg7cgFmd/5cckhuI81wMgXW9OqtzSBIMTcOGsN64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XiMnn1Tq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XiMnn1Tq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 605DBC433F1;
	Tue, 23 Jan 2024 00:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971475;
	bh=tuZN3/aRluOYILGRzdLE7HXZrLtZEoWGMvp9pQXWNJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XiMnn1TqSw7liKJxDgGBRXMpy//mdfnaJ0EwTvBvfMEQjmWXMXnDIKD0WCYQ4sl6B
	 e1nhQeU3C9u41Ok75MgfsKq8nHVazFiTvIyzq6BZIqE72Bf8/gbLI5n8QcaOnVNGED
	 DNQ/Bn5XkXH1KSkAVpWRghPNBG7O+dCtye3AC4EY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 157/286] drm/msm/mdp4: flush vblank event on disable
Date: Mon, 22 Jan 2024 15:57:43 -0800
Message-ID: <20240122235738.218329658@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a0253297bc76..bf54b9e4fd61 100644
--- a/drivers/gpu/drm/msm/disp/mdp4/mdp4_crtc.c
+++ b/drivers/gpu/drm/msm/disp/mdp4/mdp4_crtc.c
@@ -268,6 +268,7 @@ static void mdp4_crtc_atomic_disable(struct drm_crtc *crtc,
 {
 	struct mdp4_crtc *mdp4_crtc = to_mdp4_crtc(crtc);
 	struct mdp4_kms *mdp4_kms = get_kms(crtc);
+	unsigned long flags;
 
 	DBG("%s", mdp4_crtc->name);
 
@@ -280,6 +281,14 @@ static void mdp4_crtc_atomic_disable(struct drm_crtc *crtc,
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



