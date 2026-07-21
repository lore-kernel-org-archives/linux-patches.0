Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F23A46DFF5;
	Tue, 21 Jul 2026 18:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659845; cv=none; b=fsxAqmiQIN2GmQp+7KTOphzmyLLy2upzAfA9ndHckY2Q79LLzi40GVpP0i83InH/LqiOJ7UwSd+6h4nMbQ5BCk7qI8EZUpf9g5w8WgPtiy2+CmO/e7HdT9eoGE+1C7Sh2TxXvgeIrp/U2z06K8J3EIV1niEjSGTQGu0VlYuOoz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659845; c=relaxed/simple;
	bh=fC/sAYyVOn/XBG4JAUDwV4VC8/G+lqmQOmQ9BxLBKSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aa9uNW67dbxStZmz8/2gehJt4zuAANRHISXHtpcE3T1vm3RROjRH+UmbTBgTCo1J8IxAj18lWSuwxM+tzPX5XoEjAauWvmIa2Buaurj/RorjEMMQyiSzTPblQe5C7qThWj+CjPi+sUCuSc35xxb2MQP1+zfVfeNHY8Ic0g5VTLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zc9idSLS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zc9idSLS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE6D81F000E9;
	Tue, 21 Jul 2026 18:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659844;
	bh=Fw8ZGEz0nsh1Ms4E+spXpiLCEKqUSD6/CEbMxVxsmtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zc9idSLST/wUmE+iSjCIHxWfPuDv2nDx6xaDUJ0bXMUKKQKnQn6Ox02LFoGElo0ax
	 67G9Z1hGaQZ7XSBdBBitjUOsCjoURRRcuW959CbPCHocNq+V3GwWbcwLtzUVTfabMh
	 93otLoCyvg6wYacRHs1CdMqyr8yplghy0i7+VDPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0755/2077] octeontx2-af: npc: Fix size of entry2cntr_map
Date: Tue, 21 Jul 2026 17:07:08 +0200
Message-ID: <20260721152610.595594019@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ratheesh Kannoth <rkannoth@marvell.com>

[ Upstream commit f9cd6fabe0e7c7f6fc30c6c192c7ed72aba37232 ]

KASAN prints below splat. This is caused by allocating counter for
reserved mcam entry for cpt 2nd pass entry. But mcam->entry2cntr_map
is not allocated for reserved entries.

BUG: KASAN: slab-out-of-bounds in npc_map_mcam_entry_and_cntr+0xb0/0x1a0
Write of size 2 at addr ffff0001033e7ffe by task kworker/0:1/14

CPU: 0 PID: 14 Comm: kworker/0:1 Not tainted 6.1.67 #1
Hardware name: Marvell CN106XX board (DT)
Workqueue: events work_for_cpu_fn
Call trace:
 dump_backtrace.part.0+0xe4/0xf0
 show_stack+0x18/0x30
 dump_stack_lvl+0x88/0xb4
 print_report+0x154/0x458
 kasan_report+0xb8/0x194
 __asan_store2+0x7c/0xa0
 npc_map_mcam_entry_and_cntr+0xb0/0x1a0
 rvu_mbox_handler_npc_mcam_write_entry+0x268/0x280
 npc_install_flow+0x840/0xfe0
 rvu_npc_install_cpt_pass2_entry+0x138/0x190
 rvu_nix_init+0x148c/0x2880
 rvu_probe+0x1800/0x30b0
 local_pci_probe+0x78/0xe0
 work_for_cpu_fn+0x30/0x50
 process_one_work+0x4cc/0x97c
 worker_thread+0x360/0x630
 kthread+0x1a0/0x1b0
 ret_from_fork+0x10/0x20

Fixes: 55307fcb9258 ("octeontx2-af: Add mbox messages to install and delete MCAM rules")
Cc: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
Link: https://patch.msgid.link/20260610022344.969774-1-rkannoth@marvell.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/marvell/octeontx2/af/rvu_npc.c   | 40 +++++++------------
 1 file changed, 15 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index d301a3f0f87a86..4994385a822b72 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -2181,7 +2181,7 @@ int npc_mcam_rsrcs_init(struct rvu *rvu, int blkaddr)
 	/* Alloc memory for MCAM entry to counter mapping and for tracking
 	 * counter's reference count.
 	 */
