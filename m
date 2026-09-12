Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D3E830ACF6;
	Sat, 12 Sep 2026 15:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225900; cv=none; b=OvM1agK9omDjoIVTZSYfPJ/X2zfRjPYgtKaqr6/F9LM8azhK47QGVMe1VcKTjoIZADi4m24OaWgjVcps93rCbsN5ZOW65o0gYujlsH+JB7bGJpC0b0+z6TPb+hjuJAJ4ywxQMOtPg++pU41o4vSppihajILFaVw6FTUOd0ZCs8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225900; c=relaxed/simple;
	bh=/0fhjOLS/FiTykXhncxj28l1IHhPAAcsDM1SlDhaSS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F798FCkjrmV/VzxXAdOE3KZYbXqLum/Acv6pBqAjwcPAMW1AfyKTfSbeN1q/V3cL5iGxc+LBRiKJ2YROWXByZThFwhRG98fLUVgluoFo4jcJ56TbYDWM7uspGB37IAbzMKeoluA6gACtn1S7kMT3LpEPYrj9FWjh2GExdz2Y/GM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vHu1aBT9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vHu1aBT9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C7181F000FF;
	Sat, 12 Sep 2026 15:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225899;
	bh=n/6T5VqXEkeanFe9ncDAzkvVNHAxJZaBGvd6HmjRo6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vHu1aBT9ckH8HGr0VJWMlUGnYCGpq33fCkAUjigxbDoKmCElyZqXuPgnVqxt6FPqZ
	 XILNyAz64mYamKmGNlRf7O+pNrpmE9p+88fTSvuvB4Gk7h/QZmW5ocpLs7kjWcAKtX
	 c2xTgyUN2+Pis91XLlxMDVBFDyqyWUMn4L/NHGw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1292/1424] vxlan: mdb: Add MDB bulk deletion support
Date: Sat, 12 Sep 2026 09:02:04 +0200
Message-ID: <20260912065636.203902331@linuxfoundation.org>
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

[ Upstream commit 4cde72fead4cebb5b6b2fe9425904c2064739184 ]

