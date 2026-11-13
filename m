Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585506;
	b=36N3b/36lDDSPRU4GRN9UHioejyZJkrq1tMw6bI+Lj9pLtuu65/T18UNiSNCfWB9kJUz
	 hEpusGXvtSlT0odU+RL+V815yS/8VJwh4U09OWfPwuKiGPZW87YL4ugJGlPp3pEEX8GbS
	 5oGt17vV7MSgNZ6TsbjDNYYOHs2oDEslpB+3YejUmvqv9KbG33QPWFQpV0UgqbpIg1b4Y
	 6Dyj7Tpt/Qc22AOn4txWlbFGk0Si4YakICg31jdAhriKm2yjCwAmRcsWBNeSAxBSRB4hG
	 aoBf72BKOxhODUyhjb5b3gNn5P906GwtaEHlTggoyRK3PyT2hWMoeEwUlBzKyEoNZFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585506;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YZxwlrp3zZ+oYPKWLOTGyfiJDJeOWKMoizinWlawgcU=;
	b=WFY7OexFAMeOQfYa3A/GhX5Jli8twue5SDb7Qrywm/hT49QlWs+jLzFB0KagVB57lbHa
	 JxGF9OkRMWNViQqWZK1dqXsHpsXCe80gd91ElCG3M0xFdWB5f6QgJtPrttvQabNIjwPDN
	 cULq1/wgI9CyXCSC1T8XdVabkesHINX4Qo1HHa1ztghD40KO60IEsPF4j7SIyocFil3XL
	 3TnbFfYb1h9kRpoAlGrX4HNHSNRRy8eG30GsmAl2MlkZ7wvXtvkGU/+AgfuCtUM6+5jrs
	 EqO0ryWInWVoALZ/fCOqUmIrYJ9oPvw8E6TYskYYLyOpPcqkt5b59MLxPA0dhPfRKtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OMbTyj6I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B999606AE0B;
	Fri, 13 Nov 2026 15:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OMbTyj6I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D271C1F000C6;
	Fri, 13 Nov 2026 15:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585506;
	bh=YZxwlrp3zZ+oYPKWLOTGyfiJDJeOWKMoizinWlawgcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OMbTyj6IUj4ojd4OnZC77PuWco9X7jEns/SX0cnLegk58CRPFuU8VCD1Q4ZXthOlc
	 dTD7PQcEmmyyBsBRQ6frrNY32166PRhvkX++4H7M+p2rd4nG25INX9SaKCPcjKCltO
	 2WUo2O+w9cqjga7nzaZ/UoaKCx8fLdIIKos5I3L4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Mani Tofigh <mt4022@columbia.edu>,
	Lance Yang <lance.yang@linux.dev>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 154/507] mm/huge_memory: fix list corruption when deferred_split_scan() races with deferred_split_folio()
Date: Fri, 13 Nov 2026 10:47:38 -0500
Message-ID: <20261113153759.744765421@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand (Arm) <david@kernel.org>

[ Upstream commit f09171b67ea06a7fe425db33e8b74a92de1426b9 ]

Since the deferred split queue became a list_lru, the isolate callback
moves the folios it took a reference on to an on-stack list, linked
through folio->_deferred_list, and deferred_split_scan() takes them off
that list with list_del_init() without holding the list_lru lock.

deferred_split_folio() does not know about the on-stack list. It only
holds the list_lru lock when it looks at the same list_head, and it can
run for such a folio: a THP is queued when it is mapped, as a candidate
for the underused check, and is queued "again" when a part of it gets
unmapped:

  CPU0 deferred_split_scan()          CPU1 deferred_split_folio()
  list_del_init(&folio->_deferred_list)
    next->prev = prev
    prev->next = next
    entry->next = entry
                                      list_lru_lock_irqsave()
                                      folio_set_partially_mapped()
                                      __list_lru_add()
                                        list_empty(item)  -> true
                                        list_add_tail(item, &l->list)
                                          item->next = &l->list
                                          item->prev = tail
    entry->prev = entry

The folio now sits on the list_lru with ->prev pointing to itself. The
next removal leaves the neighbours pointing to it, and they still do so
after the folio has been freed. With CONFIG_DEBUG_LIST:

  list_del corruption. prev->next should be ffd4000000270090, but was
  ffd4000000278090. (prev=ffd4000000270090)

Fix it by grabbing the lock around list_del_init() so
deferred_split_folio() cannot race with it.

Fixes: fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru")
Cc: stable@vger.kernel.org
Reported-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Mani Tofigh <mt4022@columbia.edu>
Tested-by: Mani Tofigh <mt4022@columbia.edu>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Link: https://patch.msgid.link/20261031-fixes_core-v3-10-d6437171ecc3@kernel.org
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/huge_memory.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 779c02e0bf6cc..fd32f629400a6 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4511,8 +4511,7 @@ int split_folio_to_list(struct folio *folio, struct list_head *list)
  *
  * It is unsafe to call folio_unqueue_deferred_split() until folio refcount is
  * zero: because even when the list_lru lock is held, a non-empty
- * _deferred_list might be in use on deferred_split_scan()'s unlocked
- * on-stack list.
+ * _deferred_list might be in use on deferred_split_scan()'s on-stack list.
  *
  * The list_lru sublist is determined by folio's memcg: it is therefore
  * important to unqueue deferred split before changing folio memcg.
@@ -4658,10 +4657,22 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
 					    deferred_split_isolate, &dispose);
 
 	list_for_each_entry_safe(folio, next, &dispose, _deferred_list) {
+		struct mem_cgroup *memcg;
+		struct list_lru_one *lru;
 		bool did_split = false;
 		bool underused = false;
 
+		/*
+		 * Sync with deferred_split_folio(), which can requeue the
+		 * folio once list_empty() is true, and sets PG_partially_mapped.
+		 */
+		rcu_read_lock();
+		memcg = folio_memcg(folio);
+		lru = list_lru_lock_irq(&deferred_split_lru, folio_nid(folio),
+					&memcg);
 		list_del_init(&folio->_deferred_list);
+		list_lru_unlock_irq(lru);
+		rcu_read_unlock();
 
 		if (!folio_test_partially_mapped(folio)) {
 			/*
-- 
2.53.0



