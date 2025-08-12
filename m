Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43E7A26FA77;
	Tue, 12 Aug 2025 19:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026021; cv=none; b=g2oHIY9K2Mci4y0hthwUjO4nttpXj3pThGEJkHJSuHJUkaBqXZCJ3GfN5GC41ScicXr2aATD00dtW24gT1rJ2l713TWpbIQODN2MupFthha5CspTUy7h/dOnOTHAmI8LqV4XIHUyEGKzEuiy3Yh5I3SrZGIHDHdgxEyNOgGo2C8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026021; c=relaxed/simple;
	bh=ZuQ4QVaXLYDRcbZJYmDsWzafe7nA7jol62DkZUDpcxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VSR6ppZhEkMp9Fe6toXGiicF8BXPlQCzhJ+iONiMw4YvA8zuYUVqGg80PDCd/bYrPW5LJqMt0UXkR3rEZB3RNv0wjIByLFn088xZtGMNfQFX818Ep/iLc5OyjHgzCw7BCIy1brJLmBtTmLYQkao/ngeQziZi5ECgJCH2+zcaZ8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q3CMKA1v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q3CMKA1v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A52A1C4CEF6;
	Tue, 12 Aug 2025 19:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026021;
	bh=ZuQ4QVaXLYDRcbZJYmDsWzafe7nA7jol62DkZUDpcxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q3CMKA1vne4yFyRPYfVVjqc0bHzNlK0PlXULy89ub/2N/+AnJ6oreufAHzcmqTVkP
	 1u9jkHOEpvKpQB/5vuFTXwKtZn46g5NcFff1+8AqpggzCwsi94EDuOxBRsw28GCR46
	 C2pnynrRvsgwqXo/oZ5eylWzsisnwN/LXzBDVaAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 213/480] vrf: Drop existing dst reference in vrf_ip6_input_dst
Date: Tue, 12 Aug 2025 19:47:01 +0200
Message-ID: <20250812174406.247669174@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

From: Stanislav Fomichev <sdf@fomichev.me>

[ Upstream commit f388f807eca1de9e6e70f9ffb1a573c3811c4215 ]

Commit ff3fbcdd4724 ("selftests: tc: Add generic erspan_opts matching support
for tc-flower") started triggering the following kmemleak warning:

unreferenced object 0xffff888015fb0e00 (size 512):
  comm "softirq", pid 0, jiffies 4294679065
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 40 d2 85 9e ff ff ff ff  ........@.......
    41 69 59 9d ff ff ff ff 00 00 00 00 00 00 00 00  AiY.............
  backtrace (crc 30b71e8b):
    __kmalloc_noprof+0x359/0x460
    metadata_dst_alloc+0x28/0x490
    erspan_rcv+0x4f1/0x1160 [ip_gre]
    gre_rcv+0x217/0x240 [ip_gre]
    gre_rcv+0x1b8/0x400 [gre]
    ip_protocol_deliver_rcu+0x31d/0x3a0
    ip_local_deliver_finish+0x37d/0x620
    ip_local_deliver+0x174/0x460
    ip_rcv+0x52b/0x6b0
    __netif_receive_skb_one_core+0x149/0x1a0
    process_backlog+0x3c8/0x1390
    __napi_poll.constprop.0+0xa1/0x390
    net_rx_action+0x59b/0xe00
    handle_softirqs+0x22b/0x630
    do_softirq+0xb1/0xf0
    __local_bh_enable_ip+0x115/0x150

vrf_ip6_input_dst unconditionally sets skb dst entry, add a call to
skb_dst_drop to drop any existing entry.

Cc: David Ahern <dsahern@kernel.org>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Fixes: 9ff74384600a ("net: vrf: Handle ipv6 multicast and link-local addresses")
Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
Link: https://patch.msgid.link/20250725160043.350725-1-sdf@fomichev.me
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vrf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index 7168b33adadb..8b12b3ae580d 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -1304,6 +1304,8 @@ static void vrf_ip6_input_dst(struct sk_buff *skb, struct net_device *vrf_dev,
 	struct net *net = dev_net(vrf_dev);
 	struct rt6_info *rt6;
 
+	skb_dst_drop(skb);
+
 	rt6 = vrf_ip6_route_lookup(net, vrf_dev, &fl6, ifindex, skb,
 				   RT6_LOOKUP_F_HAS_SADDR | RT6_LOOKUP_F_IFACE);
 	if (unlikely(!rt6))
-- 
2.39.5



