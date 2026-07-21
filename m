Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20ACD4499BC;
	Tue, 21 Jul 2026 22:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672207; cv=none; b=El58vjovhfs1/dJ7Nsn3wrUbsS8D6ooShxG9varsGa9j+zKu3Yp+ndGlWhIv1pzVWZNmf4WriuVEvrLK65sd3NsTuh8Un77qf7zQA5aaCY9XgA/KcNaYRmH638x5bDoBGeg/OQgNy7k/PiTsrRuov3kNPImfWYprRVILg6r7ZV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672207; c=relaxed/simple;
	bh=vMVfWBeWqjX6dL5Xau+TtBipmgZe7I9Umqj0QAgpuvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r5H2mZb2fBqc/yFCAwt9BEFL/GECnnsUx08GjGZIZBAkFeR7JKLE0wfryv6vfafFApI4aQxCy0kdRmdvS4ISHGWykS/ZI4jcQ7k5zQl3S/ix1ygH9dTNJiUNmLvguMMgimBHtDaYu6ILIMU2UdZnE+tVYW10glD1nYLTPH7v8kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n8V4clGW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n8V4clGW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 861D91F000E9;
	Tue, 21 Jul 2026 22:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672206;
	bh=fwZXYKV2SZ/Hmhifkx7nNyvKsJhkdgLSr290ensKRMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n8V4clGWYtW0TpjN0qtdJRO2KIMyQePF3U/yRtjCZMrLaoFXwpjjZ8tJKw+vhv6QL
	 3SS+IITOJjMXYnLSI+PyXUHXXGMrbaSbnC44pW4/1oXhKhMEv/HEiRjL9EB68LzZnA
	 s2vQy6uoiMs440GkiWesBB+bWVRLl6JNZiCI1II4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 535/843] octeontx2-af: Exact match scan from kex profile
Date: Tue, 21 Jul 2026 17:22:50 +0200
Message-ID: <20260721152418.067235463@linuxfoundation.org>
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

[ Upstream commit 60ec393117503e97a59ff9545b1b5be1a875c1c7 ]

CN10KB silicon supports exact match table. Scanning KEX
profile should check for exact match feature is enabled
and then set profile masks properly.

These kex profile masks are required to configure NPC
MCAM drop rules. If there is a miss in exact match table,
these drop rules will drop those packets.

Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 235acadd3105 ("octeontx2-pf: check DMAC extraction support before filtering")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/marvell/octeontx2/af/npc.h   |  1 +
 .../marvell/octeontx2/af/rvu_npc_fs.c         | 37 +++++++++++++++++--
 2 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc.h b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
index 5df7354ba12855..2662a46857ef9c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
@@ -215,6 +215,7 @@ enum key_fields {
 	NPC_ERRLEV,
 	NPC_ERRCODE,
 	NPC_LXMB,
+	NPC_EXACT_RESULT,
 	NPC_LA,
 	NPC_LB,
 	NPC_LC,
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
index 08656eba898962..c5c452cf6cf4b3 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
@@ -229,6 +229,25 @@ static bool npc_check_field(struct rvu *rvu, int blkaddr, enum key_fields type,
 	return true;
 }
 
+static void npc_scan_exact_result(struct npc_mcam *mcam, u8 bit_number,
+				  u8 key_nibble, u8 intf)
+{
+	u8 offset = (key_nibble * 4) % 64; /* offset within key word */
+	u8 kwi = (key_nibble * 4) / 64; /* which word in key */
+	u8 nr_bits = 4; /* bits in a nibble */
+	u8 type;
+
+	switch (bit_number) {
+	case 40 ... 43:
+		type = NPC_EXACT_RESULT;
+		break;
+
+	default:
+		return;
+	}
+	npc_set_kw_masks(mcam, type, nr_bits, kwi, offset, intf);
+}
+
 static void npc_scan_parse_result(struct npc_mcam *mcam, u8 bit_number,
 				  u8 key_nibble, u8 intf)
 {
@@ -512,8 +531,8 @@ static int npc_scan_kex(struct rvu *rvu, int blkaddr, u8 intf)
 {
 	struct npc_mcam *mcam = &rvu->hw->mcam;
 	u8 lid, lt, ld, bitnr;
+	u64 cfg, masked_cfg;
 	u8 key_nibble = 0;
-	u64 cfg;
 
 	/* Scan and note how parse result is going to be in key.
 	 * A bit set in PARSE_NIBBLE_ENA corresponds to a nibble from
@@ -521,12 +540,24 @@ static int npc_scan_kex(struct rvu *rvu, int blkaddr, u8 intf)
 	 * will be concatenated in key.
 	 */
 	cfg = rvu_read64(rvu, blkaddr, NPC_AF_INTFX_KEX_CFG(intf));
-	cfg &= NPC_PARSE_NIBBLE;
-	for_each_set_bit(bitnr, (unsigned long *)&cfg, 31) {
+	masked_cfg = cfg & NPC_PARSE_NIBBLE;
+	for_each_set_bit(bitnr, (unsigned long *)&masked_cfg, 31) {
 		npc_scan_parse_result(mcam, bitnr, key_nibble, intf);
 		key_nibble++;
 	}
 
+	/* Ignore exact match bits for mcam entries except the first rule
+	 * which is drop on hit. This first rule is configured explitcitly by
+	 * exact match code.
+	 */
+	masked_cfg = cfg & NPC_EXACT_NIBBLE;
+	bitnr = NPC_EXACT_NIBBLE_START;
+	for_each_set_bit_from(bitnr, (unsigned long *)&masked_cfg,
+			      NPC_EXACT_NIBBLE_START) {
+		npc_scan_exact_result(mcam, bitnr, key_nibble, intf);
+		key_nibble++;
+	}
+
 	/* Scan and note how layer data is going to be in key */
 	for (lid = 0; lid < NPC_MAX_LID; lid++) {
 		for (lt = 0; lt < NPC_MAX_LT; lt++) {
-- 
2.53.0



