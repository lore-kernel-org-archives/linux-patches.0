Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215219;
	b=Y5Yi+QDjBIV0xGdD0HB4IDiZDp7w5LFShDorLH6GBWxv4fOvGn3HVi78IuthpUvgom0O
	 HacgVoDaqR4TYjXdJ/3D4HLcfEnv3jFhvDIT1cEdnxpXQRRejySTp1vs1qtgFFHUIy4Hv
	 AnHmJm8ooGCG11NdQn9XiLMcYTaeQG8UOdU8qrc/8a1pHCGAP5An20txQlMInSDNWSTYq
	 M6h7VEBal4NN9PwLuPrry6soRg4FPcgpIOR1OAvMPDxJU8SoSFgJac3LHTs1nRgkrL3Pq
	 CUNEvDQRNGlBP6VYB8zRPEs8SRT6C1n8aeZfuAzuCjjc+xbJK1gccP57ugv4gfHEV/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215219;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YdwXSkhDAqozvB0pkEMB5wHuy1aeRgc5y0O94Ls/ulc=;
	b=3AS+tW6uMaARPAX2Dy3Y36dvspU3XZ3Ai8cAeC3/RFcIjIn0VQhifB4BtGWCM7hT+JNM
	 fduOcHRTvrJkqVhVJcnrapHUxJduhvpixmNhZQLKuFVSshqvHzUVzWaz83EhQG2cvroac
	 x2XcP4o9p0PXQBqjCwR6TDF5Ckg0TEBB9Qh47FgbPy2bb1/0Klvn/C0AxLWJpYzcsql3E
	 P8tIHDBhZRXroQxTFtmg8mD5wFZHmm22x5BIPsCTdVInxsgznnG+Dw5F6LlD9Bnx6WrMN
	 Es7KSJozOH5c0NuWGlz4tvlC+ffqPQxfMUc5Bq0rQ8eh4EPOGXgsUQZKVuhJlyyWUZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I7ZOtizA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07AB606A31E;
	Wed, 28 Oct 2026 19:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I7ZOtizA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C90D1F01825;
	Wed, 28 Oct 2026 19:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215218;
	bh=YdwXSkhDAqozvB0pkEMB5wHuy1aeRgc5y0O94Ls/ulc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I7ZOtizAauL3l4o1wmfaWkJeIxfz/7QTG5WuX5xRRmL8NqyMMveBjbqQVvSkM6ebH
	 K4ybC/qhz0rGy2oxrzspoX8j37SFSbx5uVo+f7kFeSq+lwHjlQYXiciSSJvDg4jiVI
	 bH03hDyb9E7DyLTmmFjtd1dhawp/ITOQ0gAfCgDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Sowden <jeremy@azazel.net>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1132/1887] netfilter: nf_tables: fix dst corruption in same register operation
Date: Wed, 28 Oct 2026 17:53:48 +0100
Message-ID: <20261028170525.164040642@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 18014147d3ee7831dce53fe65d7fc8d428b02552 ]

For lshift and rshift, the shift operations are performed in a loop over
32-bit words. The loop calculates the shifted value and write it to dst,
and then immediately reads from src to calculate the carry for the next
iteration. Because src and dst could point to the same memory location,
the carry is incorrectly calculated using the newly modified dst value
instead of the original src value.

Adding a temporary local variable to cache the original value before
writing to dst and using it for the carry calculation solves the
problem. In addition, partial overlap is rejected from control plane for
all kind of operations including byteorder. This was tested with the
following bytecode:

table test_table ip flags 0 use 1 handle 1
ip test_table test_chain use 3 type filter hook input prio 0 policy accept packets 0 bytes 0 flags 1
ip test_table test_chain 2
  [ immediate reg 1 0x44332211 0x88776655 ]
  [ bitwise reg 1 = ( reg 1 << 0x08000000 ) ]
  [ cmp eq reg 1 0x66443322 0x00887766 ]
  [ counter pkts 0 bytes 0 ]
