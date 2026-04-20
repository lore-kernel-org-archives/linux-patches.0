Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37EE333EAF9;
	Mon, 20 Apr 2026 16:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700911; cv=none; b=sdokrmi28ZSDt89DeiKzFpRNlZBGQJmqrvMpDvmM20Vx2zlXM6GaNJ6wjRuCfzCV+jc8yqGQmCo6kk8FGHQ1SiiWKKpPbGXDg6Zcp+CDO1zFHhWRjSVyvRC61GzBHCGH5Hqj92M+ACJHOZxS0X72jEKf0JS5lUcUEseidVipQV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700911; c=relaxed/simple;
	bh=mjgi/TAmoYCdHP+8HKjq2ZiKTjwfLrk5+v/qa4NirGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k692Yl3dG2Wh252cwG2G4J+sRp9i20JGzI/9GyMu29cAUuISvDCiRlGk1QIjTSi2xEi9Javs8Xc4l7EuQy95KSjaac1iHe1eQ2nFviYWrz069eKK5V0+9DdGRrKgQSscPC/YcqBlVHlf0g3Ktpm/Vl3WN9BorNzUlbp3y29qxTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=078WdTMp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="078WdTMp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90A24C2BCB4;
	Mon, 20 Apr 2026 16:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700910;
	bh=mjgi/TAmoYCdHP+8HKjq2ZiKTjwfLrk5+v/qa4NirGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=078WdTMpzeWx0KX+G9zQQ8n4GdFP2EDO3so/gZsKjA/VbrYfeaXLcGn13a6OI89Ve
	 Gk3LJJjDbqUkZToJV/2JjoV+xAs2W4Sa5pvNQLV2mJfhcD5eeZNIzvpQ4eq6/ZpXF8
	 OYQiXQqy1RstqsUnpverQlJOoEgjr34raK9nysJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolaos Gkarlis <nickgarlis@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 075/198] rtnetlink: add missing netlink_ns_capable() check for peer netns
Date: Mon, 20 Apr 2026 17:40:54 +0200
Message-ID: <20260420153938.310443939@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolaos Gkarlis <nickgarlis@gmail.com>

[ Upstream commit 7b735ef81286007794a227ce2539419479c02a5f ]

rtnl_newlink() lacks a CAP_NET_ADMIN capability check on the peer
network namespace when creating paired devices (veth, vxcan,
netkit). This allows an unprivileged user with a user namespace
to create interfaces in arbitrary network namespaces, including
init_net.

Add a netlink_ns_capable() check for CAP_NET_ADMIN in the peer
namespace before allowing device creation to proceed.

Fixes: 81adee47dfb6 ("net: Support specifying the network namespace upon device creation.")
Signed-off-by: Nikolaos Gkarlis <nickgarlis@gmail.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260402181432.4126920-1-nickgarlis@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/rtnetlink.c | 40 +++++++++++++++++++++++++++-------------
 1 file changed, 27 insertions(+), 13 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index f3b22d5526fe6..f4ed60bd9a256 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3887,28 +3887,42 @@ static int rtnl_newlink_create(struct sk_buff *skb, struct ifinfomsg *ifm,
 	goto out;
 }
 
-static struct net *rtnl_get_peer_net(const struct rtnl_link_ops *ops,
+static struct net *rtnl_get_peer_net(struct sk_buff *skb,
+				     const struct rtnl_link_ops *ops,
 				     struct nlattr *tbp[],
 				     struct nlattr *data[],
 				     struct netlink_ext_ack *extack)
 {
-	struct nlattr *tb[IFLA_MAX + 1];
+	struct nlattr *tb[IFLA_MAX + 1], **attrs;
+	struct net *net;
 	int err;
 
-	if (!data || !data[ops->peer_type])
-		return rtnl_link_get_net_ifla(tbp);
-
-	err = rtnl_nla_parse_ifinfomsg(tb, data[ops->peer_type], extack);
-	if (err < 0)
-		return ERR_PTR(err);
-
-	if (ops->validate) {
-		err = ops->validate(tb, NULL, extack);
+	if (!data || !data[ops->peer_type]) {
+		attrs = tbp;
+	} else {
+		err = rtnl_nla_parse_ifinfomsg(tb, data[ops->peer_type], extack);
 		if (err < 0)
 			return ERR_PTR(err);
+
+		if (ops->validate) {
+			err = ops->validate(tb, NULL, extack);
+			if (err < 0)
+				return ERR_PTR(err);
+		}
+
+		attrs = tb;
 	}
 
-	return rtnl_link_get_net_ifla(tb);
+	net = rtnl_link_get_net_ifla(attrs);
+	if (IS_ERR_OR_NULL(net))
+		return net;
+
+	if (!netlink_ns_capable(skb, net->user_ns, CAP_NET_ADMIN)) {
+		put_net(net);
+		return ERR_PTR(-EPERM);
+	}
+
+	return net;
 }
 
 static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
@@ -4047,7 +4061,7 @@ static int rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 		}
 
 		if (ops->peer_type) {
-			peer_net = rtnl_get_peer_net(ops, tb, data, extack);
+			peer_net = rtnl_get_peer_net(skb, ops, tb, data, extack);
 			if (IS_ERR(peer_net)) {
 				ret = PTR_ERR(peer_net);
 				goto put_ops;
-- 
2.53.0



