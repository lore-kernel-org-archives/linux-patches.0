Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80FA42848A7;
	Thu, 25 Jun 2026 13:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782392820; cv=none; b=fig6UVaCSzwXOHXqzfVmZg85Nauo+UucaciP38vnGZAvY9navDhsBK5SzHx0nox2YWXMWUm8SqA3LTpbMrYjLM1OFGqb6mb8mHtblfbnHTWJJbLuVgjDu5iileE/hGzcolovtakmiHo9ADaRkRx9as3stmA7/ZQ4LScSVaBZYoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782392820; c=relaxed/simple;
	bh=fLt/j0dTL+mSHOO1EjsgaESorXazHZLhEOx0OQU8eyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wsxz54hzV9yWpacKaxd833hRj2mC7YUXQYVl0qtMnYcQx1X1Gmsvsb/Q5KrMmothVnsZ6BubSa7X/jxSoadimXihijiDabkz84VGO4ypnqxs/4DRkle7rx20IGvOHdwgb5yQ334Aaa91Zxd3TG4nfamXJ0sVgiTICkwXzyJdU6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RuxYYQy+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RuxYYQy+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4D5D1F000E9;
	Thu, 25 Jun 2026 13:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782392819;
	bh=+9PmY22WCE5ujdb2mhdDhdkbTD+pjcuLbGU2C+gawXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RuxYYQy+HePsHc2+qJl+1ho3vhYcPOgJugehdv1jYR9icHUEvsKInolOolemcxsIf
	 hD4m0io81hc1XKovD0fekvmuWN1wRvXYFP7b/sJbqWaWQ7E0uHtbmgHSMiCVeNE6qd
	 YhgSSindguBaG5vhHPgjIf/VX4lTcWv+eJQMIw5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"marcelo.leitner@gmail.com, lucien.xin@gmail.com, davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, bestswngs@gmail.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, Alexander Martyniuk" <alexevgmart@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Alexander Martyniuk <alexevgmart@gmail.com>
Subject: [PATCH 6.18 33/60] sctp: disable BH before calling udp_tunnel_xmit_skb()
Date: Thu, 25 Jun 2026 14:03:18 +0100
Message-ID: <20260625125650.415762921@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625125645.554579168@linuxfoundation.org>
References: <20260625125645.554579168@linuxfoundation.org>
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

From: Xin Long <lucien.xin@gmail.com>

commit 2cd7e6971fc2787408ceef17906ea152791448cf upstream.

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
Signed-off-by: Alexander Martyniuk <alexevgmart@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/ipv6.c     |    2 ++
 net/sctp/protocol.c |    2 ++
 2 files changed, 4 insertions(+)

--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -261,9 +261,11 @@ static int sctp_v6_xmit(struct sk_buff *
 	skb_set_inner_ipproto(skb, IPPROTO_SCTP);
 	label = ip6_make_flowlabel(sock_net(sk), skb, fl6->flowlabel, true, fl6);
 
+	local_bh_disable();
 	udp_tunnel6_xmit_skb(dst, sk, skb, NULL, &fl6->saddr, &fl6->daddr,
 			     tclass, ip6_dst_hoplimit(dst), label,
 			     sctp_sk(sk)->udp_port, t->encap_port, false, 0);
+	local_bh_enable();
 	return 0;
 }
 
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1102,10 +1102,12 @@ static inline int sctp_v4_xmit(struct sk
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
 


