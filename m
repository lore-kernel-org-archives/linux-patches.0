Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47B22163AE;
	Thu, 12 Dec 2024 15:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015862; cv=none; b=VY8bgPj+xfk33zukKdngay7ObeXTT+LOVPhtV+TlltwOOxpV/oeM6ILQ5Kj0pSoAIsgIi0J1QC/JUwEYzen6FnwtTMif434b/7YeFZKTtDU33YkT8gzgIX0jDecAgGXgoVTUhMQTY+3WkTJqk9DaLwkmX6Oi/lGCIueGfLu5/tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015862; c=relaxed/simple;
	bh=H/WS0i2f++3St1U77bM8apR39w2b22ItLtS+uPHem/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RcL1SKf8RXfb1OrWyQgTMUdFpdIDXNnyEt8LnLgcM9VK/Lzgc4iK6qh4opSAT77vUHjmqpKcJeXeNKYLMoHDdi1qFe69Bx2Cpi898PCgxXRaF6QARBDOLHvYPSakvFRbxG1BIhHaWmVK4JqMEiJPqtM4EnMx84Ig/o9wKrxMr1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f6yAFZ7I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f6yAFZ7I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1706C4CED4;
	Thu, 12 Dec 2024 15:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734015862;
	bh=H/WS0i2f++3St1U77bM8apR39w2b22ItLtS+uPHem/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f6yAFZ7IPcT2E3hegizklb71UroL3swpS0YCiSbfFUXUS54VJCfH4HpoeHoC+i7Sb
	 Xd3H/lt5o/fRoVW1pOyoJY8BRmiRU9hStVWvXQyj9xlnPZDXpwaD+JTovCXaQ5wwA/
	 b9AvIBAtxtSwkbqAM3YEAMBpUVJTmAdYkfRTMOrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dong Chenchen <dongchenchen2@huawei.com>,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 025/466] net: Fix icmp host relookup triggering ip_rt_bug
Date: Thu, 12 Dec 2024 15:53:14 +0100
Message-ID: <20241212144307.684711664@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dong Chenchen <dongchenchen2@huawei.com>

[ Upstream commit c44daa7e3c73229f7ac74985acb8c7fb909c4e0a ]

arp link failure may trigger ip_rt_bug while xfrm enabled, call trace is:

WARNING: CPU: 0 PID: 0 at net/ipv4/route.c:1241 ip_rt_bug+0x14/0x20
Modules linked in:
CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 6.12.0-rc6-00077-g2e1b3cc9d7f7
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
RIP: 0010:ip_rt_bug+0x14/0x20
Call Trace:
 <IRQ>
 ip_send_skb+0x14/0x40
 __icmp_send+0x42d/0x6a0
 ipv4_link_failure+0xe2/0x1d0
 arp_error_report+0x3c/0x50
 neigh_invalidate+0x8d/0x100
 neigh_timer_handler+0x2e1/0x330
 call_timer_fn+0x21/0x120
 __run_timer_base.part.0+0x1c9/0x270
 run_timer_softirq+0x4c/0x80
 handle_softirqs+0xac/0x280
 irq_exit_rcu+0x62/0x80
 sysvec_apic_timer_interrupt+0x77/0x90

The script below reproduces this scenario:
ip xfrm policy add src 0.0.0.0/0 dst 0.0.0.0/0 \
	dir out priority 0 ptype main flag localok icmp
ip l a veth1 type veth
ip a a 192.168.141.111/24 dev veth0
ip l s veth0 up
ping 192.168.141.155 -c 1

icmp_route_lookup() create input routes for locally generated packets
while xfrm relookup ICMP traffic.Then it will set input route
(dst->out = ip_rt_bug) to skb for DESTUNREACH.

For ICMP err triggered by locally generated packets, dst->dev of output
route is loopback. Generally, xfrm relookup verification is not required
on loopback interfaces (net.ipv4.conf.lo.disable_xfrm = 1).

Skip icmp relookup for locally generated packets to fix it.

Fixes: 8b7817f3a959 ("[IPSEC]: Add ICMP host relookup support")
Signed-off-by: Dong Chenchen <dongchenchen2@huawei.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20241127040850.1513135-1-dongchenchen2@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/icmp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index e1384e7331d82..c3ad41573b33e 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -519,6 +519,9 @@ static struct rtable *icmp_route_lookup(struct net *net,
 	if (!IS_ERR(dst)) {
 		if (rt != rt2)
 			return rt;
+		if (inet_addr_type_dev_table(net, route_lookup_dev,
+					     fl4->daddr) == RTN_LOCAL)
+			return rt;
 	} else if (PTR_ERR(dst) == -EPERM) {
 		rt = NULL;
 	} else {
-- 
2.43.0



