Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC63369D61;
	Wed, 20 May 2026 16:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294912; cv=none; b=M6kwmhONRtnJnz/wbOVJb/lkxju1cN9i5zQqkC+APBwc4sf6c+yh83hJ9O/ICAO0QOZSnbSLil+1gSVcgZvD80Qd5DwogBV/X1YEA1+siI44yQ5K+ahLHS+qI9GGDNY8pCTtu9OGHgeIaxwT9/axv2h0TnwjZY2zMDpMI4I6Fpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294912; c=relaxed/simple;
	bh=mBW2a7XfraUjqgPEzL8wRslbNNOA/Tl9+9gFt4QHK0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZJDo5N30USfK16c3IC4twkp2hNrRH0rcv99EqYJLSkqdxtvM9JGzg66VTaTBNUBKX0HTia0Oys1fAV9FnKlrLv/zMzQaS7/ESjTXi+DdIhhdRLWV5A0dNCeFic3nT83WCq/ceC5JPSEi2uwYdwaylLUK7bBh27ExnU5M24+o4tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mNoY3Dii; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mNoY3Dii"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A8671F000E9;
	Wed, 20 May 2026 16:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294911;
	bh=GcagG/Bdyc1tIAS1E3sExTDU422Nn3cxahpRGI49Ihs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mNoY3Dii7RNw8wMkV7eFe7MSy0N4Ls6TDuYUWNO9ejQt8qtlYNEYNpDzcgPdr9c9a
	 R/1HwEikyabVKmQ4QN98cCzL9FNG3AVcaR7r+yVp8iFh0uTHDaCtSDiqrHKI7VCjYY
	 61IrriJZHOP8Knu5fis9HqGL9udEASe0nlYeQgOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0220/1146] sctp: disable BH before calling udp_tunnel_xmit_skb()
Date: Wed, 20 May 2026 18:07:50 +0200
Message-ID: <20260520162153.236737304@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 2cd7e6971fc2787408ceef17906ea152791448cf ]

udp_tunnel_xmit_skb() / udp_tunnel6_xmit_skb() are expected to run with
BH disabled.  After commit 6f1a9140ecda ("add xmit recursion limit to
tunnel xmit functions"), on the path:

  udp(6)_tunnel_xmit_skb() -> ip(6)tunnel_xmit()

dev_xmit_recursion_inc()/dec() must stay balanced on the same CPU.

Without local_bh_disable(), the context may move between CPUs, which can
break the inc/dec pairing. This may lead to incorrect recursion level
detection and cause packets to be dropped in ip(6)_tunnel_xmit() or
__dev_queue_xmit().

Fix it by disabling BH around both IPv4 and IPv6 SCTP UDP xmit paths.

In my testing, after enabling the SCTP over UDP:

  # ip net exec ha sysctl -w net.sctp.udp_port=9899
  # ip net exec ha sysctl -w net.sctp.encap_port=9899
  # ip net exec hb sysctl -w net.sctp.udp_port=9899
  # ip net exec hb sysctl -w net.sctp.encap_port=9899

  # ip net exec ha iperf3 -s

- without this patch:

  # ip net exec hb iperf3 -c 192.168.0.1 --sctp
  [  5]   0.00-10.00  sec  37.2 MBytes  31.2 Mbits/sec  sender
  [  5]   0.00-10.00  sec  37.1 MBytes  31.1 Mbits/sec  receiver

- with this patch:

  # ip net exec hb iperf3 -c 192.168.0.1 --sctp
  [  5]   0.00-10.00  sec  3.14 GBytes  2.69 Gbits/sec  sender
  [  5]   0.00-10.00  sec  3.14 GBytes  2.69 Gbits/sec  receiver

Fixes: 6f1a9140ecda ("net: add xmit recursion limit to tunnel xmit functions")
Fixes: 046c052b475e ("sctp: enable udp tunneling socks")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Link: https://patch.msgid.link/c874a8548221dcd56ff03c65ba75a74e6cf99119.1776017727.git.lucien.xin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/ipv6.c     | 2 ++
 net/sctp/protocol.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index 53a5c027f8e31..cd15b695607eb 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -261,9 +261,11 @@ static int sctp_v6_xmit(struct sk_buff *skb, struct sctp_transport *t)
 	skb_set_inner_ipproto(skb, IPPROTO_SCTP);
 	label = ip6_make_flowlabel(sock_net(sk), skb, fl6->flowlabel, true, fl6);
 
+	local_bh_disable();
 	udp_tunnel6_xmit_skb(dst, sk, skb, NULL, &fl6->saddr, &fl6->daddr,
 			     tclass, ip6_dst_hoplimit(dst), label,
 			     sctp_sk(sk)->udp_port, t->encap_port, false, 0);
+	local_bh_enable();
 	return 0;
 }
 
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 828a59b8e7bf8..5800e7ee7ea02 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1070,10 +1070,12 @@ static inline int sctp_v4_xmit(struct sk_buff *skb, struct sctp_transport *t)
 	skb_reset_inner_mac_header(skb);
 	skb_reset_inner_transport_header(skb);
 	skb_set_inner_ipproto(skb, IPPROTO_SCTP);
+	local_bh_disable();
 	udp_tunnel_xmit_skb(dst_rtable(dst), sk, skb, fl4->saddr,
 			    fl4->daddr, dscp, ip4_dst_hoplimit(dst), df,
 			    sctp_sk(sk)->udp_port, t->encap_port, false, false,
 			    0);
+	local_bh_enable();
 	return 0;
 }
 
-- 
2.53.0



