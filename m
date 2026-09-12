Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B55A242D65;
	Sat, 12 Sep 2026 11:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212037; cv=none; b=d4ZooEynIxm4RzUkNWOWWfGbMagUaGJFYR41bZxl5CBzrL6fzPzZUHnu07p4xd6LcJykP8QXR7ZiQ+vTYB42Hi/7VKcJO2Ys0beIZJ4dzPe1DvTVHA3GYKRjFpCz321MglN+oB2lXv0cC/XvOyvpOTHfx9Dlv+mllj41TrT9mlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212037; c=relaxed/simple;
	bh=uh8xD4tW5ktyf4Yq6lZ5zqAyKHqE6NLIiZCc+YGqeuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p5aTXngsjhPhbt85MvkNo3XmJ4ImvHzAA2DSLNm0B2aQPg+rhfIHuD/R6Ab9GqxoDdrU0qWSvFKuwhujoE6ovorUqF1eaFY5hnIx3JUJL+e38K0SZqybqJoWMNovUI512wCSwIgIXY6Ga0bVMi+QwfK3Zc5UWToT+2kgw9S3ASM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R+8Qp+D/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R+8Qp+D/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C78E31F000FF;
	Sat, 12 Sep 2026 11:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212036;
	bh=l8x3CqzgjkdNz9WX7AGsGcrDZTvsFBnR6vGkkjGsitQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R+8Qp+D/rPAFKHDrHRCaJy+gVMjjGVrge6qsdA8HkFwNAFns3TJnSzvvBCxkjKqcX
	 qMSzRpv7T93XRM4HZhhyQLP2Mg1Ej3h0ya2yU/5JNq6RkXOnl8X+luSmH1eC0xQAee
	 FCeuhIsF/IMFyoq+SRzeD+M6wggGfzf02tUHmecA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1354/1518] ipmr: Move unregister_netdevice_many() out of mroute_clean_tables().
Date: Sat, 12 Sep 2026 08:58:43 +0200
Message-ID: <20260912065654.158903458@linuxfoundation.org>
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

[ Upstream commit 3810f9529dc7f784b5b958b2a018bb6996cf9077 ]

This is a prep commit to convert ipmr_net_exit_batch() to
->exit_rtnl().

Let's move unregister_netdevice_many() in mroute_clean_tables()
to its callers.

As a bonus, mrtsock_destruct() can do batching for all tables.

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260228221800.1082070-8-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 235b42b58601 ("ip6mr: do not clone dst in ip6mr_cache_report()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ipmr.c | 34 ++++++++++++++++++++++++----------
 1 file changed, 24 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 92867b439909d..ec98a47c75f7b 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -112,7 +112,8 @@ static int ipmr_cache_report(const struct mr_table *mrt,
 static void mroute_netlink_event(struct mr_table *mrt, struct mfc_cache *mfc,
 				 int cmd);
 static void igmpmsg_netlink_event(const struct mr_table *mrt, struct sk_buff *pkt);
-static void mroute_clean_tables(struct mr_table *mrt, int flags);
+static void mroute_clean_tables(struct mr_table *mrt, int flags,
+				struct list_head *dev_kill_list);
 static void ipmr_expire_process(struct timer_list *t);
 
 #ifdef CONFIG_IP_MROUTE_MULTIPLE_TABLES
@@ -427,12 +428,15 @@ static struct mr_table *ipmr_new_table(struct net *net, u32 id)
 static void ipmr_free_table(struct mr_table *mrt)
 {
 	struct net *net = read_pnet(&mrt->net);
+	LIST_HEAD(dev_kill_list);
 
 	WARN_ON_ONCE(!mr_can_free_table(net));
 
 	timer_shutdown_sync(&mrt->ipmr_expire_timer);
 	mroute_clean_tables(mrt, MRT_FLUSH_VIFS | MRT_FLUSH_VIFS_STATIC |
-				 MRT_FLUSH_MFC | MRT_FLUSH_MFC_STATIC);
+			    MRT_FLUSH_MFC | MRT_FLUSH_MFC_STATIC,
+			    &dev_kill_list);
+	unregister_netdevice_many(&dev_kill_list);
 	rhltable_destroy(&mrt->mfc_hash);
 	kfree(mrt);
 }
@@ -1293,12 +1297,12 @@ static int ipmr_mfc_add(struct net *net, struct mr_table *mrt,
 }
 
 /* Close the multicast socket, and clear the vif tables etc */
-static void mroute_clean_tables(struct mr_table *mrt, int flags)
+static void mroute_clean_tables(struct mr_table *mrt, int flags,
+				struct list_head *dev_kill_list)
 {
 	struct net *net = read_pnet(&mrt->net);
-	struct mr_mfc *c, *tmp;
 	struct mfc_cache *cache;
-	LIST_HEAD(list);
+	struct mr_mfc *c, *tmp;
 	int i;
 
 	/* Shut down all active vif entries */
@@ -1308,9 +1312,8 @@ static void mroute_clean_tables(struct mr_table *mrt, int flags)
 			     !(flags & MRT_FLUSH_VIFS_STATIC)) ||
 			    (!(mrt->vif_table[i].flags & VIFF_STATIC) && !(flags & MRT_FLUSH_VIFS)))
 				continue;
-			vif_delete(mrt, i, 0, &list);
+			vif_delete(mrt, i, 0, dev_kill_list);
 		}
-		unregister_netdevice_many(&list);
 	}
 
 	/* Wipe the cache */
@@ -1349,9 +1352,11 @@ static void mroute_clean_tables(struct mr_table *mrt, int flags)
 static void mrtsock_destruct(struct sock *sk)
 {
 	struct net *net = sock_net(sk);
+	LIST_HEAD(dev_kill_list);
 	struct mr_table *mrt;
 
 	rtnl_lock();
+
 	ipmr_for_each_table(mrt, net) {
 		if (sk == rtnl_dereference(mrt->mroute_sk)) {
 			IPV4_DEVCONF_ALL(net, MC_FORWARDING)--;
@@ -1360,9 +1365,13 @@ static void mrtsock_destruct(struct sock *sk)
 						    NETCONFA_IFINDEX_ALL,
 						    net->ipv4.devconf_all);
 			RCU_INIT_POINTER(mrt->mroute_sk, NULL);
-			mroute_clean_tables(mrt, MRT_FLUSH_VIFS | MRT_FLUSH_MFC);
+			mroute_clean_tables(mrt, MRT_FLUSH_VIFS | MRT_FLUSH_MFC,
+					    &dev_kill_list);
 		}
 	}
+
+	unregister_netdevice_many(&dev_kill_list);
+
 	rtnl_unlock();
 }
 
@@ -1485,7 +1494,9 @@ int ip_mroute_setsockopt(struct sock *sk, int optname, sockptr_t optval,
 					   sk == rtnl_dereference(mrt->mroute_sk),
 					   parent);
 		break;
-	case MRT_FLUSH:
+	case MRT_FLUSH: {
+		LIST_HEAD(dev_kill_list);
+
 		if (optlen != sizeof(val)) {
 			ret = -EINVAL;
 			break;
@@ -1494,8 +1505,11 @@ int ip_mroute_setsockopt(struct sock *sk, int optname, sockptr_t optval,
 			ret = -EFAULT;
 			break;
 		}
-		mroute_clean_tables(mrt, val);
+
+		mroute_clean_tables(mrt, val, &dev_kill_list);
+		unregister_netdevice_many(&dev_kill_list);
 		break;
+	}
 	/* Control PIM assert. */
 	case MRT_ASSERT:
 		if (optlen != sizeof(val)) {
-- 
2.53.0



