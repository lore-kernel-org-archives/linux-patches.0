Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFBA439934B;
	Sat, 17 Oct 2026 16:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253756; cv=none; b=eTaobDEcewo3CqB0D5o4Jmx4Krd/ZEr2EURFiov49uvRAGaRRe0gc7ihMz5ZcAkvvIsi6fhrMfEJ17881/RJ1UPT9cL//Q2LvgSH6b6rInkS4qeMA+I8XITIuS4sv+86e9Y0LwFPm0Q03r1Ujp5svqav3EQ7EcvOgV1pIF5GY1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253756; c=relaxed/simple;
	bh=ASbQ0yifH+LKhgmuxLE/faE/ZcS4FjJUUv6lolWwecc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JwY5e+8x/3qsZgKHRO9Q/3gVXrTZpsLOCDjY34MB/kfjQlCk3N3tLxrNy5NCE5An2m6WyA/Qo0pFNhka29ho6nQoJiNUwRmLXFKjd9OjAN+8mzd136x/99K53kmObHO+qRL2qWK/3IscjKl4h0cIpTPJxi+DGmsjvVk+Bth+riI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YXGW/X9l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YXGW/X9l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50E041F000C4;
	Sat, 17 Oct 2026 16:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253754;
	bh=h/4qHVOCGPA2YCDqBjvEdpEk7m2AKPLojn1TXo2/5kw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YXGW/X9lJndYTwmrHKIjxiA6dczJ5IIju3G08EEqDcxtRbFYsRIiJO1AdAoBqSWJW
	 H/Pvntf4W6s9hI+VI1Givrroiwo0cnkivTfIFUqdEVMd9W5tejlTiStiRr2y/B5QMP
	 wbI/opaCpw8D3kxoKhyZblAo7ngdYld8bM41G5zk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Guillaume Nault <gnault@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 222/869] mpls: Pass net to mpls_dev_get().
Date: Sat, 17 Oct 2026 17:51:03 +0200
Message-ID: <20261017160042.741801342@linuxfoundation.org>
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

[ Upstream commit 1fb462de9329731c17267c7ccf19619f22790a0a ]

We will replace RTNL with a per-netns mutex to protect dev->mpls_ptr.

Then, we will use rcu_dereference_protected() with the lockdep_is_held()
annotation, which requires net to access the per-netns mutex.

However, dev_net(dev) is not safe without RTNL.

Let's pass net to mpls_dev_get().

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Guillaume Nault <gnault@redhat.com>
Link: https://patch.msgid.link/20251029173344.2934622-8-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 629ec78ef860 ("mpls: add seqcount to protect the platform_label{,s} pair")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mpls/af_mpls.c  | 11 ++++++-----
 net/mpls/internal.h |  3 ++-
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/mpls/af_mpls.c b/net/mpls/af_mpls.c
index 7e1b0d08c0c20..7181af81e4290 100644
--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -709,7 +709,7 @@ static int mpls_nh_assign_dev(struct net *net, struct mpls_route *rt,
 
 	/* Ensure this is a supported device */
 	err = -EINVAL;
-	if (!mpls_dev_get(dev))
+	if (!mpls_dev_get(net, dev))
 		goto errout_put;
 
 	if ((nh->nh_via_table == NEIGH_LINK_TABLE) &&
@@ -1290,7 +1290,7 @@ static int mpls_netconf_get_devconf(struct sk_buff *in_skb,
 	if (!dev)
 		goto errout;
 
-	mdev = mpls_dev_get(dev);
+	mdev = mpls_dev_get(net, dev);
 	if (!mdev)
 		goto errout;
 
@@ -1613,6 +1613,7 @@ static int mpls_dev_notify(struct notifier_block *this, unsigned long event,
 			   void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+	struct net *net = dev_net(dev);
 	struct mpls_dev *mdev;
 	unsigned int flags;
 	int err;
@@ -1627,7 +1628,7 @@ static int mpls_dev_notify(struct notifier_block *this, unsigned long event,
 		goto out;
 	}
 
-	mdev = mpls_dev_get(dev);
+	mdev = mpls_dev_get(net, dev);
 	if (!mdev)
 		goto out;
 
@@ -1660,7 +1661,7 @@ static int mpls_dev_notify(struct notifier_block *this, unsigned long event,
 		if (err)
 			goto err;
 
-		mdev = mpls_dev_get(dev);
+		mdev = mpls_dev_get(net, dev);
 		if (mdev) {
 			mpls_dev_sysctl_unregister(dev, mdev);
 			RCU_INIT_POINTER(dev->mpls_ptr, NULL);
@@ -1668,7 +1669,7 @@ static int mpls_dev_notify(struct notifier_block *this, unsigned long event,
 		}
 		break;
 	case NETDEV_CHANGENAME:
-		mdev = mpls_dev_get(dev);
+		mdev = mpls_dev_get(net, dev);
 		if (mdev) {
 			mpls_dev_sysctl_unregister(dev, mdev);
 			err = mpls_dev_sysctl_register(dev, mdev);
diff --git a/net/mpls/internal.h b/net/mpls/internal.h
index 9adbbdeb8f848..324988a77681c 100644
--- a/net/mpls/internal.h
+++ b/net/mpls/internal.h
@@ -190,7 +190,8 @@ static inline struct mpls_dev *mpls_dev_rcu(const struct net_device *dev)
 	return rcu_dereference(dev->mpls_ptr);
 }
 
-static inline struct mpls_dev *mpls_dev_get(const struct net_device *dev)
+static inline struct mpls_dev *mpls_dev_get(const struct net *net,
+					    const struct net_device *dev)
 {
 	return rcu_dereference_rtnl(dev->mpls_ptr);
 }
-- 
2.53.0



