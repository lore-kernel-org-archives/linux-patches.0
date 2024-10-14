Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A15821ABEA1;
	Mon, 14 Oct 2024 14:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917114; cv=none; b=WKwzuVWPOXxn6MfIFoVqND+mcDpur6z/xLx1mLT+Awlw32YlqD9wtKjd7lwRb/6evtpBNXCg5bj5cqTggBavDBsFr20BEvFYTsHGireFHJs7e6CUYVkHwXr9BizDiZEcihpGBaafg2V1lgGJIYOP2EJ9p58WtlkSlw+flt53EgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917114; c=relaxed/simple;
	bh=BT+DCkexdLHm7GdH2I9olnBOleUjhCMqVI4VXrtGq2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ebVGX2T4Zrr7kXjYrlt+iyogTikVnfnoU5hfyiOMwe32zzhO8x6IsxzJgtPzIBXa1+xyuOe9GO5A7aMCj/U3Xj6O/857wseKcI4rRLQ4GvwS4m6JAl/Om0ybAArHgl5v6qoPAO2rvvqPnAQ3Gt+02V60K/PT4I/dzj9ctzgPJW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JATGUXOo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JATGUXOo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E837AC4CEC3;
	Mon, 14 Oct 2024 14:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917114;
	bh=BT+DCkexdLHm7GdH2I9olnBOleUjhCMqVI4VXrtGq2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JATGUXOoU08d0KaiQ/DuOqgGQt0xxCJUo9W0daGCBE1i28HHpMblaZtPVStc2ntgp
	 9WmaWL7ESHKWdvGLc//oaMSM0GbMkGveEBPJFjMVTZBMDC4jhrzcvInEJHoS41g/uw
	 Ax2TAfJASUHZxhJ4/NHMZUsy8zj2/swimpO4gpUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 156/213] rtnetlink: change nlk->cb_mutex role
Date: Mon, 14 Oct 2024 16:21:02 +0200
Message-ID: <20241014141049.058899024@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit e39951d965bf58b5aba7f61dc1140dcb8271af22 ]

