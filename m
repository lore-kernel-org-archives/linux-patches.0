Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1224E1DE8AE;
	Sun,  7 Jun 2026 10:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780826881; cv=none; b=pFrsm9kJC9SAEhMStOcFlxi006iXYJ3RNBnkxKh1iK1nxlDJb7lDerWZQx3zGWbPJbY53O3d7otRkSHS2slh6g5/CA6xkDuaHs1bPEqq+6qxzQTMFWDYLdU/ffCwfqn6tHc1PHp8Dj+B/o8sCwLnw0ZXD/AO74qHA+ioromxM8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780826881; c=relaxed/simple;
	bh=+5QWb+5UNoU03K/uMv2SfFukKZeJ0/zLT4CIAuHBI28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A5F8D51QVqbFZgRQNmXVnqTT6oHHvjLQJ0D1zdbU0NrKr8dmGS5xt97ngGzW2SH1GiBFY9I1zh4MCi4VU4Th9MU3/LZEOTnu2AzqdDsHgLrZjHqpLAFO/7lp9atWOkX7uNtxs4KSd7gEEhKtWnutUCeG4NePpunZGaJc8KoAesw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wd5wXffe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wd5wXffe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 174481F00893;
	Sun,  7 Jun 2026 10:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780826879;
	bh=FPwJMT0DlaD9j41lfY+bhEVMmNbQ4z4idHXfk7UNIuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wd5wXffejPjIr0GelCltCHWFE9yFNIP+B1EJt5FPUVS+UNxiwWKHAAmrYETe5Nghn
	 s/QOc1YckxGPycxN2c1DUF3lUE1fSFXFqgTy0GtxHm8nFKEezfWwjZbMvC8BqnWZqt
	 HVgNCkkyigtrxDu5448Dm1Xuf4k4y8HwXlwmFQK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Sowden <jeremy@azazel.net>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 019/315] netfilter: nf_tables: fix dst corruption in same register operation
Date: Sun,  7 Jun 2026 11:56:46 +0200
Message-ID: <20260607095728.200523499@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 net/netfilter/nft_bitwise.c       | 18 ++++++++++++++----
 net/netfilter/nft_byteorder.c     | 13 ++++++++++---
 3 files changed, 31 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 4dc080f7f27c65..b35e8c02fadcd5 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -188,6 +188,13 @@ static inline u64 nft_reg_load64(const u32 *sreg)
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
index af990c600745be..1afb36fb5994db 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -43,8 +43,10 @@ static void nft_bitwise_eval_lshift(u32 *dst, const u32 *src,
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
 
@@ -56,8 +58,10 @@ static void nft_bitwise_eval_rshift(u32 *dst, const u32 *src,
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
 
@@ -235,6 +239,9 @@ static int nft_bitwise_init_bool(const struct nft_ctx *ctx,
 					      &priv->sreg2, priv->len);
 		if (err < 0)
 			return err;
+
+		if (nft_reg_overlap(priv->sreg2, priv->dreg, priv->len))
+			return -EINVAL;
 	}
 
 	return 0;
@@ -265,6 +272,9 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
 	if (err < 0)
 		return err;
 
+	if (nft_reg_overlap(priv->sreg, priv->dreg, priv->len))
+		return -EINVAL;
+
 	if (tb[NFTA_BITWISE_OP]) {
 		priv->op = ntohl(nla_get_be32(tb[NFTA_BITWISE_OP]));
 		switch (priv->op) {
diff --git a/net/netfilter/nft_byteorder.c b/net/netfilter/nft_byteorder.c
index af9206a3afd181..5e7a7841b789b0 100644
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



