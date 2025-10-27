Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EBB64A00;
	Mon, 27 Oct 2025 19:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591638; cv=none; b=rS3TSSnMcKlnz7CkS+BQEb34A2H+JA5hclEmgo24QFMlZw+yejR2Jh4vvPrCGjiUeq5R/ePjI+hsorBWOX/1cTT1YkY1UQ9hjpeJ3sNweEOcbgucoMg50jCxeDPyrxlIRFpZiUvXLKsirRS5aukepIWkEfwuxN0rgRnYAF9tDpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591638; c=relaxed/simple;
	bh=/xbBo8SL7VM2pVT6vwjQEj8Dwtd7sMOmi4O0FJXFyvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sjuzX7Utkc2emwEjnvDcvR6CmiRD4RwshNFKRLIuwJ7hHtbkkmv9HrXzZD1bqdf/Nqzv9JYWas73SLQwm/zIknpnE7zWm545I4rzPyQV7e9Ft8RG5avq8dPZVsLQYhUJHI9neOWkS6mKaelysySuZeGTKzrHo36BhlTGSMFTAaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mmz/Sy9g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mmz/Sy9g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E6A7C4CEF1;
	Mon, 27 Oct 2025 19:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591638;
	bh=/xbBo8SL7VM2pVT6vwjQEj8Dwtd7sMOmi4O0FJXFyvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mmz/Sy9gCnlQBuuWN9GTC6uwUhEBcHsZux9XegggSYPNqWxQ5ReYDtAj/ah+iX+Ky
	 hz5mYaFZ7hBTlmyaZEMusyrttzSSs/2YXfOv/R2PMl3NVjalRYs3LolixusUsEM4dh
	 yLGTATbPUt8XfGro/rDlLtZnqfBJxHKOV+4HV+7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <razor@blackwall.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 274/332] net: rtnetlink: add NLM_F_BULK support to rtnl_fdb_del
Date: Mon, 27 Oct 2025 19:35:27 +0100
Message-ID: <20251027183532.098214039@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

From: Nikolay Aleksandrov <razor@blackwall.org>

[ Upstream commit 9e83425993f38bb89e0ea07849ba0039a748e85b ]

When NLM_F_BULK is specified in a fdb del message we need to handle it
differently. First since this is a new call we can strictly validate the
passed attributes, at first only ifindex and vlan are allowed as these
will be the initially supported filter attributes, any other attribute
is rejected. The mac address is no longer mandatory, but we use it
to error out in older kernels because it cannot be specified with bulk
request (the attribute is not allowed) and then we have to dispatch
the call to ndo_fdb_del_bulk if the device supports it. The del bulk
callback can do further validation of the attributes if necessary.

Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: bf29555f5bdc ("rtnetlink: Allow deleting FDB entries in user namespace")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/rtnetlink.c | 67 +++++++++++++++++++++++++++++++-------------
 1 file changed, 48 insertions(+), 19 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index d861744940c6f..42c97a71174fe 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -4134,22 +4134,34 @@ int ndo_dflt_fdb_del(struct ndmsg *ndm,
 }
 EXPORT_SYMBOL(ndo_dflt_fdb_del);
 
+static const struct nla_policy fdb_del_bulk_policy[NDA_MAX + 1] = {
+	[NDA_VLAN]	= { .type = NLA_U16 },
+	[NDA_IFINDEX]	= NLA_POLICY_MIN(NLA_S32, 1),
+};
+
 static int rtnl_fdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
 			struct netlink_ext_ack *extack)
 {
+	bool del_bulk = !!(nlh->nlmsg_flags & NLM_F_BULK);
 	struct net *net = sock_net(skb->sk);
+	const struct net_device_ops *ops;
 	struct ndmsg *ndm;
 	struct nlattr *tb[NDA_MAX+1];
 	struct net_device *dev;
-	__u8 *addr;
+	__u8 *addr = NULL;
 	int err;
 	u16 vid;
 
 	if (!netlink_capable(skb, CAP_NET_ADMIN))
 		return -EPERM;
 
-	err = nlmsg_parse_deprecated(nlh, sizeof(*ndm), tb, NDA_MAX, NULL,
-				     extack);
+	if (!del_bulk) {
+		err = nlmsg_parse_deprecated(nlh, sizeof(*ndm), tb, NDA_MAX,
+					     NULL, extack);
+	} else {
+		err = nlmsg_parse(nlh, sizeof(*ndm), tb, NDA_MAX,
+				  fdb_del_bulk_policy, extack);
+	}
 	if (err < 0)
 		return err;
 
@@ -4165,9 +4177,12 @@ static int rtnl_fdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
 		return -ENODEV;
 	}
 
