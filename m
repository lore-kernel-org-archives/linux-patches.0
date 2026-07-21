Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CBA744AB91;
	Tue, 21 Jul 2026 22:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673220; cv=none; b=HxzKV2BCukVdbSdhEk+auUTq6OErvOFmpysSWCpr+UR6DEOJHH0SSeSijcN4sXgpZfw+P4U9nkEhR0SvNEzurdIjdguvSQirJiyRBTyBdOF99trePYC1yhDtjhpawaa+bOejyputSCmWJ/74A90GCDt9xVr9nmoypQ5xx7/lqwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673220; c=relaxed/simple;
	bh=VNooFS5NFKqUoWKgnhqrr4ctpzDMayajP8/bSAdXHJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZVvrnYCQW33vU90LcRdj065McMEMT7FePIMzS4tx/Bti5C2leF2l1rCmBEqt3KmEjm2bcIzi629ODlDhJjhwoKA5jdE24aHK9bqhJfmzAksFQebU0guDEuAm8ACavE5PzdtvC4EZQH0wOagBHviNGgJNPuzt9TL/7vUG8gJXtys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HtypFtA1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HtypFtA1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2B501F000E9;
	Tue, 21 Jul 2026 22:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673219;
	bh=ygswHaRjp3ph5lxDjusY3mLrpwRvBRWTZpuAmXjejag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HtypFtA1nqDqaSpLujabFK828yDoh7TEzPDDdvvmcvRZJ02HrEhzlD0MzCJULo+eK
	 WIvZJ1yqfwxBKx9mD1NqqCTR+PyoigrSCWAv1GI7pBe8GLWSk1h1KT5AAT5eFXQ06h
	 UWi2kZpfM2m6gLfqdwYQLPLYBy2sGbZbc18eDI0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuyang Huang <yuyanghuang@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.10 078/699] ipv4: igmp: remove multicast group from hash table on device destruction
Date: Tue, 21 Jul 2026 17:17:17 +0200
Message-ID: <20260721152357.465795579@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

From: Yuyang Huang <yuyanghuang@google.com>

commit 7993211bde166471dffac074dc965489f86531f8 upstream.

When a device is destroyed under RTNL, ip_mc_destroy_dev() iterates through
the multicast list and calls ip_ma_put() on each membership, scheduling
them for RCU reclamation. However, they are not unlinked from the device's
multicast hash table (mc_hash).

Since the device remains published in dev->ip_ptr until after
ip_mc_destroy_dev() completes, concurrent RCU readers traversing mc_hash
can still locate and access the multicast group after its refcount is
decremented. If the RCU callback runs and frees the group while a reader is
accessing it, a use-after-free occurs.

Fix this by unlinking the multicast group from mc_hash using
ip_mc_hash_remove() before scheduling it for reclamation.

BUG: KASAN: slab-use-after-free in ip_check_mc_rcu+0x149/0x3f0
Read of size 4 at addr ffff888009bf1408 by task mausezahn/2276

Call Trace:
 <IRQ>
 dump_stack_lvl+0x67/0x90
 print_report+0x175/0x7c0
 kasan_report+0x147/0x180
 ip_check_mc_rcu+0x149/0x3f0
 udp_v4_early_demux+0x36d/0x12d0
 ip_rcv_finish_core+0xb8b/0x1390
 ip_rcv_finish+0x54/0x120
 NF_HOOK+0x213/0x2b0
 __netif_receive_skb+0x126/0x340
 process_backlog+0x4f2/0xf00
 __napi_poll+0x92/0x2c0
 net_rx_action+0x583/0xc60
 handle_softirqs+0x236/0x7f0
 do_softirq+0x57/0x80
 </IRQ>

Allocated by task 2239:
 kasan_save_track+0x3e/0x80
 __kasan_kmalloc+0x72/0x90
 ____ip_mc_inc_group+0x31a/0xa40
 __ip_mc_join_group+0x334/0x3f0
 do_ip_setsockopt+0x16fa/0x2010
 ip_setsockopt+0x3f/0x90
 do_sock_setsockopt+0x1ad/0x300

Freed by task 0:
 kasan_save_track+0x3e/0x80
 kasan_save_free_info+0x40/0x50
 __kasan_slab_free+0x3a/0x60
 __rcu_free_sheaf_prepare+0xd4/0x220
 rcu_free_sheaf+0x36/0x190
 rcu_core+0x8d9/0x12f0
 handle_softirqs+0x236/0x7f0

Fixes: e9897071350b ("igmp: hash a hash table to speedup ip_check_mc_rcu()")
Cc: stable@vger.kernel.org
Signed-off-by: Yuyang Huang <yuyanghuang@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260701235014.73505-1-yuyanghuang@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/igmp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -1816,6 +1816,7 @@ void ip_mc_destroy_dev(struct in_device
 #endif
 
 	while ((i = rtnl_dereference(in_dev->mc_list)) != NULL) {
+		ip_mc_hash_remove(in_dev, i);
 		in_dev->mc_list = i->next_rcu;
 		in_dev->mc_count--;
 		ip_mc_clear_src(i);


