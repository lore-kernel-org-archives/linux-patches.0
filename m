Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE27B2113;
	Tue, 23 Jan 2024 00:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969489; cv=none; b=UnWAUUkhvmYzmOWnA4Zsz7TZZmdsIyYl0zWRDNlbU0EJtxC+e7Spw/fi+fq5yIyAMOcgAnw+nP4vNET1w++xL88iEE6FK3lr1ygwQivVnjaGESZ4EQ+OuC9wmaUxTstwxGE6E49oH99LLJ3WY1IsMT3w1z30YBMmsmSdojUEjJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969489; c=relaxed/simple;
	bh=X0c6wRlP1fpqDXU+ge+dyn+dQTo5PeKLlAwTEgq1++M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M+90ljz8UVr/0FrV+1VYL8gk82c3EKASzkMP+rCCjSXW299BpO//Gs97KCoEBPaF7isU9NfQcfE6ewl18vKMJ70LiaUNFuE7qqYYO7Ycq7J/gMt8glPLvGOfSy4Pa5kUEml0hfk14C+vwv4dMFaPTYoZe7/71oazXHOFDxGPAzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=akSR4Alh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="akSR4Alh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AC78C43390;
	Tue, 23 Jan 2024 00:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969489;
	bh=X0c6wRlP1fpqDXU+ge+dyn+dQTo5PeKLlAwTEgq1++M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=akSR4AlhwWLZoccd+A4I2paCmQLzA8Rku9yCciVu1Ch9A9vhwqxXNplo9/dFiD29M
	 rxrkEnS2/co9zhqEayHzV0fCK75irjwaVyuy7nsWPvtKCMAjn7xrtDmLdgaluC/VYm
	 bWvYRfShLnWfE0o5GzWhYjUuIrzNhE2ui+Pq9PNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 279/641] drm/msm/mdp4: flush vblank event on disable
Date: Mon, 22 Jan 2024 15:53:03 -0800
Message-ID: <20240122235826.640794240@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



