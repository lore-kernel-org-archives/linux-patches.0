Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3BC2DF126;
	Sat, 17 Oct 2026 18:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260723; cv=none; b=cseRNUtFi1iCOeDb96sCz1aHJx4oeSIx4JoXZGdEv9/AvQt9T9SzeAkDw1ChqyDnwklXMJhMtz57AHukoo0DvcXGaPorViP/pTQujOKZKbjKdsEH20a9oJVZvei6Z2oKmlqeW+7dQBmiSXdIqSkzrMH4V262QRJaLw7oMvPRxr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260723; c=relaxed/simple;
	bh=8RFuG8uY0lCVo9ZLa8R00G7HBbOR8C+GGJDkOVyt5iA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NfEk6Oh6fOz8sKYnEze6tJSsHCoCGyxQRJ0y+UHdTOfElDWiVioM7z/Dn2gdBzQNjsdeZuFXn9IUFcQH9Ztv9bkXm+l48Kx6pOHCpdddOAnWncUKR7cM66r+O2/fbVfNwBMSdvhZ0oRUf1JO1ppZ56EbPJjDOkdnWKwtOZ+2dgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DY1JiPG8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DY1JiPG8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E02F1F000C4;
	Sat, 17 Oct 2026 18:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260722;
	bh=KVncqfrXgIu8B5NEfyizAtYIFswBC9evgdvy/Hnh+nY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DY1JiPG8ejhXC1hcDNJUJh5Bzk1FdAmiU5vgb1NAGR2T0Rl4Q95vDuJzivb/E+q0v
	 mYSRz0OuS1B0c9SFqVrgJEhyjHQE+zSLGnEQgIq0dSrkYbxQdDp0NYTUjonijtyaav
	 N8dNjqTDW5zlDqDXeI7gHvYvBtEd7f2B+6qu4CkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1640/1674] net: plumb extack in __dev_change_net_namespace()
Date: Sat, 17 Oct 2026 18:05:12 +0200
Message-ID: <20261017160513.172954300@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

[ Upstream commit 12b6f7069ba5aa160f3332916408b34ae8e0b0f6 ]

It could be hard to understand why the netlink command fails. For example,
if dev->netns_immutable is set, the error is "Invalid argument".

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: debac3a20dec ("net: Remove conflicting altnames for dying netns in __dev_change_net_namespace().")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdevice.h |  5 +++--
 net/core/dev.c            | 43 +++++++++++++++++++++++++++++++--------
 net/core/rtnetlink.c      |  2 +-
 3 files changed, 38 insertions(+), 12 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index f733b7de0fe0c..61f1a64b72293 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4031,12 +4031,13 @@ int dev_change_flags(struct net_device *dev, unsigned int flags,
 int dev_set_alias(struct net_device *, const char *, size_t);
 int dev_get_alias(const struct net_device *, char *, size_t);
 int __dev_change_net_namespace(struct net_device *dev, struct net *net,
-			       const char *pat, int new_ifindex);
+			       const char *pat, int new_ifindex,
+			       struct netlink_ext_ack *extack);
 static inline
 int dev_change_net_namespace(struct net_device *dev, struct net *net,
 			     const char *pat)
 {
-	return __dev_change_net_namespace(dev, net, pat, 0);
+	return __dev_change_net_namespace(dev, net, pat, 0, NULL);
 }
 int __dev_set_mtu(struct net_device *, int);
 int dev_set_mtu(struct net_device *, int);
diff --git a/net/core/dev.c b/net/core/dev.c
index bad8765c7f13b..cc0335ce38c37 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -11309,6 +11309,7 @@ EXPORT_SYMBOL(unregister_netdev);
  *	      is already taken in the destination network namespace.
  *	@new_ifindex: If not zero, specifies device index in the target
  *	              namespace.
+ *	@extack: netlink extended ack
  *
  *	This function shuts down a device interface and moves it
  *	to a new network namespace. On success 0 is returned, on
@@ -11318,7 +11319,8 @@ EXPORT_SYMBOL(unregister_netdev);
  */
 
 int __dev_change_net_namespace(struct net_device *dev, struct net *net,
-			       const char *pat, int new_ifindex)
+			       const char *pat, int new_ifindex,
+			       struct netlink_ext_ack *extack)
 {
 	struct netdev_name_node *name_node;
 	struct net *net_old = dev_net(dev);
@@ -11329,12 +11331,16 @@ int __dev_change_net_namespace(struct net_device *dev, struct net *net,
 
 	/* Don't allow namespace local devices to be moved. */
 	err = -EINVAL;
-	if (dev->features & NETIF_F_NETNS_LOCAL)
+	if (dev->features & NETIF_F_NETNS_LOCAL) {
+		NL_SET_ERR_MSG(extack, "The interface netns is immutable");
 		goto out;
+	}
 
 	/* Ensure the device has been registrered */
-	if (dev->reg_state != NETREG_REGISTERED)
+	if (dev->reg_state != NETREG_REGISTERED) {
+		NL_SET_ERR_MSG(extack, "The interface isn't registered");
 		goto out;
+	}
 
 	/* Get out if there is nothing todo */
 	err = 0;
@@ -11347,30 +11353,49 @@ int __dev_change_net_namespace(struct net_device *dev, struct net *net,
 	err = -EEXIST;
 	if (netdev_name_in_use(net, dev->name)) {
 		/* We get here if we can't use the current device name */
-		if (!pat)
+		if (!pat) {
+			NL_SET_ERR_MSG(extack,
+				       "An interface with the same name exists in the target netns");
 			goto out;
+		}
 		err = dev_prep_valid_name(net, dev, pat, new_name);
-		if (err < 0)
+		if (err < 0) {
+			NL_SET_ERR_MSG_FMT(extack,
+					   "Unable to use '%s' for the new interface name in the target netns",
+					   pat);
 			goto out;
+		}
 	}
 	/* Check that none of the altnames conflicts. */
 	err = -EEXIST;
-	netdev_for_each_altname(dev, name_node)
-		if (netdev_name_in_use(net, name_node->name))
+	netdev_for_each_altname(dev, name_node) {
+		if (netdev_name_in_use(net, name_node->name)) {
+			NL_SET_ERR_MSG_FMT(extack,
+					   "An interface with the altname %s exists in the target netns",
+					   name_node->name);
 			goto out;
+		}
+	}
 
 	/* Check that new_ifindex isn't used yet. */
 	if (new_ifindex) {
 		err = dev_index_reserve(net, new_ifindex);
-		if (err < 0)
+		if (err < 0) {
+			NL_SET_ERR_MSG_FMT(extack,
+					   "The ifindex %d is not available in the target netns",
+					   new_ifindex);
 			goto out;
+		}
 	} else {
 		/* If there is an ifindex conflict assign a new one */
 		err = dev_index_reserve(net, dev->ifindex);
 		if (err == -EBUSY)
 			err = dev_index_reserve(net, 0);
-		if (err < 0)
+		if (err < 0) {
+			NL_SET_ERR_MSG(extack,
+				       "Unable to allocate a new ifindex in the target netns");
 			goto out;
+		}
 		new_ifindex = err;
 	}
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 6e4c366ecffc0..5e2df9b8aaf95 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2824,7 +2824,7 @@ static int do_setlink(const struct sk_buff *skb,
 		else
 			new_ifindex = 0;
 
-		err = __dev_change_net_namespace(dev, net, pat, new_ifindex);
+		err = __dev_change_net_namespace(dev, net, pat, new_ifindex, extack);
 		put_net(net);
 		if (err)
 			goto errout;
-- 
2.53.0



