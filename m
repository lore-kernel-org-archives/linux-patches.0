Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15C11741FC;
	Wed,  3 Jul 2024 10:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003610; cv=none; b=HZx1lSq7TtyTxGYMX27TlcaCg1kBnP3BtqZiDBSlLZ/Q14wauTp2Bd52HtNJSx5JY5I9VFDjEtoNFzhtMTqgPnYHrAyJ443e/Dt9B0chYJ8qBL9DDes0ybXW0FyyAE27cuoWtOrHXaV56FTlBhLJsSw0/NX9+nNaPSGhpq/HwxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003610; c=relaxed/simple;
	bh=L/eXae5nN6je8t1rjzvdDHbGMfInAlzfdm2lHkAKaoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cRly4HDP09U0thF9ERK2VoWkwQIsJmzDNWUF2Li+wwMchlRgPwhXaMG7NUBQ6eUme//R81vO2iiDi9k1EVLOlh4yfnJj2OvVIF2YSNVP0r7XccsrwKrNZYtYVXNxXuDD8r5v+mLSf9CsMNw+KvFTBhoSdg8O729BaseQmjJphcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J/wC+/4p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J/wC+/4p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5805CC2BD10;
	Wed,  3 Jul 2024 10:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003610;
	bh=L/eXae5nN6je8t1rjzvdDHbGMfInAlzfdm2lHkAKaoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J/wC+/4pL2Iek7hfDGQmkEJ7ERbwpwV1YH3MNO6sUVCi2o+Uq+DszCW55iBrPOs5g
	 dO7IUhKlTGtnaxSrTrVaqpa6lWZFlhAI0NlfMVSsLrKonEpx1a9ntSAbtHR7i3va8p
	 Ihpr8KwuNizzDjT7muTd+WrSNNz5mXqtq2jA/eak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linuxfoundation.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 106/139] netfilter: nf_tables: fully validate NFT_DATA_VALUE on store to data registers
Date: Wed,  3 Jul 2024 12:40:03 +0200
Message-ID: <20240703102834.445204854@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 7931d32955e09d0a11b1fe0b6aac1bfa061c005c ]

register store validation for NFT_DATA_VALUE is conditional, however,
the datatype is always either NFT_DATA_VALUE or NFT_DATA_VERDICT. This
only requires a new helper function to infer the register type from the
set datatype so this conditional check can be removed. Otherwise,
pointer to chain object can be leaked through the registers.

Fixes: 96518518cc41 ("netfilter: add nftables")
Reported-by: Linus Torvalds <torvalds@linuxfoundation.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables.h | 5 +++++
 net/netfilter/nf_tables_api.c     | 8 ++++----
 net/netfilter/nft_lookup.c        | 3 ++-
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 9ce7837520f39..4a0f51c2b3b91 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -445,6 +445,11 @@ static inline void *nft_set_priv(const struct nft_set *set)
 	return (void *)set->data;
 }
 
+static inline enum nft_data_types nft_set_datatype(const struct nft_set *set)
+{
+	return set->dtype == NFT_DATA_VERDICT ? NFT_DATA_VERDICT : NFT_DATA_VALUE;
+}
+
 static inline bool nft_set_gc_is_pending(const struct nft_set *s)
 {
 	return refcount_read(&s->refs) != 1;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 2c31470dd61f5..f2611406af141 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4154,8 +4154,7 @@ static int nf_tables_fill_setelem(struct sk_buff *skb,
 
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_DATA) &&
 	    nft_data_dump(skb, NFTA_SET_ELEM_DATA, nft_set_ext_data(ext),
-			  set->dtype == NFT_DATA_VERDICT ? NFT_DATA_VERDICT : NFT_DATA_VALUE,
-			  set->dlen) < 0)
+			  nft_set_datatype(set), set->dlen) < 0)
 		goto nla_put_failure;
 
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_EXPR) &&
@@ -7655,6 +7654,9 @@ static int nft_validate_register_store(const struct nft_ctx *ctx,
 
 		return 0;
 	default:
+		if (type != NFT_DATA_VALUE)
+			return -EINVAL;
+
 		if (reg < NFT_REG_1 * NFT_REG_SIZE / NFT_REG32_SIZE)
 			return -EINVAL;
 		if (len == 0)
@@ -7663,8 +7665,6 @@ static int nft_validate_register_store(const struct nft_ctx *ctx,
 		    FIELD_SIZEOF(struct nft_regs, data))
 			return -ERANGE;
 
-		if (data != NULL && type != NFT_DATA_VALUE)
-			return -EINVAL;
 		return 0;
 	}
 }
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index 3c380fb326511..bb8bd562c1ba2 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -101,7 +101,8 @@ static int nft_lookup_init(const struct nft_ctx *ctx,
 			return -EINVAL;
 
 		err = nft_parse_register_store(ctx, tb[NFTA_LOOKUP_DREG],
-					       &priv->dreg, NULL, set->dtype,
+					       &priv->dreg, NULL,
+					       nft_set_datatype(set),
 					       set->dlen);
 		if (err < 0)
 			return err;
-- 
2.43.0