ip test_table test_chain 4 3
  [ immediate reg 1 0x44332211 0x88776655 ]
  [ bitwise reg 1 = ( reg 1 << 0x08000000 ) ]
  [ cmp eq reg 1 0x55443322 0x00887766 ]
  [ counter pkts 21794 bytes 1917798 ]

Fixes: 567d746b55bc ("netfilter: bitwise: add support for shifts.")
Acked-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables.h |  7 +++++++
 net/netfilter/nft_bitwise.c       | 15 +++++++++++----
 net/netfilter/nft_byteorder.c     | 13 ++++++++++---
 3 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 6d07f70b77ec0..ab228acb04c4c 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -187,6 +187,13 @@ static inline u64 nft_reg_load64(const u32 *sreg)
 	return get_unaligned((u64 *)sreg);
 }
 
+static inline bool nft_reg_overlap(u8 src, u8 dst, u32 len)
+{
+	unsigned int n = DIV_ROUND_UP(len, sizeof(u32));
+
+	return src != dst && src < dst + n && dst < src + n;
+}
+
 static inline void nft_data_copy(u32 *dst, const struct nft_data *src,
 				 unsigned int len)
 {
diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index a8f266d18501d..ca478f2bee8b7 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -42,8 +42,10 @@ static void nft_bitwise_eval_lshift(u32 *dst, const u32 *src,
 	u32 carry = 0;
 
 	for (i = DIV_ROUND_UP(priv->len, sizeof(u32)); i > 0; i--) {
-		dst[i - 1] = (src[i - 1] << shift) | carry;
-		carry = src[i - 1] >> (BITS_PER_TYPE(u32) - shift);
+		u32 tmp_src = src[i - 1];
+
+		dst[i - 1] = (tmp_src << shift) | carry;
+		carry = tmp_src >> (BITS_PER_TYPE(u32) - shift);
 	}
 }
 
@@ -55,8 +57,10 @@ static void nft_bitwise_eval_rshift(u32 *dst, const u32 *src,
 	u32 carry = 0;
 
 	for (i = 0; i < DIV_ROUND_UP(priv->len, sizeof(u32)); i++) {
-		dst[i] = carry | (src[i] >> shift);
-		carry = src[i] << (BITS_PER_TYPE(u32) - shift);
+		u32 tmp_src = src[i];
+
+		dst[i] = carry | (tmp_src >> shift);
+		carry = tmp_src << (BITS_PER_TYPE(u32) - shift);
 	}
 }
 
@@ -183,6 +187,9 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
 	if (err < 0)
 		return err;
 
+	if (nft_reg_overlap(priv->sreg, priv->dreg, priv->len))
+		return -EINVAL;
+
 	if (tb[NFTA_BITWISE_OP]) {
 		priv->op = ntohl(nla_get_be32(tb[NFTA_BITWISE_OP]));
 		switch (priv->op) {
diff --git a/net/netfilter/nft_byteorder.c b/net/netfilter/nft_byteorder.c
index 010d0d2f3423d..7218f8e3c6d45 100644
--- a/net/netfilter/nft_byteorder.c
+++ b/net/netfilter/nft_byteorder.c
@@ -144,9 +144,16 @@ static int nft_byteorder_init(const struct nft_ctx *ctx,
 	if (err < 0)
 		return err;
 
-	return nft_parse_register_store(ctx, tb[NFTA_BYTEORDER_DREG],
-					&priv->dreg, NULL, NFT_DATA_VALUE,
-					priv->len);
+	err = nft_parse_register_store(ctx, tb[NFTA_BYTEORDER_DREG],
+				       &priv->dreg, NULL, NFT_DATA_VALUE,
+				       priv->len);
+	if (err < 0)
+		return err;
+
+	if (nft_reg_overlap(priv->sreg, priv->dreg, priv->len))
+		return -EINVAL;
+
+	return 0;
 }
 
 static int nft_byteorder_dump(struct sk_buff *skb,
-- 
2.53.0



