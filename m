Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C09E2E8E10;
	Tue, 17 Jun 2025 16:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179020; cv=none; b=d5+XzZ7Ba4SJkbEMd4nuXEcOSotNqnFbQEAjAxIUADLh9PrGnODCzhyqjWjSvYmlyBw0dK70FDd498VG6GjF71X7rYqH+FYxwRM704HhFYoy2KEvYB5SO67+Hg1zdIwa8VDjyOmBed4kZFU1jfscQb8p4PW5bkBp5kqdMBeIkyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179020; c=relaxed/simple;
	bh=AcpKWJhbOK8ZdmgJqwhA6pLzc+EUqcdgG0XI52VpXQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fSIj+E6HwCdCPvQhAFLiXZlq9f4EghwOlzXujA3goT/hicgJe1KgpRq1bqX0KAq6IuIpnJAGrnKW+6bysOMVTIfeNDh1tHO7fWCaJnju0e1DuG2FzncS/eDPyCX2nyKCCAbJcIQFFe5cSoTixVIvBihXdVmjV4Fn8Tufw1n9f9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Xle2Hin; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Xle2Hin"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED3E8C4CEE3;
	Tue, 17 Jun 2025 16:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179020;
	bh=AcpKWJhbOK8ZdmgJqwhA6pLzc+EUqcdgG0XI52VpXQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Xle2HineTmlLvjcOX0A5Wer4YpSjuRl3G8wADoTrUFml5xcK8o+5iazYx9K/yUED
	 QLHfFmVlB5zGV+XEDXKQCT7xr7SilZfFry39JABx1dky5vjpwStqq6OF3f6jbPlin3
	 ab0ixLTv5SsFVnZBEqj5hw0oWUaBHeNkdSc10t+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9fc858ba0312b42b577e@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 624/780] net: prevent a NULL deref in rtnl_create_link()
Date: Tue, 17 Jun 2025 17:25:32 +0200
Message-ID: <20250617152516.885595263@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit feafc73f3e6ae73371777a037d41d2e31c929636 ]

At the time rtnl_create_link() is running, dev->netdev_ops is NULL,
we must not use netdev_lock_ops() or risk a NULL deref if
CONFIG_NET_SHAPER is defined.

Use netif_set_group() instead of dev_set_group().

 RIP: 0010:netdev_need_ops_lock include/net/netdev_lock.h:33 [inline]
 RIP: 0010:netdev_lock_ops include/net/netdev_lock.h:41 [inline]
 RIP: 0010:dev_set_group+0xc0/0x230 net/core/dev_api.c:82
Call Trace:
 <TASK>
  rtnl_create_link+0x748/0xd10 net/core/rtnetlink.c:3674
  rtnl_newlink_create+0x25c/0xb00 net/core/rtnetlink.c:3813
  __rtnl_newlink net/core/rtnetlink.c:3940 [inline]
  rtnl_newlink+0x16d6/0x1c70 net/core/rtnetlink.c:4055
  rtnetlink_rcv_msg+0x7cf/0xb70 net/core/rtnetlink.c:6944
  netlink_rcv_skb+0x208/0x470 net/netlink/af_netlink.c:2534
  netlink_unicast_kernel net/netlink/af_netlink.c:1313 [inline]
  netlink_unicast+0x75b/0x8d0 net/netlink/af_netlink.c:1339
  netlink_sendmsg+0x805/0xb30 net/netlink/af_netlink.c:1883
  sock_sendmsg_nosec net/socket.c:712 [inline]

Reported-by: syzbot+9fc858ba0312b42b577e@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/6840265f.a00a0220.d4325.0009.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Fixes: 7e4d784f5810 ("net: hold netdev instance lock during rtnetlink operations")
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Link: https://patch.msgid.link/20250604105815.1516973-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/rtnetlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index c5a7f41982a57..fc6815ad78266 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3681,7 +3681,7 @@ struct net_device *rtnl_create_link(struct net *net, const char *ifname,
 	if (tb[IFLA_LINKMODE])
 		dev->link_mode = nla_get_u8(tb[IFLA_LINKMODE]);
 	if (tb[IFLA_GROUP])
-		dev_set_group(dev, nla_get_u32(tb[IFLA_GROUP]));
+		netif_set_group(dev, nla_get_u32(tb[IFLA_GROUP]));
 	if (tb[IFLA_GSO_MAX_SIZE])
 		netif_set_gso_max_size(dev, nla_get_u32(tb[IFLA_GSO_MAX_SIZE]));
 	if (tb[IFLA_GSO_MAX_SEGS])
-- 
2.39.5



