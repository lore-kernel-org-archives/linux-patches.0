Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF17D49659;
	Mon, 14 Oct 2024 14:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917107; cv=none; b=ZnAvkHxxpPcTSMJoHv9TvUZemXh8cQQA8JNwlpNMbdjm8rP+tbBB8AZx9cczjKL+MXc+jjWiX2pgm+RWKvDKcTrhDeEA/Ww+dGGz4oGehiv0BeFpq3m/Lnwl+Euc+NAyROPeOwggQVnPXKXWsCnvu3ILM/AYoOR5DYDcWBbTGM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917107; c=relaxed/simple;
	bh=XIiy2En0ZPKzwpBBgcbkWKbSAAQ3mbiDxr8WD9PH2TI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a1iYPCjW2bRnb9xOuPqcCTETcUw/42OR7smwde45ERrEA3XclT/EKg8+LHrE08qskpDBSdYIIA9LzD0yYMEWNFWQcl/IsMNlpCGtUFHG9wN1SjkFx4P1NMBg136311dkm/MO5eaK50Vm6tDEspURJ17OrKlr1CvbAtJ1vocIYZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lj7Ak0VC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lj7Ak0VC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44D65C4CED0;
	Mon, 14 Oct 2024 14:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917107;
	bh=XIiy2En0ZPKzwpBBgcbkWKbSAAQ3mbiDxr8WD9PH2TI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lj7Ak0VC12eA2JjN+DBETpBy8v5gVZ0lSSYjmR9+MUgWpbpEOCax0jjk1Y6W9VkFQ
	 6lfAoFXJVe+l1ZYbbBEg3eeHwjwc8ru049J8NeBUo5cYJZanlVUvUbLbotaz7mhlxy
	 6a/w7MZu+Y2vSJ8k3qX6+eA5IDQIpWyWKbyYTzvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 154/213] bridge: Handle error of rtnl_register_module().
Date: Mon, 14 Oct 2024 16:21:00 +0200
Message-ID: <20241014141048.981387448@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit cba5e43b0b757734b1e79f624d93a71435e31136 ]

Since introduced, br_vlan_rtnl_init() has been ignoring the returned
value of rtnl_register_module(), which could fail silently.

Handling the error allows users to view a module as an all-or-nothing
thing in terms of the rtnetlink functionality.  This prevents syzkaller
from reporting spurious errors from its tests, where OOM often occurs
and module is automatically loaded.

Let's handle the errors by rtnl_register_many().

Fixes: 8dcea187088b ("net: bridge: vlan: add rtm definitions and dump support")
Fixes: f26b296585dc ("net: bridge: vlan: add new rtm message support")
Fixes: adb3ce9bcb0f ("net: bridge: vlan: add del rtm message support")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_netlink.c |  6 +++++-
 net/bridge/br_private.h |  5 +++--
 net/bridge/br_vlan.c    | 19 +++++++++----------
 3 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 4488faf059a36..4b80ec5ae5700 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -1905,7 +1905,10 @@ int __init br_netlink_init(void)
 {
 	int err;
 
-	br_vlan_rtnl_init();
+	err = br_vlan_rtnl_init();
+	if (err)
+		goto out;
+
 	rtnl_af_register(&br_af_ops);
 
 	err = rtnl_link_register(&br_link_ops);
@@ -1916,6 +1919,7 @@ int __init br_netlink_init(void)
 
 out_af:
 	rtnl_af_unregister(&br_af_ops);
+out:
 	return err;
 }
 
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index e4f1a08322da9..72d80fd943a8a 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1547,7 +1547,7 @@ void br_vlan_get_stats(const struct net_bridge_vlan *v,
 void br_vlan_port_event(struct net_bridge_port *p, unsigned long event);
 int br_vlan_bridge_event(struct net_device *dev, unsigned long event,
 			 void *ptr);
-void br_vlan_rtnl_init(void);
+int br_vlan_rtnl_init(void);
 void br_vlan_rtnl_uninit(void);
 void br_vlan_notify(const struct net_bridge *br,
 		    const struct net_bridge_port *p,
@@ -1778,8 +1778,9 @@ static inline int br_vlan_bridge_event(struct net_device *dev,
 	return 0;
 }
 
-static inline void br_vlan_rtnl_init(void)
+static inline int br_vlan_rtnl_init(void)
 {
+	return 0;
 }
 
 static inline void br_vlan_rtnl_uninit(void)
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 15f44d026e75a..be714b4d7b430 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -2296,19 +2296,18 @@ static int br_vlan_rtm_process(struct sk_buff *skb, struct nlmsghdr *nlh,
 	return err;
 }
 
-void br_vlan_rtnl_init(void)
+static const struct rtnl_msg_handler br_vlan_rtnl_msg_handlers[] = {
+	{THIS_MODULE, PF_BRIDGE, RTM_NEWVLAN, br_vlan_rtm_process, NULL, 0},
+	{THIS_MODULE, PF_BRIDGE, RTM_DELVLAN, br_vlan_rtm_process, NULL, 0},
+	{THIS_MODULE, PF_BRIDGE, RTM_GETVLAN, NULL, br_vlan_rtm_dump, 0},
+};
+
+int br_vlan_rtnl_init(void)
 {
-	rtnl_register_module(THIS_MODULE, PF_BRIDGE, RTM_GETVLAN, NULL,
-			     br_vlan_rtm_dump, 0);
-	rtnl_register_module(THIS_MODULE, PF_BRIDGE, RTM_NEWVLAN,
-			     br_vlan_rtm_process, NULL, 0);
-	rtnl_register_module(THIS_MODULE, PF_BRIDGE, RTM_DELVLAN,
-			     br_vlan_rtm_process, NULL, 0);
+	return rtnl_register_many(br_vlan_rtnl_msg_handlers);
 }
 
 void br_vlan_rtnl_uninit(void)
 {
-	rtnl_unregister(PF_BRIDGE, RTM_GETVLAN);
-	rtnl_unregister(PF_BRIDGE, RTM_NEWVLAN);
-	rtnl_unregister(PF_BRIDGE, RTM_DELVLAN);
+	rtnl_unregister_many(br_vlan_rtnl_msg_handlers);
 }
-- 
2.43.0



