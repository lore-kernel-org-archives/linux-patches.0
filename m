Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 472053C23
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:38:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C39E6C433C0;
	Mon, 19 Jun 2023 10:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171119;
	bh=+dL4KD/N2q4MwQ4FKjKcVbXHpf0CN7d9dg68q7mCrug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dyCf02ZGjY8x3olCfW7qqszSpPUtXKlsyccsJuiuOjGcijP4I7fN3vrL6gvtOt+xH
	 2rt+l/XRPneNSZnkUJuBJ3Zf+JtM1Myo5b3Dd23isQ3VWdT4Ccelv84hUUWjDIq+R+
	 duv8mfbiFN0nnMnpII8au7dH5KlhP3x+/weP4HaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 129/187] octeontx2-af: Fix promiscuous mode
Date: Mon, 19 Jun 2023 12:29:07 +0200
Message-ID: <20230619102203.835882916@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102157.579823843@linuxfoundation.org>
References: <20230619102157.579823843@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ratheesh Kannoth <rkannoth@marvell.com>

[ Upstream commit c0e489372a294044feea650b38f38c888eff57a4 ]

CN10KB silicon introduced a new exact match feature,
which is used for DMAC filtering. The state of installed
DMAC filters in this exact match table is getting corrupted
when promiscuous mode is toggled. Fix this by not touching
Exact match related config when promiscuous mode is toggled.

Fixes: 2dba9459d2c9 ("octeontx2-af: Wrapper functions for MAC addr add/del/update/reset")
Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../marvell/octeontx2/af/rvu_npc_hash.c       | 29 ++-----------------
 1 file changed, 2 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
index 51209119f0f2f..9f11c1e407373 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
@@ -1164,10 +1164,8 @@ static u16 __rvu_npc_exact_cmd_rules_cnt_update(struct rvu *rvu, int drop_mcam_i
 {
 	struct npc_exact_table *table;
 	u16 *cnt, old_cnt;
-	bool promisc;
 
 	table = rvu->hw->table;
-	promisc = table->promisc_mode[drop_mcam_idx];
 
 	cnt = &table->cnt_cmd_rules[drop_mcam_idx];
 	old_cnt = *cnt;
@@ -1179,16 +1177,13 @@ static u16 __rvu_npc_exact_cmd_rules_cnt_update(struct rvu *rvu, int drop_mcam_i
 
 	*enable_or_disable_cam = false;
 
-	if (promisc)
-		goto done;
-
-	/* If all rules are deleted and not already in promisc mode; disable cam */
+	/* If all rules are deleted, disable cam */
 	if (!*cnt && val < 0) {
 		*enable_or_disable_cam = true;
 		goto done;
 	}
 
-	/* If rule got added and not already in promisc mode; enable cam */
+	/* If rule got added, enable cam */
 	if (!old_cnt && val > 0) {
 		*enable_or_disable_cam = true;
 		goto done;
@@ -1443,7 +1438,6 @@ int rvu_npc_exact_promisc_disable(struct rvu *rvu, u16 pcifunc)
 	u32 drop_mcam_idx;
 	bool *promisc;
 	bool rc;
-	u32 cnt;
 
 	table = rvu->hw->table;
 
@@ -1466,17 +1460,8 @@ int rvu_npc_exact_promisc_disable(struct rvu *rvu, u16 pcifunc)
 		return LMAC_AF_ERR_INVALID_PARAM;
 	}
 	*promisc = false;
-	cnt = __rvu_npc_exact_cmd_rules_cnt_update(rvu, drop_mcam_idx, 0, NULL);
 	mutex_unlock(&table->lock);
 
-	/* If no dmac filter entries configured, disable drop rule */
-	if (!cnt)
-		rvu_npc_enable_mcam_by_entry_index(rvu, drop_mcam_idx, NIX_INTF_RX, false);
-	else
-		rvu_npc_enable_mcam_by_entry_index(rvu, drop_mcam_idx, NIX_INTF_RX, !*promisc);
-
-	dev_dbg(rvu->dev, "%s: disabled  promisc mode (cgx=%d lmac=%d, cnt=%d)\n",
-		__func__, cgx_id, lmac_id, cnt);
 	return 0;
 }
 
@@ -1494,7 +1479,6 @@ int rvu_npc_exact_promisc_enable(struct rvu *rvu, u16 pcifunc)
 	u32 drop_mcam_idx;
 	bool *promisc;
 	bool rc;
-	u32 cnt;
 
 	table = rvu->hw->table;
 
@@ -1517,17 +1501,8 @@ int rvu_npc_exact_promisc_enable(struct rvu *rvu, u16 pcifunc)
 		return LMAC_AF_ERR_INVALID_PARAM;
 	}
 	*promisc = true;
-	cnt = __rvu_npc_exact_cmd_rules_cnt_update(rvu, drop_mcam_idx, 0, NULL);
 	mutex_unlock(&table->lock);
 
-	/* If no dmac filter entries configured, disable drop rule */
-	if (!cnt)
-		rvu_npc_enable_mcam_by_entry_index(rvu, drop_mcam_idx, NIX_INTF_RX, false);
-	else
-		rvu_npc_enable_mcam_by_entry_index(rvu, drop_mcam_idx, NIX_INTF_RX, !*promisc);
-
-	dev_dbg(rvu->dev, "%s: Enabled promisc mode (cgx=%d lmac=%d cnt=%d)\n",
-		__func__, cgx_id, lmac_id, cnt);
 	return 0;
 }
 
-- 
2.39.2



