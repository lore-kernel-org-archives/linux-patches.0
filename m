Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47FAD224F6;
	Tue,  8 Apr 2025 11:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111181; cv=none; b=kxxa6X1+cmA99BzTU9B7rruEpR6Esa8ZLza2v9yV1nhFGnVtFKKfavINqYvz58y+iInmntYOdjAWajXTirEhT1q7dWVKBVlOgJGvyk5v25cnhVIrDltY2F88m/VrCmVG2jvzpBSLD5SkOabGnzF9iHTJpNc+oPdhEhXl48vu5mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111181; c=relaxed/simple;
	bh=LXNhiEa2/09y8G1Z9dyb7AlH/A+IVi/hG0TW/hs/GVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=exFvntHYvTklAlu6ML8UciN8YatsSqJP6m7cvvb+s9KEF5rmzHsEYf6fWkiv/+vuqDd5/nWeeWyhAR81AR41wT6l/Sv9UulQRtnWYL5V7+WQ/tYHkEF6zb9XVOtw53woBOX/yVjbIRHJq5gI4NGYJWK9NziZY5DTSsSweXUaKBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BMe1jP2s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BMe1jP2s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB543C4CEE5;
	Tue,  8 Apr 2025 11:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111181;
	bh=LXNhiEa2/09y8G1Z9dyb7AlH/A+IVi/hG0TW/hs/GVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BMe1jP2ssNlidFTdzdIfFUvr/mI5Fh59RKStsj07BXLAj4bMcCIJpRZWOnXqowBqk
	 b6A0Fbui0auc4hLPcvjj/O/hUxKib6RxYZ9/hXNoMoYiEywpA/+lg56yrK3/6eDsRo
	 E/RUVSyTLrCPt+CAH3mryaU4DuX6dhXXu0cNJyEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 299/731] drm/msm/dsi: Set PHY usescase (and mode) before registering DSI host
Date: Tue,  8 Apr 2025 12:43:16 +0200
Message-ID: <20250408104921.233629044@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marijn Suijten <marijn.suijten@somainline.org>

[ Upstream commit 660c396c98c061f9696bebacc178b74072e80054 ]

Ordering issues here cause an uninitialized (default STANDALONE)
usecase to be programmed (which appears to be a MUX) in some cases
when msm_dsi_host_register() is called, leading to the slave PLL in
bonded-DSI mode to source from a clock parent (dsi1vco) that is off.

This should seemingly not be a problem as the actual dispcc clocks from
DSI1 that are muxed in the clock tree of DSI0 are way further down, this
bit still seems to have an effect on them somehow and causes the right
side of the panel controlled by DSI1 to not function.

In an ideal world this code is refactored to no longer have such
error-prone calls "across subsystems", and instead model the "PLL src"
register field as a regular mux so that changing the clock parents
programmatically or in DTS via `assigned-clock-parents` has the
desired effect.
But for the avid reader, the clocks that we *are* muxing into DSI0's
tree are way further down, so if this bit turns out to be a simple mux
between dsiXvco and out_div, that shouldn't have any effect as this
whole tree is off anyway.

Fixes: 57bf43389337 ("drm/msm/dsi: Pass down use case to PHY")
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Patchwork: https://patchwork.freedesktop.org/patch/637650/
Link: https://lore.kernel.org/r/20250217-drm-msm-initial-dualpipe-dsc-fixes-v3-2-913100d6103f@somainline.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/dsi_manager.c | 32 ++++++++++++++++++---------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/msm/dsi/dsi_manager.c b/drivers/gpu/drm/msm/dsi/dsi_manager.c
index a210b7c9e5ca2..4fabb01345aa2 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_manager.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_manager.c
@@ -74,17 +74,35 @@ static int dsi_mgr_setup_components(int id)
 	int ret;
 
 	if (!IS_BONDED_DSI()) {
+		/*
+		 * Set the usecase before calling msm_dsi_host_register(), which would
+		 * already program the PLL source mux based on a default usecase.
+		 */
+		msm_dsi_phy_set_usecase(msm_dsi->phy, MSM_DSI_PHY_STANDALONE);
+		msm_dsi_host_set_phy_mode(msm_dsi->host, msm_dsi->phy);
+
 		ret = msm_dsi_host_register(msm_dsi->host);
 		if (ret)
 			return ret;
-
-		msm_dsi_phy_set_usecase(msm_dsi->phy, MSM_DSI_PHY_STANDALONE);
-		msm_dsi_host_set_phy_mode(msm_dsi->host, msm_dsi->phy);
 	} else if (other_dsi) {
 		struct msm_dsi *master_link_dsi = IS_MASTER_DSI_LINK(id) ?
 							msm_dsi : other_dsi;
 		struct msm_dsi *slave_link_dsi = IS_MASTER_DSI_LINK(id) ?
 							other_dsi : msm_dsi;
+
+		/*
+		 * PLL0 is to drive both DSI link clocks in bonded DSI mode.
+		 *
+		 * Set the usecase before calling msm_dsi_host_register(), which would
+		 * already program the PLL source mux based on a default usecase.
+		 */
+		msm_dsi_phy_set_usecase(clk_master_dsi->phy,
+					MSM_DSI_PHY_MASTER);
+		msm_dsi_phy_set_usecase(clk_slave_dsi->phy,
+					MSM_DSI_PHY_SLAVE);
+		msm_dsi_host_set_phy_mode(msm_dsi->host, msm_dsi->phy);
+		msm_dsi_host_set_phy_mode(other_dsi->host, other_dsi->phy);
+
 		/* Register slave host first, so that slave DSI device
 		 * has a chance to probe, and do not block the master
 		 * DSI device's probe.
@@ -98,14 +116,6 @@ static int dsi_mgr_setup_components(int id)
 		ret = msm_dsi_host_register(master_link_dsi->host);
 		if (ret)
 			return ret;
-
-		/* PLL0 is to drive both 2 DSI link clocks in bonded DSI mode. */
-		msm_dsi_phy_set_usecase(clk_master_dsi->phy,
-					MSM_DSI_PHY_MASTER);
-		msm_dsi_phy_set_usecase(clk_slave_dsi->phy,
-					MSM_DSI_PHY_SLAVE);
-		msm_dsi_host_set_phy_mode(msm_dsi->host, msm_dsi->phy);
-		msm_dsi_host_set_phy_mode(other_dsi->host, other_dsi->phy);
 	}
 
 	return 0;
-- 
2.39.5



