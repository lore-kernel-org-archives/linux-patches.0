Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4794A18DB2A;
	Wed, 25 Feb 2026 01:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983270; cv=none; b=MAB7LSoQgQI4Z+oKRzyW7eoXfj2OdpxDjYVOBe2OiEMRYni6t/cnVuelP3WurptfkZidpQK+ITmADZnyOViz5wTZ1lgC6NYp3jYPYCEX8yd9T+eGVCNRnahiMxBEwBQ/3l1tppailExnJDAotRtkrXhlnBFO6xKuNranAJMJ/2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983270; c=relaxed/simple;
	bh=sgW2jOuXzXw2W8pW4L+ds1sVGWWj/dCpFAr7fabmSt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jdcJpFxylE+aRXXilrgO9y8rZ9mUmVCReGkVY6OVFPULRDv6AISqmDecRAJ5rB3Ju6NAK83778tdWAJxJaL5I0W7TPHENQ898LNg0E0hf8FJbtJRR875g3KZNh6oBzd4QG3nukU1pQSTCL/9lRzxqY6AXuatIihGQ7qurztBbkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tO0WpRw4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tO0WpRw4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 081CFC116D0;
	Wed, 25 Feb 2026 01:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983270;
	bh=sgW2jOuXzXw2W8pW4L+ds1sVGWWj/dCpFAr7fabmSt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tO0WpRw4GfZcssnJaB4wbI+laifRKxysw0hUNOlySEgZsYaJ1afEByya5a06525Os
	 w9IhwPpDgZT6UiCij0U15Lic9+E/WAzmg11eh7J/5MMm/SnbG9Wyl03cyOCpXkKPM6
	 0/ZOQQhtA49k0z9ow4FaWimMvyimUmxSfbETKEQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 410/781] netfilter: nft_set_hash: fix get operation on big endian
Date: Tue, 24 Feb 2026 17:18:39 -0800
Message-ID: <20260225012409.760147623@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 2f635adbe2642d398a0be3ab245accd2987be0c3 ]

tests/shell/testcases/packetpath/set_match_nomatch_hash_fast
fails on big endian with:

Error: Could not process rule: No such file or directory
reset element ip test s { 244.147.90.126 }
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Fatal: Cannot fetch element "244.147.90.126"

... because the wrong bucket is searched, jhash() and jhash1_word are
not interchangeable on big endian.

Fixes: 3b02b0adc242 ("netfilter: nft_set_hash: fix lookups with fixed size hash on big endian")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_hash.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index ba01ce75d6dea..739b992bde591 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -619,15 +619,20 @@ static struct nft_elem_priv *
 nft_hash_get(const struct net *net, const struct nft_set *set,
 	     const struct nft_set_elem *elem, unsigned int flags)
 {
+	const u32 *key = (const u32 *)&elem->key.val;
 	struct nft_hash *priv = nft_set_priv(set);
 	u8 genmask = nft_genmask_cur(net);
 	struct nft_hash_elem *he;
 	u32 hash;
 
-	hash = jhash(elem->key.val.data, set->klen, priv->seed);
+	if (set->klen == 4)
+		hash = jhash_1word(*key, priv->seed);
+	else
+		hash = jhash(key, set->klen, priv->seed);
+
 	hash = reciprocal_scale(hash, priv->buckets);
 	hlist_for_each_entry_rcu(he, &priv->table[hash], node) {
-		if (!memcmp(nft_set_ext_key(&he->ext), elem->key.val.data, set->klen) &&
+		if (!memcmp(nft_set_ext_key(&he->ext), key, set->klen) &&
 		    nft_set_elem_active(&he->ext, genmask))
 			return &he->priv;
 	}
-- 
2.51.0



