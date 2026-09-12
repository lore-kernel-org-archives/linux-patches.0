Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 754CA303A35;
	Sat, 12 Sep 2026 15:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225880; cv=none; b=Zj2DWnbCdFJY2dUH39nH4uLQTIrhRzDLsf1JNsmnx/usXVn+uXuj0u19rBZVds0EV+zvEL6Dt5oU82qjX62M+UdWBSfZ17skpLFlUBxh5Gsn3Nj+SS7BiyrMV9iRiLMOj63lutc8GlDRQGjg2//s+QFuTP/fTtFzI3ym+W5jL2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225880; c=relaxed/simple;
	bh=KJKCo5zCU0Yv5jILgwTXnliaHrplMZjBc4wJyMMG5fU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NyRPqn4qxXEWIkcCQ1itWViVjYA3t2LnAt4ZJpMCz5eM6H9pteWhId3+VFEP+5ZpzPJfXaHeXYdedkxUGqb0u0Q7lOX4Wt3o5Br+esUJy0PhiAWw7h940IlE69IM7ilwaBGvan5S1F/Nx67JFdi4A4kTrjG6NzQAvYPMn+9wDcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NVw63dQW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NVw63dQW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D68C1F000FF;
	Sat, 12 Sep 2026 15:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225879;
	bh=njSLtHjGXrN/MWxUQhdv5AdrRmscBirwnwf6jHIJspw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NVw63dQWh3ux+bXgtwWkzQLLyBGvx3NNdA+8VstXo/dNYE3BmGvf/NTkUpKiyXrrr
	 mAWPDo57x5DsoYo111/n4ynoK3Ge1XeDg80+jqeymE4RYAmS1/m/dF1ZAR/HdHVm1J
	 Au8EWWCDjgIRwLo0BSa/nbHSs/lAfJbURIuVK4Qk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1289/1424] vxlan: mdb: Add MDB get support
Date: Sat, 12 Sep 2026 09:02:01 +0200
Message-ID: <20260912065636.138421745@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 32d9673e96dc636cbfca2381b2c93b7a15dc3369 ]

