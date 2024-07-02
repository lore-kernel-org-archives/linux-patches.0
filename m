Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B17415218A;
	Tue,  2 Jul 2024 17:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940827; cv=none; b=PYJ0XEMEB7TzYj/+K6HcGwAVABgTnxX6xScWxJEU7eIc8qRrjhHcdWrHycWSRg7PpWRAtpTADYhwYil2a5sp7rTZP7yUjUVbM/4rgV8aaOxqX257WYwxZS1bxIROPjhT7K9eDQItnbPSvKPZ6wcvPJF3i1PcKrQ6vusQ1EMHqPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940827; c=relaxed/simple;
	bh=EZPbJPgjg/56D5Y75fXDCJuaD4YiACUa0x/GDsmOkl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T4nZfG6qic5jqJeiisUWtjDt9NHcRLwXYyy8BgJsQ+jL7fawCBc9uOO23QkzZCjhkrot4QkD3p7zVSxK7z4daNYcU5/Teat6zQPn0i45uaI0jES/BepR6OD0OpH2HR4AQKYIbk/CaMS/vuCoXJhoZjRN2UwrRtzqe9IIz6b5690=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gsFiSFBU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gsFiSFBU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 921C2C116B1;
	Tue,  2 Jul 2024 17:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940827;
	bh=EZPbJPgjg/56D5Y75fXDCJuaD4YiACUa0x/GDsmOkl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gsFiSFBU3tbvRAHRZbRhSqHW46Zgbpj3g2MGLxrEadvUIiO4HqtT3fg5U1uFR2Kdt
	 dMD+0WPFtDK5kcvdblgYiP8zyavyzCE+U18riTfHn5BHDu5tEbqXxATtV5jwhCsGHC
	 V2d3De8a2FpmnERVZpXtzQd9cuFI8oBgx3MCfFc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linuxfoundation.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 048/163] netfilter: nf_tables: fully validate NFT_DATA_VALUE on store to data registers
Date: Tue,  2 Jul 2024 19:02:42 +0200
Message-ID: <20240702170234.881659062@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5bb8a83e26046..8af2543520b99 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -587,6 +587,11 @@ static inline void *nft_set_priv(const struct nft_set *set)
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
index 387eee416b0bf..7547f7b869395 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5648,8 +5648,7 @@ static int nf_tables_fill_setelem(struct sk_buff *skb,
 
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_DATA) &&
 	    nft_data_dump(skb, NFTA_SET_ELEM_DATA, nft_set_ext_data(ext),
-			  set->dtype == NFT_DATA_VERDICT ? NFT_DATA_VERDICT : NFT_DATA_VALUE,
-			  set->dlen) < 0)
+			  nft_set_datatype(set), set->dlen) < 0)
 		goto nla_put_failure;
 
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_EXPRESSIONS) &&
@@ -10881,6 +10880,9 @@ static int nft_validate_register_store(const struct nft_ctx *ctx,
 
 		return 0;
 	default:
+		if (type != NFT_DATA_VALUE)
+			return -EINVAL;
+
 		if (reg < NFT_REG_1 * NFT_REG_SIZE / NFT_REG32_SIZE)
 			return -EINVAL;
 		if (len == 0)
@@ -10889,8 +10891,6 @@ static int nft_validate_register_store(const struct nft_ctx *ctx,
 		    sizeof_field(struct nft_regs, data))
 			return -ERANGE;
 
-		if (data != NULL && type != NFT_DATA_VALUE)
-			return -EINVAL;
 		return 0;
 	}
 }
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index 870e5b113d13e..7ba4b1454db46 100644
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



