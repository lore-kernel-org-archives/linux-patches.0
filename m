Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5408451A14B;
	Wed, 30 Sep 2026 17:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789131; cv=none; b=IbtYB4Fn2bR7Uwr7QfSLqCVu1TlkCoz6NwqhnNTN7dEgUAQsekSzGT+Zf8YsxYO7NeFHSoTlZllytWLKDqaD3OvgSgj1+Ltx1hptTV7n4xCMkKOPAW5AArffFpYECGBU7psRF5e2g7JK0MKvk/JQJrwxcmNfk9N0aL46mxtnIuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789131; c=relaxed/simple;
	bh=KdbkWLhWGlBxymb6BTF/VWlooJBnaxSbd4uuwdfD4Co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IKRGh2+p68uqgRzxNxrX/VupOx6poG0c6ymkhVtUca+Lc2EWBpUIf7eB/1IXxam3ef7ibVjvw8mMgbj4nCbj89d1wzF35SS870Husq7grO5nAjt2er9edj9bTbvBu5ToAG0pKJOTgHJsqskwiNrCnHdt73TK7+sJpQFkJbURZQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pn/YEnXh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pn/YEnXh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A870F1F000FF;
	Wed, 30 Sep 2026 17:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789130;
	bh=G/JPodqhpihMVIOE0rUqPoHq4Pcm8S4qgK25CgoXgTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pn/YEnXhH3EmtTgwpLnMr7piJj2ZctV3rWQHHWz6ZZJvhps0esVXusLPI0pSb4MCj
	 PcXzyb7M3Z1AgZ4U91UUx9JIuqo2rqefEsWX/R057ypTrdbrOiZ2+TjYiF6FOK3++O
	 fM9IUf4OWG6ebtaFP5R9TfGD69BkPDe/oDUq0TGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4bd730aede2791e40bdf@syzkaller.appspotmail.com,
	Naman Gulati <namangulati@google.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 352/877] netfilter: ctnetlink: fix suspicious RCU usage in expect_iter_name
Date: Wed, 30 Sep 2026 17:21:03 +0200
Message-ID: <20260930152422.268512725@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a081d38702f5d..8bb32965edb83 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3390,7 +3390,8 @@ static bool expect_iter_name(struct nf_conntrack_expect *exp, void *data)
 	struct nf_conntrack_helper *helper;
 	const char *name = data;
 
-	helper = rcu_dereference(exp->helper);
+	helper = rcu_dereference_protected(exp->helper,
+					   lockdep_is_held(&nf_conntrack_expect_lock));
 	if (!helper)
 		return false;
 
-- 
2.53.0



