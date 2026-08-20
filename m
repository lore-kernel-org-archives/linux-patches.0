Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711BB360745;
	Thu, 20 Aug 2026 15:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238658; cv=none; b=rKsXkceSZ3LltodtJT7ejY6RTbnnZMbcw9uRD2XyP3f5pNBV5WSiZW/mwJ3Lva68zrVpbD/pKPCoe/Z/R8RJXR3w/YOmcCDU9FgPHOdtK6CpaRfNmDWpfY8/p1x+EtGaw81x0mEoGPcVev2Iw12Gwj+lwugR8R9PRaJRN3dxU9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238658; c=relaxed/simple;
	bh=gHEsasjfTmv/zvt0PARbB5C2jsag2Mn5mdSYlmWTBbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KZ4XeoV4JMI0td4ZCtz134FOrAR2kYVqLpSAKKgTxPrR6s76RbM7Mze6EcNVqft5pV+rM8ViS+5Piz2v2y5B9nv2WbSIp5pmQZJLd9VLXqOJURvUg8qCyGwp7XU2s6X1XaWtrtAkBrXsHn++sOblwCt66bQkN+kfo9+Y92g6qUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x+wVfvLc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x+wVfvLc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C20AD1F000E9;
	Thu, 20 Aug 2026 15:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238657;
	bh=1dfTohAUXL4MzXLzbSAijEVcABNc7wt1ixYY8F+/H/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x+wVfvLc8So67niQ0QmB2FKREeXxBquXTkoZWM9e7DlRQi2LPinuvqft8lXh9vRoF
	 XF1RnMn5Qh28lqeR81tjTWwUm75TeTqNEw/Or2hYG9c75stCl/uXHAiTAIUYEJnGji
	 jcVpKp+kZdhifJtbfUy7ajKxm+b3hDA/2bNxeoSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	"Xiang Mei (Microsoft)" <xmei5@asu.edu>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 187/228] netfilter: ipset: fix refcount race between list:set GC and swap
Date: Thu, 20 Aug 2026 16:55:29 +0200
Message-ID: <20260820145250.385320381@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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
index 822a53a7f502a..5624036daf8c5 100644
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
 
@@ -854,11 +861,11 @@ __ip_set_put_byindex(struct ip_set_net *inst, ip_set_id_t index)
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



