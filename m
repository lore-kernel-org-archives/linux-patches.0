Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D5047012F;
	Tue, 21 Jul 2026 19:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660890; cv=none; b=kBNUNZABdE6eSdg2xR/OS/6lq3QltObjypqR361uDLUZqu/XkQ8TPjLk+cIFx+pw3z8sqb/5dE9joDIWYygeS/lRTI9bLz2pT2/+5dn3fzYtsWXlKnhGcZ9jVrlnOSnfuCyHkPKCZn3FKFctgIgQkkeZ0DZAiTkKREzhPE6Ob4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660890; c=relaxed/simple;
	bh=kfbfWfgNGm+rIHNBJaHtiCmPZW4vgkcEsh/Hd66GcgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dbEplRWlujRXkjOvCIYTtbMla/ksRE1PnW03XweaibV09WuiImmtIT58taOIKCwKhEzXzURqlaUTbZVKcDwp9PVBERGOCGLA06DVWkDJyrAtaC0KiKT/QbZ+w3U4ZlOn/D2x3RvkJT4TRCATDuN8lrxAZ+tA3AprqZrPHm16zlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sbzWSyD5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sbzWSyD5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 072991F000E9;
	Tue, 21 Jul 2026 19:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660885;
	bh=WQl91/syGF9JJplk1vjBrF5Y+9khaCU1FF8A+NPliAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sbzWSyD5BKHhKxFH5QH/ouvCVT5y5jhdjXedlSPbU3oUKGlH3aMiU8U9wKkDFpCkx
	 BE4ItnNY4dgLSHE0FbjhU+rYBeISembMy8W2pmEcLM+YJBcu7fBUU/t4oXRNkA8Fw1
	 DDA4CG3BsPSy6N3TbYrvBlzP15gI6SAd++aEpwT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1147/2077] netfilter: ipset: Dont use test_bit() in lockless RCU readers in bitmap types
Date: Tue, 21 Jul 2026 17:13:40 +0200
Message-ID: <20260721152619.874622585@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jozsef Kadlecsik <kadlec@netfilter.org>

[ Upstream commit 1171192ac9af46ddf65caf4162f1b64c58ae37f4 ]

The pair of the patch "netfilter: ipset: Don't use test_bit() in lockless
RCU readers in hash types" for the bitmap types.

Fixes: 02a3231b6d82 ("netfilter: nf_conntrack_expect: store netns and zone in expectation")
Fixes: b0da3905bb1e ("netfilter: ipset: Bitmap types using the unified code base")
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipset/ip_set_bitmap_gen.h   | 4 +++-
 net/netfilter/ipset/ip_set_bitmap_ip.c    | 2 +-
 net/netfilter/ipset/ip_set_bitmap_ipmac.c | 2 +-
 net/netfilter/ipset/ip_set_bitmap_port.c  | 2 +-
 4 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_bitmap_gen.h b/net/netfilter/ipset/ip_set_bitmap_gen.h
index 798c7993635e66..bb9b5bed10e19c 100644
--- a/net/netfilter/ipset/ip_set_bitmap_gen.h
+++ b/net/netfilter/ipset/ip_set_bitmap_gen.h
@@ -165,6 +165,7 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 		ip_set_init_skbinfo(ext_skbinfo(x, set), ext);
 
 	/* Activate element */
+	smp_mb__before_atomic();
 	set_bit(e->id, map->members);
 	set->elements++;
 
@@ -219,7 +220,7 @@ mtype_list(const struct ip_set *set,
 		cond_resched_rcu();
 		id = cb->args[IPSET_CB_ARG0];
 		x = get_ext(set, map, id);
-		if (!test_bit(id, map->members) ||
+		if (!test_bit_acquire(id, map->members) ||
 		    (SET_WITH_TIMEOUT(set) &&
 #ifdef IP_SET_BITMAP_STORED_TIMEOUT
 		     mtype_is_filled(x) &&
@@ -278,6 +279,7 @@ mtype_gc(struct timer_list *t)
 			x = get_ext(set, map, id);
 			if (ip_set_timeout_expired(ext_timeout(x, set))) {
 				clear_bit(id, map->members);
+				smp_mb__after_atomic();
 				ip_set_ext_destroy(set, x);
 				set->elements--;
 			}
diff --git a/net/netfilter/ipset/ip_set_bitmap_ip.c b/net/netfilter/ipset/ip_set_bitmap_ip.c
index 5988b9bb9029dc..ac7febce074f1f 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ip.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ip.c
@@ -67,7 +67,7 @@ static int
 bitmap_ip_do_test(const struct bitmap_ip_adt_elem *e,
 		  struct bitmap_ip *map, size_t dsize)
 {
-	return !!test_bit(e->id, map->members);
+	return !!test_bit_acquire(e->id, map->members);
 }
 
 static int
diff --git a/net/netfilter/ipset/ip_set_bitmap_ipmac.c b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
index 752f59ef874429..5921fd9d2dca00 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ipmac.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
@@ -86,7 +86,7 @@ bitmap_ipmac_do_test(const struct bitmap_ipmac_adt_elem *e,
 {
 	const struct bitmap_ipmac_elem *elem;
 
-	if (!test_bit(e->id, map->members))
+	if (!test_bit_acquire(e->id, map->members))
 		return 0;
 	elem = get_const_elem(map->extensions, e->id, dsize);
 	if (e->add_mac && elem->filled == MAC_FILLED)
diff --git a/net/netfilter/ipset/ip_set_bitmap_port.c b/net/netfilter/ipset/ip_set_bitmap_port.c
index 7138e080def4cf..ca875c9824245f 100644
--- a/net/netfilter/ipset/ip_set_bitmap_port.c
+++ b/net/netfilter/ipset/ip_set_bitmap_port.c
@@ -58,7 +58,7 @@ static int
 bitmap_port_do_test(const struct bitmap_port_adt_elem *e,
 		    const struct bitmap_port *map, size_t dsize)
 {
-	return !!test_bit(e->id, map->members);
+	return !!test_bit_acquire(e->id, map->members);
 }
 
 static int
-- 
2.53.0



