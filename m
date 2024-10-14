Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59ED320EB;
	Mon, 14 Oct 2024 14:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916301; cv=none; b=KQh972Rt3k0ry3efpDtA8qtZ5jLXgVZblFCWJMHIkJoBtYg3vtiD2dyU6avRJJpZHFlrxAJHL87e4V9VgV8H/X4vEhOzP/rqtQiGOZuhcB0Z6kZuyAl2Ud0ZJEVIPUtbkEopKawDBhpQdjPu9FH+VvIatFMIZxCb6wMgh29hXqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916301; c=relaxed/simple;
	bh=Od8bJnrOnUXkah7g0ynv7OKFoYx5wQfbzBTcktLRrzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qpDq/DV+XruxykGyyeWTCz00JXKtVK8KdFcDyiUWy0EOalv9DJz+blw+OU3RQbIL0jzriSkCWs16//K3Bb9hfjkXtXqDzjk0SU/gwYC4u8Q/B6IJeBkjHDLM7WzezX0OFXSw0dfA/h+RQ4vt6sf9ywLFXwAv8v3GjAyQjVHWy3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VIzb7HBJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VIzb7HBJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF505C4CEC3;
	Mon, 14 Oct 2024 14:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916301;
	bh=Od8bJnrOnUXkah7g0ynv7OKFoYx5wQfbzBTcktLRrzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VIzb7HBJnB2+p5VgXx1SNHl5wKSqVbWDGVy5NPEdTNjaStdkWetRUvVV9o9qTDuhc
	 y37xkazdHKiM4xn/xEgWam1cxyX6266fbWTJG7eMNkVmMTFpYDPnsENpQqoyhHmogF
	 MQtELtWFpXfDUg0tZ+Ji9uS41gxfnpZ/EveKYwl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 143/214] bridge: Handle error of rtnl_register_module().
Date: Mon, 14 Oct 2024 16:20:06 +0200
Message-ID: <20241014141050.567760172@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index f17dbac7d8284..6b97ae47f8552 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -1920,7 +1920,10 @@ int __init br_netlink_init(void)
 {
 	int err;
 
-	br_vlan_rtnl_init();
+	err = br_vlan_rtnl_init();
+	if (err)
+		goto out;
+
 	rtnl_af_register(&br_af_ops);
 
 	err = rtnl_link_register(&br_link_ops);
@@ -1931,6 +1934,7 @@ int __init br_netlink_init(void)
 
 out_af:
 	rtnl_af_unregister(&br_af_ops);
+out:
 	return err;
 }
 
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index d4bedc87b1d8f..041f6e571a209 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1571,7 +1571,7 @@ void br_vlan_get_stats(const struct net_bridge_vlan *v,
 void br_vlan_port_event(struct net_bridge_port *p, unsigned long event);
 int br_vlan_bridge_event(struct net_device *dev, unsigned long event,
 			 void *ptr);
-void br_vlan_rtnl_init(void);
+int br_vlan_rtnl_init(void);
 void br_vlan_rtnl_uninit(void);
 void br_vlan_notify(const struct net_bridge *br,
 		    const struct net_bridge_port *p,
@@ -1802,8 +1802,9 @@ static inline int br_vlan_bridge_event(struct net_device *dev,
 	return 0;
 }
 
-static inline void br_vlan_rtnl_init(void)
+static inline int br_vlan_rtnl_init(void)
 {
+	return 0;
 }
 
 static inline void br_vlan_rtnl_uninit(void)
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 9c2fffb827ab1..89f51ea4cabec 100644
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



