Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 750A527781E;
	Tue, 12 Aug 2025 19:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026007; cv=none; b=pujIJQYO8f/jYQ+cmnwlbLYe8iJ3/QijD3b7wML09E/moHMWTpXoCkfO7SaKejeI/g5TJioE09yv5SuWsVrrVPJhdMEB5XWdYJPzvhOgIqJvGA9OlwmmLTwmtDEIbPM2XulORY5n//wWpJpLuGTtvLQHrUBK7OyMsuLYsPN5zU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026007; c=relaxed/simple;
	bh=l1PS60gtuwwtqQhZhaqs37Cy+mN9qycg6mMqFBbNIi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dlh9Fo5go1Aa4EwntUgrTsN1jwO6MsRqkVIKPmDmEdS5ndxZxkTweGcDQD9rIAkcIRiG3+6e0LIqlJU1ZAR+29/gXqty3i8d6kwDzYxifDSyTc4UgNHn3FDspfhkfBvQF0BF1MQPBKzrktlgyFj6dUw+8WBjWEVE1879IUxXtks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NHwVb0yc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NHwVb0yc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF3C4C4CEF0;
	Tue, 12 Aug 2025 19:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026007;
	bh=l1PS60gtuwwtqQhZhaqs37Cy+mN9qycg6mMqFBbNIi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NHwVb0ych7SECbszxLVAuZxVji3M3tIzY0LUVK2FK2m+wBYbrXeUOB+ZJEl6FKNyi
	 hAXih7453SdcjskewsM+TksjPwwfWcPKgomTQmwamIdUnAdHzHj2SFEZJzTVovi8OC
	 VrN5Gu01HkU45YykKK+xfrmo3W4ZWSl2AoodRomk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 209/480] neighbour: Fix null-ptr-deref in neigh_flush_dev().
Date: Tue, 12 Aug 2025 19:46:57 +0200
Message-ID: <20250812174406.089161432@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 1bbb76a899486827394530916f01214d049931b3 ]

kernel test robot reported null-ptr-deref in neigh_flush_dev(). [0]

The cited commit introduced per-netdev neighbour list and converted
neigh_flush_dev() to use it instead of the global hash table.

One thing we missed is that neigh_table_clear() calls neigh_ifdown()
with NULL dev.

Let's restore the hash table iteration.

Note that IPv6 module is no longer unloadable, so neigh_table_clear()
is called only when IPv6 fails to initialise, which is unlikely to
happen.

[0]:
IPv6: Attempt to unregister permanent protocol 136
IPv6: Attempt to unregister permanent protocol 17
Oops: general protection fault, probably for non-canonical address 0xdffffc00000001a0: 0000 [#1] SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000d00-0x0000000000000d07]
CPU: 1 UID: 0 PID: 1 Comm: systemd Tainted: G                T  6.12.0-rc6-01246-gf7f52738637f #1
Tainted: [T]=RANDSTRUCT
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:neigh_flush_dev.llvm.6395807810224103582+0x52/0x570
Code: c1 e8 03 42 8a 04 38 84 c0 0f 85 15 05 00 00 31 c0 41 83 3e 0a 0f 94 c0 48 8d 1c c3 48 81 c3 f8 0c 00 00 48 89 d8 48 c1 e8 03 <42> 80 3c 38 00 74 08 48 89 df e8 f7 49 93 fe 4c 8b 3b 4d 85 ff 0f
RSP: 0000:ffff88810026f408 EFLAGS: 00010206
RAX: 00000000000001a0 RBX: 0000000000000d00 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffffc0631640
RBP: ffff88810026f470 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: ffffffffc0625250 R14: ffffffffc0631640 R15: dffffc0000000000
FS:  00007f575cb83940(0000) GS:ffff8883aee00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f575db40008 CR3: 00000002bf936000 CR4: 00000000000406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __neigh_ifdown.llvm.6395807810224103582+0x44/0x390
 neigh_table_clear+0xb1/0x268
 ndisc_cleanup+0x21/0x38 [ipv6]
 init_module+0x2f5/0x468 [ipv6]
 do_one_initcall+0x1ba/0x628
 do_init_module+0x21a/0x530
 load_module+0x2550/0x2ea0
 __se_sys_finit_module+0x3d2/0x620
 __x64_sys_finit_module+0x76/0x88
 x64_sys_call+0x7ff/0xde8
 do_syscall_64+0xfb/0x1e8
 entry_SYSCALL_64_after_hwframe+0x67/0x6f
RIP: 0033:0x7f575d6f2719
Code: 08 89 e8 5b 5d c3 66 2e 0f 1f 84 00 00 00 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d b7 06 0d 00 f7 d8 64 89 01 48
RSP: 002b:00007fff82a2a268 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
RAX: ffffffffffffffda RBX: 0000557827b45310 RCX: 00007f575d6f2719
RDX: 0000000000000000 RSI: 00007f575d584efd RDI: 0000000000000004
RBP: 00007f575d584efd R08: 0000000000000000 R09: 0000557827b47b00
R10: 0000000000000004 R11: 0000000000000246 R12: 0000000000020000
R13: 0000000000000000 R14: 0000557827b470e0 R15: 00007f575dbb4270
 </TASK>
Modules linked in: ipv6(+)

Fixes: f7f52738637f4 ("neighbour: Create netdev->neighbour association")
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202507200931.7a89ecd8-lkp@intel.com
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20250723195443.448163-1-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/neighbour.c | 88 ++++++++++++++++++++++++++++++--------------
 1 file changed, 61 insertions(+), 27 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index a07249b59ae1..559841334f1a 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -368,6 +368,43 @@ static void pneigh_queue_purge(struct sk_buff_head *list, struct net *net,
 	}
 }
 
