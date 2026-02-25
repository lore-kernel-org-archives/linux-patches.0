Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22ECA2D4805;
	Wed, 25 Feb 2026 06:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002748; cv=none; b=TXY1nrKsvXCQ0rRWwFRzAMv4XYSNQKZ4KL3fGRYT1sRVf+g9hQuPl+YoP/a8k4lGLo+qkgXGJ00EEUvRW0AuDxt77JmHFzXGUILi8HQGRAzc0Oid+7VJxrLuP/+VfAYm1ZQRD2mRZX5iSM9SfhUHDjNwTwsWnS+RmqZwQb0OQyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002748; c=relaxed/simple;
	bh=hv+rh8VPgDn+AFnwuwMHWsVQsXQa1lw1UyVDdpLB3TY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gB4Sf+kdUXryS+ZV17ilvl8pkGHNA7y82DLcbAWJRQBhckmtMLKiGAYT5CLuZozcp6RP9Pjwdbn4CiF1NfcM4+SyUBiV+30B8Km2rQZp/7bqrF5UH49PGwGU73Dq6/95JxG5cDfevPNnqzrrJYvM1Kcdcb6jP9AWuwTHWyR+hHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XZGcak4d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XZGcak4d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDCA8C116D0;
	Wed, 25 Feb 2026 06:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002748;
	bh=hv+rh8VPgDn+AFnwuwMHWsVQsXQa1lw1UyVDdpLB3TY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XZGcak4dGVkA/6evMHuxDBf9g03WOmaaK8WXpjgyXPU/k1HoZKearocBMKsAdG60z
	 +/qwkiuOa4OitZD38ote9J/0OVkQOKxRR9kkJ+2OfF+OvuPq/r3BIkTPsFqg+xbYDT
	 yNF+6S1XVOnZjqWbB8Hbkuy+oAMfPEvQosbLVRMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hariprasad Kelam <hkelam@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 555/641] octeontx2-af: Fix default entries mcam entry action
Date: Tue, 24 Feb 2026 17:24:41 -0800
Message-ID: <20260225012401.972609551@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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
Message-ID: <20260225012441.wHo6ASUZE-HWVutQW0GZw3lHyJfYJM0D-KstCA-R6bA@z>

6.18-stable review patch.  If anyone has any objections, please let me know.

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



