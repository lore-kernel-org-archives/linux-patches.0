Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19DC14A81
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qTF6AuUe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18D06C433C8;
	Mon, 23 Oct 2023 11:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059106;
	bh=PkrrBXZJrxWMir3bb9InaEm82r4J3KC+lCfumNPzY7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qTF6AuUe3HtJQMypUhQi/czGzg6JQThrJJVWbaA7hoXfTMybHcwZAt5mi2KylbbWE
	 bF1xE+YNXVG0UTdSXnZ7T2rRWrnbOpYMxtRybOs7ax+9Asctgu/n1WlCBB3RNE+gQh
	 IzT4K2zANuv3pdKIzo7Z+mpW1P821qznUG3nMicM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dong Chenchen <dongchenchen2@huawei.com>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 6.5 058/241] net: xfrm: skip policies marked as dead while reinserting policies
Date: Mon, 23 Oct 2023 12:54:04 +0200
Message-ID: <20231023104835.326428246@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dong Chenchen <dongchenchen2@huawei.com>

commit 6d41d4fe28724db16ca1016df0713a07e0cc7448 upstream.

BUG: KASAN: slab-use-after-free in xfrm_policy_inexact_list_reinsert+0xb6/0x430
Read of size 1 at addr ffff8881051f3bf8 by task ip/668

CPU: 2 PID: 668 Comm: ip Not tainted 6.5.0-rc5-00182-g25aa0bebba72-dirty #64
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.13 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x72/0xa0
 print_report+0xd0/0x620
 kasan_report+0xb6/0xf0
 xfrm_policy_inexact_list_reinsert+0xb6/0x430
 xfrm_policy_inexact_insert_node.constprop.0+0x537/0x800
 xfrm_policy_inexact_alloc_chain+0x23f/0x320
 xfrm_policy_inexact_insert+0x6b/0x590
 xfrm_policy_insert+0x3b1/0x480
 xfrm_add_policy+0x23c/0x3c0
 xfrm_user_rcv_msg+0x2d0/0x510
 netlink_rcv_skb+0x10d/0x2d0
 xfrm_netlink_rcv+0x49/0x60
 netlink_unicast+0x3fe/0x540
 netlink_sendmsg+0x528/0x970
 sock_sendmsg+0x14a/0x160
 ____sys_sendmsg+0x4fc/0x580
 ___sys_sendmsg+0xef/0x160
 __sys_sendmsg+0xf7/0x1b0
 do_syscall_64+0x3f/0x90
 entry_SYSCALL_64_after_hwframe+0x73/0xdd

The root cause is:

cpu 0			cpu1
xfrm_dump_policy
xfrm_policy_walk
list_move_tail
			xfrm_add_policy
			... ...
			xfrm_policy_inexact_list_reinsert
			list_for_each_entry_reverse
				if (!policy->bydst_reinsert)
				//read non-existent policy
xfrm_dump_policy_done
xfrm_policy_walk_done
list_del(&walk->walk.all);

If dump_one_policy() returns err (triggered by netlink socket),
xfrm_policy_walk() will move walk initialized by socket to list
net->xfrm.policy_all. so this socket becomes visible in the global
policy list. The head *walk can be traversed when users add policies
with different prefixlen and trigger xfrm_policy node merge.

The issue can also be triggered by policy list traversal while rehashing
and flushing policies.

It can be fixed by skip such "policies" with walk.dead set to 1.

Fixes: 9cf545ebd591 ("xfrm: policy: store inexact policies in a tree ordered by destination address")
Fixes: 12a169e7d8f4 ("ipsec: Put dumpers on the dump list")
Signed-off-by: Dong Chenchen <dongchenchen2@huawei.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/xfrm_policy.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -851,7 +851,7 @@ static void xfrm_policy_inexact_list_rei
 		struct hlist_node *newpos = NULL;
 		bool matches_s, matches_d;
 
-		if (!policy->bydst_reinsert)
+		if (policy->walk.dead || !policy->bydst_reinsert)
 			continue;
 
 		WARN_ON_ONCE(policy->family != family);
@@ -1256,8 +1256,11 @@ static void xfrm_hash_rebuild(struct wor
 		struct xfrm_pol_inexact_bin *bin;
 		u8 dbits, sbits;
 
+		if (policy->walk.dead)
+			continue;
+
 		dir = xfrm_policy_id2dir(policy->index);
-		if (policy->walk.dead || dir >= XFRM_POLICY_MAX)
+		if (dir >= XFRM_POLICY_MAX)
 			continue;
 
 		if ((dir & XFRM_POLICY_MASK) == XFRM_POLICY_OUT) {
@@ -1821,9 +1824,11 @@ int xfrm_policy_flush(struct net *net, u
 
 again:
 	list_for_each_entry(pol, &net->xfrm.policy_all, walk.all) {
+		if (pol->walk.dead)
+			continue;
+
 		dir = xfrm_policy_id2dir(pol->index);
-		if (pol->walk.dead ||
-		    dir >= XFRM_POLICY_MAX ||
+		if (dir >= XFRM_POLICY_MAX ||
 		    pol->type != type)
 			continue;
 
@@ -1860,9 +1865,11 @@ int xfrm_dev_policy_flush(struct net *ne
 
 again:
 	list_for_each_entry(pol, &net->xfrm.policy_all, walk.all) {
+		if (pol->walk.dead)
+			continue;
+
 		dir = xfrm_policy_id2dir(pol->index);
-		if (pol->walk.dead ||
-		    dir >= XFRM_POLICY_MAX ||
+		if (dir >= XFRM_POLICY_MAX ||
 		    pol->xdo.dev != dev)
 			continue;
 


