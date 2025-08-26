Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E53811713;
	Tue, 26 Aug 2025 14:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218713; cv=none; b=Oy105juwiKuns6D55sWldaI/SI6VxSUEyw2d70IpnHz/A2tcuFHRGnmbViPwkwzn9AHhdWltBu+saVSp98a+p1ZVgbH7ZkYe0nxpHCVdcy5HyDLos/xCxQVodt22iz8MRMPh1N9cXN710GSIvSuDGdR89zEc+vWRhxmyo+Vn0kY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218713; c=relaxed/simple;
	bh=jPaxiLJFHLDJfJHLuX5zjb6y+TWHJUNDBgSnXvxuZoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jSRYV0atBrndPe3+gKFMPSavATAgqUiXR0xUFthXKmmoZEpe7F1jfJzzboCU38JqLd5pehexBiwvvSLu9yyRW+txBEwiXxaFpz6LHrw5edu9kVVTZQAovcVmJNq0P1cs5V0r1jPWGkSerUC3g41nSsFRAUALNEDigx8d+iG9N08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c5V6PbWY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c5V6PbWY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 939FDC4CEF1;
	Tue, 26 Aug 2025 14:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218712;
	bh=jPaxiLJFHLDJfJHLuX5zjb6y+TWHJUNDBgSnXvxuZoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c5V6PbWYEKpqvfkC2sMJmQ1UI9OLyzYRitEthnoDX2WSi3UbqBEICMX8OnEdWIJJb
	 F59FTse30QZVZE4vWz3/prBcyEqOgTzOzcLbUP6ZB3a7oEaWyQ92MQaSMRqugOasBN
	 Mk1xJjxm62bA/64tRyEVfbvPqK2gCZNYroIj/Ybw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 104/403] vrf: Drop existing dst reference in vrf_ip6_input_dst
Date: Tue, 26 Aug 2025 13:07:10 +0200
Message-ID: <20250826110909.553264148@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index b51a2367dbaa..8a320300a617 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -1040,6 +1040,8 @@ static void vrf_ip6_input_dst(struct sk_buff *skb, struct net_device *vrf_dev,
 	struct net *net = dev_net(vrf_dev);
 	struct rt6_info *rt6;
 
+	skb_dst_drop(skb);
+
 	rt6 = vrf_ip6_route_lookup(net, vrf_dev, &fl6, ifindex, skb,
 				   RT6_LOOKUP_F_HAS_SADDR | RT6_LOOKUP_F_IFACE);
 	if (unlikely(!rt6))
-- 
2.39.5



