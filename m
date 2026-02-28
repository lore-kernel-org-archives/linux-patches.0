Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5FAD3451CC
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301749; cv=none; b=MUyLzGNCVB/Ljzw763kyK4CSmUqx7fere6iqQy9qjWrtVpOvixOUcYx6PLvrHXMhETbVXc5hP3BeNrWQlqfth0ah4vv2s3+uCMoUBtQbwSHfZWUOHXGEZLrpKvFo6zd84uFqXcgX43cK2DcumqmY82OxmN7l3Ik49y1XiyGFsso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301749; c=relaxed/simple;
	bh=u+70R99ZkfbwP+7tDNa46cQF0GC8uiFClTYXEzDqu2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jVyZ85zagcjsyvoJEpsQSo67hLG55mqAdoaZrl56dOOnS7QermqOFDAJgPSZwwkCiw5eJZ6nv9eJUtxr3eJgjArs03sLz7KXOomBA4eH76UQk+0c7LQiAcABUNbcHugX371ucc0ugSXNg2wR/HYLwqmmJaLYBYZ5a2iWXfRQeLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZOExFGV3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZOExFGV3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 115B1C116D0;
	Sat, 28 Feb 2026 18:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301749;
	bh=u+70R99ZkfbwP+7tDNa46cQF0GC8uiFClTYXEzDqu2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZOExFGV3tcVji+iSGKv5g3++qGqhNx4UjaYqu7MNWN/AElJuxTxBgIk5Mbsc0OdDa
	 NrUAxLU9CH+ikh+aRQ87SdeOU3Fm6MLmT27eK4hp8/Aig6UYLkpuPpyHbHHOmTGbD3
	 aIZdPea+RQ7fc60mqajepR7ofVryQ9I2bAIA+cKSnYU9Ka+1LVcq+fPhy0q2Q/qE98
	 tMfgBNyDiLKcEFOUFx1bsPjFm//IxkPUgBhS5QPhJMFanl37o3Q4EsoJ9suzMcktf1
	 u7K1SX3OahVOCdDQxn46LZ60WgPVUdveVcbfA9dKPHksVWneJYn5hpFmyAJS6E9zVE
	 hxCE2q74Eg9cg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Teguh Sobirin <teguh@sobir.in>,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 152/385] drm/msm/dpu: Set vsync source irrespective of mdp top support
Date: Sat, 28 Feb 2026 12:56:14 -0500
Message-ID: <20260228180011.1568201-152-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Teguh Sobirin <teguh@sobir.in>

[ Upstream commit 1ad9880f059c9b0943e53714f9a59924cb035bbb ]

Since DPU 5.x the vsync source TE setup is split between MDP TOP and
INTF blocks. Currently all code to setup vsync_source is only executed
if MDP TOP implements the setup_vsync_source() callback. However on
DPU >= 8.x this callback is not implemented, making DPU driver skip all
vsync setup. Move the INTF part out of this condition, letting DPU
driver to setup TE vsync selection on all new DPU devices.

Signed-off-by: Teguh Sobirin <teguh@sobir.in>
Fixes: 2f69e5458447 ("drm/msm/dpu: skip watchdog timer programming through TOP on >= SM8450")
[DB: restored top->ops.setup_vsync_source call]
Reviewed-by: Marijn Suijten <marijn.suijten@somainline.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/696584/
Link: https://lore.kernel.org/r/20251230-intf-fix-wd-v6-1-98203d150611@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
index 47b514c89ce66..19c84426e6693 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
@@ -768,6 +768,8 @@ static void _dpu_encoder_update_vsync_source(struct dpu_encoder_virt *dpu_enc,
 		return;
 	}
 
+	vsync_cfg.vsync_source = disp_info->vsync_source;
+
 	if (hw_mdptop->ops.setup_vsync_source) {
 		for (i = 0; i < dpu_enc->num_phys_encs; i++)
 			vsync_cfg.ppnumber[i] = dpu_enc->hw_pp[i]->idx;
@@ -775,17 +777,15 @@ static void _dpu_encoder_update_vsync_source(struct dpu_encoder_virt *dpu_enc,
 		vsync_cfg.pp_count = dpu_enc->num_phys_encs;
 		vsync_cfg.frame_rate = drm_mode_vrefresh(&dpu_enc->base.crtc->state->adjusted_mode);
 
-		vsync_cfg.vsync_source = disp_info->vsync_source;
-
 		hw_mdptop->ops.setup_vsync_source(hw_mdptop, &vsync_cfg);
+	}
 
-		for (i = 0; i < dpu_enc->num_phys_encs; i++) {
-			phys_enc = dpu_enc->phys_encs[i];
+	for (i = 0; i < dpu_enc->num_phys_encs; i++) {
+		phys_enc = dpu_enc->phys_encs[i];
 
-			if (phys_enc->has_intf_te && phys_enc->hw_intf->ops.vsync_sel)
-				phys_enc->hw_intf->ops.vsync_sel(phys_enc->hw_intf,
-						vsync_cfg.vsync_source);
-		}
+		if (phys_enc->has_intf_te && phys_enc->hw_intf->ops.vsync_sel)
+			phys_enc->hw_intf->ops.vsync_sel(phys_enc->hw_intf,
+							 vsync_cfg.vsync_source);
 	}
 }
 
-- 
2.51.0

