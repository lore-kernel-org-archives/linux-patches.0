Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C5FF1442EF;
	Thu, 13 Jun 2024 11:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278914; cv=none; b=R94t25N1klAL5PcHtRiDPEP08xe7CV60MvCs72/DDaledWeoIMTAax7tKoXQPQTuWbE8WSVp9K64VL3QSVZvsP6ecVb3Ltwdn+DFwlWxVGGxVBlXMQoj6YjH7zjpRkqLrXPF6lKa7WqbicOWwwlsvh0Uj/BME1NY1TDsCmWMENM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278914; c=relaxed/simple;
	bh=0r/Y8W5KnwzYiRUvOig0KbNClpB+4fu32hbDlorqWxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rNJNxCAHXW0HsxW5Q+M3aO7aMf9+ciqYAvArNJizoQNKaD83WskACcE8kN9NH3bRIm3nIXEa4Mo+9QJyTOBy+VSPdXpcYhm4MQkAaVLxsdpVK6l4erRtPoc+Qoi5e8hHv/alojKpQm2m0qbdtn2ptAUNjDSvGilc1wsccPialRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MxwXGcS/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MxwXGcS/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DEBFC2BBFC;
	Thu, 13 Jun 2024 11:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278914;
	bh=0r/Y8W5KnwzYiRUvOig0KbNClpB+4fu32hbDlorqWxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MxwXGcS/mb5IlDR3tcu7tfn464L5Gn3IKHIV5QHB1Bx8CF8hrxdmmHY/Yz1/jmC+p
	 axSFSdz6NsWkWGY2pkf0VkM2UplYvr2a/a7fC+rVG4iBVyZnDsFqiUh/plFeGX4arW
	 b3imrwsYBuYmcmHOod7Cf/3FLrRxIlWXtxV1P4UI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeykumar Sankaran <jsanka@codeaurora.org>,
	Sean Paul <seanpaul@chromium.org>,
	Rob Clark <robdclark@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 111/213] drm/msm/dpu: use kms stored hw mdp block
Date: Thu, 13 Jun 2024 13:32:39 +0200
Message-ID: <20240613113232.283674658@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeykumar Sankaran <jsanka@codeaurora.org>

[ Upstream commit 57250ca5433306774e7f83b11503609ed1bf28cf ]

Avoid querying RM for hw mdp block. Use the one
stored in KMS during initialization.

changes in v4:
	- none
changes in v5:
	- none

Signed-off-by: Jeykumar Sankaran <jsanka@codeaurora.org>
Reviewed-by: Sean Paul <seanpaul@chromium.org>
Signed-off-by: Sean Paul <seanpaul@chromium.org>
Signed-off-by: Rob Clark <robdclark@gmail.com>
Stable-dep-of: 2b938c3ab0a6 ("drm/msm/dpu: Always flush the slave INTF on the CTL")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_cmd.c | 12 +-----------
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c |  9 +--------
 2 files changed, 2 insertions(+), 19 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_cmd.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_cmd.c
index 3084675ed4257..c8c4612dc34dd 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_cmd.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_cmd.c
@@ -823,7 +823,6 @@ struct dpu_encoder_phys *dpu_encoder_phys_cmd_init(
 {
 	struct dpu_encoder_phys *phys_enc = NULL;
 	struct dpu_encoder_phys_cmd *cmd_enc = NULL;
-	struct dpu_hw_mdp *hw_mdp;
 	struct dpu_encoder_irq *irq;
 	int i, ret = 0;
 
@@ -836,14 +835,7 @@ struct dpu_encoder_phys *dpu_encoder_phys_cmd_init(
 		goto fail;
 	}
 	phys_enc = &cmd_enc->base;
-
-	hw_mdp = dpu_rm_get_mdp(&p->dpu_kms->rm);
-	if (IS_ERR_OR_NULL(hw_mdp)) {
-		ret = PTR_ERR(hw_mdp);
-		DPU_ERROR("failed to get mdptop\n");
-		goto fail_mdp_init;
-	}
-	phys_enc->hw_mdptop = hw_mdp;
+	phys_enc->hw_mdptop = p->dpu_kms->hw_mdp;
 	phys_enc->intf_idx = p->intf_idx;
 
 	dpu_encoder_phys_cmd_init_ops(&phys_enc->ops);
@@ -898,8 +890,6 @@ struct dpu_encoder_phys *dpu_encoder_phys_cmd_init(
 
 	return phys_enc;
 
-fail_mdp_init:
-	kfree(cmd_enc);
 fail:
 	return ERR_PTR(ret);
 }
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c
index c9962a36b86b8..15a1277fe3540 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c
@@ -829,7 +829,6 @@ struct dpu_encoder_phys *dpu_encoder_phys_vid_init(
 	struct dpu_encoder_phys *phys_enc = NULL;
 	struct dpu_encoder_phys_vid *vid_enc = NULL;
 	struct dpu_rm_hw_iter iter;
-	struct dpu_hw_mdp *hw_mdp;
 	struct dpu_encoder_irq *irq;
 	int i, ret = 0;
 
@@ -846,13 +845,7 @@ struct dpu_encoder_phys *dpu_encoder_phys_vid_init(
 
 	phys_enc = &vid_enc->base;
 
-	hw_mdp = dpu_rm_get_mdp(&p->dpu_kms->rm);
-	if (IS_ERR_OR_NULL(hw_mdp)) {
-		ret = PTR_ERR(hw_mdp);
-		DPU_ERROR("failed to get mdptop\n");
-		goto fail;
-	}
-	phys_enc->hw_mdptop = hw_mdp;
+	phys_enc->hw_mdptop = p->dpu_kms->hw_mdp;
 	phys_enc->intf_idx = p->intf_idx;
 
 	/**
-- 
2.43.0



