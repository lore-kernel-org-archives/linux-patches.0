Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11637178381;
	Tue,  2 Jul 2024 17:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940118; cv=none; b=ddcnq1t/teBENYbjltko6pVp/L5hq9ZXC9JXT1kVn6Mw5i4bVR/zcp7rFUVlvN0ado65D0eJXP5BPlp70DAHOMFcNdNNMGEP0uZAh+ArnRt/JULUM2QkjmMLauvY7z91H1wSmIrA3ADzOhz9yS8BiasMaUoWBmuOz4rBEVqoxcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940118; c=relaxed/simple;
	bh=RjpV9Wo7bBK5wSqtouQMTAt2Pva8Mj5bKypvYX4lmdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=omDZE5fBCLGV6mj17r/xC9iTb1pp8e/2NG4J7alSlWGzr4C5vQ/uoxVKfzlWWV5mvZXBfdA2htnbDQ4W4Lp8PrnCfmF6Id/EGlZ2HM+4/EFMrzLMwuDemsc7IHa7AJfjqAYQ3zxsosbZHz9+6rhTFPT9tf7XSsNK5wvHAZX17Os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZlHLYKNv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZlHLYKNv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26D74C116B1;
	Tue,  2 Jul 2024 17:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940117;
	bh=RjpV9Wo7bBK5wSqtouQMTAt2Pva8Mj5bKypvYX4lmdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZlHLYKNv3neDfusOXy457oMiYkPUBSYrzylrpOareYZI2zKxyF19yxsZ25lCxQZLi
	 3GheaOCwCq7AnwqLBcn1Y51dfmU22ewqt1kQaY+15diLMQ26UDgNfL2GhwTda/vqtE
	 Ge4Dcddpe6FGzBhYU8tYxcZHR9Ekyf0ricD2gGj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linuxfoundation.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 058/222] netfilter: nf_tables: fully validate NFT_DATA_VALUE on store to data registers
Date: Tue,  2 Jul 2024 19:01:36 +0200
Message-ID: <20240702170246.202036038@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 3f1ed467f951f..2164fa350fa69 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -619,6 +619,11 @@ static inline void *nft_set_priv(const struct nft_set *set)
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
index 167074283ea91..faa77b031d1f3 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5740,8 +5740,7 @@ static int nf_tables_fill_setelem(struct sk_buff *skb,
 
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_DATA) &&
 	    nft_data_dump(skb, NFTA_SET_ELEM_DATA, nft_set_ext_data(ext),
-			  set->dtype == NFT_DATA_VERDICT ? NFT_DATA_VERDICT : NFT_DATA_VALUE,
-			  set->dlen) < 0)
+			  nft_set_datatype(set), set->dlen) < 0)
 		goto nla_put_failure;
 
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_EXPRESSIONS) &&
@@ -11069,6 +11068,9 @@ static int nft_validate_register_store(const struct nft_ctx *ctx,
 
 		return 0;
 	default:
+		if (type != NFT_DATA_VALUE)
+			return -EINVAL;
+
 		if (reg < NFT_REG_1 * NFT_REG_SIZE / NFT_REG32_SIZE)
 			return -EINVAL;
 		if (len == 0)
@@ -11077,8 +11079,6 @@ static int nft_validate_register_store(const struct nft_ctx *ctx,
 		    sizeof_field(struct nft_regs, data))
 			return -ERANGE;
 
-		if (data != NULL && type != NFT_DATA_VALUE)
-			return -EINVAL;
 		return 0;
 	}
 }
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index b314ca728a291..f3080fa1b2263 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -132,7 +132,8 @@ static int nft_lookup_init(const struct nft_ctx *ctx,
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



