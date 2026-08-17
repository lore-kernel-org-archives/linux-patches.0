Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D7E3DC857;
	Mon, 17 Aug 2026 14:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975608; cv=none; b=VgkEIjvGIuR1ZrIeflOaYYwa/hgNQj/Ti4rybzfGZecB4cd2KGAjSnllSLv8u1gAZQEZEDleek1szziA4qcKZdFc1qA+ATOWEPNOd7iZ64mqwThfE2xB6Su7ADkz7fD0gOOAC/3R3ZDiHCANjCqIRfDvHzaoB/nyJ9GvpHaILDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975608; c=relaxed/simple;
	bh=Fze8bCPoB6CyDwFog285Or78pZ0tWBWPAEjqVK/c158=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aBTiBERco0YGt+B/pSCk48ddcxA6AmA8R1u8fIS3VYenpYZkZzhy36l8KAnVQWiUXDel0gU/xXVBNe9u/WMqcrJG75TvUk0k0w26jszrSHsCIPNW7+qn+DzOxNdyO1C9K/q3u03YsyUMvRoqDqtOxoM6XeYbbzNy+1wIICXY/B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aoQSiC/s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aoQSiC/s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E288D1F000E9;
	Mon, 17 Aug 2026 14:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975607;
	bh=TuEga0J0e5ZwjESBBaDAC7DtfVheQcdoithdagOkfE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aoQSiC/sUZWRqr5HvT6v83IN+QlIHAElgUeoPW2EqGnwG81eOQAdpuEoeAMgzjAld
	 lrtu5L4yUx2Gq8i+iKKAu4nD+asB4vkTn+W5vTQCKnjJNkHYXEkyJMj2D39uh9Z30K
	 eOewxsa9qapH/Cm/VhCnL/BvhLDRCel4KcYM3P8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <nikolay@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 086/389] net: bridge: vlan: add support for global options
Date: Mon, 17 Aug 2026 15:28:45 +0200
Message-ID: <20260817132542.462565492@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolay Aleksandrov <nikolay@nvidia.com>

[ Upstream commit 47ecd2dbd8ec43125ea75d7d2e73c888cda8663f ]

We can have two types of vlan options depending on context:
 - per-device vlan options (split in per-bridge and per-port)
 - global vlan options

The second type wasn't supported in the bridge until now, but we need
them for per-vlan multicast support, per-vlan STP support and other
options which require global vlan context. They are contained in the global
bridge vlan context even if the vlan is not configured on the bridge device
itself. This patch adds initial netlink attributes and support for setting
these global vlan options, they can only be set (RTM_NEWVLAN) and the
operation must use the bridge device. Since there are no such options yet
it shouldn't have any functional effect.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 43171c97e471 ("net: bridge: vlan: fix vlan range dumps starting with pvid")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/if_bridge.h | 13 ++++++
 net/bridge/br_private.h        |  4 ++
 net/bridge/br_vlan.c           | 16 +++++--
 net/bridge/br_vlan_options.c   | 85 ++++++++++++++++++++++++++++++++++
 4 files changed, 115 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index 4c687686aa8f73..f56e9114558299 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -360,10 +360,15 @@ enum {
  *     [BRIDGE_VLANDB_ENTRY_INFO]
  *     ...
  * }
+ * [BRIDGE_VLANDB_GLOBAL_OPTIONS] = {
+ *     [BRIDGE_VLANDB_GOPTS_ID]
+ *     ...
+ * }
  */
 enum {
 	BRIDGE_VLANDB_UNSPEC,
 	BRIDGE_VLANDB_ENTRY,
+	BRIDGE_VLANDB_GLOBAL_OPTIONS,
 	__BRIDGE_VLANDB_MAX,
 };
 #define BRIDGE_VLANDB_MAX (__BRIDGE_VLANDB_MAX - 1)
@@ -413,6 +418,14 @@ enum {
 };
 #define BRIDGE_VLANDB_STATS_MAX (__BRIDGE_VLANDB_STATS_MAX - 1)
 
