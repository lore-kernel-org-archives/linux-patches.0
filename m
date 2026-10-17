Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846A0397929;
	Sat, 17 Oct 2026 16:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253766; cv=none; b=FtZXcOpg5jFHO1sz/ETq1NjyVruuZHNpxdqrLc40vGD1gwzSlFBKHzsol2nHFeTmMCevkpArACGS/o+hZS3otxeRog1x2zkUnMbw4MI/YdAn1C24T6+IwVFS+JQoZm8xLtY10sCZCxJbk08LAwknNaw/+qh7il39/6pj9KZXadU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253766; c=relaxed/simple;
	bh=cfFbT1JDFuv2NJ5rzWQxkh2NYI8vDgppnN0s5ijrGDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mgYMZAyGlimM2HmtL3k4x0trwZywmHUOguqpQb7rIPY4rWSLXx7NowfNXbp+zjtxSKkO1kFX3xrCETL00ElLMaMWzz2MmPyh6pF+LQoaI41nbbC16yYy1y6BO2NOn3szVkvivt1hF+UKhGFfktmSIKV4PF4wJttEsSDCRq8VLYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MedUarAx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MedUarAx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 661FC1F000C5;
	Sat, 17 Oct 2026 16:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253764;
	bh=sNs+unUQKMv4o1aoM1Fp4nU+jfsc+t6szP/09K91Z18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MedUarAxb9LX1p4itOnSm4XvPcHmKD0Us78O6UXkhUg7Tqav0SAndn33h6ogjmOIL
	 VjxIu4BwKMi16Isn3hI+ug5M0qSeHjD33kd7QpZN6vyuay/Wk0Q/+F8dvNI4B80UI3
	 S5WGX2E/3gosS73VQrfcVaP3ySryzPUzvEs7zYJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Guillaume Nault <gnault@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 225/869] mpls: Protect net->mpls.platform_label with a per-netns mutex.
Date: Sat, 17 Oct 2026 17:51:06 +0200
Message-ID: <20261017160042.817943884@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit e833eb25161aae6cd0caf14782f405d0ed5765ed ]

MPLS (re)uses RTNL to protect net->mpls.platform_label,
but the lock does not need to be RTNL at all.

Let's protect net->mpls.platform_label with a dedicated
per-netns mutex.

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Guillaume Nault <gnault@redhat.com>
Link: https://patch.msgid.link/20251029173344.2934622-13-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 629ec78ef860 ("mpls: add seqcount to protect the platform_label{,s} pair")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netns/mpls.h |  1 +
 net/mpls/af_mpls.c       | 55 ++++++++++++++++++++++++++--------------
 net/mpls/internal.h      |  7 ++++-
 3 files changed, 43 insertions(+), 20 deletions(-)

diff --git a/include/net/netns/mpls.h b/include/net/netns/mpls.h
index 19ad2574b267c..6682e51513efa 100644
--- a/include/net/netns/mpls.h
+++ b/include/net/netns/mpls.h
@@ -16,6 +16,7 @@ struct netns_mpls {
 	int default_ttl;
 	size_t platform_labels;
 	struct mpls_route __rcu * __rcu *platform_label;
+	struct mutex platform_mutex;
 
 	struct ctl_table_header *ctl;
 };
diff --git a/net/mpls/af_mpls.c b/net/mpls/af_mpls.c
index c555005cfcf55..c621ab55f3b82 100644
--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -79,8 +79,8 @@ static struct mpls_route *mpls_route_input(struct net *net, unsigned int index)
 {
 	struct mpls_route __rcu **platform_label;
 
-	platform_label = rtnl_dereference(net->mpls.platform_label);
-	return rtnl_dereference(platform_label[index]);
+	platform_label = mpls_dereference(net, net->mpls.platform_label);
+	return mpls_dereference(net, platform_label[index]);
 }
 
 static struct mpls_route *mpls_route_input_rcu(struct net *net, unsigned int index)
