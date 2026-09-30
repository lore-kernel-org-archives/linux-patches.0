Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29DF25158B7;
	Wed, 30 Sep 2026 16:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787025; cv=none; b=Uu6YGuPDZUrqohUEkoL3/z8f4wIt9sc4JL/CY7hjl664W2ABtYFkebwjRwZ30CU/qfsSri/6vadgP+wYGh3JEUS1Zg8IpY5Rp3XoJCLoPuOIFNqWdjN633qIk79Ke7zAog3oBSZ8eInekc9y5sLpGkFybSUT3fjJ+rRJttpjyZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787025; c=relaxed/simple;
	bh=QGYVE59uPVK18yQe6Ah2tn8UcDTclB8yqtCn+Q41NU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HvLIgV+JBRWDP/+PRNHC59q19ZMojfKsqu7zRdpKG96g3typW2XvSnMtXFiXrK1sEDdiotkZyWhayEEBmdkSnOx1dHAD9mRvxde5HTiYaAj1I7QJ3CYoL8fQUR39rOBMfHyht8v9QnCyY0Oh3fX8v2/XUl4Su7EdL8RjLpEIWh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=obQXiM9m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="obQXiM9m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B6A01F000FF;
	Wed, 30 Sep 2026 16:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787024;
	bh=nPfP2pGcfqplJEcoiAJ9F5Btqv90fWX8B4UWALwH5bE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=obQXiM9m1z8f2oMjlnFOTt6CyRC+7ZCTAWfL2bnaA8M2tYy2mW+Ja0+T+bBwAYG9I
	 oECLXwwjGJ4XOPm/Zg/enyNwxtXnbZ1Bf4VcZ2SVDCogLhoaF+schXtPQ3xblhv11u
	 +aI0DnRxn0YKcN3LSLteJodl9gedKEA8PspMfsUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4bd730aede2791e40bdf@syzkaller.appspotmail.com,
	Naman Gulati <namangulati@google.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 085/457] netfilter: ctnetlink: fix suspicious RCU usage in expect_iter_name
Date: Wed, 30 Sep 2026 17:23:10 +0200
Message-ID: <20260930152347.882529671@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 92c3bb77d27e8..6cddfa339d71e 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3392,7 +3392,8 @@ static bool expect_iter_name(struct nf_conntrack_expect *exp, void *data)
 	struct nf_conntrack_helper *helper;
 	const char *name = data;
 
-	helper = rcu_dereference(exp->helper);
+	helper = rcu_dereference_protected(exp->helper,
+					   lockdep_is_held(&nf_conntrack_expect_lock));
 	if (!helper)
 		return false;
 
-- 
2.53.0