-	mcam->entry2cntr_map = kcalloc(mcam->bmap_entries, sizeof(u16),
+	mcam->entry2cntr_map = kcalloc(mcam->total_entries, sizeof(u16),
 				       GFP_KERNEL);
 	if (!mcam->entry2cntr_map)
 		goto free_cntr_map;
@@ -2197,10 +2197,11 @@ int npc_mcam_rsrcs_init(struct rvu *rvu, int blkaddr)
 	if (!mcam->entry2target_pffunc)
 		goto free_cntr_refcnt;
 
-	for (index = 0; index < mcam->bmap_entries; index++) {
+	for (index = 0; index < mcam->bmap_entries; index++)
 		mcam->entry2pfvf_map[index] = NPC_MCAM_INVALID_MAP;
+
+	for (index = 0; index < mcam->total_entries; index++)
 		mcam->entry2cntr_map[index] = NPC_MCAM_INVALID_MAP;
-	}
 
 	for (cntr = 0; cntr < mcam->counters.max; cntr++)
 		mcam->cntr2pfvf_map[cntr] = NPC_MCAM_INVALID_MAP;
@@ -3531,7 +3532,7 @@ static int __npc_mcam_free_counter(struct rvu *rvu,
 				   struct msg_rsp *rsp)
 {
 	struct npc_mcam *mcam = &rvu->hw->mcam;
-	u16 index, entry = 0;
+	u16 index;
 	int blkaddr, err;
 
 	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
@@ -3547,20 +3548,16 @@ static int __npc_mcam_free_counter(struct rvu *rvu,
 	mcam->cntr2pfvf_map[req->cntr] = NPC_MCAM_INVALID_MAP;
 	rvu_free_rsrc(&mcam->counters, req->cntr);
 
-	/* Disable all MCAM entry's stats which are using this counter */
-	while (entry < mcam->bmap_entries) {
+	/* Disable all MCAM entry's stats which are using this counter.
+	 * Scan the full MCAM index range: AF-reserved rules (e.g. CPT pass-2)
+	 */
+	for (index = 0; index < mcam->total_entries; index++) {
 		if (!mcam->cntr_refcnt[req->cntr])
 			break;
-
-		index = find_next_bit(mcam->bmap, mcam->bmap_entries, entry);
-		if (index >= mcam->bmap_entries)
-			break;
-		entry = index + 1;
 		if (mcam->entry2cntr_map[index] != req->cntr)
 			continue;
-
-		npc_unmap_mcam_entry_and_cntr(rvu, mcam, blkaddr,
-					      index, req->cntr);
+		npc_unmap_mcam_entry_and_cntr(rvu, mcam, blkaddr, index,
+					      req->cntr);
 	}
 
 	return 0;
@@ -3631,7 +3628,7 @@ int rvu_mbox_handler_npc_mcam_unmap_counter(struct rvu *rvu,
 		struct npc_mcam_unmap_counter_req *req, struct msg_rsp *rsp)
 {
 	struct npc_mcam *mcam = &rvu->hw->mcam;
-	u16 index, entry = 0;
+	u16 index;
 	int blkaddr, rc;
 
 	/* Counter is not supported for CN20K */
@@ -3658,20 +3655,13 @@ int rvu_mbox_handler_npc_mcam_unmap_counter(struct rvu *rvu,
 	}
 
 	/* Disable all MCAM entry's stats which are using this counter */
-	while (entry < mcam->bmap_entries) {
+	for (index = 0; index < mcam->total_entries; index++) {
 		if (!mcam->cntr_refcnt[req->cntr])
 			break;
-
-		index = find_next_bit(mcam->bmap, mcam->bmap_entries, entry);
-		if (index >= mcam->bmap_entries)
-			break;
-		entry = index + 1;
-
 		if (mcam->entry2cntr_map[index] != req->cntr)
 			continue;
-
-		npc_unmap_mcam_entry_and_cntr(rvu, mcam, blkaddr,
-					      index, req->cntr);
+		npc_unmap_mcam_entry_and_cntr(rvu, mcam, blkaddr, index,
+					      req->cntr);
 	}
 exit:
 	mutex_unlock(&mcam->lock);
-- 
2.53.0



