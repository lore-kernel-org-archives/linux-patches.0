Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE37D1CAA85;
	Tue, 20 May 2025 14:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750579; cv=none; b=JydnTyN6JwkOgOEifhDWJkMY1OiCPMGUxu4VjKTscymdWoz9KfdxQSq9Hrqq0VroogKyzw6AvZPpN2PHQIY2CDekGswfJz26PQdT5ql0Iy32GYaDUAHWArjJVQTgjJ4LIwl0/kdJVWXxRboD7gXwrIf3b2ZU0NTlfUsBO/4yb7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750579; c=relaxed/simple;
	bh=wjW7hxsmroRVFb3uPw+uIw2AfQ9NGEA6iw+qXFwk8dI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ICBtMXhI4FUjLXMNwFvEtZNQpthrU0KNnXpq0ktOBufKEWpSqPWsmOCOSjuic9T3b5ytlID2PQAH9rGYa52LElEUhox113xYETW9ev927SdrwCq21kOaB0MOuzmDSNaJPp4r285bTGTT71XD3p+yoqarVvpnCxHENMqsAhXOoN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CMNGX7GQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CMNGX7GQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51E03C4CEE9;
	Tue, 20 May 2025 14:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750579;
	bh=wjW7hxsmroRVFb3uPw+uIw2AfQ9NGEA6iw+qXFwk8dI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CMNGX7GQ43BnGGMs0RfqkhHqij0UOrgGAUUzScYi4gKQM7LJtiAk+hwmJSYz9GKez
	 dPdPN+m4G4++Z1HUtutIexENv5h9eXCr6t1AFTq/qspWknsA1DUu5nSminx5J61lDQ
	 h3UulNJih6hiSF0w5GNZuLoC1qVT/OXiRjxhnENg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 055/145] octeontx2-pf: Do not reallocate all ntuple filters
Date: Tue, 20 May 2025 15:50:25 +0200
Message-ID: <20250520125812.735987118@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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
index 65814e3dc93f5..7cc12f10e8a15 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -349,6 +349,7 @@ struct otx2_flow_config {
 	struct list_head	flow_list_tc;
 	u8			ucast_flt_cnt;
 	bool			ntuple;
+	u16			ntuple_cnt;
 };
 
 struct dev_hw_ops {
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.c
index 33ec9a7f7c033..e13ae5484c19c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.c
@@ -41,6 +41,7 @@ static int otx2_dl_mcam_count_set(struct devlink *devlink, u32 id,
 	if (!pfvf->flow_cfg)
 		return 0;
 
+	pfvf->flow_cfg->ntuple_cnt = ctx->val.vu16;
 	otx2_alloc_mcam_entries(pfvf, ctx->val.vu16);
 
 	return 0;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
index 47bfd1fb37d4b..64c6d9162ef64 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
@@ -247,7 +247,7 @@ int otx2_mcam_entry_init(struct otx2_nic *pfvf)
 	mutex_unlock(&pfvf->mbox.lock);
 
 	/* Allocate entries for Ntuple filters */
-	count = otx2_alloc_mcam_entries(pfvf, OTX2_DEFAULT_FLOWCOUNT);
+	count = otx2_alloc_mcam_entries(pfvf, flow_cfg->ntuple_cnt);
 	if (count <= 0) {
 		otx2_clear_ntuple_flow_info(pfvf, flow_cfg);
 		return 0;
@@ -307,6 +307,7 @@ int otx2_mcam_flow_init(struct otx2_nic *pf)
 	INIT_LIST_HEAD(&pf->flow_cfg->flow_list_tc);
 
 	pf->flow_cfg->ucast_flt_cnt = OTX2_DEFAULT_UNICAST_FLOWS;
+	pf->flow_cfg->ntuple_cnt = OTX2_DEFAULT_FLOWCOUNT;
 
 	/* Allocate bare minimum number of MCAM entries needed for
 	 * unicast and ntuple filters.
-- 
2.39.5



