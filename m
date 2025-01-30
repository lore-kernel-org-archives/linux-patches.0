Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DAB47482;
	Thu, 30 Jan 2025 14:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247435; cv=none; b=mYxqZ0jfnTvrpylb1O49FQQo/maozkwMd0yCRuGtYK5PiYV8GENlMLYPv49IMKyDxKHTbH5drvqvB4lXQ2cALk5bcBiYqWtDdr2V8YTJ5253o169xCSfgsbuiqdpa1NBLaDXrvPaH3+JNnqqCFBq+WM2ut3xaKM2RNsWEnAErrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247435; c=relaxed/simple;
	bh=pvejN7SSSyF+iom6FPzpVlS0htb3Rs0bFCn/JXUxWPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nZ0L+/KoLa4uB5dSXOJAQmFz7ub1HfFu6fCgXcnPTkVonjcq8gGZ/b8xzV0r8LszxDRxRCPXIu4Giw+jPTYYdr9IMzfSluywlqY4+q/haY+p9fZhpiF4yQsgbY8crKkaZjTXvYpSu5uHzLeSkGRQXtSk1N+Kzs/gOVCgJ3qyJiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TWRaOH+x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TWRaOH+x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61976C4CED2;
	Thu, 30 Jan 2025 14:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247434;
	bh=pvejN7SSSyF+iom6FPzpVlS0htb3Rs0bFCn/JXUxWPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TWRaOH+xOerTnUqPxAgJCYv1El89CZsUXYjOaZqtte4Bz6OnN52fXZq4LDZzqZXYO
	 vgIgIZMg/WQRxGi/SA0eEyzC3sZmsvUDt++NKkoxVHUVAE+dNpyVCxWRQ3eNtoSvuR
	 1eJkPrxAaR5XGLBt/Vhm/pegbbwdCUwxVncOl4J0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Alva Lan <alvalan9@foxmail.com>
Subject: [PATCH 6.1 38/49] ipv4: ip_tunnel: Fix suspicious RCU usage warning in ip_tunnel_find()
Date: Thu, 30 Jan 2025 15:02:14 +0100
Message-ID: <20250130140135.360766679@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.825446496@linuxfoundation.org>
References: <20250130140133.825446496@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

commit 90e0569dd3d32f4f4d2ca691d3fa5a8a14a13c12 upstream.

The per-netns IP tunnel hash table is protected by the RTNL mutex and
ip_tunnel_find() is only called from the control path where the mutex is
taken.

Add a lockdep expression to hlist_for_each_entry_rcu() in
ip_tunnel_find() in order to validate that the mutex is held and to
silence the suspicious RCU usage warning [1].

[1]
WARNING: suspicious RCU usage
6.12.0-rc3-custom-gd95d9a31aceb #139 Not tainted
-----------------------------
net/ipv4/ip_tunnel.c:221 RCU-list traversed in non-reader section!!

other info that might help us debug this:

rcu_scheduler_active = 2, debug_locks = 1
1 lock held by ip/362:
 #0: ffffffff86fc7cb0 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x377/0xf60

stack backtrace:
CPU: 12 UID: 0 PID: 362 Comm: ip Not tainted 6.12.0-rc3-custom-gd95d9a31aceb #139
Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
Call Trace:
 <TASK>
 dump_stack_lvl+0xba/0x110
 lockdep_rcu_suspicious.cold+0x4f/0xd6
 ip_tunnel_find+0x435/0x4d0
 ip_tunnel_newlink+0x517/0x7a0
 ipgre_newlink+0x14c/0x170
 __rtnl_newlink+0x1173/0x19c0
 rtnl_newlink+0x6c/0xa0
 rtnetlink_rcv_msg+0x3cc/0xf60
 netlink_rcv_skb+0x171/0x450
 netlink_unicast+0x539/0x7f0
 netlink_sendmsg+0x8c1/0xd80
 ____sys_sendmsg+0x8f9/0xc20
 ___sys_sendmsg+0x197/0x1e0
 __sys_sendmsg+0x122/0x1f0
 do_syscall_64+0xbb/0x1d0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Fixes: c54419321455 ("GRE: Refactor GRE tunneling code.")
Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20241023123009.749764-1-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Alva Lan <alvalan9@foxmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_tunnel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -218,7 +218,7 @@ static struct ip_tunnel *ip_tunnel_find(
 	struct ip_tunnel *t = NULL;
 	struct hlist_head *head = ip_bucket(itn, parms);
 
-	hlist_for_each_entry_rcu(t, head, hash_node) {
+	hlist_for_each_entry_rcu(t, head, hash_node, lockdep_rtnl_is_held()) {
 		if (local == t->parms.iph.saddr &&
 		    remote == t->parms.iph.daddr &&
 		    link == READ_ONCE(t->parms.link) &&


