Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E45FB35C1A6;
	Tue, 21 Jul 2026 19:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662839; cv=none; b=qa4gUije/mJfB1XyJoET6lLJZRZ9eUE9+WakE2CrEyjT0s+Yf/KkRJ0WmM4xOnE8zvkJiBAX4fynzFmXvFmOdBuJvUfONVpIEzGfEG2qekwew0jRko3msnPbOX3wtQHAla1KMNz+B6rmdAlqNJDVsJVkZfl2VCnMaPdeUTnewqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662839; c=relaxed/simple;
	bh=k8ngfAg6plUD9rg0z3Tj9JT2D4YNwnAPfYewxcSVI7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H4VEBGPcdMk5NDWCxkT7I848Xalpgcn82qiYwaX+eM/Q6qjiIAv68pmmMJxzn1TZuk3xjfCQpoGsD3IikBPPqgnqzPy3RVr0S6mr8IJi2uzPxfoXVmYac36QmYQFiP5euD1IJ0Vy7XP/CKp00ghaVM4sHVanGRRXdROR6zFLWUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oFY/Zd2q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oFY/Zd2q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 566131F000E9;
	Tue, 21 Jul 2026 19:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662837;
	bh=Zut1VsGWqf4FQLDRPhkqOxbWfYoaaS4H49ceIB38oWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oFY/Zd2qo7w+jZ+QD+PQB//I10D+2mf6EimBgxgrk0F040wbfUDwfWt9A1GVZUuXh
	 Gp2PH6p2lSgioKyntKKv+X0AHgYYoJ7aqdUYPa9d2zUzKbiAThnFyJQpBjOSKj/G/d
	 BMZo+/5hPkuAQWQIgqAHCES4j330wod7auEqiuKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0594/1276] netfilter: ipset: Dont use test_bit() in lockless RCU readers in hash types
Date: Tue, 21 Jul 2026 17:17:17 +0200
Message-ID: <20260721152459.407502869@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jozsef Kadlecsik <kadlec@netfilter.org>

[ Upstream commit e4b4984e28c16406ecb318444dea4a8bf47def3e ]

Sashiko pointed out that there are a few lockless RCU readers
using test_bit() which is a relaxed atomic operation and
provides no memory barrier guarantees. Use test_bit_acquire()
instead where the operation may run parallel with add/del/gc,
i.e. is not one from the next cases

- protected by region lock
- in a set destroy phase
- in a new/temporary set creation phase

Fixes: 18f84d41d34f ("netfilter: ipset: Introduce RCU locking in hash:* types")
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 16cddd0bd6aeb9..94f11c0a5f928d 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -689,7 +689,7 @@ mtype_resize(struct ip_set *set, bool retried)
 				continue;
 			pos = smp_load_acquire(&n->pos);
 			for (j = 0; j < pos; j++) {
-				if (!test_bit(j, n->used))
+				if (!test_bit_acquire(j, n->used))
 					continue;
 				data = ahash_data(n, j, dsize);
 				if (SET_ELEM_EXPIRED(set, data))
@@ -826,7 +826,7 @@ mtype_ext_size(struct ip_set *set, u32 *elements, size_t *ext_size)
 				continue;
 			pos = smp_load_acquire(&n->pos);
 			for (j = 0; j < pos; j++) {
-				if (!test_bit(j, n->used))
+				if (!test_bit_acquire(j, n->used))
 					continue;
 				data = ahash_data(n, j, set->dsize);
 				if (!SET_ELEM_EXPIRED(set, data))
@@ -1202,7 +1202,7 @@ mtype_test_cidrs(struct ip_set *set, struct mtype_elem *d,
 			continue;
 		pos = smp_load_acquire(&n->pos);
 		for (i = 0; i < pos; i++) {
-			if (!test_bit(i, n->used))
+			if (!test_bit_acquire(i, n->used))
 				continue;
 			data = ahash_data(n, i, set->dsize);
 			if (!mtype_data_equal(data, d, &multi))
@@ -1260,7 +1260,7 @@ mtype_test(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	}
 	pos = smp_load_acquire(&n->pos);
 	for (i = 0; i < pos; i++) {
-		if (!test_bit(i, n->used))
+		if (!test_bit_acquire(i, n->used))
 			continue;
 		data = ahash_data(n, i, set->dsize);
 		if (!mtype_data_equal(data, d, &multi))
@@ -1397,7 +1397,7 @@ mtype_list(const struct ip_set *set,
 			continue;
 		pos = smp_load_acquire(&n->pos);
 		for (i = 0; i < pos; i++) {
-			if (!test_bit(i, n->used))
+			if (!test_bit_acquire(i, n->used))
 				continue;
 			e = ahash_data(n, i, set->dsize);
 			if (SET_ELEM_EXPIRED(set, e))
-- 
2.53.0



