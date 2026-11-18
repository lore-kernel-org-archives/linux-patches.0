Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028437;
	b=eCmuJG5sUfk+wh8s3fqhpgXVrvbiAmOXYhB23ydLWR1XixVKuYqbDVfUTD8tzv21NKCR
	 Ta/EFhCj4QaMO7v7zQ5u9BRPwxOBJHPHAXwMwfLdSLk+Df456kfO8oKs/JLkMKGc4O/NY
	 DEw0OTd6n84bPf9tJVdfEyHasDVgVO669eNhPmVHdjaITvukYg9QHCUt/gv+iXe4GOJdK
	 9VapJuCndHougoKhE4yqdPNmo9tBuHIhZavHyjRzbpAYHRkHZEjXczLPuptyq/SoEw8rW
	 1+wjdenArWIxNl4A2HZ6CQco9aAe+Gi7uzQ4+fQ3+aSKGM8cJfKChHeBiT3b/+tIoig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028437;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BOwGemjm/8s79tHJidUcjnK/8W8doe9WCukPlc5qtKg=;
	b=WDeM+2qQffMaNKgvX3lhDDp8VTm2gapN/+YDPMovs3wQeruOsM5h16BnlBWuETkDZj29
	 HNNv7TImbkjiCvi4HWV9+NIUn+J/U0CSiENfDXvDEjnk5DiO4pXyO4WqJJy8d7wL8x5Z0
	 TzJ00Rz5j+RuyB6+r4RYuyTvY+ed7qYW8rE3yP7LKknBECHqdXEMRC257i1ESR3wgfwJN
	 R1uB7vXXLnUuoJa8IyIIs/wMzci69oU1ak294CvwiSN2rCiaSyuk/LVudXH42Ej3bVUsA
	 CAK4VciqG20qdK/B2ZUQ6CMZi9CR0jxxJh8XmBg8/dPfZl8zw9oHauHtw1KrxYsVbWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bWFb6rCG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C587606A325;
	Wed, 18 Nov 2026 19:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bWFb6rCG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AECB61F000C5;
	Wed, 18 Nov 2026 19:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028437;
	bh=BOwGemjm/8s79tHJidUcjnK/8W8doe9WCukPlc5qtKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bWFb6rCG1iiXYTHe0EAB0BwuBCCKC9/ZPVyBk0SK8nE3CMr63LL9a8vZ6ks/wi3cX
	 55k8g2J0z0N+I4NC9BuWNDJYTkSzdmXoMLQ0ZVquRhU1D3qvNoAVHylWebsqRz0WEm
	 /PcSCxjqsjAxzkdvBLEy2XLDJ62gnWVXlMd2pgGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 2145/2151] net: lwtunnel: Drop skb metadata before LWT encapsulation
Date: Wed, 18 Nov 2026 16:04:40 +0100
Message-ID: <20261118150239.807474670@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Sitnicki <jakub@cloudflare.com>

commit c00320b0e355c4bf0ae4743a53b4180fea237546 upstream.

skb metadata is meant for passing information between XDP and TC. It lives
in the skb headroom, immediately before skb->data. LWT programs cannot
access the __sk_buff->data_meta pseudo-pointer to metadata.

However, LWT encapsulation prepends outer headers, moving skb->data back
over the headroom where the metadata sits. On an RX-originated (forwarded)
packet that still carries XDP metadata this goes wrong in two different
ways, depending on the encap type:

1. Non-BPF LWT encaps (mpls, seg6, ioam6 ...) call skb_push()/skb_pull()
   and silently overwrite the metadata that sits in the headroom.

