Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CDD43D813D;
	Wed,  8 Apr 2026 18:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671712; cv=none; b=g1R7xKgZKaA/2s1KXcoQ6SxCQtJJs/ThuX3MqelkFXPPawe1magGfwPvvtsbKVa0JcDITsna84TYvCDoBrdixu1PSOWYdXeFWldi9SjDAt0/Z+osbJ9YaUm2+V0DLNnTgntAOx25VaEHvMgGnl1BniH/LEDorbymwVUyZlp/z6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671712; c=relaxed/simple;
	bh=VNqzyGg9BApaS6NwST5etGxl81pha86KSrh/QJatTI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MzLltq23QIjzo/mxMcvTXspKKFco7CmE1i9ajrXgdXxliSZuTJ7ZQt/6RvVPJkvAneHkAYEDlEKB7fT01pvUjtx7DDVzRDNMv/e0kp0ZlT5MukiIOLcEZsmcsaCHIWjTU5Y33pG8/cVcT1ANXJ6QZpc/Ce8AkKwucNZt+jtkZpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U0oWu+76; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U0oWu+76"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 632E1C19421;
	Wed,  8 Apr 2026 18:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671711;
	bh=VNqzyGg9BApaS6NwST5etGxl81pha86KSrh/QJatTI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U0oWu+76ycwCW9jWA98E6aAUyLj7qp4i3Rd8GlZBYOFAUudg+YZ2/NaudY1Q+gWWD
	 uAg3VBaKf9fRzp7zJyk2B9cUR3BHJmKgHIAoCeu06NVhXqvXdaW35/MLLopi1uOBLk
	 59Q7T60tdC5JVi3QBBCtWZqCGiNCb7UXZ6msD+B0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Nault <gnault@redhat.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 038/312] net: add new helper unregister_netdevice_many_notify
Date: Wed,  8 Apr 2026 19:59:15 +0200
Message-ID: <20260408175935.153746140@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 77f4aa9a2a1766a0b9343fd812b71f18d05178da ]

Add new helper unregister_netdevice_many_notify(), pass netlink message
header and portid, which could be used to notify userspace when flag
NLM_F_ECHO is set.

Make the unregister_netdevice_many() as a wrapper of new function
unregister_netdevice_many_notify().

Suggested-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 6931d21f87bc ("openvswitch: defer tunnel netdev_put to RCU release")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 27 +++++++++++++++++----------
 net/core/dev.h |  3 +++
 2 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 7c743a39747fa..332d3b73d45e7 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10950,14 +10950,8 @@ void unregister_netdevice_queue(struct net_device *dev, struct list_head *head)
 }
 EXPORT_SYMBOL(unregister_netdevice_queue);
 
-/**
- *	unregister_netdevice_many - unregister many devices
- *	@head: list of devices
- *
- *  Note: As most callers use a stack allocated list_head,
- *  we force a list_del() to make sure stack wont be corrupted later.
- */
-void unregister_netdevice_many(struct list_head *head)
+void unregister_netdevice_many_notify(struct list_head *head,
+				      u32 portid, const struct nlmsghdr *nlh)
 {
 	struct net_device *dev, *tmp;
 	LIST_HEAD(close_head);
@@ -11019,7 +11013,8 @@ void unregister_netdevice_many(struct list_head *head)
 		if (!dev->rtnl_link_ops ||
 		    dev->rtnl_link_state == RTNL_LINK_INITIALIZED)
 			skb = rtmsg_ifinfo_build_skb(RTM_DELLINK, dev, ~0U, 0,
-						     GFP_KERNEL, NULL, 0, 0, 0);
+						     GFP_KERNEL, NULL, 0,
+						     portid, nlmsg_seq(nlh));
 
 		/*
 		 *	Flush the unicast and multicast chains
@@ -11034,7 +11029,7 @@ void unregister_netdevice_many(struct list_head *head)
 			dev->netdev_ops->ndo_uninit(dev);
 
 		if (skb)
-			rtmsg_ifinfo_send(skb, dev, GFP_KERNEL, 0, NULL);
+			rtmsg_ifinfo_send(skb, dev, GFP_KERNEL, portid, nlh);
 
 		/* Notifier chain MUST detach us all upper devices. */
 		WARN_ON(netdev_has_any_upper_dev(dev));
@@ -11057,6 +11052,18 @@ void unregister_netdevice_many(struct list_head *head)
 
 	list_del(head);
 }
+
+/**
+ *	unregister_netdevice_many - unregister many devices
+ *	@head: list of devices
+ *
+ *  Note: As most callers use a stack allocated list_head,
+ *  we force a list_del() to make sure stack wont be corrupted later.
+ */
+void unregister_netdevice_many(struct list_head *head)
+{
+	unregister_netdevice_many_notify(head, 0, NULL);
+}
 EXPORT_SYMBOL(unregister_netdevice_many);
 
 /**
diff --git a/net/core/dev.h b/net/core/dev.h
index 8d1afb9887dec..c1e4a39c40787 100644
--- a/net/core/dev.h
+++ b/net/core/dev.h
@@ -98,6 +98,9 @@ void __dev_notify_flags(struct net_device *dev, unsigned int old_flags,
 			unsigned int gchanges, u32 portid,
 			const struct nlmsghdr *nlh);
 
+void unregister_netdevice_many_notify(struct list_head *head,
+				      u32 portid, const struct nlmsghdr *nlh);
+
 static inline void netif_set_gso_max_size(struct net_device *dev,
 					  unsigned int size)
 {
-- 
2.51.0



