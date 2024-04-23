Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3BFD143899;
	Tue, 23 Apr 2024 21:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908459; cv=none; b=MX6u+eWPGah1Q8cFJF3QGudhf3K13KzfiZPMs5DGJwRyuxPeKANXh8o7s7YEDWdSbLMjhkzMraDtLRdJpRrx2SY52dVOV0ZeRCVMbeA1txQ7cMwpRpJSpObarc2L4G+CdJMcUUR19o07xyanmI8EADpZVl5JYw69ewaX1+3LS0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908459; c=relaxed/simple;
	bh=1Qo3zLN/ucCgBWZJ9yrCto5BkpIgZX+4V8nF2x+Av5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sslZr4FXmFZlbY8WHlHdQg8Y7EV5F9KXzYFZTZ/5HBbfxypqUeAoqu8tJoYJyHVi68jr5AaM5TbLEDwvT+0wjlI9GryJ9ZwddHa5RPux3Wwoe0PPMK1LdDwFPD9CX3BHbK1UvlKX34LMMMPgWSPFt7AVuzCrRX2dGpw4rGIBA74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X4jFef2y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X4jFef2y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3E7CC3277B;
	Tue, 23 Apr 2024 21:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908458;
	bh=1Qo3zLN/ucCgBWZJ9yrCto5BkpIgZX+4V8nF2x+Av5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X4jFef2yTtg9FTUfxFEdojN17jRZ10FKXh03eMnggh7XEUAQkZiMZX6SEk1N2gVSW
	 PcljJKpcswIeRbiZBP4LGCkZVoDm+5TXiTkwgCgKNpqkJZG5hQIeiwtk2LgjBaONwf
	 Km0wyBLX6pfJAd31mLIzB1PY+Q3naF41uU/BuFy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Stefano Brivio <sbrivio@redhat.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 019/158] netfilter: nft_set_pipapo: do not free live element
Date: Tue, 23 Apr 2024 14:37:21 -0700
Message-ID: <20240423213856.482883461@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 3cfc9ec039af60dbd8965ae085b2c2ccdcfbe1cc ]

Pablo reports a crash with large batches of elements with a
back-to-back add/remove pattern.  Quoting Pablo:

  add_elem("00000000") timeout 100 ms
  ...
  add_elem("0000000X") timeout 100 ms
  del_elem("0000000X") <---------------- delete one that was just added
  ...
  add_elem("00005000") timeout 100 ms

  1) nft_pipapo_remove() removes element 0000000X
  Then, KASAN shows a splat.

Looking at the remove function there is a chance that we will drop a
rule that maps to a non-deactivated element.

Removal happens in two steps, first we do a lookup for key k and return the
to-be-removed element and mark it as inactive in the next generation.
Then, in a second step, the element gets removed from the set/map.

The _remove function does not work correctly if we have more than one
element that share the same key.

This can happen if we insert an element into a set when the set already
holds an element with same key, but the element mapping to the existing
key has timed out or is not active in the next generation.

In such case its possible that removal will unmap the wrong element.
If this happens, we will leak the non-deactivated element, it becomes
unreachable.

The element that got deactivated (and will be freed later) will
remain reachable in the set data structure, this can result in
a crash when such an element is retrieved during lookup (stale
pointer).

Add a check that the fully matching key does in fact map to the element
that we have marked as inactive in the deactivation step.
If not, we need to continue searching.

Add a bug/warn trap at the end of the function as well, the remove
function must not ever be called with an invisible/unreachable/non-existent
element.

v2: avoid uneeded temporary variable (Stefano)

Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")
Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_pipapo.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 69b1ab6849e67..979b5e80c400b 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -2002,6 +2002,8 @@ static void nft_pipapo_remove(const struct net *net, const struct nft_set *set,
 		rules_fx = rules_f0;
 
 		nft_pipapo_for_each_field(f, i, m) {
+			bool last = i == m->field_count - 1;
+
 			if (!pipapo_match_field(f, start, rules_fx,
 						match_start, match_end))
 				break;
@@ -2014,16 +2016,18 @@ static void nft_pipapo_remove(const struct net *net, const struct nft_set *set,
 
 			match_start += NFT_PIPAPO_GROUPS_PADDED_SIZE(f);
 			match_end += NFT_PIPAPO_GROUPS_PADDED_SIZE(f);
-		}
 
-		if (i == m->field_count) {
-			priv->dirty = true;
-			pipapo_drop(m, rulemap);
-			return;
+			if (last && f->mt[rulemap[i].to].e == e) {
+				priv->dirty = true;
+				pipapo_drop(m, rulemap);
+				return;
+			}
 		}
 
 		first_rule += rules_f0;
 	}
+
+	WARN_ON_ONCE(1); /* elem_priv not found */
 }
 
 /**
-- 
2.43.0



