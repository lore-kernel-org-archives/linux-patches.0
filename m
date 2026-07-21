Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E3D367B92;
	Tue, 21 Jul 2026 21:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669554; cv=none; b=hqG8ttgR3BmjRgvT0JRgtqHLP43tgtV6WWaRusK3tafGwCGReHF59Nkb5cGwm0HBbPPAsheHsN9e20JZZWmhXNyjtndx8kvoNAc3PqCUl8qB+QRA3pp7qNEWs9udO/3JQQvVVbg9esh5ZWt0ktXV1MLFDuPTHRTPj40F2I6LsQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669554; c=relaxed/simple;
	bh=4bpglKJhnEba93BCdhGeiNX5VEdKNgpF5b0PzMXQQPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QenSyzmfxc0hT5sKpnyQDd60BUC/Ua0JrEom8kxdkbiTYrFwptxvXxSrxu7gfx5nCJZLZDwyisyGEw2cDejwqTuTPEI6a2PNhdW3v529QoGGqA7jeVfDc/LkSnQUR19WImyzUgVs5bOTHfsX9pu/2rEac1sYIGm6wjlcQtZcVD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T8es0sZR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T8es0sZR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C8A91F000E9;
	Tue, 21 Jul 2026 21:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669552;
	bh=o+JFvTPKzllY1C88jgOayRPYKMLsrjOSoQYvj9ORI78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T8es0sZRIJjXk2aISoNTnPT179ivJY7k5NtKYrvndF473xxoyj+mYw+DWp2u+l01m
	 AN91p1HKUfTuiGtJPuxGuLr7l96Z9Cy0gjNupnXSx6Gnab2BmnDAH52Fj7tkSDets3
	 Yg5quogQeaqgmaDtr3HvB+pBonBI4sKW/II0m18A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0597/1067] netfilter: ipset: Dont use test_bit() in lockless RCU readers in hash types
Date: Tue, 21 Jul 2026 17:19:58 +0200
Message-ID: <20260721152437.960303357@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 25c51a8e2bfb12..d2da54de4d15bc 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -676,7 +676,7 @@ mtype_resize(struct ip_set *set, bool retried)
 				continue;
 			pos = smp_load_acquire(&n->pos);
 			for (j = 0; j < pos; j++) {
-				if (!test_bit(j, n->used))
+				if (!test_bit_acquire(j, n->used))
 					continue;
 				data = ahash_data(n, j, dsize);
 				if (SET_ELEM_EXPIRED(set, data))
@@ -813,7 +813,7 @@ mtype_ext_size(struct ip_set *set, u32 *elements, size_t *ext_size)
 				continue;
 			pos = smp_load_acquire(&n->pos);
 			for (j = 0; j < pos; j++) {
-				if (!test_bit(j, n->used))
+				if (!test_bit_acquire(j, n->used))
 					continue;
 				data = ahash_data(n, j, set->dsize);
 				if (!SET_ELEM_EXPIRED(set, data))
@@ -1189,7 +1189,7 @@ mtype_test_cidrs(struct ip_set *set, struct mtype_elem *d,
 			continue;
 		pos = smp_load_acquire(&n->pos);
 		for (i = 0; i < pos; i++) {
-			if (!test_bit(i, n->used))
+			if (!test_bit_acquire(i, n->used))
 				continue;
 			data = ahash_data(n, i, set->dsize);
 			if (!mtype_data_equal(data, d, &multi))
@@ -1247,7 +1247,7 @@ mtype_test(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	}
 	pos = smp_load_acquire(&n->pos);
 	for (i = 0; i < pos; i++) {
-		if (!test_bit(i, n->used))
+		if (!test_bit_acquire(i, n->used))
 			continue;
 		data = ahash_data(n, i, set->dsize);
 		if (!mtype_data_equal(data, d, &multi))
@@ -1372,7 +1372,7 @@ mtype_list(const struct ip_set *set,
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



