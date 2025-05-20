Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B49924679A;
	Tue, 20 May 2025 14:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750165; cv=none; b=oyI/jmjaR5PchH0qcqL68TnPBJxAwVPgfVXJZ32/6JDyL1n8JtG/HfrjUnlJryQyPY7qPh5abozmFJs3bemmThQsVrkEyXGeWQg/CmSRPLOx3D9NPoLxgaN7hrq3VFm+9wRZ9empmWdAl/NwVn1Utfit9YkLS5WV5CAGdvTWZq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750165; c=relaxed/simple;
	bh=Xyyg4F/R/O0K2Fy5MYEwYrsXIfCG50Gn3Jtx8Q+0ESw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R8GYPi6kS83VC/EXFXZ8fCNQ/Vs1P2lmKUNQk5lsVm6ucDUXDuCBtuyzl1S9RZ4aEmRFuagg6hzpEZqX0PEeQ9FtQU5SKQA8b5eENFLvPNbFxvOjYXDb65tUtcfdcn9YbXnCqn69yetWfbNY54MsrBLcr6gTp1TjjUhtvP1MOtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n0fYFglp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n0fYFglp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAE68C4CEF1;
	Tue, 20 May 2025 14:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750165;
	bh=Xyyg4F/R/O0K2Fy5MYEwYrsXIfCG50Gn3Jtx8Q+0ESw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n0fYFglpvjwiK+dAcj6zVsLp3kA6ua8bMehtiRFRoKUxVIJsRBDcop0klKIeJ2rXO
	 j5wc6DVUoxy5MQk/xGrZAeMQAYLBnMZqf8kPX2yKUoNwIWiVW6t0EO3SvHP/Ixkasz
	 7jht61hc4X3eATMmtUKFz/ruhD3I/8d2oTyovvFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 063/143] octeontx2-pf: Do not reallocate all ntuple filters
Date: Tue, 20 May 2025 15:50:18 +0200
Message-ID: <20250520125812.542570584@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Subbaraya Sundeep <sbhatta@marvell.com>

[ Upstream commit dcb479fde00be9a151c047d0a7c0626b64eb0019 ]

If ntuple filters count is modified followed by
unicast filters count using devlink then the ntuple count
set by user is ignored and all the ntuple filters are
being reallocated. Fix this by storing the ntuple count
set by user. Without this patch, say if user tries
to modify ntuple count as 8 followed by ucast filter count as 4
using devlink commands then ntuple count is being reverted to
default value 16 i.e, not retaining user set value 8.

Fixes: 39c469188b6d ("octeontx2-pf: Add ucast filter count configurability via devlink.")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/1747054357-5850-1-git-send-email-sbhatta@marvell.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h  | 1 +
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.c | 1 +
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c   | 3 ++-
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index f27a3456ae64f..5b45fd78d2825 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -364,6 +364,7 @@ struct otx2_flow_config {
 	struct list_head	flow_list_tc;
 	u8			ucast_flt_cnt;
 	bool			ntuple;
+	u16			ntuple_cnt;
 };
 
 struct dev_hw_ops {
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.c
index 53f14aa944bdb..aaea19345750e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.c
@@ -41,6 +41,7 @@ static int otx2_dl_mcam_count_set(struct devlink *devlink, u32 id,
 	if (!pfvf->flow_cfg)
 		return 0;
 
+	pfvf->flow_cfg->ntuple_cnt = ctx->val.vu16;
 	otx2_alloc_mcam_entries(pfvf, ctx->val.vu16);
 
 	return 0;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
index 58720a161ee24..2750326bfcf8b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
@@ -252,7 +252,7 @@ int otx2_mcam_entry_init(struct otx2_nic *pfvf)
 	mutex_unlock(&pfvf->mbox.lock);
 
 	/* Allocate entries for Ntuple filters */
-	count = otx2_alloc_mcam_entries(pfvf, OTX2_DEFAULT_FLOWCOUNT);
+	count = otx2_alloc_mcam_entries(pfvf, flow_cfg->ntuple_cnt);
 	if (count <= 0) {
 		otx2_clear_ntuple_flow_info(pfvf, flow_cfg);
 		return 0;
@@ -312,6 +312,7 @@ int otx2_mcam_flow_init(struct otx2_nic *pf)
 	INIT_LIST_HEAD(&pf->flow_cfg->flow_list_tc);
 
 	pf->flow_cfg->ucast_flt_cnt = OTX2_DEFAULT_UNICAST_FLOWS;
+	pf->flow_cfg->ntuple_cnt = OTX2_DEFAULT_FLOWCOUNT;
 
 	/* Allocate bare minimum number of MCAM entries needed for
 	 * unicast and ntuple filters.
-- 
2.39.5



