Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4609D19EEAA;
	Thu, 15 Aug 2024 13:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729588; cv=none; b=QkUgjrrlWGynINLIlv75G20J3xvRLgch+yBlTqXhqbrvUB6JX7Yds5QKHCde6E6rcO3YVLzCMiemizRWW4KrGIgFg+sjz3Q42rn2L3zXqCLK2FEB1XfrX3Fxf+yMvvqj6CI5JM34w6N5t0qcJQQLSBTjaxZTwBB4C/kVket8rWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729588; c=relaxed/simple;
	bh=TpFNiYI8jeRT78WspV4GmKR04gJxUVsLHD+3fgldiIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m6cCtd7wkkX1hxc8wBPgGjGWjmmePrSjPyVzASimwuC10NClGVGcWk7AftOyitGQ5TBSZ35z260j9nXKWoO0phAyF/0DGyl1UfDFLu3KjnM5SdN+AoNLNWuNCZ4te9TpaIdMK+YuzLhDDaGPtXscWHBph5GwPvhI7ao50nqRuMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GA4kRxPk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GA4kRxPk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6871C32786;
	Thu, 15 Aug 2024 13:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729588;
	bh=TpFNiYI8jeRT78WspV4GmKR04gJxUVsLHD+3fgldiIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GA4kRxPkbVzw/r/c8Uy+Nn0HPdFsGJkE8Ux7/LPGzAoCh/QyxUi4JeYtGFuVG29XF
	 lbGmjDhIXeOv6/WohcWL8fiWYty1uhOEsWWJkPlMxaN6cYU/vwpA2Zj63+iJA0MAsh
	 vrobIfLX4oTHXGMpD+P2qUdNYJfV+t+bkgwi+GIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Chen <yiche@redhat.com>,
	Stefano Brivio <sbrivio@redhat.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 146/484] netfilter: nf_set_pipapo: fix initial map fill
Date: Thu, 15 Aug 2024 15:20:04 +0200
Message-ID: <20240815131947.057149919@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

[ Upstream commit 791a615b7ad2258c560f91852be54b0480837c93 ]

The initial buffer has to be inited to all-ones, but it must restrict
it to the size of the first field, not the total field size.

After each round in the map search step, the result and the fill map
are swapped, so if we have a set where f->bsize of the first element
is smaller than m->bsize_max, those one-bits are leaked into future
rounds result map.

This makes pipapo find an incorrect matching results for sets where
first field size is not the largest.

Followup patch adds a test case to nft_concat_range.sh selftest script.

Thanks to Stefano Brivio for pointing out that we need to zero out
the remainder explicitly, only correcting memset() argument isn't enough.

Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")
Reported-by: Yi Chen <yiche@redhat.com>
Cc: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_pipapo.c      |  4 ++--
 net/netfilter/nft_set_pipapo.h      | 21 +++++++++++++++++++++
 net/netfilter/nft_set_pipapo_avx2.c | 10 ++++++----
 3 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index cde08578722ef..8b1a88a16e5c1 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -432,7 +432,7 @@ bool nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
 	res_map  = scratch->map + (map_index ? m->bsize_max : 0);
 	fill_map = scratch->map + (map_index ? 0 : m->bsize_max);
 
-	memset(res_map, 0xff, m->bsize_max * sizeof(*res_map));
+	pipapo_resmap_init(m, res_map);
 
 	nft_pipapo_for_each_field(f, i, m) {
 		bool last = i == m->field_count - 1;
@@ -536,7 +536,7 @@ static struct nft_pipapo_elem *pipapo_get(const struct net *net,
 		goto out;
 	}
 
-	memset(res_map, 0xff, m->bsize_max * sizeof(*res_map));
+	pipapo_resmap_init(m, res_map);
 
 	nft_pipapo_for_each_field(f, i, m) {
 		bool last = i == m->field_count - 1;
diff --git a/net/netfilter/nft_set_pipapo.h b/net/netfilter/nft_set_pipapo.h
index 73a4518308be4..519a2e6dc206f 100644
--- a/net/netfilter/nft_set_pipapo.h
+++ b/net/netfilter/nft_set_pipapo.h
@@ -285,4 +285,25 @@ static u64 pipapo_estimate_size(const struct nft_set_desc *desc)
 	return size;
 }
 
+/**
+ * pipapo_resmap_init() - Initialise result map before first use
+ * @m:		Matching data, including mapping table
+ * @res_map:	Result map
+ *
+ * Initialize all bits covered by the first field to one, so that after
+ * the first step, only the matching bits of the first bit group remain.
+ *
+ * If other fields have a large bitmap, set remainder of res_map to 0.
+ */
+static inline void pipapo_resmap_init(const struct nft_pipapo_match *m, unsigned long *res_map)
+{
+	const struct nft_pipapo_field *f = m->f;
+	int i;
+
+	for (i = 0; i < f->bsize; i++)
+		res_map[i] = ULONG_MAX;
+
+	for (i = f->bsize; i < m->bsize_max; i++)
+		res_map[i] = 0ul;
+}
 #endif /* _NFT_SET_PIPAPO_H */
diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
index ef24c41482a32..295406cf63672 100644
--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -1036,6 +1036,7 @@ static int nft_pipapo_avx2_lookup_8b_16(unsigned long *map, unsigned long *fill,
 
 /**
  * nft_pipapo_avx2_lookup_slow() - Fallback function for uncommon field sizes
+ * @mdata:	Matching data, including mapping table
  * @map:	Previous match result, used as initial bitmap
  * @fill:	Destination bitmap to be filled with current match result
  * @f:		Field, containing lookup and mapping tables
@@ -1051,7 +1052,8 @@ static int nft_pipapo_avx2_lookup_8b_16(unsigned long *map, unsigned long *fill,
  * Return: -1 on no match, rule index of match if @last, otherwise first long
  * word index to be checked next (i.e. first filled word).
  */
-static int nft_pipapo_avx2_lookup_slow(unsigned long *map, unsigned long *fill,
+static int nft_pipapo_avx2_lookup_slow(const struct nft_pipapo_match *mdata,
+					unsigned long *map, unsigned long *fill,
 					const struct nft_pipapo_field *f,
 					int offset, const u8 *pkt,
 					bool first, bool last)
@@ -1062,7 +1064,7 @@ static int nft_pipapo_avx2_lookup_slow(unsigned long *map, unsigned long *fill,
 	lt += offset * NFT_PIPAPO_LONGS_PER_M256;
 
 	if (first)
-		memset(map, 0xff, bsize * sizeof(*map));
+		pipapo_resmap_init(mdata, map);
 
 	for (i = offset; i < bsize; i++) {
 		if (f->bb == 8)
@@ -1188,7 +1190,7 @@ bool nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
 			} else if (f->groups == 16) {
 				NFT_SET_PIPAPO_AVX2_LOOKUP(8, 16);
 			} else {
-				ret = nft_pipapo_avx2_lookup_slow(res, fill, f,
+				ret = nft_pipapo_avx2_lookup_slow(m, res, fill, f,
 								  ret, rp,
 								  first, last);
 			}
@@ -1204,7 +1206,7 @@ bool nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
 			} else if (f->groups == 32) {
 				NFT_SET_PIPAPO_AVX2_LOOKUP(4, 32);
 			} else {
-				ret = nft_pipapo_avx2_lookup_slow(res, fill, f,
+				ret = nft_pipapo_avx2_lookup_slow(m, res, fill, f,
 								  ret, rp,
 								  first, last);
 			}
-- 
2.43.0



