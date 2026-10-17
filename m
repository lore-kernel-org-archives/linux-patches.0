Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F1A535C1BC;
	Sat, 17 Oct 2026 16:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253753; cv=none; b=jQukYxw8qSkn3pXuQg28fLgbgD0glBicMRHcp6P1w9bH4eqBovn4U5eITS/cVNnpexBrxF7s2utx98NjM4EhKW+SJkuXVDjMooQcd2XeINWhJhjkXVbsTeNqwQd2ZKYPiVYToJ+v4R9j4mYl7fwikrKAGwYQIqnYJY0sVa5Ocxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253753; c=relaxed/simple;
	bh=uKV229rCYgR0Z4QWFyR9bYpqwtEHJvM5rd8R32LQcsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jTSWXFeDVaztlRCqn6PcnNNtOIg/sTovRMT3TJEpnGqzysBhAlgvUPjI+iGgNKlC+Uc+YvnwrEHYHKJSTINRw69qKIzPzv0spJqj2nwRvB/38kOfaNxZYPQWMakDsiHZRoRe08DLSBy0VUJL9XkSc43Gb3+8FkwZDJWTbaulS80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dbJ0ckbP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dbJ0ckbP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 661AE1F000C4;
	Sat, 17 Oct 2026 16:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253752;
	bh=1dxZgzsm0TxBSFIFBFuaTUcBIS87U8kPRUrcCebQ/UA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dbJ0ckbPGyjVQntWd6ZYg4S/0fZVyYRH6jzAAIDMiNdvCfQ5L0l/fMmcXTD0zxG5m
	 m1vgCoqoxm+UCeWlOezbSujHmX+74oCbhDVEM4DdKSL5F2gND7EnXQIxvJG4GFz5BQ
	 TgnsAb6i6NFedCQTcAjpT0/TSKp42z+p5KvwUjJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Guillaume Nault <gnault@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 221/869] mpls: Add mpls_dev_rcu().
Date: Sat, 17 Oct 2026 17:51:02 +0200
Message-ID: <20261017160042.717034593@linuxfoundation.org>
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

[ Upstream commit ab061f3347923b6e3aa7731056dc58cbe5044c9f ]

mpls_dev_get() uses rcu_dereference_rtnl() to fetch dev->mpls_ptr.

We will replace RTNL with a dedicated mutex to protect the field.

Then, we will use rcu_dereference_protected() for clarity.

Let's add mpls_dev_rcu() for the RCU reader.

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Guillaume Nault <gnault@redhat.com>
Link: https://patch.msgid.link/20251029173344.2934622-7-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 629ec78ef860 ("mpls: add seqcount to protect the platform_label{,s} pair")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mpls/af_mpls.c       | 12 ++++++------
 net/mpls/internal.h      |  5 +++++
 net/mpls/mpls_iptunnel.c |  2 +-
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/net/mpls/af_mpls.c b/net/mpls/af_mpls.c
index 65fc18eaf4171..7e1b0d08c0c20 100644
--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -135,7 +135,7 @@ void mpls_stats_inc_outucastpkts(struct net_device *dev,
 	struct mpls_dev *mdev;
 
 	if (skb->protocol == htons(ETH_P_MPLS_UC)) {
-		mdev = mpls_dev_get(dev);
+		mdev = mpls_dev_rcu(dev);
 		if (mdev)
 			MPLS_INC_STATS_LEN(mdev, skb->len,
 					   tx_packets,
@@ -359,7 +359,7 @@ static int mpls_forward(struct sk_buff *skb, struct net_device *dev,
 
 	/* Careful this entire function runs inside of an rcu critical section */
 
-	mdev = mpls_dev_get(dev);
+	mdev = mpls_dev_rcu(dev);
 	if (!mdev)
 		goto drop;
 
@@ -468,7 +468,7 @@ static int mpls_forward(struct sk_buff *skb, struct net_device *dev,
 	return 0;
 
 tx_err:
-	out_mdev = out_dev ? mpls_dev_get(out_dev) : NULL;
+	out_mdev = out_dev ? mpls_dev_rcu(out_dev) : NULL;
 	if (out_mdev)
 		MPLS_INC_STATS(out_mdev, tx_errors);
 	goto drop;
@@ -1120,7 +1120,7 @@ static int mpls_fill_stats_af(struct sk_buff *skb,
 	struct mpls_dev *mdev;
 	struct nlattr *nla;
 
-	mdev = mpls_dev_get(dev);
+	mdev = mpls_dev_rcu(dev);
 	if (!mdev)
 		return -ENODATA;
 
@@ -1140,7 +1140,7 @@ static size_t mpls_get_stats_af_size(const struct net_device *dev)
 {
 	struct mpls_dev *mdev;
 
-	mdev = mpls_dev_get(dev);
+	mdev = mpls_dev_rcu(dev);
 	if (!mdev)
 		return 0;
 
@@ -1343,7 +1343,7 @@ static int mpls_netconf_dump_devconf(struct sk_buff *skb,
 
 	rcu_read_lock();
 	for_each_netdev_dump(net, dev, ctx->ifindex) {
-		mdev = mpls_dev_get(dev);
+		mdev = mpls_dev_rcu(dev);
 		if (!mdev)
 			continue;
 		err = mpls_netconf_fill_devconf(skb, mdev,
diff --git a/net/mpls/internal.h b/net/mpls/internal.h
index 76a133cb8efe7..9adbbdeb8f848 100644
--- a/net/mpls/internal.h
+++ b/net/mpls/internal.h
@@ -185,6 +185,11 @@ static inline struct mpls_entry_decoded mpls_entry_decode(struct mpls_shim_hdr *
 	return result;
 }
 
+static inline struct mpls_dev *mpls_dev_rcu(const struct net_device *dev)
+{
+	return rcu_dereference(dev->mpls_ptr);
+}
+
 static inline struct mpls_dev *mpls_dev_get(const struct net_device *dev)
 {
 	return rcu_dereference_rtnl(dev->mpls_ptr);
diff --git a/net/mpls/mpls_iptunnel.c b/net/mpls/mpls_iptunnel.c
index 6e73da94af7fb..33872b4b90070 100644
--- a/net/mpls/mpls_iptunnel.c
+++ b/net/mpls/mpls_iptunnel.c
@@ -153,7 +153,7 @@ static int mpls_xmit(struct sk_buff *skb)
 	return LWTUNNEL_XMIT_DONE;
 
 drop:
-	out_mdev = out_dev ? mpls_dev_get(out_dev) : NULL;
+	out_mdev = out_dev ? mpls_dev_rcu(out_dev) : NULL;
 	if (out_mdev)
 		MPLS_INC_STATS(out_mdev, tx_errors);
 	kfree_skb(skb);
-- 
2.53.0



