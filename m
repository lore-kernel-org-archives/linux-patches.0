Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E4D611A
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:42:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6378C433C8;
	Mon, 28 Aug 2023 10:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693219351;
	bh=verYMXFD0Bvv/u4cflhntJtSEOpYiBSoQSGP2GAdvwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LR0o+az/IYAex1aIKx0mvzBoGKlOExTCShfDAko91o4nSCjG4O2U1QP9aB8puVT9G
	 W12QvGyYg8IRsJTp1ezayO5tRWMnlJ7RTwJJXgLf29FKSh8/MCO02vOxSaO9CQl124
	 68gTWitA2EG0harzy8l+c0a3fI8PRJ7137Qud1nU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5ba06978f34abb058571@syzkaller.appspotmail.com,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 125/158] net: validate veth and vxcan peer ifindexes
Date: Mon, 28 Aug 2023 12:13:42 +0200
Message-ID: <20230828101201.593592580@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101157.322319621@linuxfoundation.org>
References: <20230828101157.322319621@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit f534f6581ec084fe94d6759f7672bd009794b07e ]

veth and vxcan need to make sure the ifindexes of the peer
are not negative, core does not validate this.

Using iproute2 with user-space-level checking removed:

Before:

  # ./ip link add index 10 type veth peer index -1
  # ip link show
  1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
  2: enp1s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether 52:54:00:74:b2:03 brd ff:ff:ff:ff:ff:ff
  10: veth1@veth0: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether 8a:90:ff:57:6d:5d brd ff:ff:ff:ff:ff:ff
  -1: veth0@veth1: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether ae:ed:18:e6:fa:7f brd ff:ff:ff:ff:ff:ff

Now:

  $ ./ip link add index 10 type veth peer index -1
  Error: ifindex can't be negative.

This problem surfaced in net-next because an explicit WARN()
was added, the root cause is older.

Fixes: e6f8f1a739b6 ("veth: Allow to create peer link with given ifindex")
Fixes: a8f820a380a2 ("can: add Virtual CAN Tunnel driver (vxcan)")
Reported-by: syzbot+5ba06978f34abb058571@syzkaller.appspotmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/vxcan.c |  7 +------
 drivers/net/veth.c      |  5 +----
 include/net/rtnetlink.h |  4 ++--
 net/core/rtnetlink.c    | 22 ++++++++++++++++++----
 4 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/drivers/net/can/vxcan.c b/drivers/net/can/vxcan.c
index 282c53ef76d23..1bfede407270d 100644
--- a/drivers/net/can/vxcan.c
+++ b/drivers/net/can/vxcan.c
@@ -179,12 +179,7 @@ static int vxcan_newlink(struct net *net, struct net_device *dev,
 
 		nla_peer = data[VXCAN_INFO_PEER];
 		ifmp = nla_data(nla_peer);
-		err = rtnl_nla_parse_ifla(peer_tb,
-					  nla_data(nla_peer) +
-					  sizeof(struct ifinfomsg),
-					  nla_len(nla_peer) -
-					  sizeof(struct ifinfomsg),
-					  NULL);
+		err = rtnl_nla_parse_ifinfomsg(peer_tb, nla_peer, extack);
 		if (err < 0)
 			return err;
 
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 683425e3a353c..a6445bba4f942 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1255,10 +1255,7 @@ static int veth_newlink(struct net *src_net, struct net_device *dev,
 
 		nla_peer = data[VETH_INFO_PEER];
 		ifmp = nla_data(nla_peer);
-		err = rtnl_nla_parse_ifla(peer_tb,
-					  nla_data(nla_peer) + sizeof(struct ifinfomsg),
-					  nla_len(nla_peer) - sizeof(struct ifinfomsg),
-					  NULL);
+		err = rtnl_nla_parse_ifinfomsg(peer_tb, nla_peer, extack);
 		if (err < 0)
 			return err;
 
diff --git a/include/net/rtnetlink.h b/include/net/rtnetlink.h
index 4da61c950e931..5c2a73bbfabee 100644
--- a/include/net/rtnetlink.h
+++ b/include/net/rtnetlink.h
@@ -166,8 +166,8 @@ struct net_device *rtnl_create_link(struct net *net, const char *ifname,
 int rtnl_delete_link(struct net_device *dev);
 int rtnl_configure_link(struct net_device *dev, const struct ifinfomsg *ifm);
 
-int rtnl_nla_parse_ifla(struct nlattr **tb, const struct nlattr *head, int len,
-			struct netlink_ext_ack *exterr);
+int rtnl_nla_parse_ifinfomsg(struct nlattr **tb, const struct nlattr *nla_peer,
+			     struct netlink_ext_ack *exterr);
 struct net *rtnl_get_net_ns_capable(struct sock *sk, int netnsid);
 
 #define MODULE_ALIAS_RTNL_LINK(kind) MODULE_ALIAS("rtnl-link-" kind)
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 3eaf7c706b0ec..3dfdf83e6e45f 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2034,13 +2034,27 @@ static int rtnl_dump_ifinfo(struct sk_buff *skb, struct netlink_callback *cb)
 	return err;
 }
 
-int rtnl_nla_parse_ifla(struct nlattr **tb, const struct nlattr *head, int len,
-			struct netlink_ext_ack *exterr)
+int rtnl_nla_parse_ifinfomsg(struct nlattr **tb, const struct nlattr *nla_peer,
+			     struct netlink_ext_ack *exterr)
 {
-	return nla_parse_deprecated(tb, IFLA_MAX, head, len, ifla_policy,
+	const struct ifinfomsg *ifmp;
+	const struct nlattr *attrs;
+	size_t len;
+
+	ifmp = nla_data(nla_peer);
+	attrs = nla_data(nla_peer) + sizeof(struct ifinfomsg);
+	len = nla_len(nla_peer) - sizeof(struct ifinfomsg);
+
+	if (ifmp->ifi_index < 0) {
+		NL_SET_ERR_MSG_ATTR(exterr, nla_peer,
+				    "ifindex can't be negative");
+		return -EINVAL;
+	}
+
+	return nla_parse_deprecated(tb, IFLA_MAX, attrs, len, ifla_policy,
 				    exterr);
 }
-EXPORT_SYMBOL(rtnl_nla_parse_ifla);
+EXPORT_SYMBOL(rtnl_nla_parse_ifinfomsg);
 
 struct net *rtnl_link_get_net(struct net *src_net, struct nlattr *tb[])
 {
-- 
2.40.1



