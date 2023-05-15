Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 900DEFBF0
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:51:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E83DCC433EF;
	Mon, 15 May 2023 16:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169482;
	bh=D/ubNfuwc96h9hm0KG55nLI2hSYaoice0uOgBM37JA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ij7yBV6S5X7h/lTGpjvqPnN43UKTcbP5y1V62SpEV7vTMdxBeyx/v/F486fH6MfZo
	 /qhI+0lbt+uKVQ38NtFjrDf7UoBaS8vXS4JboATx0JbdaDNu2d6ht6G2h1aQwhGZeK
	 vxNwNvGJ/Izx6NSNEfE0V/FjLB+HBqt37+gYleTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Sunil Kovvuri Goutham <sgoutham@marvell.com>,
	Sai Krishna <saikrishnag@marvell.com>,
	Simon Horman <simon.horman@corigine.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 072/246] octeontx2-af: Fix issues with NPC field hash extract
Date: Mon, 15 May 2023 18:24:44 +0200
Message-Id: <20230515161724.732547157@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
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

[ Upstream commit f66155905959076619c9c519fb099e8ae6cb6f7b ]

1. Allow field hash configuration for both source and destination IPv6.
2. Configure hardware parser based on hash extract feature enable flag
   for IPv6.
3. Fix IPv6 endianness issue while updating the source/destination IP
   address via ntuple rule.

Fixes: 56d9f5fd2246 ("octeontx2-af: Use hashed field in MCAM key")
Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Signed-off-by: Sai Krishna <saikrishnag@marvell.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../marvell/octeontx2/af/rvu_npc_fs.c         | 23 +++--
 .../marvell/octeontx2/af/rvu_npc_fs.h         |  4 +
 .../marvell/octeontx2/af/rvu_npc_hash.c       | 88 ++++++++++---------
 .../marvell/octeontx2/af/rvu_npc_hash.h       |  4 +-
 4 files changed, 69 insertions(+), 50 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
index f15efd41972ee..952319453701b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
@@ -13,11 +13,6 @@
 #include "rvu_npc_fs.h"
 #include "rvu_npc_hash.h"
 
