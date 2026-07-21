Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A31A395243;
	Tue, 21 Jul 2026 20:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666711; cv=none; b=MjQnUvZNlN8xOmMeUl9ccs60/0LB9LZbIu2Fhxq2El50PbSoYcWG/vPquFpJyqQ1sUXEvkWMFqod0Z1SSrA7jjTKX6a0L+HWu88XpPcOnjpwq4q91C1JElSyTIxNoAyObyndcCuaJJH36Wne0TXc7bY0CnoSdFVIBNWfgSraLMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666711; c=relaxed/simple;
	bh=7WDnCwz7GBhDEnVAS9bMyZSfOGzadxFFGjUBW/804B0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BY67mteKB8zlaOXaYQ0Kt0UJ2g/vHLy4dAx06Yx58H+lMxchaQRawC4n8VfEZy5Xt+ROs3YBROdM5i9TtwFw9uxDM4ZGUx0AQXDAOhbhpGx54oFX59Ctsf+jttsvdrl9NCpW3+yro0hgjmswydLHeABv0VWSqgTDicCp9cahpH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TXFIfSXT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TXFIfSXT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A8E31F000E9;
	Tue, 21 Jul 2026 20:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666710;
	bh=0LGx2NrUaKPefyp0QCO9l4of7V98BxRFkLvrG0cjHAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TXFIfSXThi/4Jg8H5PCN9S/e0vAuGrUDqs5R5sBGy0FUz/5m4wMheW1Yn+8yv+Hpa
	 8jTluK6lD3r/6iOEJTM1eldaguD21QHzXtL2DRQtjfzUwsZgSGv1yxIq1lQU0OWOAC
	 I8ufl9P/WLz8LLi9a7yXDvAN9qMA1GUuhcC+nLBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0743/1266] netfilter: ipset: Dont use test_bit() in lockless RCU readers in hash types
Date: Tue, 21 Jul 2026 17:19:40 +0200
Message-ID: <20260721152458.498170804@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
index 3ed883b4be54b4..ad2ff9cc0b58d9 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -688,7 +688,7 @@ mtype_resize(struct ip_set *set, bool retried)
 				continue;
 			pos = smp_load_acquire(&n->pos);
 			for (j = 0; j < pos; j++) {
-				if (!test_bit(j, n->used))
+				if (!test_bit_acquire(j, n->used))
 					continue;
 				data = ahash_data(n, j, dsize);
 				if (SET_ELEM_EXPIRED(set, data))
@@ -825,7 +825,7 @@ mtype_ext_size(struct ip_set *set, u32 *elements, size_t *ext_size)
 				continue;
 			pos = smp_load_acquire(&n->pos);
 			for (j = 0; j < pos; j++) {
-				if (!test_bit(j, n->used))
+				if (!test_bit_acquire(j, n->used))
 					continue;
 				data = ahash_data(n, j, set->dsize);
 				if (!SET_ELEM_EXPIRED(set, data))
@@ -1201,7 +1201,7 @@ mtype_test_cidrs(struct ip_set *set, struct mtype_elem *d,
 			continue;
 		pos = smp_load_acquire(&n->pos);
 		for (i = 0; i < pos; i++) {
-			if (!test_bit(i, n->used))
+			if (!test_bit_acquire(i, n->used))
 				continue;
 			data = ahash_data(n, i, set->dsize);
 			if (!mtype_data_equal(data, d, &multi))
@@ -1259,7 +1259,7 @@ mtype_test(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	}
 	pos = smp_load_acquire(&n->pos);
 	for (i = 0; i < pos; i++) {
-		if (!test_bit(i, n->used))
+		if (!test_bit_acquire(i, n->used))
 			continue;
 		data = ahash_data(n, i, set->dsize);
 		if (!mtype_data_equal(data, d, &multi))
@@ -1396,7 +1396,7 @@ mtype_list(const struct ip_set *set,
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



