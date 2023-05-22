Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA7A8171A1
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:19:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3827EC433EF;
	Mon, 22 May 2023 19:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783163;
	bh=XS8NOe42e6gQdhzW5ZEjWVqzcRzVWw2b7iG97AjDV84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OI16zzU4v0hyQI7qASrjNYDcKWYtwnEimmGyYO/7Dei4GKqCycqMBdA/M/Z5uVb8h
	 EduHJdQUq3eXpJZ1iFVMA7eQkhGcwsmTqrQg77dWHUSUgFFAoWQPaPX2EQCmurRDS8
	 rqx7USkeM13DNcVHnPk5/enUrONdD5af6FF812U4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 160/203] bridge: always declare tunnel functions
Date: Mon, 22 May 2023 20:09:44 +0100
Message-Id: <20230522190359.403498673@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190354.935300867@linuxfoundation.org>
References: <20230522190354.935300867@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 89dcd87ce534a3a7f267cfd58505803006f51301 ]

When CONFIG_BRIDGE_VLAN_FILTERING is disabled, two functions are still
defined but have no prototype or caller. This causes a W=1 warning for
the missing prototypes:

net/bridge/br_netlink_tunnel.c:29:6: error: no previous prototype for 'vlan_tunid_inrange' [-Werror=missing-prototypes]
net/bridge/br_netlink_tunnel.c:199:5: error: no previous prototype for 'br_vlan_tunnel_info' [-Werror=missing-prototypes]

The functions are already contitional on CONFIG_BRIDGE_VLAN_FILTERING,
and I coulnd't easily figure out the right set of #ifdefs, so just
move the declarations out of the #ifdef to avoid the warning,
at a small cost in code size over a more elaborate fix.

Fixes: 188c67dd1906 ("net: bridge: vlan options: add support for tunnel id dumping")
Fixes: 569da0822808 ("net: bridge: vlan options: add support for tunnel mapping set/del")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://lore.kernel.org/r/20230516194625.549249-3-arnd@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_private_tunnel.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/bridge/br_private_tunnel.h b/net/bridge/br_private_tunnel.h
index 2b053289f0166..efb096025151a 100644
--- a/net/bridge/br_private_tunnel.h
+++ b/net/bridge/br_private_tunnel.h
@@ -27,6 +27,10 @@ int br_process_vlan_tunnel_info(const struct net_bridge *br,
 int br_get_vlan_tunnel_info_size(struct net_bridge_vlan_group *vg);
 int br_fill_vlan_tunnel_info(struct sk_buff *skb,
 			     struct net_bridge_vlan_group *vg);
+bool vlan_tunid_inrange(const struct net_bridge_vlan *v_curr,
+			const struct net_bridge_vlan *v_last);
+int br_vlan_tunnel_info(const struct net_bridge_port *p, int cmd,
+			u16 vid, u32 tun_id, bool *changed);
 
 #ifdef CONFIG_BRIDGE_VLAN_FILTERING
 /* br_vlan_tunnel.c */
@@ -43,10 +47,6 @@ void br_handle_ingress_vlan_tunnel(struct sk_buff *skb,
 				   struct net_bridge_vlan_group *vg);
 int br_handle_egress_vlan_tunnel(struct sk_buff *skb,
 				 struct net_bridge_vlan *vlan);
-bool vlan_tunid_inrange(const struct net_bridge_vlan *v_curr,
-			const struct net_bridge_vlan *v_last);
-int br_vlan_tunnel_info(const struct net_bridge_port *p, int cmd,
-			u16 vid, u32 tun_id, bool *changed);
 #else
 static inline int vlan_tunnel_init(struct net_bridge_vlan_group *vg)
 {
-- 
2.39.2