In commit af65bdfce98d ("[NETLINK]: Switch cb_lock spinlock
to mutex and allow to override it"), Patrick McHardy used
a common mutex to protect both nlk->cb and the dump() operations.

The override is used for rtnl dumps, registered with
rntl_register() and rntl_register_module().

We want to be able to opt-out some dump() operations
to not acquire RTNL, so we need to protect nlk->cb
with a per socket mutex.

This patch renames nlk->cb_def_mutex to nlk->nl_cb_mutex

The optional pointer to the mutex used to protect dump()
call is stored in nlk->dump_cb_mutex

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 5be2062e3080 ("mpls: Handle error of rtnl_register_module().")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlink/af_netlink.c | 32 ++++++++++++++++++--------------
 net/netlink/af_netlink.h |  5 +++--
 2 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index db49fc4d42cf7..e40376997f393 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -636,7 +636,7 @@ static struct proto netlink_proto = {
 };
 
 static int __netlink_create(struct net *net, struct socket *sock,
-			    struct mutex *cb_mutex, int protocol,
+			    struct mutex *dump_cb_mutex, int protocol,
 			    int kern)
 {
 	struct sock *sk;
@@ -651,15 +651,11 @@ static int __netlink_create(struct net *net, struct socket *sock,
 	sock_init_data(sock, sk);
 
 	nlk = nlk_sk(sk);
-	if (cb_mutex) {
-		nlk->cb_mutex = cb_mutex;
-	} else {
-		nlk->cb_mutex = &nlk->cb_def_mutex;
-		mutex_init(nlk->cb_mutex);
-		lockdep_set_class_and_name(nlk->cb_mutex,
+	mutex_init(&nlk->nl_cb_mutex);
+	lockdep_set_class_and_name(&nlk->nl_cb_mutex,
 					   nlk_cb_mutex_keys + protocol,
 					   nlk_cb_mutex_key_strings[protocol]);
-	}
+	nlk->dump_cb_mutex = dump_cb_mutex;
 	init_waitqueue_head(&nlk->wait);
 
 	sk->sk_destruct = netlink_sock_destruct;
@@ -2211,7 +2207,7 @@ static int netlink_dump(struct sock *sk, bool lock_taken)
 	int alloc_size;
 
 	if (!lock_taken)
-		mutex_lock(nlk->cb_mutex);
+		mutex_lock(&nlk->nl_cb_mutex);
 	if (!nlk->cb_running) {
 		err = -EINVAL;
 		goto errout_skb;
@@ -2263,14 +2259,22 @@ static int netlink_dump(struct sock *sk, bool lock_taken)
 	netlink_skb_set_owner_r(skb, sk);
 
 	if (nlk->dump_done_errno > 0) {
+		struct mutex *extra_mutex = nlk->dump_cb_mutex;
+
 		cb->extack = &extack;
+
+		if (extra_mutex)
+			mutex_lock(extra_mutex);
 		nlk->dump_done_errno = cb->dump(skb, cb);
+		if (extra_mutex)
+			mutex_unlock(extra_mutex);
+
 		cb->extack = NULL;
 	}
 
 	if (nlk->dump_done_errno > 0 ||
 	    skb_tailroom(skb) < nlmsg_total_size(sizeof(nlk->dump_done_errno))) {
-		mutex_unlock(nlk->cb_mutex);
+		mutex_unlock(&nlk->nl_cb_mutex);
 
 		if (sk_filter(sk, skb))
 			kfree_skb(skb);
@@ -2304,13 +2308,13 @@ static int netlink_dump(struct sock *sk, bool lock_taken)
 	WRITE_ONCE(nlk->cb_running, false);
 	module = cb->module;
 	skb = cb->skb;
-	mutex_unlock(nlk->cb_mutex);
+	mutex_unlock(&nlk->nl_cb_mutex);
 	module_put(module);
 	consume_skb(skb);
 	return 0;
 
 errout_skb:
-	mutex_unlock(nlk->cb_mutex);
+	mutex_unlock(&nlk->nl_cb_mutex);
 	kfree_skb(skb);
 	return err;
 }
@@ -2333,7 +2337,7 @@ int __netlink_dump_start(struct sock *ssk, struct sk_buff *skb,
 	}
 
 	nlk = nlk_sk(sk);
-	mutex_lock(nlk->cb_mutex);
+	mutex_lock(&nlk->nl_cb_mutex);
 	/* A dump is in progress... */
 	if (nlk->cb_running) {
 		ret = -EBUSY;
@@ -2384,7 +2388,7 @@ int __netlink_dump_start(struct sock *ssk, struct sk_buff *skb,
 	module_put(control->module);
 error_unlock:
 	sock_put(sk);
-	mutex_unlock(nlk->cb_mutex);
+	mutex_unlock(&nlk->nl_cb_mutex);
 error_free:
 	kfree_skb(skb);
 	return ret;
diff --git a/net/netlink/af_netlink.h b/net/netlink/af_netlink.h
index 2145979b9986a..9751e29d4bbb9 100644
--- a/net/netlink/af_netlink.h
+++ b/net/netlink/af_netlink.h
@@ -39,8 +39,9 @@ struct netlink_sock {
 	bool			cb_running;
 	int			dump_done_errno;
 	struct netlink_callback	cb;
-	struct mutex		*cb_mutex;
-	struct mutex		cb_def_mutex;
+	struct mutex		nl_cb_mutex;
+
+	struct mutex		*dump_cb_mutex;
 	void			(*netlink_rcv)(struct sk_buff *skb);
 	int			(*netlink_bind)(struct net *net, int group);
 	void			(*netlink_unbind)(struct net *net, int group);
-- 
2.43.0



