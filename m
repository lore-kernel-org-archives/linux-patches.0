Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6612A43E9FD;
	Tue, 21 Jul 2026 22:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672212; cv=none; b=U69JsEwwwSmpafPhYM4wv7xhLKqsd0e/hPIVTJn1kzDSJTthzNB4OYm8D60Qk/KcImV8XYaKKX7tRNXTZYTE8bRvF5kxKmLEnG2ijIkysnBR8873uBl13NS9wPRUg9lE6PcRaFQ6WUcRDffaN4u/OvYqCh2lW8893zGYbQkSM8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672212; c=relaxed/simple;
	bh=gBUiSxKC9Cnn2Dtitp+PJf3UV8xTpILGjkPEJuxrVXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oz9DGhtiww3JwOwXEtfZPU6m2c8gbDq4H59DHCIHuPF9/mnXow/79jC3kuizjJqUbqvtEuWb4ZrqfDby2shgL0ETLs/fWYBIoS8WP78bjWn3N/O7mmRRKXPNpaR2BZODlSOckKTKYVCAIGnJjKTp/+oXIIERjonpDj5Gk/w0tUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YO22rSz1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YO22rSz1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB32C1F000E9;
	Tue, 21 Jul 2026 22:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672211;
	bh=Bs1xHGcuJMS5yL/ojmPhLMhYMXOLWpUqm4iwF77M1yQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YO22rSz1UGxYsSSvbePX2LKNJvxR2yJ4gQpcIpNC8XiXcyy3/Z6Uw9YM5BLru/T/C
	 RxDiAy+pJB1LkRHHn6HUO3G5LrnzqoneftTtiRzg1vUYuTC1qwo0zU+NJ/SW5LYjUz
	 KrPvsf2QgJP4ALm656oZygCJvRBOKVKi2k5ib/7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 537/843] octeontx2-af: FLR handler for exact match table.
Date: Tue, 21 Jul 2026 17:22:52 +0200
Message-ID: <20260721152418.113541130@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ratheesh Kannoth <rkannoth@marvell.com>

[ Upstream commit 799f02ef2ce38e5da7f9c8724df87d5043287526 ]

FLR handler should remove/free all exact match table resources
corresponding to each interface.

Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 235acadd3105 ("octeontx2-pf: check DMAC extraction support before filtering")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |  3 +++
 .../marvell/octeontx2/af/rvu_npc_hash.c       | 27 +++++++++++++++++++
 .../marvell/octeontx2/af/rvu_npc_hash.h       |  1 +
 3 files changed, 31 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 28a55362d37587..3e4f0309d8e9fb 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -2579,6 +2579,9 @@ static void rvu_blklf_teardown(struct rvu *rvu, u16 pcifunc, u8 blkaddr)
 
 static void __rvu_flr_handler(struct rvu *rvu, u16 pcifunc)
 {
+	if (rvu_npc_exact_has_match_table(rvu))
+		rvu_npc_exact_reset(rvu, pcifunc);
+
 	mutex_lock(&rvu->flr_lock);
 	/* Reset order should reflect inter-block dependencies:
 	 * 1. Reset any packet/work sources (NIX, CPT, TIM)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
index fc18f543ca25fb..d9be6b9978266e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
@@ -1183,6 +1183,33 @@ void rvu_npc_exact_disable_feature(struct rvu *rvu)
 	rvu->hw->cap.npc_exact_match_enabled = false;
 }
 
+/**
+ *	rvu_npc_exact_reset - Delete and free all entry which match pcifunc.
+ *      @rvu: resource virtualization unit.
+ *	@pcifunc: PCI func to match.
+ */
+void rvu_npc_exact_reset(struct rvu *rvu, u16 pcifunc)
+{
+	struct npc_exact_table *table = rvu->hw->table;
+	struct npc_exact_table_entry *tmp, *iter;
+	u32 seq_id;
+
+	mutex_lock(&table->lock);
+	list_for_each_entry_safe(iter, tmp, &table->lhead_gbl, glist) {
+		if (pcifunc != iter->pcifunc)
+			continue;
+
+		seq_id = iter->seq_id;
+		dev_dbg(rvu->dev, "%s: resetting pcifun=%d seq_id=%u\n", __func__,
+			pcifunc, seq_id);
+
+		mutex_unlock(&table->lock);
+		rvu_npc_exact_del_table_entry_by_id(rvu, seq_id);
+		mutex_lock(&table->lock);
+	}
+	mutex_unlock(&table->lock);
+}
+
 /**
  *      rvu_npc_exact_init - initialize exact match table
  *      @rvu: resource virtualization unit.
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h
index 7adb5c5c508209..0a4aeddbadcad1 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h
@@ -187,5 +187,6 @@ int rvu_npc_exact_init(struct rvu *rvu);
 
 bool rvu_npc_exact_can_disable_feature(struct rvu *rvu);
 void rvu_npc_exact_disable_feature(struct rvu *rvu);
+void rvu_npc_exact_reset(struct rvu *rvu, u16 pcifunc);
 
 #endif /* RVU_NPC_HASH_H */
-- 
2.53.0



