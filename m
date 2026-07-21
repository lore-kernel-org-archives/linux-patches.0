Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C970644AB62;
	Tue, 21 Jul 2026 21:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670842; cv=none; b=pNn1dAhSkzO+06t5vfdyFbd1lzoUbXOcS5NXOOCUV0a8QDABscHhjuSrrQT3sfO0+ZiS7Ol7m64BA/mg2ryqUWRXlyrd6U30gGMSG0/s4zTlfBh6cTxKBSf69rH2N3ChJG6pP/4XT+XdRZi3RPQ0arQ1LQ56/3sygxoTZQpFO6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670842; c=relaxed/simple;
	bh=eBMvWlhpVrIdvNnRX/6iteHLGCc5v3cs8JNU5iWpLpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WjdQ0bu01/zK8ts50Ghr0bIVnmMR32Bh463wz/u5h1mZLPgxifPYzVDTdLXI6TdW35uZm0jprfaF4NQ/n37UIaov+k2LeH7OMt+fINgt8XtxKbeInQQZSTT2pMiuHcP8KMAs8SWk7VQyGtPR4PaFqQv2SEljIpHB3MAeVJAhT4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XtKwZAmZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XtKwZAmZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A9561F000E9;
	Tue, 21 Jul 2026 21:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670841;
	bh=UMdvPK4iWPpn0UoIu7fSp8GgI2NWxZI/ItqB0M/Syck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XtKwZAmZQVre6OYDf7+8w9ssK6zR2LbSSDYRwrlMIBRICQ/hEl6nomXVPOYtI50Ry
	 rgcs9S+z73Xy753ReR4dVG4yMBXZ0bnXDnphpyg+H7zP497oGAhqN5634vFu4XdjT2
	 Dn+ADmlnnf4L/dx2/qvBJT50yewg8iqMUKLWF8uc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiao Liang <shaw.leon@gmail.com>,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 022/843] net: ip_gre: require CAP_NET_ADMIN in the device netns for changelink
Date: Tue, 21 Jul 2026 17:14:17 +0200
Message-ID: <20260721152406.460740757@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maoyi Xie <maoyixie.tju@gmail.com>

[ Upstream commit 8165f7ff57d9667d2bb477ef6af83ede7fed4ad7 ]

A tunnel changelink() operates on at most two netns, dev_net(dev) and
the tunnel link netns t->net. They differ once the device is created in
or moved to a netns other than the one the request runs in. The rtnl
changelink path checks CAP_NET_ADMIN only against dev_net(dev), so a
caller privileged there but not in t->net can rewrite a tunnel that
lives in t->net.

Add rtnl_dev_link_net_capable() next to rtnl_get_net_ns_capable() in
net/core/rtnetlink.c. It requires CAP_NET_ADMIN in the link netns and is
skipped when the link netns is dev_net(dev), where the rtnl path already
checked it. The other patches in this series use the same helper.

Gate ipgre_changelink() and erspan_changelink() with it, at the top of
the op before any attribute is parsed, because the parsers update live
tunnel fields first. ipgre_netlink_parms() sets t->collect_md before
ip_tunnel_changelink() runs.

Commit 8b484efd5cb4 ("ip6: vti: Use ip6_tnl.net in
vti6_siocdevprivate().") added the same check on the ioctl path. This
adds it on RTM_NEWLINK.

Reported-by: Xiao Liang <shaw.leon@gmail.com>
Closes: https://lore.kernel.org/netdev/CABAhCOSzP1vaThGV35_VnsRCb=87_CPjPVsTHbq905k8A+BuUg@mail.gmail.com/
Fixes: b57708add314 ("gre: add x-netns support")
Cc: stable@vger.kernel.org
Signed-off-by: Maoyi Xie <maoyixie.tju@gmail.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260612085941.3158249-2-maoyixie.tju@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/rtnetlink.h |    2 ++
 net/core/rtnetlink.c    |    8 ++++++++
 net/ipv4/ip_gre.c       |    6 ++++++
 3 files changed, 16 insertions(+)

--- a/include/net/rtnetlink.h
+++ b/include/net/rtnetlink.h
@@ -209,6 +209,8 @@ int rtnl_configure_link(struct net_devic
 int rtnl_nla_parse_ifinfomsg(struct nlattr **tb, const struct nlattr *nla_peer,
 			     struct netlink_ext_ack *exterr);
 struct net *rtnl_get_net_ns_capable(struct sock *sk, int netnsid);
+bool rtnl_dev_link_net_capable(const struct net_device *dev,
+			       const struct net *link_net);
 
 #define MODULE_ALIAS_RTNL_LINK(kind) MODULE_ALIAS("rtnl-link-" kind)
 
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2065,6 +2065,14 @@ struct net *rtnl_get_net_ns_capable(stru
 }
 EXPORT_SYMBOL_GPL(rtnl_get_net_ns_capable);
 
+bool rtnl_dev_link_net_capable(const struct net_device *dev,
+			       const struct net *link_net)
+{
+	return net_eq(link_net, dev_net(dev)) ||
+	       ns_capable(link_net->user_ns, CAP_NET_ADMIN);
+}
+EXPORT_SYMBOL_GPL(rtnl_dev_link_net_capable);
+
 static int rtnl_valid_dump_ifinfo_req(const struct nlmsghdr *nlh,
 				      bool strict_check, struct nlattr **tb,
 				      struct netlink_ext_ack *extack)
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -1412,6 +1412,9 @@ static int ipgre_changelink(struct net_d
 	struct ip_tunnel_parm p;
 	int err;
 
+	if (!rtnl_dev_link_net_capable(dev, t->net))
+		return -EPERM;
+
 	err = ipgre_newlink_encap_setup(dev, data);
 	if (err)
 		return err;
@@ -1441,6 +1444,9 @@ static int erspan_changelink(struct net_
 	struct ip_tunnel_parm p;
 	int err;
 
+	if (!rtnl_dev_link_net_capable(dev, t->net))
+		return -EPERM;
+
 	err = ipgre_newlink_encap_setup(dev, data);
 	if (err)
 		return err;


