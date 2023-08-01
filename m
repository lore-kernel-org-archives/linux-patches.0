Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55071FB4F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:43:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B885C433C8;
	Tue,  1 Aug 2023 09:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883010;
	bh=I/dCVCOy77eC5j0u8S+/JPAs1oSzQZNWnRRmdoVnzZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M9AFLGhUWtg1/sjp1oQNeagRhXpSHA2N28fGeW44yZh/ci9kMNpklMfBUpkOGuhp3
	 ZLz5W2iEdPx5Mxs3FWxnxwf+2pFoUTWyesAcW+8izZ3qq6h3Nd6n8oFAqtZSqq3kFU
	 jD24vflAOxIMh4QOF5p+b5fdJyANc6KQMaoWzPxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suman Ghosh <sumang@marvell.com>,
	Simon Horman <simon.horman@corigine.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 082/239] octeontx2-af: Fix hash extraction enable configuration
Date: Tue,  1 Aug 2023 11:19:06 +0200
Message-ID: <20230801091928.703902793@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Suman Ghosh <sumang@marvell.com>

[ Upstream commit 4e62c99d71e56817c934caa2a709a775c8cee078 ]

As of today, hash extraction support is enabled for all the silicons.
Because of which we are facing initialization issues when the silicon
does not support hash extraction. During creation of the hardware
parsing table for IPv6 address, we need to consider if hash extraction
is enabled then extract only 32 bit, otherwise 128 bit needs to be
extracted. This patch fixes the issue and configures the hardware parser
based on the availability of the feature.

Fixes: a95ab93550d3 ("octeontx2-af: Use hashed field in MCAM key")
Signed-off-by: Suman Ghosh <sumang@marvell.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/r/20230721061222.2632521-1-sumang@marvell.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../marvell/octeontx2/af/rvu_npc_hash.c       | 43 ++++++++++++++++++-
 .../marvell/octeontx2/af/rvu_npc_hash.h       |  8 ++--
 2 files changed, 46 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
index 6fe67f3a7f6f1..7e20282c12d00 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
@@ -218,13 +218,54 @@ void npc_config_secret_key(struct rvu *rvu, int blkaddr)
 
 void npc_program_mkex_hash(struct rvu *rvu, int blkaddr)
 {
+	struct npc_mcam_kex_hash *mh = rvu->kpu.mkex_hash;
 	struct hw_cap *hwcap = &rvu->hw->cap;
+	u8 intf, ld, hdr_offset, byte_len;
 	struct rvu_hwinfo *hw = rvu->hw;
-	u8 intf;
+	u64 cfg;
 
+	/* Check if hardware supports hash extraction */
 	if (!hwcap->npc_hash_extract)
 		return;
 
+	/* Check if IPv6 source/destination address
+	 * should be hash enabled.
+	 * Hashing reduces 128bit SIP/DIP fields to 32bit
+	 * so that 224 bit X2 key can be used for IPv6 based filters as well,
+	 * which in turn results in more number of MCAM entries available for
+	 * use.
+	 *
+	 * Hashing of IPV6 SIP/DIP is enabled in below scenarios
+	 * 1. If the silicon variant supports hashing feature
+	 * 2. If the number of bytes of IP addr being extracted is 4 bytes ie
+	 *    32bit. The assumption here is that if user wants 8bytes of LSB of
+	 *    IP addr or full 16 bytes then his intention is not to use 32bit
+	 *    hash.
+	 */
+	for (intf = 0; intf < hw->npc_intfs; intf++) {
+		for (ld = 0; ld < NPC_MAX_LD; ld++) {
+			cfg = rvu_read64(rvu, blkaddr,
+					 NPC_AF_INTFX_LIDX_LTX_LDX_CFG(intf,
+								       NPC_LID_LC,
+								       NPC_LT_LC_IP6,
+								       ld));
+			hdr_offset = FIELD_GET(NPC_HDR_OFFSET, cfg);
+			byte_len = FIELD_GET(NPC_BYTESM, cfg);
+			/* Hashing of IPv6 source/destination address should be
+			 * enabled if,
+			 * hdr_offset == 8 (offset of source IPv6 address) or
+			 * hdr_offset == 24 (offset of destination IPv6)
+			 * address) and the number of byte to be
+			 * extracted is 4. As per hardware configuration
+			 * byte_len should be == actual byte_len - 1.
+			 * Hence byte_len is checked against 3 but nor 4.
+			 */
+			if ((hdr_offset == 8 || hdr_offset == 24) && byte_len == 3)
+				mh->lid_lt_ld_hash_en[intf][NPC_LID_LC][NPC_LT_LC_IP6][ld] = true;
+		}
+	}
+
+	/* Update hash configuration if the field is hash enabled */
 	for (intf = 0; intf < hw->npc_intfs; intf++) {
 		npc_program_mkex_hash_rx(rvu, blkaddr, intf);
 		npc_program_mkex_hash_tx(rvu, blkaddr, intf);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h
index a1c3d987b8044..57a09328d46b5 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h
@@ -70,8 +70,8 @@ static struct npc_mcam_kex_hash npc_mkex_hash_default __maybe_unused = {
 	[NIX_INTF_RX] = {
 		[NPC_LID_LC] = {
 			[NPC_LT_LC_IP6] = {
-				true,
-				true,
+				false,
+				false,
 			},
 		},
 	},
@@ -79,8 +79,8 @@ static struct npc_mcam_kex_hash npc_mkex_hash_default __maybe_unused = {
 	[NIX_INTF_TX] = {
 		[NPC_LID_LC] = {
 			[NPC_LT_LC_IP6] = {
-				true,
-				true,
+				false,
+				false,
 			},
 		},
 	},
-- 
2.39.2