@@ -579,10 +579,8 @@ static void mpls_route_update(struct net *net, unsigned index,
 	struct mpls_route __rcu **platform_label;
 	struct mpls_route *rt;
 
-	ASSERT_RTNL();
-
-	platform_label = rtnl_dereference(net->mpls.platform_label);
-	rt = rtnl_dereference(platform_label[index]);
+	platform_label = mpls_dereference(net, net->mpls.platform_label);
+	rt = mpls_dereference(net, platform_label[index]);
 	rcu_assign_pointer(platform_label[index], new);
 
 	mpls_notify_route(net, index, rt, new, info);
@@ -1462,8 +1460,6 @@ static struct mpls_dev *mpls_add_dev(struct net_device *dev)
 	int err = -ENOMEM;
 	int i;
 
-	ASSERT_RTNL();
-
 	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
 	if (!mdev)
 		return ERR_PTR(err);
@@ -1625,6 +1621,8 @@ static int mpls_dev_notify(struct notifier_block *this, unsigned long event,
 	unsigned int flags;
 	int err;
 
+	mutex_lock(&net->mpls.platform_mutex);
+
 	if (event == NETDEV_REGISTER) {
 		mdev = mpls_add_dev(dev);
 		if (IS_ERR(mdev)) {
@@ -1687,9 +1685,11 @@ static int mpls_dev_notify(struct notifier_block *this, unsigned long event,
 	}
 
 out:
+	mutex_unlock(&net->mpls.platform_mutex);
 	return NOTIFY_OK;
 
 err:
+	mutex_unlock(&net->mpls.platform_mutex);
 	return notifier_from_errno(err);
 }
 
@@ -1965,6 +1965,7 @@ static int rtm_to_route_config(struct sk_buff *skb,
 static int mpls_rtm_delroute(struct sk_buff *skb, struct nlmsghdr *nlh,
 			     struct netlink_ext_ack *extack)
 {
+	struct net *net = sock_net(skb->sk);
 	struct mpls_route_config *cfg;
 	int err;
 
@@ -1976,7 +1977,9 @@ static int mpls_rtm_delroute(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (err < 0)
 		goto out;
 
+	mutex_lock(&net->mpls.platform_mutex);
 	err = mpls_route_del(cfg, extack);
+	mutex_unlock(&net->mpls.platform_mutex);
 out:
 	kfree(cfg);
 
@@ -1987,6 +1990,7 @@ static int mpls_rtm_delroute(struct sk_buff *skb, struct nlmsghdr *nlh,
 static int mpls_rtm_newroute(struct sk_buff *skb, struct nlmsghdr *nlh,
 			     struct netlink_ext_ack *extack)
 {
+	struct net *net = sock_net(skb->sk);
 	struct mpls_route_config *cfg;
 	int err;
 
@@ -1998,7 +2002,9 @@ static int mpls_rtm_newroute(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (err < 0)
 		goto out;
 
+	mutex_lock(&net->mpls.platform_mutex);
 	err = mpls_route_add(cfg, extack);
+	mutex_unlock(&net->mpls.platform_mutex);
 out:
 	kfree(cfg);
 
@@ -2402,6 +2408,8 @@ static int mpls_getroute(struct sk_buff *in_skb, struct nlmsghdr *in_nlh,
 	u8 n_labels;
 	int err;
 
+	mutex_lock(&net->mpls.platform_mutex);
+
 	err = mpls_valid_getroute_req(in_skb, in_nlh, tb, extack);
 	if (err < 0)
 		goto errout;
@@ -2445,7 +2453,8 @@ static int mpls_getroute(struct sk_buff *in_skb, struct nlmsghdr *in_nlh,
 			goto errout_free;
 		}
 
-		return rtnl_unicast(skb, net, portid);
+		err = rtnl_unicast(skb, net, portid);
+		goto errout;
 	}
 
 	if (tb[RTA_NEWDST]) {
@@ -2538,12 +2547,14 @@ static int mpls_getroute(struct sk_buff *in_skb, struct nlmsghdr *in_nlh,
 
 	err = rtnl_unicast(skb, net, portid);
 errout:
+	mutex_unlock(&net->mpls.platform_mutex);
 	return err;
 
 nla_put_failure:
 	nlmsg_cancel(skb, nlh);
 	err = -EMSGSIZE;
 errout_free:
+	mutex_unlock(&net->mpls.platform_mutex);
 	kfree_skb(skb);
 	return err;
 }
@@ -2599,9 +2610,10 @@ static int resize_platform_label_table(struct net *net, size_t limit)
 		       lo->addr_len);
 	}
 
-	rtnl_lock();
+	mutex_lock(&net->mpls.platform_mutex);
+
 	/* Remember the original table */
-	old = rtnl_dereference(net->mpls.platform_label);
+	old = mpls_dereference(net, net->mpls.platform_label);
 	old_limit = net->mpls.platform_labels;
 
 	/* Free any labels beyond the new table */
@@ -2632,7 +2644,7 @@ static int resize_platform_label_table(struct net *net, size_t limit)
 	net->mpls.platform_labels = limit;
 	rcu_assign_pointer(net->mpls.platform_label, labels);
 
-	rtnl_unlock();
+	mutex_unlock(&net->mpls.platform_mutex);
 
 	mpls_rt_free(rt2);
 	mpls_rt_free(rt0);
@@ -2705,12 +2717,13 @@ static const struct ctl_table mpls_table[] = {
 	},
 };
 
-static int mpls_net_init(struct net *net)
+static __net_init int mpls_net_init(struct net *net)
 {
 	size_t table_size = ARRAY_SIZE(mpls_table);
 	struct ctl_table *table;
 	int i;
 
+	mutex_init(&net->mpls.platform_mutex);
 	net->mpls.platform_labels = 0;
 	net->mpls.platform_label = NULL;
 	net->mpls.ip_ttl_propagate = 1;
@@ -2736,7 +2749,7 @@ static int mpls_net_init(struct net *net)
 	return 0;
 }
 
-static void mpls_net_exit(struct net *net)
+static __net_exit void mpls_net_exit(struct net *net)
 {
 	struct mpls_route __rcu **platform_label;
 	size_t platform_labels;
@@ -2756,16 +2769,20 @@ static void mpls_net_exit(struct net *net)
 	 * As such no additional rcu synchronization is necessary when
 	 * freeing the platform_label table.
 	 */
-	rtnl_lock();
-	platform_label = rtnl_dereference(net->mpls.platform_label);
+	mutex_lock(&net->mpls.platform_mutex);
+
+	platform_label = mpls_dereference(net, net->mpls.platform_label);
 	platform_labels = net->mpls.platform_labels;
+
 	for (index = 0; index < platform_labels; index++) {
-		struct mpls_route *rt = rtnl_dereference(platform_label[index]);
-		RCU_INIT_POINTER(platform_label[index], NULL);
+		struct mpls_route *rt;
+
+		rt = mpls_dereference(net, platform_label[index]);
 		mpls_notify_route(net, index, rt, NULL, NULL);
 		mpls_rt_free(rt);
 	}
-	rtnl_unlock();
+
+	mutex_unlock(&net->mpls.platform_mutex);
 
 	kvfree(platform_label);
 }
diff --git a/net/mpls/internal.h b/net/mpls/internal.h
index 324988a77681c..8ddc8b7e6cbd4 100644
--- a/net/mpls/internal.h
+++ b/net/mpls/internal.h
@@ -185,6 +185,11 @@ static inline struct mpls_entry_decoded mpls_entry_decode(struct mpls_shim_hdr *
 	return result;
 }
 
+#define mpls_dereference(net, p)					\
+	rcu_dereference_protected(					\
+		(p),							\
+		lockdep_is_held(&(net)->mpls.platform_mutex))
+
 static inline struct mpls_dev *mpls_dev_rcu(const struct net_device *dev)
 {
 	return rcu_dereference(dev->mpls_ptr);
@@ -193,7 +198,7 @@ static inline struct mpls_dev *mpls_dev_rcu(const struct net_device *dev)
 static inline struct mpls_dev *mpls_dev_get(const struct net *net,
 					    const struct net_device *dev)
 {
-	return rcu_dereference_rtnl(dev->mpls_ptr);
+	return mpls_dereference(net, dev->mpls_ptr);
 }
 
 int nla_put_labels(struct sk_buff *skb, int attrtype,  u8 labels,
-- 
2.53.0



