Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5526135E93B;
	Sat, 17 Oct 2026 17:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259454; cv=none; b=gfiyuDxW1EyygSN9o2wGmatrpInzetq+/CbWxjIUL3BYJ72dHcn5Ufr8hdvabPLcedFBcRbKUtIZuD9ko0Yi01bgezkQjqGt1IOwzqIAHHpeAdGU4z6XmRIzu1TYdK9fT7ubPWezPV73/ncIaocdqsfSbKHdGQEZ/x3aDTvMy/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259454; c=relaxed/simple;
	bh=1XMCPbe34/XKBznT2Cfom1Bb9am8RwWmIXsj+IHZtZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XNVjXJ4yhdr1jWuMAxoHchKt1mImyBFqCjO1Y2A6wpEaDadLgSaXDh8v5f2k1JCJL7NApDbByx/4p37upWHqnEk/dHi00e5//FUyJgHMThEG3o2ThfMOWgQIf+cY+6jyU625IZh+cr8zvPhbHmHzYlBc81z01lEALvlWfWTwOAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mNPtuqRE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mNPtuqRE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF821F000C4;
	Sat, 17 Oct 2026 17:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259453;
	bh=CRBuG/SjSeHl7nyHJRfbyEg3uJ14V8tiBQk/zvHZJKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mNPtuqRECQdPAdR9NOswYuMarRPBHzR7UO1K7+MxOGaukPdPGAyHgu7wGgPIQoQPJ
	 ekVtA8tiHAmCWYGAtu6YnFP2eLbl1yGWzHp4vdv0JTzEwiEaJeBN4ogZTtwoI/mDaZ
	 8nWPuHX+OCPGbs2NiAere+We0yNhT2meealfdbXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1218/1674] octeontx2-af: npc: Fix size of entry2cntr_map
Date: Sat, 17 Oct 2026 17:58:10 +0200
Message-ID: <20261017160502.407155682@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 01ffba0b4f906..fb3814717f909 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -1934,7 +1934,7 @@ static int npc_mcam_rsrcs_init(struct rvu *rvu, int blkaddr)
 	/* Alloc memory for MCAM entry to counter mapping and for tracking
 	 * counter's reference count.
 	 */
-	mcam->entry2cntr_map = devm_kcalloc(rvu->dev, mcam->bmap_entries,
+	mcam->entry2cntr_map = devm_kcalloc(rvu->dev, mcam->total_entries,
 					    sizeof(u16), GFP_KERNEL);
 	if (!mcam->entry2cntr_map)
 		goto free_mem;
@@ -1950,10 +1950,11 @@ static int npc_mcam_rsrcs_init(struct rvu *rvu, int blkaddr)
 	if (!mcam->entry2target_pffunc)
 		goto free_mem;
 
-	for (index = 0; index < mcam->bmap_entries; index++) {
+	for (index = 0; index < mcam->bmap_entries; index++)
 		mcam->entry2pfvf_map[index] = NPC_MCAM_INVALID_MAP;
+
+	for (index = 0; index < mcam->total_entries; index++)
 		mcam->entry2cntr_map[index] = NPC_MCAM_INVALID_MAP;
-	}
 
 	for (cntr = 0; cntr < mcam->counters.max; cntr++)
 		mcam->cntr2pfvf_map[cntr] = NPC_MCAM_INVALID_MAP;
@@ -3040,7 +3041,7 @@ int rvu_mbox_handler_npc_mcam_free_counter(struct rvu *rvu,
 		struct npc_mcam_oper_counter_req *req, struct msg_rsp *rsp)
 {
 	struct npc_mcam *mcam = &rvu->hw->mcam;
-	u16 index, entry = 0;
+	u16 index;
 	int blkaddr, err;
 
 	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
@@ -3058,20 +3059,16 @@ int rvu_mbox_handler_npc_mcam_free_counter(struct rvu *rvu,
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
 
 	mutex_unlock(&mcam->lock);
@@ -3082,7 +3079,7 @@ int rvu_mbox_handler_npc_mcam_unmap_counter(struct rvu *rvu,
 		struct npc_mcam_unmap_counter_req *req, struct msg_rsp *rsp)
 {
 	struct npc_mcam *mcam = &rvu->hw->mcam;
-	u16 index, entry = 0;
+	u16 index;
 	int blkaddr, rc;
 
 	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
@@ -3105,20 +3102,13 @@ int rvu_mbox_handler_npc_mcam_unmap_counter(struct rvu *rvu,
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



