Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55B13381A2;
	Fri, 24 Nov 2023 19:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oi4qFpRS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEE63C433C7;
	Fri, 24 Nov 2023 19:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853274;
	bh=opdjRo/FCNTDUirJvo/zZvw07lxgi2O26xrqhZtVftk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oi4qFpRSVmKWnXXKKkHKtWxVvANiodXZQpXQSzAjhdWZwgLMg+hj+w7+MwXwOfNfF
	 4tSkUw0PjPRfiTgo6MM1w4NzVIsNxURQ/LAAxr2uWjIm1Ba78YNnX9HljORlt9b3aY
	 JHRODWEsF36fI1QMYC3g6XgaIfbcuL53zInFNhuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 123/297] netfilter: nf_tables: add and use BE register load-store helpers
Date: Fri, 24 Nov 2023 17:52:45 +0000
Message-ID: <20231124172004.603228863@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172000.087816911@linuxfoundation.org>
References: <20231124172000.087816911@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 7278b3c1e4ebf6f9c4cda07600f19824857c81fe ]

Same as the existing ones, no conversions. This is just for sparse sake
only so that we no longer mix be16/u16 and be32/u32 types.

Alternative is to add __force __beX in various places, but this
seems nicer.

objdiff shows no changes.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: c301f0981fdd ("netfilter: nf_tables: fix pointer math issue in nft_byteorder_eval()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables.h      | 15 +++++++++++++++
 net/bridge/netfilter/nft_meta_bridge.c |  2 +-
 net/netfilter/nft_tproxy.c             |  6 +++---
 3 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index a0b47f2b896e1..df91b9f422551 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -144,11 +144,26 @@ static inline void nft_reg_store16(u32 *dreg, u16 val)
 	*(u16 *)dreg = val;
 }
 
+static inline void nft_reg_store_be16(u32 *dreg, __be16 val)
+{
+	nft_reg_store16(dreg, (__force __u16)val);
+}
+
 static inline u16 nft_reg_load16(const u32 *sreg)
 {
 	return *(u16 *)sreg;
 }
 
+static inline __be16 nft_reg_load_be16(const u32 *sreg)
+{
+	return (__force __be16)nft_reg_load16(sreg);
+}
+
+static inline __be32 nft_reg_load_be32(const u32 *sreg)
+{
+	return *(__force __be32 *)sreg;
+}
+
 static inline void nft_reg_store64(u32 *dreg, u64 val)
 {
 	put_unaligned(val, (u64 *)dreg);
diff --git a/net/bridge/netfilter/nft_meta_bridge.c b/net/bridge/netfilter/nft_meta_bridge.c
index 97805ec424c19..1967fd063cfb7 100644
--- a/net/bridge/netfilter/nft_meta_bridge.c
+++ b/net/bridge/netfilter/nft_meta_bridge.c
@@ -53,7 +53,7 @@ static void nft_meta_bridge_get_eval(const struct nft_expr *expr,
 			goto err;
 
 		br_vlan_get_proto(br_dev, &p_proto);
-		nft_reg_store16(dest, htons(p_proto));
+		nft_reg_store_be16(dest, htons(p_proto));
 		return;
 	}
 	default:
diff --git a/net/netfilter/nft_tproxy.c b/net/netfilter/nft_tproxy.c
index 9fea90ed79d44..e9679cb4afbe6 100644
--- a/net/netfilter/nft_tproxy.c
+++ b/net/netfilter/nft_tproxy.c
@@ -52,11 +52,11 @@ static void nft_tproxy_eval_v4(const struct nft_expr *expr,
 				   skb->dev, NF_TPROXY_LOOKUP_ESTABLISHED);
 
 	if (priv->sreg_addr)
-		taddr = regs->data[priv->sreg_addr];
+		taddr = nft_reg_load_be32(&regs->data[priv->sreg_addr]);
 	taddr = nf_tproxy_laddr4(skb, taddr, iph->daddr);
 
 	if (priv->sreg_port)
-		tport = nft_reg_load16(&regs->data[priv->sreg_port]);
+		tport = nft_reg_load_be16(&regs->data[priv->sreg_port]);
 	if (!tport)
 		tport = hp->dest;
 
@@ -124,7 +124,7 @@ static void nft_tproxy_eval_v6(const struct nft_expr *expr,
 	taddr = *nf_tproxy_laddr6(skb, &taddr, &iph->daddr);
 
 	if (priv->sreg_port)
-		tport = nft_reg_load16(&regs->data[priv->sreg_port]);
+		tport = nft_reg_load_be16(&regs->data[priv->sreg_port]);
 	if (!tport)
 		tport = hp->dest;
 
-- 
2.42.0



