Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F692EC09B;
	Sat, 12 Sep 2026 11:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212052; cv=none; b=HspmaiTW14CNEOkOO93wk64D2QY2RuZWIvZDunpBBt8fgby/HgJapXmh9ezhmh5WWXn5J+FHDQwDJiR4Aiwv2tIBhPhFFaSG9DDKFnI54rZEzQgMbRFgM8tNW5LupNZPoXinObqWwkEMb5DSPRgZFWgCvsPhxFfxD3jAYpqc2yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212052; c=relaxed/simple;
	bh=fyhlEb4kZimoWgTu3fHuIkU/YDnHx+cuyBBHEbWZr30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ILPKXIs/0Legdr1P7RFbFDuH7LXfy5ZQR8Y+DzogyBBeWxoNQ8ipiv6HubpByEu35+httVMfltzlCZ6RXCv0kh3bO7rw5XrKesjLdEY5Ay88dWHcIKhWnxIABidNU5aZCgTWoviU/xeLPoWGx2relOkik7LpCvBT4Iuglh3eRbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DYdJuUa4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DYdJuUa4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B0EE1F000FF;
	Sat, 12 Sep 2026 11:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212050;
	bh=4Q3XGy54nWJpB7794pe6TNe1oNhrs5OKuNWcHxHFr14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DYdJuUa4OjAqh3Vx6gW5a7JBbnxpUBq2DvJJCHgclqTWXWuzRN9GIsRuCzz2pTi5M
	 Kr9kd5BDyjzzL70o9AX4ECXXK7W14oKL5jP/N2nhnjNr6LsUA1ax/rgWpVru5ueosB
	 Q58oM2OmTkb2h4Y+Z/qR9mKT2B7+pWY73oqTZpkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1357/1518] ipmr: Remove RTNL in ipmr_rules_init() and ipmr_net_init().
Date: Sat, 12 Sep 2026 08:58:46 +0200
Message-ID: <20260912065654.229995234@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 4a11adcd9eefb841d4595267bbd4df304a98ded6 ]

When ipmr_free_table() is called from ipmr_rules_init() or
ipmr_net_init(), the netns is not yet published.

Thus, no device should have been registered, and
mroute_clean_tables() will not call vif_delete(), so
unregister_netdevice_many() is unnecessary.

unregister_netdevice_many() does nothing if the list is empty,
but it requires RTNL due to the unconditional ASSERT_RTNL()
at the entry of unregister_netdevice_many_notify().

Let's remove unnecessary RTNL and ASSERT_RTNL() and instead
add WARN_ON_ONCE() in ipmr_free_table().

Note that we use a local list for the new WARN_ON_ONCE() because
dev_kill_list passed from ipmr_rules_exit_rtnl() may have some
devices when other ops->init() fails after ipmr durnig setup_net().

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260228221800.1082070-11-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 235b42b58601 ("ip6mr: do not clone dst in ip6mr_cache_report()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ipmr.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index df5620fb5dad7..18e3ad5ae8be2 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -276,10 +276,7 @@ static int __net_init ipmr_rules_init(struct net *net)
 	return 0;
 
 err2:
-	rtnl_lock();
 	ipmr_free_table(mrt, &dev_kill_list);
-	unregister_netdevice_many(&dev_kill_list);
-	rtnl_unlock();
 err1:
 	fib_rules_unregister(ops);
 	return err;
@@ -290,7 +287,6 @@ static void __net_exit ipmr_rules_exit_rtnl(struct net *net,
 {
 	struct mr_table *mrt, *next;
 
-	ASSERT_RTNL();
 	list_for_each_entry_safe(mrt, next, &net->ipv4.mr_tables, list) {
 		list_del(&mrt->list);
 		ipmr_free_table(mrt, dev_kill_list);
@@ -355,8 +351,6 @@ static int __net_init ipmr_rules_init(struct net *net)
 static void __net_exit ipmr_rules_exit_rtnl(struct net *net,
 					    struct list_head *dev_kill_list)
 {
-	ASSERT_RTNL();
-
 	ipmr_free_table(net->ipv4.mrt, dev_kill_list);
 
 	net->ipv4.mrt = NULL;
@@ -436,15 +430,19 @@ static struct mr_table *ipmr_new_table(struct net *net, u32 id)
 static void ipmr_free_table(struct mr_table *mrt, struct list_head *dev_kill_list)
 {
 	struct net *net = read_pnet(&mrt->net);
+	LIST_HEAD(ipmr_dev_kill_list);
 
 	WARN_ON_ONCE(!mr_can_free_table(net));
 
 	timer_shutdown_sync(&mrt->ipmr_expire_timer);
 	mroute_clean_tables(mrt, MRT_FLUSH_VIFS | MRT_FLUSH_VIFS_STATIC |
 			    MRT_FLUSH_MFC | MRT_FLUSH_MFC_STATIC,
-			    dev_kill_list);
+			    &ipmr_dev_kill_list);
 	rhltable_destroy(&mrt->mfc_hash);
 	kfree(mrt);
+
+	WARN_ON_ONCE(!net_initialized(net) && !list_empty(&ipmr_dev_kill_list));
+	list_splice(&ipmr_dev_kill_list, dev_kill_list);
 }
 
 /* Service routines creating virtual interfaces: DVMRP tunnels and PIMREG */
@@ -3274,10 +3272,7 @@ static int __net_init ipmr_net_init(struct net *net)
 proc_cache_fail:
 	remove_proc_entry("ip_mr_vif", net->proc_net);
 proc_vif_fail:
-	rtnl_lock();
 	ipmr_rules_exit_rtnl(net, &dev_kill_list);
-	unregister_netdevice_many(&dev_kill_list);
-	rtnl_unlock();
 #endif
 ipmr_rules_fail:
 	ipmr_notifier_exit(net);
-- 
2.53.0



