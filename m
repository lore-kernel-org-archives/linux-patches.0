Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A83F1946C8;
	Fri,  9 Jan 2026 12:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960274; cv=none; b=Qr3FpDHn5jgcCZOqy6Cqq+S073Ge9i5mcwO99i0n43vaHyszKvl0Q2NsFj1Zsl6yNxnDm2WSApVbfo+n2NTZ3WPfd7FfaK7NhvgyohcqiDDsFlXX7XBdOBERfbavPbRDEPUFsUHv1sOSceDcljZCXKTtwFWLi8BH2R6fXLv9RC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960274; c=relaxed/simple;
	bh=7Sp6/TkT40NXzkvqnwleiT1rFc8tGHgxtEfZqFqPC5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d/vXvR7WqsMvuQMerxfLv4OcnkZzdGZM5UVHGcna5CT9kKyQTvG4+aR6/YLIxXE4yj37rdlQV+wK0ytJevKAz8Bz6vHgvw0GE2p8RNugktPPrS0y4oBm3waCFNSD/v8+aC3gGzkbzvwNlreNoOjbhdFsgGMbESa+JyNNU+GKswI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DqOBUo8+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DqOBUo8+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 157C9C4CEF1;
	Fri,  9 Jan 2026 12:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960274;
	bh=7Sp6/TkT40NXzkvqnwleiT1rFc8tGHgxtEfZqFqPC5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DqOBUo8+FkBLj/QHCH4mNgnECicyh0Vyd1agYjcwxEYnc7XJ9Me0CQ9yjfH6Fzek1
	 FlJlxbckpEhStc+Ojxb07OKbcaIl5yymed3FHwi69ymqWdQCIttYmZAhPLmXKuUgMp
	 YSFrl6D4JNYSTLTc0MDqNgexsVnQFfeWi744j8H0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 346/737] netfilter: nf_tables: allow loads only when register is initialized
Date: Fri,  9 Jan 2026 12:38:05 +0100
Message-ID: <20260109112147.003750344@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 14fb07130c7ddd257e30079b87499b3f89097b09 ]

Reject rules where a load occurs from a register that has not seen a store
early in the same rule.

commit 4c905f6740a3 ("netfilter: nf_tables: initialize registers in
nft_do_chain()")
had to add a unconditional memset to the nftables register space to avoid
leaking stack information to userspace.

This memset shows up in benchmarks.  After this change, this commit can
be reverted again.

Note that this breaks userspace compatibility, because theoretically
you can do

  rule 1: reg2 := meta load iif, reg2  == 1 jump ...
  rule 2: reg2 == 2 jump ...   // read access with no store in this rule

... after this change this is rejected.

Neither nftables nor iptables-nft generate such rules, each rule is
always standalone.

This resuts in a small increase of nft_ctx structure by sizeof(long).

To cope with hypothetical rulesets like the example above one could emit
on-demand "reg[x] = 0" store when generating the datapath blob in
nf_tables_commit_chain_prepare().

A patch that does this is linked to below.

For now, lets disable this.  In nf_tables, a rule is the smallest
unit that can be replaced from userspace, i.e. a hypothetical ruleset
that relies on earlier initialisations of registers can't be changed
at will as register usage would need to be coordinated.

Link: https://lore.kernel.org/netfilter-devel/20240627135330.17039-4-fw@strlen.de/
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: a67fd55f6a09 ("netfilter: nf_tables: remove redundant chain validation on register store")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables.h |  1 +
 net/netfilter/nf_tables_api.c     | 38 +++++++++++++++++++++++++++----
 2 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 917edb4380e58..a8fcbdb37a7f9 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -221,6 +221,7 @@ struct nft_ctx {
 	u8				family;
 	u8				level;
 	bool				report;
+	DECLARE_BITMAP(reg_inited, NFT_REG32_NUM);
 };
 
 enum nft_data_desc_flags {
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 7bccfb1a8a725..8b8895e4372d9 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -146,6 +146,8 @@ static void nft_ctx_init(struct nft_ctx *ctx,
 	ctx->report	= nlmsg_report(nlh);
 	ctx->flags	= nlh->nlmsg_flags;
 	ctx->seq	= nlh->nlmsg_seq;
+
+	bitmap_zero(ctx->reg_inited, NFT_REG32_NUM);
 }
 
 static struct nft_trans *nft_trans_alloc_gfp(const struct nft_ctx *ctx,
@@ -10915,8 +10917,8 @@ static int nft_validate_register_load(enum nft_registers reg, unsigned int len)
 int nft_parse_register_load(const struct nft_ctx *ctx,
 			    const struct nlattr *attr, u8 *sreg, u32 len)
 {
-	u32 reg;
-	int err;
+	int err, invalid_reg;
+	u32 reg, next_register;
 
 	err = nft_parse_register(attr, &reg);
 	if (err < 0)
@@ -10926,11 +10928,36 @@ int nft_parse_register_load(const struct nft_ctx *ctx,
 	if (err < 0)
 		return err;
 
+	next_register = DIV_ROUND_UP(len, NFT_REG32_SIZE) + reg;
+
+	/* Can't happen: nft_validate_register_load() should have failed */
+	if (WARN_ON_ONCE(next_register > NFT_REG32_NUM))
+		return -EINVAL;
+
+	/* find first register that did not see an earlier store. */
+	invalid_reg = find_next_zero_bit(ctx->reg_inited, NFT_REG32_NUM, reg);
+
+	/* invalid register within the range that we're loading from? */
+	if (invalid_reg < next_register)
+		return -ENODATA;
+
 	*sreg = reg;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(nft_parse_register_load);
 
+static void nft_saw_register_store(const struct nft_ctx *__ctx,
+				   int reg, unsigned int len)
+{
+	unsigned int registers = DIV_ROUND_UP(len, NFT_REG32_SIZE);
+	struct nft_ctx *ctx = (struct nft_ctx *)__ctx;
+
+	if (WARN_ON_ONCE(len == 0 || reg < 0))
+		return;
+
+	bitmap_set(ctx->reg_inited, reg, registers);
+}
+
 static int nft_validate_register_store(const struct nft_ctx *ctx,
 				       enum nft_registers reg,
 				       const struct nft_data *data,
@@ -10952,7 +10979,7 @@ static int nft_validate_register_store(const struct nft_ctx *ctx,
 				return err;
 		}
 
-		return 0;
+		break;
 	default:
 		if (type != NFT_DATA_VALUE)
 			return -EINVAL;
@@ -10965,8 +10992,11 @@ static int nft_validate_register_store(const struct nft_ctx *ctx,
 		    sizeof_field(struct nft_regs, data))
 			return -ERANGE;
 
-		return 0;
+		break;
 	}
+
+	nft_saw_register_store(ctx, reg, len);
+	return 0;
 }
 
 int nft_parse_register_store(const struct nft_ctx *ctx,
-- 
2.51.0