Implement MDB bulk deletion support in the VXLAN driver, allowing MDB
entries to be deleted in bulk according to provided parameters.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: bc2dc66a6693 ("vxlan: mdb: Fix use-after-free in vxlan_mdb_flush()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan/vxlan_core.c    |   1 +
 drivers/net/vxlan/vxlan_mdb.c     | 174 +++++++++++++++++++++++++-----
 drivers/net/vxlan/vxlan_private.h |   2 +
 3 files changed, 153 insertions(+), 24 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index a1ff8a9ae60ea..dd7c4c50ce589 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -3181,6 +3181,7 @@ static const struct net_device_ops vxlan_netdev_ether_ops = {
 	.ndo_fdb_get		= vxlan_fdb_get,
 	.ndo_mdb_add		= vxlan_mdb_add,
 	.ndo_mdb_del		= vxlan_mdb_del,
+	.ndo_mdb_del_bulk	= vxlan_mdb_del_bulk,
 	.ndo_mdb_dump		= vxlan_mdb_dump,
 	.ndo_mdb_get		= vxlan_mdb_get,
 	.ndo_fill_metadata_dst	= vxlan_fill_metadata_dst,
diff --git a/drivers/net/vxlan/vxlan_mdb.c b/drivers/net/vxlan/vxlan_mdb.c
index 91272344e9c83..8b8b4d052a9c6 100644
--- a/drivers/net/vxlan/vxlan_mdb.c
+++ b/drivers/net/vxlan/vxlan_mdb.c
@@ -75,6 +75,14 @@ struct vxlan_mdb_config {
 	u8 rt_protocol;
 };
 
+struct vxlan_mdb_flush_desc {
+	union vxlan_addr remote_ip;
+	__be32 src_vni;
+	__be32 remote_vni;
+	__be16 remote_port;
+	u8 rt_protocol;
+};
+
 static const struct rhashtable_params vxlan_mdb_rht_params = {
 	.head_offset = offsetof(struct vxlan_mdb_entry, rhnode),
 	.key_offset = offsetof(struct vxlan_mdb_entry, key),
@@ -1312,6 +1320,145 @@ int vxlan_mdb_del(struct net_device *dev, struct nlattr *tb[],
 	return err;
 }
 
+static const struct nla_policy
+vxlan_mdbe_attrs_del_bulk_pol[MDBE_ATTR_MAX + 1] = {
+	[MDBE_ATTR_RTPROT] = NLA_POLICY_MIN(NLA_U8, RTPROT_STATIC),
+	[MDBE_ATTR_DST] = NLA_POLICY_RANGE(NLA_BINARY,
+					   sizeof(struct in_addr),
+					   sizeof(struct in6_addr)),
+	[MDBE_ATTR_DST_PORT] = { .type = NLA_U16 },
+	[MDBE_ATTR_VNI] = NLA_POLICY_FULL_RANGE(NLA_U32, &vni_range),
+	[MDBE_ATTR_SRC_VNI] = NLA_POLICY_FULL_RANGE(NLA_U32, &vni_range),
+	[MDBE_ATTR_STATE_MASK] = NLA_POLICY_MASK(NLA_U8, MDB_PERMANENT),
+};
+
+static int vxlan_mdb_flush_desc_init(struct vxlan_dev *vxlan,
+				     struct vxlan_mdb_flush_desc *desc,
+				     struct nlattr *tb[],
+				     struct netlink_ext_ack *extack)
+{
+	struct br_mdb_entry *entry = nla_data(tb[MDBA_SET_ENTRY]);
+	struct nlattr *mdbe_attrs[MDBE_ATTR_MAX + 1];
+	int err;
+
+	if (entry->ifindex && entry->ifindex != vxlan->dev->ifindex) {
+		NL_SET_ERR_MSG_MOD(extack, "Invalid port net device");
+		return -EINVAL;
+	}
+
+	if (entry->vid) {
+		NL_SET_ERR_MSG_MOD(extack, "VID must not be specified");
+		return -EINVAL;
+	}
+
+	if (!tb[MDBA_SET_ENTRY_ATTRS])
+		return 0;
+
+	err = nla_parse_nested(mdbe_attrs, MDBE_ATTR_MAX,
+			       tb[MDBA_SET_ENTRY_ATTRS],
+			       vxlan_mdbe_attrs_del_bulk_pol, extack);
+	if (err)
+		return err;
+
+	if (mdbe_attrs[MDBE_ATTR_STATE_MASK]) {
+		u8 state_mask = nla_get_u8(mdbe_attrs[MDBE_ATTR_STATE_MASK]);
+
+		if ((state_mask & MDB_PERMANENT) && !(entry->state & MDB_PERMANENT)) {
+			NL_SET_ERR_MSG_MOD(extack, "Only permanent MDB entries are supported");
+			return -EINVAL;
+		}
+	}
+
+	if (mdbe_attrs[MDBE_ATTR_RTPROT])
+		desc->rt_protocol = nla_get_u8(mdbe_attrs[MDBE_ATTR_RTPROT]);
+
+	if (mdbe_attrs[MDBE_ATTR_DST])
+		vxlan_nla_get_addr(&desc->remote_ip, mdbe_attrs[MDBE_ATTR_DST]);
+
+	if (mdbe_attrs[MDBE_ATTR_DST_PORT])
+		desc->remote_port =
+			cpu_to_be16(nla_get_u16(mdbe_attrs[MDBE_ATTR_DST_PORT]));
+
+	if (mdbe_attrs[MDBE_ATTR_VNI])
+		desc->remote_vni =
+			cpu_to_be32(nla_get_u32(mdbe_attrs[MDBE_ATTR_VNI]));
+
+	if (mdbe_attrs[MDBE_ATTR_SRC_VNI])
+		desc->src_vni =
+			cpu_to_be32(nla_get_u32(mdbe_attrs[MDBE_ATTR_SRC_VNI]));
+
+	return 0;
+}
+
+static void vxlan_mdb_remotes_flush(struct vxlan_dev *vxlan,
+				    struct vxlan_mdb_entry *mdb_entry,
+				    const struct vxlan_mdb_flush_desc *desc)
+{
+	struct vxlan_mdb_remote *remote, *tmp;
+
+	list_for_each_entry_safe(remote, tmp, &mdb_entry->remotes, list) {
+		struct vxlan_rdst *rd = rtnl_dereference(remote->rd);
+		__be32 remote_vni;
+
+		if (desc->remote_ip.sa.sa_family &&
+		    !vxlan_addr_equal(&desc->remote_ip, &rd->remote_ip))
+			continue;
+
+		/* Encapsulation is performed with source VNI if remote VNI
+		 * is not set.
+		 */
+		remote_vni = rd->remote_vni ? : mdb_entry->key.vni;
+		if (desc->remote_vni && desc->remote_vni != remote_vni)
+			continue;
+
+		if (desc->remote_port && desc->remote_port != rd->remote_port)
+			continue;
+
+		if (desc->rt_protocol &&
+		    desc->rt_protocol != remote->rt_protocol)
+			continue;
+
+		vxlan_mdb_remote_del(vxlan, mdb_entry, remote);
+	}
+}
+
+static void vxlan_mdb_flush(struct vxlan_dev *vxlan,
+			    const struct vxlan_mdb_flush_desc *desc)
+{
+	struct vxlan_mdb_entry *mdb_entry;
+	struct hlist_node *tmp;
+
+	/* The removal of an entry cannot trigger the removal of another entry
+	 * since entries are always added to the head of the list.
+	 */
+	hlist_for_each_entry_safe(mdb_entry, tmp, &vxlan->mdb_list, mdb_node) {
+		if (desc->src_vni && desc->src_vni != mdb_entry->key.vni)
+			continue;
+
+		vxlan_mdb_remotes_flush(vxlan, mdb_entry, desc);
+		/* Entry will only be removed if its remotes list is empty. */
+		vxlan_mdb_entry_put(vxlan, mdb_entry);
+	}
+}
+
+int vxlan_mdb_del_bulk(struct net_device *dev, struct nlattr *tb[],
+		       struct netlink_ext_ack *extack)
+{
+	struct vxlan_dev *vxlan = netdev_priv(dev);
+	struct vxlan_mdb_flush_desc desc = {};
+	int err;
+
+	ASSERT_RTNL();
+
+	err = vxlan_mdb_flush_desc_init(vxlan, &desc, tb, extack);
+	if (err)
+		return err;
+
+	vxlan_mdb_flush(vxlan, &desc);
+
+	return 0;
+}
+
 static const struct nla_policy vxlan_mdbe_attrs_get_pol[MDBE_ATTR_MAX + 1] = {
 	[MDBE_ATTR_SOURCE] = NLA_POLICY_RANGE(NLA_BINARY,
 					      sizeof(struct in_addr),
@@ -1581,29 +1728,6 @@ static void vxlan_mdb_check_empty(void *ptr, void *arg)
 	WARN_ON_ONCE(1);
 }
 
-static void vxlan_mdb_remotes_flush(struct vxlan_dev *vxlan,
-				    struct vxlan_mdb_entry *mdb_entry)
-{
-	struct vxlan_mdb_remote *remote, *tmp;
-
-	list_for_each_entry_safe(remote, tmp, &mdb_entry->remotes, list)
-		vxlan_mdb_remote_del(vxlan, mdb_entry, remote);
-}
-
-static void vxlan_mdb_entries_flush(struct vxlan_dev *vxlan)
-{
-	struct vxlan_mdb_entry *mdb_entry;
-	struct hlist_node *tmp;
-
-	/* The removal of an entry cannot trigger the removal of another entry
-	 * since entries are always added to the head of the list.
-	 */
-	hlist_for_each_entry_safe(mdb_entry, tmp, &vxlan->mdb_list, mdb_node) {
-		vxlan_mdb_remotes_flush(vxlan, mdb_entry);
-		vxlan_mdb_entry_put(vxlan, mdb_entry);
-	}
-}
-
 int vxlan_mdb_init(struct vxlan_dev *vxlan)
 {
 	int err;
@@ -1619,7 +1743,9 @@ int vxlan_mdb_init(struct vxlan_dev *vxlan)
 
 void vxlan_mdb_fini(struct vxlan_dev *vxlan)
 {
-	vxlan_mdb_entries_flush(vxlan);
+	struct vxlan_mdb_flush_desc desc = {};
+
+	vxlan_mdb_flush(vxlan, &desc);
 	WARN_ON_ONCE(vxlan->cfg.flags & VXLAN_F_MDB);
 	rhashtable_free_and_destroy(&vxlan->mdb_tbl, vxlan_mdb_check_empty,
 				    NULL);
diff --git a/drivers/net/vxlan/vxlan_private.h b/drivers/net/vxlan/vxlan_private.h
index 89c8ef1e7fdde..76a351a997d51 100644
--- a/drivers/net/vxlan/vxlan_private.h
+++ b/drivers/net/vxlan/vxlan_private.h
@@ -235,6 +235,8 @@ int vxlan_mdb_add(struct net_device *dev, struct nlattr *tb[], u16 nlmsg_flags,
 		  struct netlink_ext_ack *extack);
 int vxlan_mdb_del(struct net_device *dev, struct nlattr *tb[],
 		  struct netlink_ext_ack *extack);
+int vxlan_mdb_del_bulk(struct net_device *dev, struct nlattr *tb[],
+		       struct netlink_ext_ack *extack);
 int vxlan_mdb_get(struct net_device *dev, struct nlattr *tb[], u32 portid,
 		  u32 seq, struct netlink_ext_ack *extack);
 struct vxlan_mdb_entry *vxlan_mdb_entry_skb_get(struct vxlan_dev *vxlan,
-- 
2.53.0



