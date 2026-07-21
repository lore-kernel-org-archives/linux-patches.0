Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D8743F4BA;
	Tue, 21 Jul 2026 22:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672228; cv=none; b=bucgvF2tEP8HblkOnkq0gExbUcjtlIrGjFIiuf2iQpYnNvVuMx+coNkzHEQ3j9G2sC1yA2RvdITS1q3XNLv7JToOmQTMe6mdhPoNcY4uUHU0Xv4JjOTDBeAfWUMzGZzfHKX7x60nue6XE7UDhXyTQu03GwYb/3ezHxVeqc0enjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672228; c=relaxed/simple;
	bh=zQvoFvgHz407i4BoTEGOYOqebs9Db474u+NSRiCQDjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bg7e0ogjE1PqHVBnxmHWFPG1+aOofzx3+y4wurroohWfDX7MnMfdKtGcs8dNu+02agYxnGmxKZKh6MnY1ng8zH/ecHhxd4h8rkyyOk41YWxLALdwnvpgs2UO+kwqWBDnyhSD0bOAUjg/DiuAahe5lwYrJvgRPGL+AUzsl2LcB44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mSLyrlMa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mSLyrlMa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A74FF1F000E9;
	Tue, 21 Jul 2026 22:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672227;
	bh=miO4WVkrnRMdyBpkfV0c9OWeleEumu9V0ud2gyc3JCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mSLyrlManTvAZ7zShvq5cU1pqKdH8FXBXrS+dvhVfmoBXzOztccO0AnH+8fHRjt+z
	 9fDnS2AYFWoMP591/uRRzMJb6XIcquZjbYO8DdVdcZUYamX8FwfsjOPUmzGO3Pv0ti
	 u6067QjZrVu7zX2vAagEHjJBu9OGvoyk9LhUXtTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 492/843] rtnetlink: change nlk->cb_mutex role
Date: Tue, 21 Jul 2026 17:22:07 +0200
Message-ID: <20260721152417.098485322@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: 9facb861dc6b ("ipv6: fib6: fix NULL deref in fib6_walk_continue() on multi-batch dump")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlink/af_netlink.c | 32 ++++++++++++++++++--------------
 net/netlink/af_netlink.h |  5 +++--
 2 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 731c53178eb559..2b9dbf003abd11 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -618,7 +618,7 @@ static struct proto netlink_proto = {
 };
 
 static int __netlink_create(struct net *net, struct socket *sock,
-			    struct mutex *cb_mutex, int protocol,
+			    struct mutex *dump_cb_mutex, int protocol,
 			    int kern)
 {
 	struct sock *sk;
@@ -633,15 +633,11 @@ static int __netlink_create(struct net *net, struct socket *sock,
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
@@ -2228,7 +2224,7 @@ static int netlink_dump(struct sock *sk, bool lock_taken)
 	int alloc_size;
 
 	if (!lock_taken)
-		mutex_lock(nlk->cb_mutex);
+		mutex_lock(&nlk->nl_cb_mutex);
 	if (!nlk->cb_running) {
 		err = -EINVAL;
 		goto errout_skb;
@@ -2284,14 +2280,22 @@ static int netlink_dump(struct sock *sk, bool lock_taken)
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
@@ -2325,13 +2329,13 @@ static int netlink_dump(struct sock *sk, bool lock_taken)
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
@@ -2354,7 +2358,7 @@ int __netlink_dump_start(struct sock *ssk, struct sk_buff *skb,
 	}
 
 	nlk = nlk_sk(sk);
-	mutex_lock(nlk->cb_mutex);
+	mutex_lock(&nlk->nl_cb_mutex);
 	/* A dump is in progress... */
 	if (nlk->cb_running) {
 		ret = -EBUSY;
@@ -2404,7 +2408,7 @@ int __netlink_dump_start(struct sock *ssk, struct sk_buff *skb,
 	module_put(control->module);
 error_unlock:
 	sock_put(sk);
-	mutex_unlock(nlk->cb_mutex);
+	mutex_unlock(&nlk->nl_cb_mutex);
 error_free:
 	kfree_skb(skb);
 	return ret;
diff --git a/net/netlink/af_netlink.h b/net/netlink/af_netlink.h
index fca9556848885e..9e65f47bc30788 100644
--- a/net/netlink/af_netlink.h
+++ b/net/netlink/af_netlink.h
@@ -36,8 +36,9 @@ struct netlink_sock {
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
2.53.0



