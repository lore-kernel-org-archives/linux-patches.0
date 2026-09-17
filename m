Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E7715A5158;
	Thu, 17 Sep 2026 15:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658836; cv=none; b=qigru9yK/KmX/qcYghrWAn2YZBAoYCptu5QdPNFuBw0K1BgN3LhPvm4ik+Jy3Zbrtb9y0xz8BmQ//p82uEd5Qjnw58BBmZdBpeoZtazK3z9iF1zR3nzvqTXo+2TmlDiv0albLKVe+bPWUUBy8viYMiCfH8tHPBCF5qUFF0hLN7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658836; c=relaxed/simple;
	bh=KyZ/zcimaVD8odwXzeNw2fDPnHmF2dezLHnmaVcLh2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=npN82ibYI/IfgFbtrBMyOjtthpp/Jm0VbcMDhxmtAH4LroEpfnax76uMrQSlSNBApYR86RNgMZ60e9S7w+ZEZYTmVeIBbLBSmJnY3GUkMJ9uoux/W48k+vxpQrRkt9fsQM3K+gJO8pRy8h2iZhAE/Qd/J2wTr+8QoydBm7RLA9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0uWvNj+B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0uWvNj+B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D2061F000FF;
	Thu, 17 Sep 2026 15:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658823;
	bh=FqmJc4uLwGUKCIxctcjDU0+EvNhsPXCcZnpKdsfRBC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0uWvNj+BJ3KwyLJDSCPJ0jeZNu0ZTv92YewjQaurju9ctMCHXUgLYbT4KX5er/sfV
	 q5ahi3j52bnuYi5ktn3aaYZH2MK35c/CRDYy19CGnEXEa4362JEGrlruXECSKjpc8a
	 1HQuLaR7R50RIKZIDdL+dJg6UEodfdYZxzpT7H3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6d2762674103618994b0@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Peilin He <he.peilin@zte.com.cn>,
	xu xin <xu.xin16@zte.com.cn>,
	Steven Rostedt <rostedt@goodmis.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 052/733] net: icmp: avoid invalid transport header access in icmp_send tracepoint
Date: Thu, 17 Sep 2026 16:06:00 +0100
Message-ID: <20260917151352.083783757@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 7fcc2fe39fed1cb98a7374a113ff3800e8f9af80 ]

syzbot reported a WARNING triggered by DEBUG_NET_WARN_ON_ONCE():

 WARNING: at skb_transport_header include/linux/skbuff.h:3087 [inline]
 WARNING: at udp_hdr include/linux/udp.h:23 [inline]
 WARNING: at do_trace_event_raw_event_icmp_send include/trace/events/icmp.h:30 [inline]
 WARNING: at trace_event_raw_event_icmp_send+0x48c/0x6ec include/trace/events/icmp.h:11
 Call trace:
  skb_transport_header include/linux/skbuff.h:3087 [inline]
  udp_hdr include/linux/udp.h:23 [inline]
  do_trace_event_raw_event_icmp_send include/trace/events/icmp.h:30 [inline]
  trace_event_raw_event_icmp_send+0x48c/0x6ec include/trace/events/icmp.h:11
  __traceiter_icmp_send include/trace/events/icmp.h:11 [inline]
  __do_trace_icmp_send include/trace/events/icmp.h:11 [inline]
  trace_icmp_send+0x320/0x49c include/trace/events/icmp.h:11
  __icmp_send+0xcfc/0x11d8 net/ipv4/icmp.c:1013
  ipv4_send_dest_unreach net/ipv4/route.c:1280 [inline]
  ipv4_link_failure+0x57c/0x8dc net/ipv4/route.c:1287
  dst_link_failure include/net/dst.h:438 [inline]
  vti_tunnel_xmit+0xe40/0x17a4 net/ipv4/ip_vti.c:307

TP_fast_assign() unconditionally calls udp_hdr(skb) before checking
whether the packet is UDP. Furthermore, __icmp_send() can be invoked
from paths (e.g., link failures, ARP errors, forwarding, AF_PACKET)
where skb->transport_header was never initialized (~0U).

Under CONFIG_DEBUG_NET=y, calling skb_transport_header(skb) triggers
DEBUG_NET_WARN_ON_ONCE(!skb_transport_header_was_set(skb)).

Fix this by:
1. Only parsing transport info when iph->protocol == IPPROTO_UDP.
2. Using skb_header_pointer() at skb_network_offset(skb) + (iph->ihl << 2)
   to safely fetch the UDP header without assuming transport_header is set.

Fixes: db3efdcf70c7 ("net/ipv4: add tracepoint for icmp_send")
Reported-by: syzbot+6d2762674103618994b0@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/6a8d5538.91706f20.ef82.0009.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Peilin He <he.peilin@zte.com.cn>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Steven Rostedt <rostedt@goodmis.org>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20260825084551.1562967-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/icmp.h | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/include/trace/events/icmp.h b/include/trace/events/icmp.h
index 31559796949a7..acfcf2b132d60 100644
--- a/include/trace/events/icmp.h
+++ b/include/trace/events/icmp.h
@@ -27,17 +27,20 @@ TRACE_EVENT(icmp_send,
 
 		TP_fast_assign(
 			struct iphdr *iph = ip_hdr(skb);
-			struct udphdr *uh = udp_hdr(skb);
-			int proto_4 = iph->protocol;
+			struct udphdr _uh, *uh = NULL;
 			__be32 *p32;
 
 			__entry->skbaddr = skb;
 			__entry->type = type;
 			__entry->code = code;
 
-			if (proto_4 != IPPROTO_UDP || (u8 *)uh < skb->head ||
-				(u8 *)uh + sizeof(struct udphdr)
-				> skb_tail_pointer(skb)) {
+			if (iph->protocol == IPPROTO_UDP)
+				uh = skb_header_pointer(skb,
+							skb_network_offset(skb) +
+							(iph->ihl << 2),
+							sizeof(_uh), &_uh);
+
+			if (!uh) {
 				__entry->sport = 0;
 				__entry->dport = 0;
 				__entry->ulen = 0;
-- 
2.53.0



