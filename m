Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D343446CA;
	Wed,  8 Apr 2026 18:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671714; cv=none; b=Vr5Fj5/TPfR83t1hRKkXBT7JRBBNk3ylQFGHx2H9p/T+wH/tQfwuUN9voqwGdzQqcCeRWyynkvkHHwUPCs8SxuKoPXLHsB3/EnqJ9AYXGifBH2McAC7jbPkLRqY0Mn8fyAPqluDSPXbfCoG5O3JNsjp6e61fckBx8+cAMFae10A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671714; c=relaxed/simple;
	bh=oSXuN8OlSb3B9LbsH2qBdHxnG+VANXyEA9RGXZZDB7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SlUd/eCwRd8jkeSrPJ8RFl5nIM+L/nEU/C0mX3xCHkH/C9HUVstR9T1p6BRXUVXszucNqEMPpotAKrbMX66u/3HWFRXHbjaWO4dMRj8VbuOglMw/h51jFvYutA/l2jKfPXLKVxCoQxeCsjOKYEYBS4LFwqmPoyC7H4s5qHypp5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UkfRFhVn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UkfRFhVn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E56EAC19421;
	Wed,  8 Apr 2026 18:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671714;
	bh=oSXuN8OlSb3B9LbsH2qBdHxnG+VANXyEA9RGXZZDB7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UkfRFhVn/qQoI+Qg81wLpGlAQQ4V01+Ljr9qcLylfYKHV7UTcprCH6SZTPQuGvuLb
	 eoVCVCeLiF+1AW+52UXye3zBjzbMwjHbFqPD6vWDtzEznWQ4dHA0qSULAR1cIqjltB
	 M4MUQNXwUn/F8cf3sDh4jjP5oUjjmX5sc7nexKFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Nault <gnault@redhat.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 039/312] rtnetlink: Honour NLM_F_ECHO flag in rtnl_delete_link
Date: Wed,  8 Apr 2026 19:59:16 +0200
Message-ID: <20260408175935.191684586@linuxfoundation.org>
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

[ Upstream commit f3a63cce1b4fbde7738395c5a2dea83f05de3407 ]

This patch use the new helper unregister_netdevice_many_notify() for
rtnl_delete_link(), so that the kernel could reply unicast when userspace
 set NLM_F_ECHO flag to request the new created interface info.

At the same time, the parameters of rtnl_delete_link() need to be updated
since we need nlmsghdr and portid info.

Suggested-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 6931d21f87bc ("openvswitch: defer tunnel netdev_put to RCU release")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/rtnetlink.h        | 2 +-
 net/core/rtnetlink.c           | 7 ++++---
 net/openvswitch/vport-geneve.c | 2 +-
 net/openvswitch/vport-gre.c    | 2 +-
 net/openvswitch/vport-netdev.c | 2 +-
 net/openvswitch/vport-vxlan.c  | 2 +-
 6 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/include/net/rtnetlink.h b/include/net/rtnetlink.h
index ad8786c9777c9..0bd400be3f8d9 100644
--- a/include/net/rtnetlink.h
+++ b/include/net/rtnetlink.h
@@ -203,7 +203,7 @@ struct net_device *rtnl_create_link(struct net *net, const char *ifname,
 				    const struct rtnl_link_ops *ops,
 				    struct nlattr *tb[],
 				    struct netlink_ext_ack *extack);
-int rtnl_delete_link(struct net_device *dev);
+int rtnl_delete_link(struct net_device *dev, u32 portid, const struct nlmsghdr *nlh);
 int rtnl_configure_link(struct net_device *dev, const struct ifinfomsg *ifm,
 			u32 portid, const struct nlmsghdr *nlh);
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 73453a92ea492..78e39543e408b 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3162,7 +3162,7 @@ static int rtnl_group_dellink(const struct net *net, int group)
 	return 0;
 }
 
