Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C651DDCE;
	Tue, 16 Jul 2024 16:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721146235; cv=none; b=nL3xx4r3xgsvGXZSU+0zoEdEoZWe8Hr9eAhfxUF5oOPOBAUD5pr7ePpOOQ8VfXgDuvnKxngtoXzhkkh1UcDcZFkl3iQgIUrOqon/6sbRbmSlkDKY1EQVMHqoHVGDEozV8CFmd81o9yGkz7doI2gVcjPaARJcCRjQxfnajuwdlpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721146235; c=relaxed/simple;
	bh=yp2ZNaN/F2ZeI/Py2d2J76uTWib+wMU9aE8wq4hlo6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JpD6SuQLsiOI6O7j5ghc87idHRoGn9NrmVt3XQmrYUWYs4cvqFYr6rLzQJoDqaSLG23MG9Jfel71SYjnR1YgBWHuy0U9nCQL2Xcdr7ySPB5fxL+EwcSlLb1/2tgI/mJkyMUIgaB2MECK3gHO3+lA7a9FS3UhslEPFzDWMVlNIeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lheXT2aO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lheXT2aO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B1E1C116B1;
	Tue, 16 Jul 2024 16:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721146235;
	bh=yp2ZNaN/F2ZeI/Py2d2J76uTWib+wMU9aE8wq4hlo6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lheXT2aOxCmAy3T3Em/xvlkharUvTgm6tDWCd2DFQSEfvmGeMtnuwi3ecsLGgmei+
	 pdg3Ry+f+YXFiUILhkn7SQAB0W4pVyVovKsq6Yu8Uw9v4rP5v11zAfAki5r9pn4fi3
	 3Ak+Nr+L1XqF9az3GCLY8OoJAyU2gh9jnSxRXGmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiran Kumar K <kirankumark@marvell.com>,
	Geetha sowjanya <gakula@marvell.com>,
	Naveen Mamindlapalli <naveenm@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 101/144] octeontx2-af: extend RSS supported offload types
Date: Tue, 16 Jul 2024 17:32:50 +0200
Message-ID: <20240716152756.418010527@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Kiran Kumar K <kirankumark@marvell.com>

[ Upstream commit 79bc788c038c9c87224d41ba6bbab20b6bf1a141 ]

Add support to select L3 SRC or DST only, L4 SRC or DST only for RSS
calculation.

AF consumer may have requirement as we can select only SRC or DST data for
RSS calculation in L3, L4 layers. With this requirement there will be
following combinations, IPV[4,6]_SRC_ONLY, IPV[4,6]_DST_ONLY,
[TCP,UDP,SCTP]_SRC_ONLY, [TCP,UDP,SCTP]_DST_ONLY. So, instead of creating
a bit for each combination, we are using upper 4 bits (31:28) in the
flow_key_cfg to represent the SRC, DST selection. 31 => L3_SRC,
30 => L3_DST, 29 => L4_SRC, 28 => L4_DST. These won't be part of flow_cfg,
so that we don't need to change the existing ABI.

Signed-off-by: Kiran Kumar K <kirankumark@marvell.com>
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: e23ac1095b9e ("octeontx2-af: fix issue with IPv6 ext match for RSS")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |  6 ++
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   | 57 +++++++++++++++++++
 2 files changed, 63 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index bd37fdced37cd..fafdf36ad58bf 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -974,6 +974,8 @@ struct nix_vtag_config_rsp {
 	 */
 };
 