+enum {
+	BRIDGE_VLANDB_GOPTS_UNSPEC,
+	BRIDGE_VLANDB_GOPTS_ID,
+	BRIDGE_VLANDB_GOPTS_RANGE,
+	__BRIDGE_VLANDB_GOPTS_MAX
+};
+#define BRIDGE_VLANDB_GOPTS_MAX (__BRIDGE_VLANDB_GOPTS_MAX - 1)
+
 /* Bridge multicast database attributes
  * [MDBA_MDB] = {
  *     [MDBA_MDB_ENTRY] = {
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 19d77a8721fafb..bd68d049c5fd93 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1327,6 +1327,10 @@ int br_vlan_process_options(const struct net_bridge *br,
 			    struct net_bridge_vlan *range_end,
 			    struct nlattr **tb,
 			    struct netlink_ext_ack *extack);
+int br_vlan_rtm_process_global_options(struct net_device *dev,
+				       const struct nlattr *attr,
+				       int cmd,
+				       struct netlink_ext_ack *extack);
 
 /* vlan state manipulation helpers using *_ONCE to annotate lock-free access */
 static inline u8 br_vlan_get_state(const struct net_bridge_vlan *v)
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 1dc5db07650c9a..0bd5a168943fd1 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -2062,12 +2062,22 @@ static int br_vlan_rtm_process(struct sk_buff *skb, struct nlmsghdr *nlh,
 	}
 
 	nlmsg_for_each_attr(attr, nlh, sizeof(*bvm), rem) {
-		if (nla_type(attr) != BRIDGE_VLANDB_ENTRY)
+		switch (nla_type(attr)) {
+		case BRIDGE_VLANDB_ENTRY:
+			err = br_vlan_rtm_process_one(dev, attr,
+						      nlh->nlmsg_type,
+						      extack);
+			break;
+		case BRIDGE_VLANDB_GLOBAL_OPTIONS:
+			err = br_vlan_rtm_process_global_options(dev, attr,
+								 nlh->nlmsg_type,
+								 extack);
+			break;
+		default:
 			continue;
+		}
 
 		vlans++;
-		err = br_vlan_rtm_process_one(dev, attr, nlh->nlmsg_type,
-					      extack);
 		if (err)
 			break;
 	}
diff --git a/net/bridge/br_vlan_options.c b/net/bridge/br_vlan_options.c
index b4add9ea8964a9..a7d5a233420732 100644
--- a/net/bridge/br_vlan_options.c
+++ b/net/bridge/br_vlan_options.c
@@ -258,3 +258,88 @@ int br_vlan_process_options(const struct net_bridge *br,
 
 	return err;
 }
+
+static int br_vlan_process_global_one_opts(const struct net_bridge *br,
+					   struct net_bridge_vlan_group *vg,
+					   struct net_bridge_vlan *v,
+					   struct nlattr **tb,
+					   bool *changed,
+					   struct netlink_ext_ack *extack)
+{
+	*changed = false;
+	return 0;
+}
+
+static const struct nla_policy br_vlan_db_gpol[BRIDGE_VLANDB_GOPTS_MAX + 1] = {
+	[BRIDGE_VLANDB_GOPTS_ID]	= { .type = NLA_U16 },
+	[BRIDGE_VLANDB_GOPTS_RANGE]	= { .type = NLA_U16 },
+};
+
+int br_vlan_rtm_process_global_options(struct net_device *dev,
+				       const struct nlattr *attr,
+				       int cmd,
+				       struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[BRIDGE_VLANDB_GOPTS_MAX + 1];
+	struct net_bridge_vlan_group *vg;
+	struct net_bridge_vlan *v;
+	u16 vid, vid_range = 0;
+	struct net_bridge *br;
+	int err = 0;
+
+	if (cmd != RTM_NEWVLAN) {
+		NL_SET_ERR_MSG_MOD(extack, "Global vlan options support only set operation");
+		return -EINVAL;
+	}
+	if (!netif_is_bridge_master(dev)) {
+		NL_SET_ERR_MSG_MOD(extack, "Global vlan options can only be set on bridge device");
+		return -EINVAL;
+	}
+	br = netdev_priv(dev);
+	vg = br_vlan_group(br);
+	if (WARN_ON(!vg))
+		return -ENODEV;
+
+	err = nla_parse_nested(tb, BRIDGE_VLANDB_GOPTS_MAX, attr,
+			       br_vlan_db_gpol, extack);
+	if (err)
+		return err;
+
+	if (!tb[BRIDGE_VLANDB_GOPTS_ID]) {
+		NL_SET_ERR_MSG_MOD(extack, "Missing vlan entry id");
+		return -EINVAL;
+	}
+	vid = nla_get_u16(tb[BRIDGE_VLANDB_GOPTS_ID]);
+	if (!br_vlan_valid_id(vid, extack))
+		return -EINVAL;
+
+	if (tb[BRIDGE_VLANDB_GOPTS_RANGE]) {
+		vid_range = nla_get_u16(tb[BRIDGE_VLANDB_GOPTS_RANGE]);
+		if (!br_vlan_valid_id(vid_range, extack))
+			return -EINVAL;
+		if (vid >= vid_range) {
+			NL_SET_ERR_MSG_MOD(extack, "End vlan id is less than or equal to start vlan id");
+			return -EINVAL;
+		}
+	} else {
+		vid_range = vid;
+	}
+
+	for (; vid <= vid_range; vid++) {
+		bool changed = false;
+
+		v = br_vlan_find(vg, vid);
+		if (!v) {
+			NL_SET_ERR_MSG_MOD(extack, "Vlan in range doesn't exist, can't process global options");
+			err = -ENOENT;
+			break;
+		}
+
+		err = br_vlan_process_global_one_opts(br, vg, v, tb, &changed,
+						      extack);
+		if (err)
+			break;
+	}
+
+	return err;
+}
-- 
2.53.0



