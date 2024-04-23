Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 949FB143C4D;
	Tue, 23 Apr 2024 21:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908581; cv=none; b=G0oeUSOrYr9g2OAijk6NVTlYFy0RJfvnLaP83z1ZarBFKeE6hVtqM9UNOGbMz/FNJQNaVY+Qt0majiI6Li1AVFLN7kRSGs0sm4WUAs3GM4eO+Wj0yRC1l086Ese59SgznAN0KWWIcIjCWVj1bp1PB6iGMuBjhFX4krqU69mQmr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908581; c=relaxed/simple;
	bh=YFCViDb12whZrK/XBuCqJyRA2wHly0wnZWEAgTU6gNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YYDXVz7XSLZHvNHDf6kxCqOjFDXUZL59iDVM+ZFD+4NidqEh71H8dcOY7bxLC9mB8jBbiteNiO4b8IFUbz8P3fEaJOFiYrrmDa6eFmgSmq+HbOQtfN0DWsyOho4WU28EWAiJ19Lb8GWxPnI+DxJwixpn9ia68YDbk3fGIiBYLws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZKaCjh0p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZKaCjh0p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62C53C116B1;
	Tue, 23 Apr 2024 21:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908581;
	bh=YFCViDb12whZrK/XBuCqJyRA2wHly0wnZWEAgTU6gNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZKaCjh0pp616ZsB9in9QHH9i3lh7hLrR0w0NIoe0rZGNHlI3IqgQu7wneFBfByFf9
	 svLh5c1vGBuXQcj9Nxq4reHZhhj8NdpbwFjIpMvpKG/dTVkO6Ha26kOwTnVJIdWSob
	 2YJ/4zPUFlzvD5A/10T1c9YV4/NBBzYQKUVdPhdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Stefano Brivio <sbrivio@redhat.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 036/158] netfilter: nft_set_pipapo: do not free live element
Date: Tue, 23 Apr 2024 14:37:53 -0700
Message-ID: <20240423213856.924661083@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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
index a890aa0abad58..69b02a3f1ff05 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1993,6 +1993,8 @@ static void nft_pipapo_remove(const struct net *net, const struct nft_set *set,
 		rules_fx = rules_f0;
 
 		nft_pipapo_for_each_field(f, i, m) {
+			bool last = i == m->field_count - 1;
+
 			if (!pipapo_match_field(f, start, rules_fx,
 						match_start, match_end))
 				break;
@@ -2005,16 +2007,18 @@ static void nft_pipapo_remove(const struct net *net, const struct nft_set *set,
 
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