-	if (!tb[NDA_LLADDR] || nla_len(tb[NDA_LLADDR]) != ETH_ALEN) {
-		NL_SET_ERR_MSG(extack, "invalid address");
-		return -EINVAL;
+	if (!del_bulk) {
+		if (!tb[NDA_LLADDR] || nla_len(tb[NDA_LLADDR]) != ETH_ALEN) {
+			NL_SET_ERR_MSG(extack, "invalid address");
+			return -EINVAL;
+		}
+		addr = nla_data(tb[NDA_LLADDR]);
 	}
 
 	if (dev->type != ARPHRD_ETHER) {
@@ -4175,8 +4190,6 @@ static int rtnl_fdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
 		return -EINVAL;
 	}
 
-	addr = nla_data(tb[NDA_LLADDR]);
-
 	err = fdb_vid_parse(tb[NDA_VLAN], &vid, extack);
 	if (err)
 		return err;
@@ -4187,10 +4200,16 @@ static int rtnl_fdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if ((!ndm->ndm_flags || ndm->ndm_flags & NTF_MASTER) &&
 	    netif_is_bridge_port(dev)) {
 		struct net_device *br_dev = netdev_master_upper_dev_get(dev);
-		const struct net_device_ops *ops = br_dev->netdev_ops;
 
-		if (ops->ndo_fdb_del)
-			err = ops->ndo_fdb_del(ndm, tb, dev, addr, vid);
+		ops = br_dev->netdev_ops;
+		if (!del_bulk) {
+			if (ops->ndo_fdb_del)
+				err = ops->ndo_fdb_del(ndm, tb, dev, addr, vid);
+		} else {
+			if (ops->ndo_fdb_del_bulk)
+				err = ops->ndo_fdb_del_bulk(ndm, tb, dev, vid,
+							    extack);
+		}
 
 		if (err)
 			goto out;
@@ -4200,15 +4219,24 @@ static int rtnl_fdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	/* Embedded bridge, macvlan, and any other device support */
 	if (ndm->ndm_flags & NTF_SELF) {
-		if (dev->netdev_ops->ndo_fdb_del)
-			err = dev->netdev_ops->ndo_fdb_del(ndm, tb, dev, addr,
-							   vid);
-		else
-			err = ndo_dflt_fdb_del(ndm, tb, dev, addr, vid);
+		ops = dev->netdev_ops;
+		if (!del_bulk) {
+			if (ops->ndo_fdb_del)
+				err = ops->ndo_fdb_del(ndm, tb, dev, addr, vid);
+			else
+				err = ndo_dflt_fdb_del(ndm, tb, dev, addr, vid);
+		} else {
+			/* in case err was cleared by NTF_MASTER call */
+			err = -EOPNOTSUPP;
+			if (ops->ndo_fdb_del_bulk)
+				err = ops->ndo_fdb_del_bulk(ndm, tb, dev, vid,
+							    extack);
+		}
 
 		if (!err) {
-			rtnl_fdb_notify(dev, addr, vid, RTM_DELNEIGH,
-					ndm->ndm_state);
+			if (!del_bulk)
+				rtnl_fdb_notify(dev, addr, vid, RTM_DELNEIGH,
+						ndm->ndm_state);
 			ndm->ndm_flags &= ~NTF_SELF;
 		}
 	}
@@ -5730,7 +5758,8 @@ void __init rtnetlink_init(void)
 	rtnl_register(PF_UNSPEC, RTM_DELLINKPROP, rtnl_dellinkprop, NULL, 0);
 
 	rtnl_register(PF_BRIDGE, RTM_NEWNEIGH, rtnl_fdb_add, NULL, 0);
-	rtnl_register(PF_BRIDGE, RTM_DELNEIGH, rtnl_fdb_del, NULL, 0);
+	rtnl_register(PF_BRIDGE, RTM_DELNEIGH, rtnl_fdb_del, NULL,
+		      RTNL_FLAG_BULK_DEL_SUPPORTED);
 	rtnl_register(PF_BRIDGE, RTM_GETNEIGH, rtnl_fdb_get, rtnl_fdb_dump, 0);
 
 	rtnl_register(PF_BRIDGE, RTM_GETLINK, NULL, rtnl_bridge_getlink, 0);
-- 
2.51.0