+static void neigh_flush_one(struct neighbour *n)
+{
+	hlist_del_rcu(&n->hash);
+	hlist_del_rcu(&n->dev_list);
+
+	write_lock(&n->lock);
+
+	neigh_del_timer(n);
+	neigh_mark_dead(n);
+
+	if (refcount_read(&n->refcnt) != 1) {
+		/* The most unpleasant situation.
+		 * We must destroy neighbour entry,
+		 * but someone still uses it.
+		 *
+		 * The destroy will be delayed until
+		 * the last user releases us, but
+		 * we must kill timers etc. and move
+		 * it to safe state.
+		 */
+		__skb_queue_purge(&n->arp_queue);
+		n->arp_queue_len_bytes = 0;
+		WRITE_ONCE(n->output, neigh_blackhole);
+
+		if (n->nud_state & NUD_VALID)
+			n->nud_state = NUD_NOARP;
+		else
+			n->nud_state = NUD_NONE;
+
+		neigh_dbg(2, "neigh %p is stray\n", n);
+	}
+
+	write_unlock(&n->lock);
+
+	neigh_cleanup_and_release(n);
+}
+
 static void neigh_flush_dev(struct neigh_table *tbl, struct net_device *dev,
 			    bool skip_perm)
 {
@@ -381,32 +418,24 @@ static void neigh_flush_dev(struct neigh_table *tbl, struct net_device *dev,
 		if (skip_perm && n->nud_state & NUD_PERMANENT)
 			continue;
 
-		hlist_del_rcu(&n->hash);
-		hlist_del_rcu(&n->dev_list);
-		write_lock(&n->lock);
-		neigh_del_timer(n);
-		neigh_mark_dead(n);
-		if (refcount_read(&n->refcnt) != 1) {
-			/* The most unpleasant situation.
-			 * We must destroy neighbour entry,
-			 * but someone still uses it.
-			 *
-			 * The destroy will be delayed until
-			 * the last user releases us, but
-			 * we must kill timers etc. and move
-			 * it to safe state.
-			 */
-			__skb_queue_purge(&n->arp_queue);
-			n->arp_queue_len_bytes = 0;
-			WRITE_ONCE(n->output, neigh_blackhole);
-			if (n->nud_state & NUD_VALID)
-				n->nud_state = NUD_NOARP;
-			else
-				n->nud_state = NUD_NONE;
-			neigh_dbg(2, "neigh %p is stray\n", n);
-		}
-		write_unlock(&n->lock);
-		neigh_cleanup_and_release(n);
+		neigh_flush_one(n);
+	}
+}
+
+static void neigh_flush_table(struct neigh_table *tbl)
+{
+	struct neigh_hash_table *nht;
+	int i;
+
+	nht = rcu_dereference_protected(tbl->nht,
+					lockdep_is_held(&tbl->lock));
+
+	for (i = 0; i < (1 << nht->hash_shift); i++) {
+		struct hlist_node *tmp;
+		struct neighbour *n;
+
+		neigh_for_each_in_bucket_safe(n, tmp, &nht->hash_heads[i])
+			neigh_flush_one(n);
 	}
 }
 
@@ -422,7 +451,12 @@ static int __neigh_ifdown(struct neigh_table *tbl, struct net_device *dev,
 			  bool skip_perm)
 {
 	write_lock_bh(&tbl->lock);
-	neigh_flush_dev(tbl, dev, skip_perm);
+	if (likely(dev)) {
+		neigh_flush_dev(tbl, dev, skip_perm);
+	} else {
+		DEBUG_NET_WARN_ON_ONCE(skip_perm);
+		neigh_flush_table(tbl);
+	}
 	pneigh_ifdown_and_unlock(tbl, dev);
 	pneigh_queue_purge(&tbl->proxy_queue, dev ? dev_net(dev) : NULL,
 			   tbl->family);
-- 
2.39.5



