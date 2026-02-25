Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E931D5141;
	Wed, 25 Feb 2026 01:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983580; cv=none; b=M3zL7R2UMxg3mJ8+cpQ6zTH8ptUIMuAw+z0fxiAHjnweBOOehjXiXsMxUZTT1qRoGlka6NaunjE5VNQNns4q1y0p78WMeqpzZy/ui59WLR+YD1CkFIyI75l+4FI729qyhXGMKhQFr1BbOY9VB1HjDS8IVpsTdrd42xxLikJkz/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983580; c=relaxed/simple;
	bh=URNlr5EEM5PytqjWMtXvBZmofAakxKvtdkncoc9Dcbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IPnVcFmwoGN9Izu/uPHhuzCsJFggFnscoaYO+lE7uKRR62kXUxixYQbaMW9IpBfmXD4Lr7eCyO/nE3+7Zgk/hNogwEUacWGPuhNObZzaa/BlZTfWK49CKhEQyOpsMsK0eo2OsDspa+RH5bLfMLEdeDVKfAJVkIAvMfaqyoP4aRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=da7BcYVe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="da7BcYVe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A539DC116D0;
	Wed, 25 Feb 2026 01:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983580;
	bh=URNlr5EEM5PytqjWMtXvBZmofAakxKvtdkncoc9Dcbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=da7BcYVe67rioADfnDBbcyGyAVf6OAIKjz155nQa6PhOtPMKYdSF7Jhsr0TuFC9jH
	 M+ltSmtbK+uBFDVZqNdjk+7WofHc43kvqbPYPOfvxbX/qPvcB/3uhPe+3njKEXD4Hl
	 drd4SBQ5FvHkWf/xHg0PFXl3HWYBX/7UWHZcOCTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hariprasad Kelam <hkelam@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 681/781] octeontx2-af: Fix default entries mcam entry action
Date: Tue, 24 Feb 2026 17:23:10 -0800
Message-ID: <20260225012416.478569551@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hariprasad Kelam <hkelam@marvell.com>

[ Upstream commit 45be47bf5d7db0f762a93e9c0ede6cb3c91edf3b ]

As per design, AF should update the default MCAM action only when
mcam_index is -1. A bug in the previous patch caused default entries
to be changed even when the request was not for them.

Fixes: 570ba37898ec ("octeontx2-af: Update RSS algorithm index")
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260216090338.1318976-1-hkelam@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/marvell/octeontx2/af/rvu_npc.c   | 41 ++++++++++---------
 1 file changed, 22 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index c7c70429eb6c1..8658cb2143dfc 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -1042,32 +1042,35 @@ void rvu_npc_update_flowkey_alg_idx(struct rvu *rvu, u16 pcifunc, int nixlf,
 	rvu_write64(rvu, blkaddr,
 		    NPC_AF_MCAMEX_BANKX_ACTION(index, bank), *(u64 *)&action);
 
-	/* update the VF flow rule action with the VF default entry action */
-	if (mcam_index < 0)
-		npc_update_vf_flow_entry(rvu, mcam, blkaddr, pcifunc,
-					 *(u64 *)&action);
-
 	/* update the action change in default rule */
 	pfvf = rvu_get_pfvf(rvu, pcifunc);
 	if (pfvf->def_ucast_rule)
 		pfvf->def_ucast_rule->rx_action = action;
 
-	index = npc_get_nixlf_mcam_index(mcam, pcifunc,
-					 nixlf, NIXLF_PROMISC_ENTRY);
+	if (mcam_index < 0) {
+		/* update the VF flow rule action with the VF default
+		 * entry action
+		 */
+		npc_update_vf_flow_entry(rvu, mcam, blkaddr, pcifunc,
+					 *(u64 *)&action);
 
-	/* If PF's promiscuous entry is enabled,
-	 * Set RSS action for that entry as well
-	 */
-	npc_update_rx_action_with_alg_idx(rvu, action, pfvf, index, blkaddr,
-					  alg_idx);
+		index = npc_get_nixlf_mcam_index(mcam, pcifunc,
+						 nixlf, NIXLF_PROMISC_ENTRY);
 
-	index = npc_get_nixlf_mcam_index(mcam, pcifunc,
-					 nixlf, NIXLF_ALLMULTI_ENTRY);
-	/* If PF's allmulti  entry is enabled,
-	 * Set RSS action for that entry as well
-	 */
-	npc_update_rx_action_with_alg_idx(rvu, action, pfvf, index, blkaddr,
-					  alg_idx);
+		/* If PF's promiscuous  entry is enabled,
+		 * Set RSS action for that entry as well
+		 */
+		npc_update_rx_action_with_alg_idx(rvu, action, pfvf, index,
+						  blkaddr, alg_idx);
+
+		index = npc_get_nixlf_mcam_index(mcam, pcifunc,
+						 nixlf, NIXLF_ALLMULTI_ENTRY);
+		/* If PF's allmulti  entry is enabled,
+		 * Set RSS action for that entry as well
+		 */
+		npc_update_rx_action_with_alg_idx(rvu, action, pfvf, index,
+						  blkaddr, alg_idx);
+	}
 }
 
 void npc_enadis_default_mce_entry(struct rvu *rvu, u16 pcifunc,
-- 
2.51.0



