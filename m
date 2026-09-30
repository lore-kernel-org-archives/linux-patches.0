Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60EAA4A8430;
	Wed, 30 Sep 2026 18:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792921; cv=none; b=OYj7V3+265kkz/OwF+kz4cAZi8Ea/4GAj3FFpxqRIqTetH6sQY5q40d26d4Kt0aV9ggrkGxm80PS1uBHLrtr4Y2kBNy1q1H3buuvF+yPZuG988P7VIowNCmgStUX0kqmFMetOKP4EVc4DYt35RmueSNbVoiYmCM6mAEhuiqiFq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792921; c=relaxed/simple;
	bh=kpfQYmOXgVFrvsd17DNSAlcaST5VkVMslD828lpxyvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=snbLQ6FDNs83+Dj+YD/bWJGuszrPGl/7GPsWVZMtSKKw/glz/BtkU2f4tK7VhzfS8jOpJNNvUNp4lMVvkixY87NJbmbta/rJAvxK0evjaZavShMDVEW3IU1zU2wQFvAmbaD2d/8OGb1b2bfv8S4QR8ANQAU4L5A7wGImweiGUWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y0b89RGc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y0b89RGc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 467041F000FF;
	Wed, 30 Sep 2026 18:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792919;
	bh=+WjdnZuBzTH8J2SNCM2nN6HlxmsXG4CknZN+BPQ75ME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y0b89RGcHkg9ebekJMLyBnjZDmvi9SY/VEA69oaNGWeoAGEEiRz8Pbe+3XgKpYe65
	 uzUpAZigmZ4jPiHQ0kDfT502/yfI7AnwpEm2GP9K7h7q2UuKfuFVhrGhEFeEe4IV+a
	 kWLvZoAj7Fpo3FB2jkJr3dUO0A0OX5v4WE9h6TAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4bd730aede2791e40bdf@syzkaller.appspotmail.com,
	Naman Gulati <namangulati@google.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 070/395] netfilter: ctnetlink: fix suspicious RCU usage in expect_iter_name
Date: Wed, 30 Sep 2026 17:25:32 +0200
Message-ID: <20260930152342.157116491@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naman Gulati <namangulati@google.com>

[ Upstream commit 207d591c353201f3bd3e0c89bb7d44a849c8fd59 ]

expect_iter_name() is invoked by nf_ct_expect_iterate_net() under
spin_lock_bh(&nf_conntrack_expect_lock). It does not hold
rcu_read_lock().

When accessing exp->helper with rcu_dereference() in syzbot's report,
lockdep warns:

  =============================
  WARNING: suspicious RCU usage
  syzkaller #0 Not tainted
  -----------------------------
  net/netfilter/nf_conntrack_netlink.c:3393 suspicious rcu_dereference_check() usage!

  locks held by syz-executor381/5628: 2, last CPU#1:
   #0: ffffffff9aee42a0 (nfnl_subsys_ctnetlink_exp){+.+.}-{4:4},
       at: nfnetlink_rcv_msg+0xa69/0x12b0
   #1: ffffffff8ea74d58 (nf_conntrack_expect_lock){+...}-{3:3},
       at: nf_ct_expect_iterate_net+0x38/0x180

  Call Trace:
   <TASK>
   dump_stack_lvl+0xe8/0x150
   lockdep_rcu_suspicious+0x140/0x1d0
   expect_iter_name+0xfb/0x100
   nf_ct_expect_iterate_net+0xf2/0x180
   ctnetlink_del_expect+0x45d/0x640
   nfnetlink_rcv_msg+0xcc2/0x12b0
   netlink_rcv_skb+0x226/0x4a0
   nfnetlink_rcv+0x2b9/0x28c0
   netlink_unicast+0x7bd/0x940
   netlink_sendmsg+0x813/0xb40
   ____sys_sendmsg+0x54e/0x850
   ___sys_sendmsg+0x2a5/0x360
   __sys_sendmsg+0x2a5/0x360
   do_syscall_64+0x166/0x520
   entry_SYSCALL_64_after_hwframe+0x77/0x7f

Use rcu_dereference_protected() with lockdep_is_held() on
nf_conntrack_expect_lock instead, similar to expect_iter_me() in
nf_conntrack_helper.c.

Fixes: f01794106042 ("netfilter: nf_conntrack_expect: use expect->helper")
Reported-by: syzbot+4bd730aede2791e40bdf@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/6aa4a377.f81106d8.2ab401.0024.GAE@google.com/T/#u
Signed-off-by: Naman Gulati <namangulati@google.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_netlink.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 48cf3dad61bdb..5211599357189 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3395,7 +3395,8 @@ static bool expect_iter_name(struct nf_conntrack_expect *exp, void *data)
 	struct nf_conntrack_helper *helper;
 	const char *name = data;
 
-	helper = rcu_dereference(exp->helper);
+	helper = rcu_dereference_protected(exp->helper,
+					   lockdep_is_held(&nf_conntrack_expect_lock));
 	if (!helper)
 		return false;
 
-- 
2.53.0



