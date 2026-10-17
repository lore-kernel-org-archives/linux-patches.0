Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD173B7767;
	Sat, 17 Oct 2026 17:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258757; cv=none; b=GcYVOT9nk6sfkC2gsOYq78lCPUmNtPDabMWPMULBAZYsR//wl8DTip6oOVBM1YYgoVEwguloBmT2flmmRS7DBxaAipY3Dby1iJxCZJyGyoJSCP8NajV7hbKjQ1ZSn2/pK7Weoye7m3JDKhNSZQ9K6Xzg7jPiZr3KUe8dn0ciSHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258757; c=relaxed/simple;
	bh=ZgJl7JTJdWh7Jz81s02B+NTCP5MX1PObJN+wOqsO1hg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lwJxi3mfCuwYJ83IN40LDx4mo445n7zz+jS96ioWtJTGXKCRrEwLeEtf6GusmkvzXQ750/i8B9j5NAZyY2VK5Cj3s7+yqgQlwEhZwszJ17kTHWM26QNzLO49UWeTnPIoKEYXRWKPJFISibptatc0vqM/MeYNwbmtsNVkf/2fKMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vZD61MWO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vZD61MWO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3F231F000CC;
	Sat, 17 Oct 2026 17:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258756;
	bh=KT/PBgO40o20hNtcHr2rJeoyPn8awryk1R47MQB0slU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vZD61MWOmq6EvPLYrjBUqujR3lkZXdxZdi90VagwZ5KZWKUq9eP0Dz+vo/ix1smun
	 yUJQP8wOuTp3t+K3VhilnmRwZCJ3+6qfpwyK3So/+qgLrdw1WbSNWo+RyoZoPb9Szg
	 7pkRYjEDOt6fuwxMwTfFEP0nuI/PHOdmLi8Y+bqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0990/1674] sctp: disable BH before calling udp_tunnel_xmit_skb()
Date: Sat, 17 Oct 2026 17:54:22 +0200
Message-ID: <20261017160456.531600208@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 net/sctp/ipv6.c     | 10 +++++++---
 net/sctp/protocol.c |  2 ++
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index 02989e5612df5..4f0647e60dae4 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -227,6 +227,7 @@ static int sctp_v6_xmit(struct sk_buff *skb, struct sctp_transport *t)
 	struct ipv6_pinfo *np = inet6_sk(sk);
 	__u8 tclass = np->tclass;
 	__be32 label;
+	int err;
 
 	pr_debug("%s: skb:%p, len:%d, src:%pI6 dst:%pI6\n", __func__, skb,
 		 skb->len, &fl6->saddr, &fl6->daddr);
@@ -263,9 +264,12 @@ static int sctp_v6_xmit(struct sk_buff *skb, struct sctp_transport *t)
 	skb_set_inner_ipproto(skb, IPPROTO_SCTP);
 	label = ip6_make_flowlabel(sock_net(sk), skb, fl6->flowlabel, true, fl6);
 
-	return udp_tunnel6_xmit_skb(dst, sk, skb, NULL, &fl6->saddr,
-				    &fl6->daddr, tclass, ip6_dst_hoplimit(dst),
-				    label, sctp_sk(sk)->udp_port, t->encap_port, false);
+	local_bh_disable();
+	err = udp_tunnel6_xmit_skb(dst, sk, skb, NULL, &fl6->saddr,
+				   &fl6->daddr, tclass, ip6_dst_hoplimit(dst),
+				   label, sctp_sk(sk)->udp_port, t->encap_port, false);
+	local_bh_enable();
+	return err;
 }
 
 /* Returns the dst cache entry for the given source and destination ip
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index ee598e319d0ed..ade01785cb1b5 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1085,9 +1085,11 @@ static inline int sctp_v4_xmit(struct sk_buff *skb, struct sctp_transport *t)
 	skb_reset_inner_mac_header(skb);
 	skb_reset_inner_transport_header(skb);
 	skb_set_inner_ipproto(skb, IPPROTO_SCTP);
+	local_bh_disable();
 	udp_tunnel_xmit_skb((struct rtable *)dst, sk, skb, fl4->saddr,
 			    fl4->daddr, dscp, ip4_dst_hoplimit(dst), df,
 			    sctp_sk(sk)->udp_port, t->encap_port, false, false);
+	local_bh_enable();
 	return 0;
 }
 
-- 
2.53.0



