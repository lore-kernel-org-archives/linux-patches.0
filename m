Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF3043C04D;
	Mon, 20 Apr 2026 13:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691790; cv=none; b=M8O2xOPLMuE2a426ciiYdpaqxCencbMJExm5LppAdsJ9HMXeE408OrIbh91u9vObriptJdrqi5BX82GBZShP6MeuvyFg+in68+ZoKJO2+NDS+kP8Zrnt9pAAG+/Egfx19BeTedk15othxLFF/i/+Jkewi9crqi0lnAqzDco7Efo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691790; c=relaxed/simple;
	bh=ENPWtoaRZ6I1Cp8jOxId7RI33mNaSVg5gJ18TA5yeBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZQqBFkLTLmWtww6lAwkVEOirufFkK7Z/P0UUBd50VhN222ISXNkyCbxY/mcpI+l46E8aC+Tq9HM15XndatPcmn+kXI5jbYi6Oouyw76aKcohvt90NwwS7s0TwYCgz8NxByrcQNfxM0FRtE6O6l62DB4FyZRkww6JTS2FJ0Mimqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DzKp3L8c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DzKp3L8c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C084BC2BCB9;
	Mon, 20 Apr 2026 13:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691790;
	bh=ENPWtoaRZ6I1Cp8jOxId7RI33mNaSVg5gJ18TA5yeBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DzKp3L8cxI799QzVEJgkXb4+w/TcsVeu1B9DdT8Wwo0yRlFodZBbxz4jkhA8ciza4
	 t2V9ACVsmKz8HGOopEgBQ1aK9kvkNTFz0pRTbTl/e86m5wG1Ar9/Ld2VnM06D/epTL
	 8mqSMQQ7cCM2ue+M5nG1Aomm3Ri0nsnev7zlB6v4RvZuv68ZUYFZiJS8JZmsY2gzYv
	 TYF1KqGax+E7xmqH4VYlG/WmqvddYWIRd4Nb3ESwGJm+k4TnbPsB/LXNeb4p2YpCZK
	 vyW4xDDrWU6Yu4Exst4mmsJ95cL56WuLtDYmRxtmQOR+vQuXI26uXUiHWd76EFfsq7
	 EnTg57jEtaIXA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Nikolaos Gkarlis <nickgarlis@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	ebiederm@aristanetworks.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] rtnetlink: add missing netlink_ns_capable() check for peer netns
Date: Mon, 20 Apr 2026 09:19:49 -0400
Message-ID: <20260420132314.1023554-195-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

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

