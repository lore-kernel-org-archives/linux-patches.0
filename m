Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4D1196D98;
	Thu,  6 Jun 2024 14:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682982; cv=none; b=f4T24FxSuaKkMc0q69fToBnETIMEhR5nUUKajmGchSAfyyfMZVRnK6HfLwtIKutSRtsvjlF/uEB/5pHvCEPxqlHo0iGV2MIFj/zGkpRFVAV+kzTO5yW0L7pNCfzaUh141EuWTaZZaWFE2bR2I/2BZBy26HGjbR0pnI0Je6wXo2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682982; c=relaxed/simple;
	bh=J/HZdDQDn+auFS4QRi6HvqcOtYzkh5jCOLAaIDW2BzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fahJZSQvoLvhqASjaiNE0FbqvrEOrdwvLKaO6lptqPNxYlivc6GPhjFtTIMtI/yMB7REZCkjLEI9OcCvRforDtmTJqG47jtcmjXPnvc2yroZzJJiW+IOIaBm5JkL9hbsqj0T9Bu7jvqYK32uWVZL0ZVNMFgbtNzxpTjngIyfSyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R5UgrYeq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R5UgrYeq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E4D6C2BD10;
	Thu,  6 Jun 2024 14:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682981;
	bh=J/HZdDQDn+auFS4QRi6HvqcOtYzkh5jCOLAaIDW2BzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R5UgrYeqp/cf7rLhixbQw6+JCE5aE9hd15gQbRdf3wtZE+RvU3LjjoFQkeYPKnGYj
	 Bv7pajUJA60dNODIT6y/q2gLheGFyaxW9lLhgr+lQdLc4NT6RZIKR0Tr5AI5qD+BVP
	 tsFawuQUtC66A+M2qUu2myD6D2XetpDDB6WSsMpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 164/374] drm/msm/dpu: Allow configuring multiple active DSC blocks
Date: Thu,  6 Jun 2024 16:02:23 +0200
Message-ID: <20240606131657.403562294@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marijn Suijten <marijn.suijten@somainline.org>

[ Upstream commit ca97fa419dfe62a384fdea8b33553c4d6afe034e ]

Just like the active interface and writeback block in ctl_intf_cfg_v1(),
and later the rest of the blocks in followup active-CTL fixes or
reworks, multiple calls to this function should enable additional DSC
blocks instead of overwriting the blocks that are enabled.

This pattern is observed in an active-CTL scenario since DPU 5.0.0 where
for example bonded-DSI uses a single CTL to drive multiple INTFs, and
each encoder calls this function individually with the INTF (hence the
pre-existing update instead of overwrite of this bitmask) and DSC blocks
it wishes to be enabled, and expects them to be OR'd into the bitmask.

The reverse already exists in reset_intf_cfg_v1() where only specified
DSC blocks are removed out of the CTL_DSC_ACTIVE bitmask (same for all
other blocks and ACTIVE bitmasks), leaving the rest enabled.

Fixes: 77f6da90487c ("drm/msm/disp/dpu1: Add DSC support in hw_ctl")
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/589902/
Link: https://lore.kernel.org/r/20240417-drm-msm-initial-dualpipe-dsc-fixes-v1-4-78ae3ee9a697@somainline.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.c
index a06f69d0b257d..2e50049f2f850 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.c
@@ -545,6 +545,7 @@ static void dpu_hw_ctl_intf_cfg_v1(struct dpu_hw_ctl *ctx,
 {
 	struct dpu_hw_blk_reg_map *c = &ctx->hw;
 	u32 intf_active = 0;
+	u32 dsc_active = 0;
 	u32 wb_active = 0;
 	u32 mode_sel = 0;
 
@@ -560,6 +561,7 @@ static void dpu_hw_ctl_intf_cfg_v1(struct dpu_hw_ctl *ctx,
 
 	intf_active = DPU_REG_READ(c, CTL_INTF_ACTIVE);
 	wb_active = DPU_REG_READ(c, CTL_WB_ACTIVE);
+	dsc_active = DPU_REG_READ(c, CTL_DSC_ACTIVE);
 
 	if (cfg->intf)
 		intf_active |= BIT(cfg->intf - INTF_0);
@@ -567,17 +569,18 @@ static void dpu_hw_ctl_intf_cfg_v1(struct dpu_hw_ctl *ctx,
 	if (cfg->wb)
 		wb_active |= BIT(cfg->wb - WB_0);
 
+	if (cfg->dsc)
+		dsc_active |= cfg->dsc;
+
 	DPU_REG_WRITE(c, CTL_TOP, mode_sel);
 	DPU_REG_WRITE(c, CTL_INTF_ACTIVE, intf_active);
 	DPU_REG_WRITE(c, CTL_WB_ACTIVE, wb_active);
+	DPU_REG_WRITE(c, CTL_DSC_ACTIVE, dsc_active);
 
 	if (cfg->merge_3d)
 		DPU_REG_WRITE(c, CTL_MERGE_3D_ACTIVE,
 			      BIT(cfg->merge_3d - MERGE_3D_0));
 
-	if (cfg->dsc)
-		DPU_REG_WRITE(c, CTL_DSC_ACTIVE, cfg->dsc);
-
 	if (cfg->cdm)
 		DPU_REG_WRITE(c, CTL_CDM_ACTIVE, cfg->cdm);
 }
-- 
2.43.0