2) BPF LWT xmit calls bpf_skb_change_head(), which uses skb_data_move().
   That helper expects metadata immediately before skb->data. But since
   the IP output path runs LWT xmit before neighbour output has built
   the outgoing L2 header, for forwarded packets skb->data points at the
   L3 header while skb_mac_header() still points at the old L2 header.
   skb_data_move() sees metadata ending at skb_mac_header(), not before
   skb->data, warns and clears metadata:

  WARNING: CPU: 21 PID: 454557 at include/linux/skbuff.h:4609 skb_data_move+0x47/0x90
  CPU: 21 UID: 0 PID: 454557 Comm: napi/iconduit-g Tainted: G           O        6.18.21 #1
  RIP: 0010:skb_data_move+0x47/0x90
  Call Trace:
   <IRQ>
   bpf_skb_change_head+0xe6/0x1a0
   bpf_prog_...+0x213/0x2e3
   run_lwt_bpf.isra.0+0x1d3/0x360
   bpf_xmit+0x46/0xe0
   lwtunnel_xmit+0xa1/0xf0
   ip_finish_output2+0x1e7/0x5e0
   ip_output+0x63/0x100
   __netif_receive_skb_one_core+0x85/0xa0
   process_backlog+0x9c/0x150
   __napi_poll+0x2b/0x190
   net_rx_action+0x40b/0x7f0
   handle_softirqs+0xd2/0x270
   do_softirq+0x3f/0x60
   </IRQ>

That is what happens, as for how to fix it - a received packet that
carries metadata can reach an encap through any of the three LWT
redirect modes:

  LWTUNNEL_STATE_INPUT_REDIRECT
   ip6_rcv_finish
     dst_input
       lwtunnel_input

  LWTUNNEL_STATE_OUTPUT_REDIRECT
   ip6_rcv_finish
     dst_input
       ip6_forward
         ip6_forward_finish
           dst_output
             lwtunnel_output

  LWTUNNEL_STATE_XMIT_REDIRECT
   ip6_rcv_finish
     dst_input
       ip6_forward
         ip6_forward_finish
           dst_output
             ip6_output
               ip6_finish_output
                 ip6_finish_output2
                   lwtunnel_xmit

Every encap funnels through the three LWT dispatch helpers, so drop the
metadata there, right before handing the skb to the encap op. This
single chokepoint covers all encap types and all three redirect modes:

  - lwtunnel_input():  seg6, rpl, ila, seg6_local
  - lwtunnel_output(): ioam6
  - lwtunnel_xmit():   mpls, LWT BPF xmit

Alternatively, we could clear the metadata right after TC ingress hook.
That would require a compromise, however. Metadata would become
inaccessible from TC egress (in setups where it actually reaches the
hook it tact, that is without any L2 tunnels on path).

Fixes: 8989d328dfe7 ("net: Helper to move packet data and metadata after skb_push/pull")
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://patch.msgid.link/20260619-bpf-lwt-drop-skb-metadata-v3-1-71d6a33ab76b@cloudflare.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/lwtunnel.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/core/lwtunnel.c
+++ b/net/core/lwtunnel.c
@@ -350,6 +350,8 @@ int lwtunnel_output(struct net *net, str
 	rcu_read_lock();
 	ops = rcu_dereference(lwtun_encaps[lwtstate->type]);
 	if (likely(ops && ops->output)) {
+		/* Encap pushes outer headers over the metadata; drop it. */
+		skb_metadata_clear(skb);
 		dev_xmit_recursion_inc();
 		ret = ops->output(net, sk, skb);
 		dev_xmit_recursion_dec();
@@ -404,6 +406,8 @@ int lwtunnel_xmit(struct sk_buff *skb)
 	rcu_read_lock();
 	ops = rcu_dereference(lwtun_encaps[lwtstate->type]);
 	if (likely(ops && ops->xmit)) {
+		/* Encap pushes outer headers over the metadata; drop it. */
+		skb_metadata_clear(skb);
 		dev_xmit_recursion_inc();
 		ret = ops->xmit(skb);
 		dev_xmit_recursion_dec();
@@ -455,6 +459,8 @@ int lwtunnel_input(struct sk_buff *skb)
 	rcu_read_lock();
 	ops = rcu_dereference(lwtun_encaps[lwtstate->type]);
 	if (likely(ops && ops->input)) {
+		/* Encap pushes outer headers over the metadata; drop it. */
+		skb_metadata_clear(skb);
 		dev_xmit_recursion_inc();
 		ret = ops->input(skb);
 		dev_xmit_recursion_dec();