-int rtnl_delete_link(struct net_device *dev)
+int rtnl_delete_link(struct net_device *dev, u32 portid, const struct nlmsghdr *nlh)
 {
 	const struct rtnl_link_ops *ops;
 	LIST_HEAD(list_kill);
@@ -3172,7 +3172,7 @@ int rtnl_delete_link(struct net_device *dev)
 		return -EOPNOTSUPP;
 
 	ops->dellink(dev, &list_kill);
-	unregister_netdevice_many(&list_kill);
+	unregister_netdevice_many_notify(&list_kill, portid, nlh);
 
 	return 0;
 }
@@ -3182,6 +3182,7 @@ static int rtnl_dellink(struct sk_buff *skb, struct nlmsghdr *nlh,
 			struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
+	u32 portid = NETLINK_CB(skb).portid;
 	struct net *tgt_net = net;
 	struct net_device *dev = NULL;
 	struct ifinfomsg *ifm;
@@ -3223,7 +3224,7 @@ static int rtnl_dellink(struct sk_buff *skb, struct nlmsghdr *nlh,
 		goto out;
 	}
 
-	err = rtnl_delete_link(dev);
+	err = rtnl_delete_link(dev, portid, nlh);
 
 out:
 	if (netnsid >= 0)
diff --git a/net/openvswitch/vport-geneve.c b/net/openvswitch/vport-geneve.c
index 89a8e1501809f..b10e1602c6b14 100644
--- a/net/openvswitch/vport-geneve.c
+++ b/net/openvswitch/vport-geneve.c
@@ -91,7 +91,7 @@ static struct vport *geneve_tnl_create(const struct vport_parms *parms)
 
 	err = dev_change_flags(dev, dev->flags | IFF_UP, NULL);
 	if (err < 0) {
-		rtnl_delete_link(dev);
+		rtnl_delete_link(dev, 0, NULL);
 		rtnl_unlock();
 		ovs_vport_free(vport);
 		goto error;
diff --git a/net/openvswitch/vport-gre.c b/net/openvswitch/vport-gre.c
index e6b5e76a962a6..4014c9b5eb798 100644
--- a/net/openvswitch/vport-gre.c
+++ b/net/openvswitch/vport-gre.c
@@ -57,7 +57,7 @@ static struct vport *gre_tnl_create(const struct vport_parms *parms)
 
 	err = dev_change_flags(dev, dev->flags | IFF_UP, NULL);
 	if (err < 0) {
-		rtnl_delete_link(dev);
+		rtnl_delete_link(dev, 0, NULL);
 		rtnl_unlock();
 		ovs_vport_free(vport);
 		return ERR_PTR(err);
diff --git a/net/openvswitch/vport-netdev.c b/net/openvswitch/vport-netdev.c
index 5bae7ca4abbc0..18376e10aeedc 100644
--- a/net/openvswitch/vport-netdev.c
+++ b/net/openvswitch/vport-netdev.c
@@ -188,7 +188,7 @@ void ovs_netdev_tunnel_destroy(struct vport *vport)
 	 * if it's not already shutting down.
 	 */
 	if (vport->dev->reg_state == NETREG_REGISTERED)
-		rtnl_delete_link(vport->dev);
+		rtnl_delete_link(vport->dev, 0, NULL);
 	netdev_put(vport->dev, &vport->dev_tracker);
 	vport->dev = NULL;
 	rtnl_unlock();
diff --git a/net/openvswitch/vport-vxlan.c b/net/openvswitch/vport-vxlan.c
index 188e9c1360a12..0b881b043bcf4 100644
--- a/net/openvswitch/vport-vxlan.c
+++ b/net/openvswitch/vport-vxlan.c
@@ -120,7 +120,7 @@ static struct vport *vxlan_tnl_create(const struct vport_parms *parms)
 
 	err = dev_change_flags(dev, dev->flags | IFF_UP, NULL);
 	if (err < 0) {
-		rtnl_delete_link(dev);
+		rtnl_delete_link(dev, 0, NULL);
 		rtnl_unlock();
 		ovs_vport_free(vport);
 		goto error;
-- 
2.51.0