-#define NPC_BYTESM		GENMASK_ULL(19, 16)
-#define NPC_HDR_OFFSET		GENMASK_ULL(15, 8)
-#define NPC_KEY_OFFSET		GENMASK_ULL(5, 0)
-#define NPC_LDATA_EN		BIT_ULL(7)
-
 static const char * const npc_flow_names[] = {
 	[NPC_DMAC]	= "dmac",
 	[NPC_SMAC]	= "smac",
@@ -442,6 +437,7 @@ static void npc_handle_multi_layer_fields(struct rvu *rvu, int blkaddr, u8 intf)
 static void npc_scan_ldata(struct rvu *rvu, int blkaddr, u8 lid,
 			   u8 lt, u64 cfg, u8 intf)
 {
+	struct npc_mcam_kex_hash *mkex_hash = rvu->kpu.mkex_hash;
 	struct npc_mcam *mcam = &rvu->hw->mcam;
 	u8 hdr, key, nr_bytes, bit_offset;
 	u8 la_ltype, la_start;
@@ -490,8 +486,21 @@ do {									       \
 	NPC_SCAN_HDR(NPC_SIP_IPV4, NPC_LID_LC, NPC_LT_LC_IP, 12, 4);
 	NPC_SCAN_HDR(NPC_DIP_IPV4, NPC_LID_LC, NPC_LT_LC_IP, 16, 4);
 	NPC_SCAN_HDR(NPC_IPFRAG_IPV6, NPC_LID_LC, NPC_LT_LC_IP6_EXT, 6, 1);
-	NPC_SCAN_HDR(NPC_SIP_IPV6, NPC_LID_LC, NPC_LT_LC_IP6, 8, 16);
-	NPC_SCAN_HDR(NPC_DIP_IPV6, NPC_LID_LC, NPC_LT_LC_IP6, 24, 16);
+	if (rvu->hw->cap.npc_hash_extract) {
+		if (mkex_hash->lid_lt_ld_hash_en[intf][lid][lt][0])
+			NPC_SCAN_HDR(NPC_SIP_IPV6, NPC_LID_LC, NPC_LT_LC_IP6, 8, 4);
+		else
+			NPC_SCAN_HDR(NPC_SIP_IPV6, NPC_LID_LC, NPC_LT_LC_IP6, 8, 16);
+
+		if (mkex_hash->lid_lt_ld_hash_en[intf][lid][lt][1])
+			NPC_SCAN_HDR(NPC_DIP_IPV6, NPC_LID_LC, NPC_LT_LC_IP6, 24, 4);
+		else
+			NPC_SCAN_HDR(NPC_DIP_IPV6, NPC_LID_LC, NPC_LT_LC_IP6, 24, 16);
+	} else {
+		NPC_SCAN_HDR(NPC_SIP_IPV6, NPC_LID_LC, NPC_LT_LC_IP6, 8, 16);
+		NPC_SCAN_HDR(NPC_DIP_IPV6, NPC_LID_LC, NPC_LT_LC_IP6, 24, 16);
+	}
+
 	NPC_SCAN_HDR(NPC_SPORT_UDP, NPC_LID_LD, NPC_LT_LD_UDP, 0, 2);
 	NPC_SCAN_HDR(NPC_DPORT_UDP, NPC_LID_LD, NPC_LT_LD_UDP, 2, 2);
 	NPC_SCAN_HDR(NPC_SPORT_TCP, NPC_LID_LD, NPC_LT_LD_TCP, 0, 2);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.h
index bdd65ce56a32d..3f5c9042d10e7 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.h
@@ -9,6 +9,10 @@
 #define __RVU_NPC_FS_H
 
 #define IPV6_WORDS	4
+#define NPC_BYTESM	GENMASK_ULL(19, 16)
+#define NPC_HDR_OFFSET	GENMASK_ULL(15, 8)
+#define NPC_KEY_OFFSET	GENMASK_ULL(5, 0)
+#define NPC_LDATA_EN	BIT_ULL(7)
 
 void npc_update_entry(struct rvu *rvu, enum key_fields type,
 		      struct mcam_entry *entry, u64 val_lo,
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
index 68f813040363d..51209119f0f2f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
@@ -78,42 +78,43 @@ static u32 rvu_npc_toeplitz_hash(const u64 *data, u64 *key, size_t data_bit_len,
 	return hash_out;
 }
 
-u32 npc_field_hash_calc(u64 *ldata, struct npc_mcam_kex_hash *mkex_hash,
-			u64 *secret_key, u8 intf, u8 hash_idx)
+u32 npc_field_hash_calc(u64 *ldata, struct npc_get_field_hash_info_rsp rsp,
+			u8 intf, u8 hash_idx)
 {
 	u64 hash_key[3];
 	u64 data_padded[2];
 	u32 field_hash;
 
-	hash_key[0] = secret_key[1] << 31;
-	hash_key[0] |= secret_key[2];
-	hash_key[1] = secret_key[1] >> 33;
-	hash_key[1] |= secret_key[0] << 31;
-	hash_key[2] = secret_key[0] >> 33;
+	hash_key[0] = rsp.secret_key[1] << 31;
+	hash_key[0] |= rsp.secret_key[2];
+	hash_key[1] = rsp.secret_key[1] >> 33;
+	hash_key[1] |= rsp.secret_key[0] << 31;
+	hash_key[2] = rsp.secret_key[0] >> 33;
 
-	data_padded[0] = mkex_hash->hash_mask[intf][hash_idx][0] & ldata[0];
-	data_padded[1] = mkex_hash->hash_mask[intf][hash_idx][1] & ldata[1];
+	data_padded[0] = rsp.hash_mask[intf][hash_idx][0] & ldata[0];
+	data_padded[1] = rsp.hash_mask[intf][hash_idx][1] & ldata[1];
 	field_hash = rvu_npc_toeplitz_hash(data_padded, hash_key, 128, 159);
 
-	field_hash &= mkex_hash->hash_ctrl[intf][hash_idx] >> 32;
-	field_hash |= mkex_hash->hash_ctrl[intf][hash_idx];
+	field_hash &= FIELD_GET(GENMASK(63, 32), rsp.hash_ctrl[intf][hash_idx]);
+	field_hash += FIELD_GET(GENMASK(31, 0), rsp.hash_ctrl[intf][hash_idx]);
 	return field_hash;
 }
 
-static u64 npc_update_use_hash(int lt, int ld)
+static u64 npc_update_use_hash(struct rvu *rvu, int blkaddr,
+			       u8 intf, int lid, int lt, int ld)
 {
-	u64 cfg = 0;
-
-	switch (lt) {
-	case NPC_LT_LC_IP6:
-		/* Update use_hash(bit-20) and bytesm1 (bit-16:19)
-		 * in KEX_LD_CFG
-		 */
-		cfg = KEX_LD_CFG_USE_HASH(0x1, 0x03,
-					  ld ? 0x18 : 0x8,
-					  0x1, 0x0, ld ? 0x14 : 0x10);
-		break;
-	}
+	u8 hdr, key;
+	u64 cfg;
+
+	cfg = rvu_read64(rvu, blkaddr, NPC_AF_INTFX_LIDX_LTX_LDX_CFG(intf, lid, lt, ld));
+	hdr = FIELD_GET(NPC_HDR_OFFSET, cfg);
+	key = FIELD_GET(NPC_KEY_OFFSET, cfg);
+
+	/* Update use_hash(bit-20) to 'true' and
+	 * bytesm1(bit-16:19) to '0x3' in KEX_LD_CFG
+	 */
+	cfg = KEX_LD_CFG_USE_HASH(0x1, 0x03,
+				  hdr, 0x1, 0x0, key);
 
 	return cfg;
 }
@@ -132,11 +133,13 @@ static void npc_program_mkex_hash_rx(struct rvu *rvu, int blkaddr,
 		for (lt = 0; lt < NPC_MAX_LT; lt++) {
 			for (ld = 0; ld < NPC_MAX_LD; ld++) {
 				if (mkex_hash->lid_lt_ld_hash_en[intf][lid][lt][ld]) {
-					u64 cfg = npc_update_use_hash(lt, ld);
+					u64 cfg;
 
 					if (hash_cnt == NPC_MAX_HASH)
 						return;
 
+					cfg = npc_update_use_hash(rvu, blkaddr,
+								  intf, lid, lt, ld);
 					/* Set updated KEX configuration */
 					SET_KEX_LD(intf, lid, lt, ld, cfg);
 					/* Set HASH configuration */
@@ -170,11 +173,13 @@ static void npc_program_mkex_hash_tx(struct rvu *rvu, int blkaddr,
 		for (lt = 0; lt < NPC_MAX_LT; lt++) {
 			for (ld = 0; ld < NPC_MAX_LD; ld++)
 				if (mkex_hash->lid_lt_ld_hash_en[intf][lid][lt][ld]) {
-					u64 cfg = npc_update_use_hash(lt, ld);
+					u64 cfg;
 
 					if (hash_cnt == NPC_MAX_HASH)
 						return;
 
+					cfg = npc_update_use_hash(rvu, blkaddr,
+								  intf, lid, lt, ld);
 					/* Set updated KEX configuration */
 					SET_KEX_LD(intf, lid, lt, ld, cfg);
 					/* Set HASH configuration */
@@ -264,44 +269,45 @@ void npc_update_field_hash(struct rvu *rvu, u8 intf,
 				 * is hashed to 32 bit value.
 				 */
 				case NPC_LT_LC_IP6:
-					if (features & BIT_ULL(NPC_SIP_IPV6)) {
+					/* ld[0] == hash_idx[0] == Source IPv6
+					 * ld[1] == hash_idx[1] == Destination IPv6
+					 */
+					if ((features & BIT_ULL(NPC_SIP_IPV6)) && !hash_idx) {
 						u32 src_ip[IPV6_WORDS];
 
 						be32_to_cpu_array(src_ip, pkt->ip6src, IPV6_WORDS);
-						ldata[0] = (u64)src_ip[0] << 32 | src_ip[1];
-						ldata[1] = (u64)src_ip[2] << 32 | src_ip[3];
+						ldata[1] = (u64)src_ip[0] << 32 | src_ip[1];
+						ldata[0] = (u64)src_ip[2] << 32 | src_ip[3];
 						field_hash = npc_field_hash_calc(ldata,
-										 mkex_hash,
-										 rsp.secret_key,
+										 rsp,
 										 intf,
 										 hash_idx);
 						npc_update_entry(rvu, NPC_SIP_IPV6, entry,
-								 field_hash, 0, 32, 0, intf);
+								 field_hash, 0,
+								 GENMASK(31, 0), 0, intf);
 						memcpy(&opkt->ip6src, &pkt->ip6src,
 						       sizeof(pkt->ip6src));
 						memcpy(&omask->ip6src, &mask->ip6src,
 						       sizeof(mask->ip6src));
-						break;
-					}
-
-					if (features & BIT_ULL(NPC_DIP_IPV6)) {
+					} else if ((features & BIT_ULL(NPC_DIP_IPV6)) && hash_idx) {
 						u32 dst_ip[IPV6_WORDS];
 
 						be32_to_cpu_array(dst_ip, pkt->ip6dst, IPV6_WORDS);
-						ldata[0] = (u64)dst_ip[0] << 32 | dst_ip[1];
-						ldata[1] = (u64)dst_ip[2] << 32 | dst_ip[3];
+						ldata[1] = (u64)dst_ip[0] << 32 | dst_ip[1];
+						ldata[0] = (u64)dst_ip[2] << 32 | dst_ip[3];
 						field_hash = npc_field_hash_calc(ldata,
-										 mkex_hash,
-										 rsp.secret_key,
+										 rsp,
 										 intf,
 										 hash_idx);
 						npc_update_entry(rvu, NPC_DIP_IPV6, entry,
-								 field_hash, 0, 32, 0, intf);
+								 field_hash, 0,
+								 GENMASK(31, 0), 0, intf);
 						memcpy(&opkt->ip6dst, &pkt->ip6dst,
 						       sizeof(pkt->ip6dst));
 						memcpy(&omask->ip6dst, &mask->ip6dst,
 						       sizeof(mask->ip6dst));
 					}
+
 					break;
 				}
 			}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h
index 65936f4aeaacf..a1c3d987b8044 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h
@@ -62,8 +62,8 @@ void npc_update_field_hash(struct rvu *rvu, u8 intf,
 			   struct flow_msg *omask);
 void npc_config_secret_key(struct rvu *rvu, int blkaddr);
 void npc_program_mkex_hash(struct rvu *rvu, int blkaddr);
-u32 npc_field_hash_calc(u64 *ldata, struct npc_mcam_kex_hash *mkex_hash,
-			u64 *secret_key, u8 intf, u8 hash_idx);
+u32 npc_field_hash_calc(u64 *ldata, struct npc_get_field_hash_info_rsp rsp,
+			u8 intf, u8 hash_idx);
 
 static struct npc_mcam_kex_hash npc_mkex_hash_default __maybe_unused = {
 	.lid_lt_ld_hash_en = {
-- 
2.39.2



