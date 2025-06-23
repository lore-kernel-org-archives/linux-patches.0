Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00FCF72624;
	Mon, 23 Jun 2025 21:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715575; cv=none; b=RRMs0KUWrRRTv7Pusxz9WtOQTW4YPxV7l+fuqOAiag/fwiQy65cq4pawRm/WRVzGXgSF/uWfH6Ql0kBJfrc+xFUnB8gyBCiB8YTNPjs1bN87pk6nGScxbDrl6Zjpj/tmi3zZj0zjOaKRymaGNLDBRNMycOT2O9Lr8hJYRVNrU14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715575; c=relaxed/simple;
	bh=JmFqn0LcSslupBG5kjHKdw+b50Gp7n7lg0uiPP+/W6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Nqnxs/jb89T8BvEhRnKk77tBQ5d+NCVhK7UECGar8s4r2yWNSwJVFyTVi2UC9u7x55CDX8H044QZSpXCrioYZlw0LoqdiW9RwthCKADvxEZohW0fkDnSJt4cBYARaZSZ8auVZjuaRVKbDT8AH2JIV6Rj+/OGqfcLxu0RB2VJeOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d7AOXyFR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d7AOXyFR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F0F4C4CEEA;
	Mon, 23 Jun 2025 21:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715574;
	bh=JmFqn0LcSslupBG5kjHKdw+b50Gp7n7lg0uiPP+/W6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d7AOXyFRDGVLjdHC2MXRn2XNTBSMTU+6Pk/1HoM7S64XaoL6rwE3ooLHKFfdzOrIb
	 GfiO86Ru//DJHsV6txnI4ZHGdVBBqDBhVQV5ApR4Sz1XgttT66mCAwYwYfB71jGJKd
	 7XQSy1qAGEYMExnrhIWUfooXKxW81M6n6411ZsIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.15 467/592] net: clear the dst when changing skb protocol
Date: Mon, 23 Jun 2025 15:07:05 +0200
Message-ID: <20250623130711.538590230@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

commit ba9db6f907ac02215e30128770f85fbd7db2fcf9 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/filter.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3233,6 +3233,13 @@ static const struct bpf_func_proto bpf_s
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
@@ -3329,7 +3336,7 @@ static int bpf_skb_proto_4_to_6(struct s
 		}
 	}
 
-	skb->protocol = htons(ETH_P_IPV6);
+	bpf_skb_change_protocol(skb, ETH_P_IPV6);
 	skb_clear_hash(skb);
 
 	return 0;
@@ -3359,7 +3366,7 @@ static int bpf_skb_proto_6_to_4(struct s
 		}
 	}
 
-	skb->protocol = htons(ETH_P_IP);
+	bpf_skb_change_protocol(skb, ETH_P_IP);
 	skb_clear_hash(skb);
 
 	return 0;
@@ -3550,10 +3557,10 @@ static int bpf_skb_net_grow(struct sk_bu
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
@@ -3606,10 +3613,10 @@ static int bpf_skb_net_shrink(struct sk_
 	/* Match skb->protocol to new outer l3 protocol */
 	if (skb->protocol == htons(ETH_P_IP) &&
 	    flags & BPF_F_ADJ_ROOM_DECAP_L3_IPV6)
-		skb->protocol = htons(ETH_P_IPV6);
+		bpf_skb_change_protocol(skb, ETH_P_IPV6);
 	else if (skb->protocol == htons(ETH_P_IPV6) &&
 		 flags & BPF_F_ADJ_ROOM_DECAP_L3_IPV4)
-		skb->protocol = htons(ETH_P_IP);
+		bpf_skb_change_protocol(skb, ETH_P_IP);
 
 	if (skb_is_gso(skb)) {
 		struct skb_shared_info *shinfo = skb_shinfo(skb);


