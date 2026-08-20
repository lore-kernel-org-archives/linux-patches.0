Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C0463793CE;
	Thu, 20 Aug 2026 16:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244586; cv=none; b=KkyoXZgJkiSDcAw9//Xs/cGr7itwN7Eh5Po1CRiRruXqnMexAe6/6SlQCl4M9ObNuVqeSXHaMA7Fd7YEaoTybwA46nSzCaGLqI5VjEqB3GCPrnvOlYkFDf5ZkuHt04yM2Fpk8OmWMm0wYz3ttZCpin9tfdJ0mmBMPuYYkd6pK5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244586; c=relaxed/simple;
	bh=9ArpY+E/crIZbC/QGXggdBufR7qEZIHR0TP8s4lHTBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b+dnDRpTcXAGhZnuDs4YkeTjBpBnu+Dv6cixx97q6SPY3XU8ONyDaUioPB2IajWpT3WKUQdDf2j2G9IOqMQyG4yefm/h5bsswFOLC1nm2PRuDC6SMmjzC5taN1CKO6RKtPXxXmTaKm6jqFlkdZbgj6irVczHt6++1+y1At4+DNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fzy+hK0i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fzy+hK0i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E74A71F00A3A;
	Thu, 20 Aug 2026 16:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244585;
	bh=WHKwAvKlyvYuxGeRBqwWimFKdaNSt8B8lUXQ7dGC0+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fzy+hK0i+634FAlvkOaPksQEnyfbd/0x6tCuGOFzzoWSW66P2hjx0mN56T+a2mGbE
	 K2iQcVI8UJn2xmXtuJYRgg/MtsVpKNbp3vhGqMSKc2h8+EEiQNyvZz7KmNui2rrqkv
	 lIhUNF6ClpeRsy7R1dbzCBLJdOg4yDca59pqDMGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	"Xiang Mei (Microsoft)" <xmei5@asu.edu>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 218/235] netfilter: ipset: fix refcount race between list:set GC and swap
Date: Thu, 20 Aug 2026 16:57:34 +0200
Message-ID: <20260820145223.227758493@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang Mei (Microsoft) <xmei5@asu.edu>

[ Upstream commit 0c88868271653537ed443272dd8e7d13634d214b ]

__ip_set_put_byindex() resolved the index to a set pointer under RCU,
then took ip_set_ref_lock in __ip_set_put() to decrement set->ref.
ip_set_swap() holds that same lock while swapping both the ip_set_list
slots and the two sets' ref counters, so it can interleave between the
dereference and the lock acquisition, leaving the caller to decrement a
set whose reference already moved to the other index and hit
BUG_ON(set->ref == 0). list_set_gc() reaches this from timer softirq,
which the nfnl mutex does not serialize against swap: an expiring
list:set member calls list_set_del() -> ip_set_put_byindex() while
IPSET_CMD_SWAP runs on the referenced sets.

Resolve the index and decrement under ip_set_ref_lock, as ip_set_swap()
already does, keeping the refcount tied to the index rather than to a
stale set pointer.

  kernel BUG at net/netfilter/ipset/ip_set_core.c:685!
  Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
  RIP: 0010:ip_set_put_byindex (net/netfilter/ipset/ip_set_core.c:870)
  Call Trace:
   <IRQ>
   list_set_del (net/netfilter/ipset/ip_set_list_set.c:159)
   set_cleanup_entries (net/netfilter/ipset/ip_set_list_set.c:181)
   list_set_gc (net/netfilter/ipset/ip_set_list_set.c:578)
   call_timer_fn (kernel/time/timer.c:1748)
   __run_timers (kernel/time/timer.c:1799 kernel/time/timer.c:2374)
   run_timer_softirq (kernel/time/timer.c:2405)
   </IRQ>
  Kernel panic - not syncing: Fatal exception in interrupt

Fixes: 9076aea76538 ("netfilter: ipset: Increase the number of maximal sets automatically")
Reported-by: AutonomousCodeSecurity@microsoft.com
Signed-off-by: Xiang Mei (Microsoft) <xmei5@asu.edu>
Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipset/ip_set_core.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 11e5536d8b263..dcf23460b6df9 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -679,11 +679,18 @@ __ip_set_get(struct ip_set *set)
 }
 
 static void
-__ip_set_put(struct ip_set *set)
+__ip_set_put_locked(struct ip_set *set)
 {
-	write_lock_bh(&ip_set_ref_lock);
+	lockdep_assert_held(&ip_set_ref_lock);
 	BUG_ON(set->ref == 0);
 	set->ref--;
+}
+
+static void
+__ip_set_put(struct ip_set *set)
+{
+	write_lock_bh(&ip_set_ref_lock);
+	__ip_set_put_locked(set);
 	write_unlock_bh(&ip_set_ref_lock);
 }
 
@@ -856,11 +863,11 @@ __ip_set_put_byindex(struct ip_set_net *inst, ip_set_id_t index)
 {
 	struct ip_set *set;
 
-	rcu_read_lock();
-	set = rcu_dereference(inst->ip_set_list)[index];
+	write_lock_bh(&ip_set_ref_lock);
+	set = ip_set(inst, index);
 	if (set)
-		__ip_set_put(set);
-	rcu_read_unlock();
+		__ip_set_put_locked(set);
+	write_unlock_bh(&ip_set_ref_lock);
 }
 
 void
-- 
2.53.0