+#define NIX_FLOW_KEY_TYPE_L3_L4_MASK (~(0xf << 28))
+
 struct nix_rss_flowkey_cfg {
 	struct mbox_msghdr hdr;
 	int	mcam_index;  /* MCAM entry index to modify */
@@ -999,6 +1001,10 @@ struct nix_rss_flowkey_cfg {
 #define NIX_FLOW_KEY_TYPE_IPV4_PROTO	BIT(21)
 #define NIX_FLOW_KEY_TYPE_AH		BIT(22)
 #define NIX_FLOW_KEY_TYPE_ESP		BIT(23)
+#define NIX_FLOW_KEY_TYPE_L4_DST_ONLY BIT(28)
+#define NIX_FLOW_KEY_TYPE_L4_SRC_ONLY BIT(29)
+#define NIX_FLOW_KEY_TYPE_L3_DST_ONLY BIT(30)
+#define NIX_FLOW_KEY_TYPE_L3_SRC_ONLY BIT(31)
 	u32	flowkey_cfg; /* Flowkey types selected */
 	u8	group;       /* RSS context or group */
 };
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 34a9a9164f3c6..9398dd3ae09b5 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -3314,6 +3314,7 @@ static int set_flowkey_fields(struct nix_rx_flowkey_alg *alg, u32 flow_cfg)
 	struct nix_rx_flowkey_alg *field;
 	struct nix_rx_flowkey_alg tmp;
 	u32 key_type, valid_key;
+	u32 l3_l4_src_dst;
 	int l4_key_offset = 0;
 
 	if (!alg)
@@ -3341,6 +3342,15 @@ static int set_flowkey_fields(struct nix_rx_flowkey_alg *alg, u32 flow_cfg)
 	 * group_member - Enabled when protocol is part of a group.
 	 */
 
+	/* Last 4 bits (31:28) are reserved to specify SRC, DST
+	 * selection for L3, L4 i.e IPV[4,6]_SRC, IPV[4,6]_DST,
+	 * [TCP,UDP,SCTP]_SRC, [TCP,UDP,SCTP]_DST
+	 * 31 => L3_SRC, 30 => L3_DST, 29 => L4_SRC, 28 => L4_DST
+	 */
+	l3_l4_src_dst = flow_cfg;
+	/* Reset these 4 bits, so that these won't be part of key */
+	flow_cfg &= NIX_FLOW_KEY_TYPE_L3_L4_MASK;
+
 	keyoff_marker = 0; max_key_off = 0; group_member = 0;
 	nr_field = 0; key_off = 0; field_marker = 1;
 	field = &tmp; max_bit_pos = fls(flow_cfg);
@@ -3378,6 +3388,22 @@ static int set_flowkey_fields(struct nix_rx_flowkey_alg *alg, u32 flow_cfg)
 			}
 			field->hdr_offset = 12; /* SIP offset */
 			field->bytesm1 = 7; /* SIP + DIP, 8 bytes */
+
+			/* Only SIP */
+			if (l3_l4_src_dst & NIX_FLOW_KEY_TYPE_L3_SRC_ONLY)
+				field->bytesm1 = 3; /* SIP, 4 bytes */
+
+			if (l3_l4_src_dst & NIX_FLOW_KEY_TYPE_L3_DST_ONLY) {
+				/* Both SIP + DIP */
+				if (field->bytesm1 == 3) {
+					field->bytesm1 = 7; /* SIP + DIP, 8B */
+				} else {
+					/* Only DIP */
+					field->hdr_offset = 16; /* DIP off */
+					field->bytesm1 = 3; /* DIP, 4 bytes */
+				}
+			}
+
 			field->ltype_mask = 0xF; /* Match only IPv4 */
 			keyoff_marker = false;
 			break;
@@ -3391,6 +3417,22 @@ static int set_flowkey_fields(struct nix_rx_flowkey_alg *alg, u32 flow_cfg)
 			}
 			field->hdr_offset = 8; /* SIP offset */
 			field->bytesm1 = 31; /* SIP + DIP, 32 bytes */
+
+			/* Only SIP */
+			if (l3_l4_src_dst & NIX_FLOW_KEY_TYPE_L3_SRC_ONLY)
+				field->bytesm1 = 15; /* SIP, 16 bytes */
+
+			if (l3_l4_src_dst & NIX_FLOW_KEY_TYPE_L3_DST_ONLY) {
+				/* Both SIP + DIP */
+				if (field->bytesm1 == 15) {
+					/* SIP + DIP, 32 bytes */
+					field->bytesm1 = 31;
+				} else {
+					/* Only DIP */
+					field->hdr_offset = 24; /* DIP off */
+					field->bytesm1 = 15; /* DIP,16 bytes */
+				}
+			}
 			field->ltype_mask = 0xF; /* Match only IPv6 */
 			break;
 		case NIX_FLOW_KEY_TYPE_TCP:
@@ -3406,6 +3448,21 @@ static int set_flowkey_fields(struct nix_rx_flowkey_alg *alg, u32 flow_cfg)
 				field->lid = NPC_LID_LH;
 			field->bytesm1 = 3; /* Sport + Dport, 4 bytes */
 
+			if (l3_l4_src_dst & NIX_FLOW_KEY_TYPE_L4_SRC_ONLY)
+				field->bytesm1 = 1; /* SRC, 2 bytes */
+
+			if (l3_l4_src_dst & NIX_FLOW_KEY_TYPE_L4_DST_ONLY) {
+				/* Both SRC + DST */
+				if (field->bytesm1 == 1) {
+					/* SRC + DST, 4 bytes */
+					field->bytesm1 = 3;
+				} else {
+					/* Only DIP */
+					field->hdr_offset = 2; /* DST off */
+					field->bytesm1 = 1; /* DST, 2 bytes */
+				}
+			}
+
 			/* Enum values for NPC_LID_LD and NPC_LID_LG are same,
 			 * so no need to change the ltype_match, just change
 			 * the lid for inner protocols
-- 
2.43.0



