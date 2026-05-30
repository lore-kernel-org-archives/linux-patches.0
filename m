Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA13223DC6;
	Sat, 30 May 2026 17:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163173; cv=none; b=i0OoY2HOlycu7h0wy2jerj1G6vF12MhGqGvRcD8O7QPfmIPud3Dyep4MqxjxHfrH6wXH8fZ+aELhDEb/Wbk87dEVP7wzDfK6mt/0o847OV7bGa1szMFy8QN08ZIDoeDVvuAO1fvzOR7dDM7HXcKfONvX0q7EXcEsK73LHTboH8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163173; c=relaxed/simple;
	bh=NlYznuKaLnIfvqdDmOmAOySHdG88091XMzf71kzhqPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q/Yt1SUUOBvfzKrbneY8RVE6u+KUwgQCjVuA00nBtRdyhSt8w7Yacv4YOo5zRhpIAwpAp/Vrt9zGMn6nBh80g2ywXbG5vnOwbhRHtOU1Bq1n8hpWL62Qt+Bmc3ynvP8j1eiuSUHVx9DHlhhaWcCeP7GJnJkn6lB5JLrkQTjHZOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0VqRR+7N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0VqRR+7N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE5B21F00893;
	Sat, 30 May 2026 17:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163172;
	bh=rJVpojcvIjY6NUQa//jbPqEeI127OmJbREPR8DA7Pgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0VqRR+7NIsfzPet79+feeV78W0Tma+W/3qPu2PSM4bSR0x5D2C0XZEY686SxJz2Bu
	 +TEFiCrlpJNpstBQjnNaNSTVVyaw5w7elji5Sdr/U5KFOb8c5oRcii+JzDJNz+miuU
	 AweO2DUrDCG4cyrFj5s8YzKHjQijpI8nbhYF1yC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Johnny Hao <johnny_haocn@sina.com>
Subject: [PATCH 5.15 161/776] net: clear the dst when changing skb protocol
Date: Sat, 30 May 2026 17:57:55 +0200
Message-ID: <20260530160244.647482775@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit ba9db6f907ac02215e30128770f85fbd7db2fcf9 ]

A not-so-careful NAT46 BPF program can crash the kernel
if it indiscriminately flips ingress packets from v4 to v6:

  BUG: kernel NULL pointer dereference, address: 0000000000000000
    ip6_rcv_core (net/ipv6/ip6_input.c:190:20)
    ipv6_rcv (net/ipv6/ip6_input.c:306:8)
    process_backlog (net/core/dev.c:6186:4)
    napi_poll (net/core/dev.c:6906:9)
    net_rx_action (net/core/dev.c:7028:13)
    do_softirq (kernel/softirq.c:462:3)
    netif_rx (net/core/dev.c:5326:3)
    dev_loopback_xmit (net/core/dev.c:4015:2)
    ip_mc_finish_output (net/ipv4/ip_output.c:363:8)
    NF_HOOK (./include/linux/netfilter.h:314:9)
    ip_mc_output (net/ipv4/ip_output.c:400:5)
    dst_output (./include/net/dst.h:459:9)
    ip_local_out (net/ipv4/ip_output.c:130:9)
    ip_send_skb (net/ipv4/ip_output.c:1496:8)
    udp_send_skb (net/ipv4/udp.c:1040:8)
    udp_sendmsg (net/ipv4/udp.c:1328:10)

The output interface has a 4->6 program attached at ingress.
We try to loop the multicast skb back to the sending socket.
Ingress BPF runs as part of netif_rx(), pushes a valid v6 hdr
and changes skb->protocol to v6. We enter ip6_rcv_core which
tries to use skb_dst(). But the dst is still an IPv4 one left
after IPv4 mcast output.

Clear the dst in all BPF helpers which change the protocol.
Try to preserve metadata dsts, those may carry non-routing
metadata.

Cc: stable@vger.kernel.org
Reviewed-by: Maciej Żenczykowski <maze@google.com>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Fixes: d219df60a70e ("bpf: Add ipip6 and ip6ip decap support for bpf_skb_adjust_room()")
Fixes: 1b00e0dfe7d0 ("bpf: update skb->protocol in bpf_skb_net_grow")
Fixes: 6578171a7ff0 ("bpf: add bpf_skb_change_proto helper")
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20250610001245.1981782-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ The context change is due to the commit d219df60a70e
("bpf: Add ipip6 and ip6ip decap support for bpf_skb_adjust_room()")
in v6.3 which is irrelevant to the logic of this patch. ]
Signed-off-by: Johnny Hao <johnny_haocn@sina.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/filter.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3219,6 +3219,13 @@ static const struct bpf_func_proto bpf_s
 	.arg1_type      = ARG_PTR_TO_CTX,
 };
 
+static void bpf_skb_change_protocol(struct sk_buff *skb, u16 proto)
+{
+	skb->protocol = htons(proto);
+	if (skb_valid_dst(skb))
+		skb_dst_drop(skb);
+}
+
 static int bpf_skb_generic_push(struct sk_buff *skb, u32 off, u32 len)
 {
 	/* Caller already did skb_cow() with len as headroom,
@@ -3315,7 +3322,7 @@ static int bpf_skb_proto_4_to_6(struct s
 		}
 	}
 
-	skb->protocol = htons(ETH_P_IPV6);
+	bpf_skb_change_protocol(skb, ETH_P_IPV6);
 	skb_clear_hash(skb);
 
 	return 0;
@@ -3345,7 +3352,7 @@ static int bpf_skb_proto_6_to_4(struct s
 		}
 	}
 
-	skb->protocol = htons(ETH_P_IP);
+	bpf_skb_change_protocol(skb, ETH_P_IP);
 	skb_clear_hash(skb);
 
 	return 0;
@@ -3532,10 +3539,10 @@ static int bpf_skb_net_grow(struct sk_bu
 		/* Match skb->protocol to new outer l3 protocol */
 		if (skb->protocol == htons(ETH_P_IP) &&
 		    flags & BPF_F_ADJ_ROOM_ENCAP_L3_IPV6)
-			skb->protocol = htons(ETH_P_IPV6);
+			bpf_skb_change_protocol(skb, ETH_P_IPV6);
 		else if (skb->protocol == htons(ETH_P_IPV6) &&
 			 flags & BPF_F_ADJ_ROOM_ENCAP_L3_IPV4)
-			skb->protocol = htons(ETH_P_IP);
+			bpf_skb_change_protocol(skb, ETH_P_IP);
 	}
 
 	if (skb_is_gso(skb)) {