Implement support for MDB get operation by looking up a matching MDB
entry, allocating the skb according to the entry's size and then filling
in the response.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: bc2dc66a6693 ("vxlan: mdb: Fix use-after-free in vxlan_mdb_flush()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan/vxlan_core.c    |   1 +
 drivers/net/vxlan/vxlan_mdb.c     | 150 ++++++++++++++++++++++++++++++
 drivers/net/vxlan/vxlan_private.h |   2 +
 3 files changed, 153 insertions(+)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 4415c1f6585ea..a1ff8a9ae60ea 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -3182,6 +3182,7 @@ static const struct net_device_ops vxlan_netdev_ether_ops = {
 	.ndo_mdb_add		= vxlan_mdb_add,
 	.ndo_mdb_del		= vxlan_mdb_del,
 	.ndo_mdb_dump		= vxlan_mdb_dump,
+	.ndo_mdb_get		= vxlan_mdb_get,
 	.ndo_fill_metadata_dst	= vxlan_fill_metadata_dst,
 };
 
diff --git a/drivers/net/vxlan/vxlan_mdb.c b/drivers/net/vxlan/vxlan_mdb.c
index 8893f3be8f963..91272344e9c83 100644
--- a/drivers/net/vxlan/vxlan_mdb.c
+++ b/drivers/net/vxlan/vxlan_mdb.c
@@ -1312,6 +1312,156 @@ int vxlan_mdb_del(struct net_device *dev, struct nlattr *tb[],
 	return err;
 }
 
+static const struct nla_policy vxlan_mdbe_attrs_get_pol[MDBE_ATTR_MAX + 1] = {
+	[MDBE_ATTR_SOURCE] = NLA_POLICY_RANGE(NLA_BINARY,
+					      sizeof(struct in_addr),
+					      sizeof(struct in6_addr)),
+	[MDBE_ATTR_SRC_VNI] = NLA_POLICY_FULL_RANGE(NLA_U32, &vni_range),
+};
+
+static int vxlan_mdb_get_parse(struct net_device *dev, struct nlattr *tb[],
+			       struct vxlan_mdb_entry_key *group,
+			       struct netlink_ext_ack *extack)
+{
+	struct br_mdb_entry *entry = nla_data(tb[MDBA_GET_ENTRY]);
+	struct nlattr *mdbe_attrs[MDBE_ATTR_MAX + 1];
+	struct vxlan_dev *vxlan = netdev_priv(dev);
+	int err;
+
+	memset(group, 0, sizeof(*group));
+	group->vni = vxlan->default_dst.remote_vni;
+
+	if (!tb[MDBA_GET_ENTRY_ATTRS]) {
+		vxlan_mdb_group_set(group, entry, NULL);
+		return 0;
+	}
+
+	err = nla_parse_nested(mdbe_attrs, MDBE_ATTR_MAX,
+			       tb[MDBA_GET_ENTRY_ATTRS],
+			       vxlan_mdbe_attrs_get_pol, extack);
+	if (err)
+		return err;
+
+	if (mdbe_attrs[MDBE_ATTR_SOURCE] &&
+	    !vxlan_mdb_is_valid_source(mdbe_attrs[MDBE_ATTR_SOURCE],
+				       entry->addr.proto, extack))
+		return -EINVAL;
+
+	vxlan_mdb_group_set(group, entry, mdbe_attrs[MDBE_ATTR_SOURCE]);
+
+	if (mdbe_attrs[MDBE_ATTR_SRC_VNI])
+		group->vni =
+			cpu_to_be32(nla_get_u32(mdbe_attrs[MDBE_ATTR_SRC_VNI]));
+
+	return 0;
+}
+
+static struct sk_buff *
+vxlan_mdb_get_reply_alloc(const struct vxlan_dev *vxlan,
+			  const struct vxlan_mdb_entry *mdb_entry)
+{
+	struct vxlan_mdb_remote *remote;
+	size_t nlmsg_size;
+
+	nlmsg_size = NLMSG_ALIGN(sizeof(struct br_port_msg)) +
+		     /* MDBA_MDB */
+		     nla_total_size(0) +
+		     /* MDBA_MDB_ENTRY */
+		     nla_total_size(0);
+
+	list_for_each_entry(remote, &mdb_entry->remotes, list)
+		nlmsg_size += vxlan_mdb_nlmsg_remote_size(vxlan, mdb_entry,
+							  remote);
+
+	return nlmsg_new(nlmsg_size, GFP_KERNEL);
+}
+
+static int
+vxlan_mdb_get_reply_fill(const struct vxlan_dev *vxlan,
+			 struct sk_buff *skb,
+			 const struct vxlan_mdb_entry *mdb_entry,
+			 u32 portid, u32 seq)
+{
+	struct nlattr *mdb_nest, *mdb_entry_nest;
+	struct vxlan_mdb_remote *remote;
+	struct br_port_msg *bpm;
+	struct nlmsghdr *nlh;
+	int err;
+
+	nlh = nlmsg_put(skb, portid, seq, RTM_NEWMDB, sizeof(*bpm), 0);
+	if (!nlh)
+		return -EMSGSIZE;
+
+	bpm = nlmsg_data(nlh);
+	memset(bpm, 0, sizeof(*bpm));
+	bpm->family  = AF_BRIDGE;
+	bpm->ifindex = vxlan->dev->ifindex;
+	mdb_nest = nla_nest_start_noflag(skb, MDBA_MDB);
+	if (!mdb_nest) {
+		err = -EMSGSIZE;
+		goto cancel;
+	}
+	mdb_entry_nest = nla_nest_start_noflag(skb, MDBA_MDB_ENTRY);
+	if (!mdb_entry_nest) {
+		err = -EMSGSIZE;
+		goto cancel;
+	}
+
+	list_for_each_entry(remote, &mdb_entry->remotes, list) {
+		err = vxlan_mdb_entry_info_fill(vxlan, skb, mdb_entry, remote);
+		if (err)
+			goto cancel;
+	}
+
+	nla_nest_end(skb, mdb_entry_nest);
+	nla_nest_end(skb, mdb_nest);
+	nlmsg_end(skb, nlh);
+
+	return 0;
+
+cancel:
+	nlmsg_cancel(skb, nlh);
+	return err;
+}
+
+int vxlan_mdb_get(struct net_device *dev, struct nlattr *tb[], u32 portid,
+		  u32 seq, struct netlink_ext_ack *extack)
+{
+	struct vxlan_dev *vxlan = netdev_priv(dev);
+	struct vxlan_mdb_entry *mdb_entry;
+	struct vxlan_mdb_entry_key group;
+	struct sk_buff *skb;
+	int err;
+
+	ASSERT_RTNL();
+
+	err = vxlan_mdb_get_parse(dev, tb, &group, extack);
+	if (err)
+		return err;
+
+	mdb_entry = vxlan_mdb_entry_lookup(vxlan, &group);
+	if (!mdb_entry) {
+		NL_SET_ERR_MSG_MOD(extack, "MDB entry not found");
+		return -ENOENT;
+	}
+
+	skb = vxlan_mdb_get_reply_alloc(vxlan, mdb_entry);
+	if (!skb)
+		return -ENOMEM;
+
+	err = vxlan_mdb_get_reply_fill(vxlan, skb, mdb_entry, portid, seq);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to fill MDB get reply");
+		goto free;
+	}
+
+	return rtnl_unicast(skb, dev_net(dev), portid);
+
+free:
+	kfree_skb(skb);
+	return err;
+}
+
 struct vxlan_mdb_entry *vxlan_mdb_entry_skb_get(struct vxlan_dev *vxlan,
 						struct sk_buff *skb,
 						__be32 src_vni)
diff --git a/drivers/net/vxlan/vxlan_private.h b/drivers/net/vxlan/vxlan_private.h
index 85b6d0c347e3b..89c8ef1e7fdde 100644
--- a/drivers/net/vxlan/vxlan_private.h
+++ b/drivers/net/vxlan/vxlan_private.h
@@ -235,6 +235,8 @@ int vxlan_mdb_add(struct net_device *dev, struct nlattr *tb[], u16 nlmsg_flags,
 		  struct netlink_ext_ack *extack);
 int vxlan_mdb_del(struct net_device *dev, struct nlattr *tb[],
 		  struct netlink_ext_ack *extack);
+int vxlan_mdb_get(struct net_device *dev, struct nlattr *tb[], u32 portid,
+		  u32 seq, struct netlink_ext_ack *extack);
 struct vxlan_mdb_entry *vxlan_mdb_entry_skb_get(struct vxlan_dev *vxlan,
 						struct sk_buff *skb,
 						__be32 src_vni);
-- 
2.53.0



