Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042805;
	b=L+LWA8xYiJ9c5RDQ56KP7NHTHxy+azgC2Bs8kvKPEYXKXlZKeUHPD4nH6Hmh/0Q/Ci8c
	 OCHn56xcH2GVstDo/7SO5h1+3h6LDdi0C/XaxwuK5XLT6oDadzsXi+kyaMqx+Wk561FbB
	 E+QoVdAcSZwMiVfAV35boy4SQVO9x3UYL9n6Qj+jSKgPPd6+vPuh7MTsRToZOyH7Aie9+
	 1GvtVF1uYc8vYeB6kGuUhfOiD4OFoSXBnO/cYDiBXdQ+OqQKOtLQM4865KGfvElktky4m
	 3owyH6obUUOesnr3K6MiKYCNpbBqnTmtujGNaj+4HF8GZ/0dm33SfuoIq8ilVo+dHDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042805;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i+gT96z3Ll+mXa8lgHC69PPETcOWzYbEe9SEht3Etkg=;
	b=22AuJ6l92Pnq4ZdegU8O2Cq/ROhDnNRBdqm7eMrzSTU5NOF4lc18ZaxtxIdLt8RZCoHP
	 rtwTH4swh/ew8O+8cOkAT8KcdRtN0cx7fcOEq+bbP0vboFPlG0YaQskE5JDxWi6sBDg8/
	 ERHnwlcNLQPk0Vg9KLhBqRuvDiHeMZdrOjJWRCZNMf2I8SVy3S/u5uVMBTzBgpKo0Rmlo
	 czw7lZtWKeABzIaAqDF0CmTYMtVHdXGPKFnAXAmSgis3qeiUfein8/gMDKZsNOO74sVir
	 fpHdnM59hzt6F8EMnWeygqHObhyNW5928OWysJnTKdCH6SEh+E/Hh6NOPzXk0u21UdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L6mF2i8r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C6A6606A336;
	Wed, 18 Nov 2026 23:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L6mF2i8r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6911B1F000C7;
	Wed, 18 Nov 2026 23:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042805;
	bh=i+gT96z3Ll+mXa8lgHC69PPETcOWzYbEe9SEht3Etkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L6mF2i8rXRWcjSTM6tuFp9O+prfq7yDyZGqCIdCkglZcq0o7IwntCDy6Rn8eyNZWN
	 tKKDmqdeSiH7Dz5pVY4V/vRNuVf1EPUpAr+FcgIBkIuuUOP6AGfldruuDmYYBqgkyZ
	 hUY8TmqM4ohRyQK/o+X3L+S1gcPmapfW6iyJPJqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 3302/3318] net: lwtunnel: Drop skb metadata before LWT encapsulation
Date: Wed, 18 Nov 2026 16:05:24 +0100
Message-ID: <20261118150458.651787048@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -358,6 +358,8 @@ int lwtunnel_output(struct net *net, str
 	rcu_read_lock();
 	ops = rcu_dereference(lwtun_encaps[lwtstate->type]);
 	if (likely(ops && ops->output)) {
+		/* Encap pushes outer headers over the metadata; drop it. */
+		skb_metadata_clear(skb);
 		dev_xmit_recursion_inc();
 		ret = ops->output(net, sk, skb);
 		dev_xmit_recursion_dec();
@@ -412,6 +414,8 @@ int lwtunnel_xmit(struct sk_buff *skb)
 	rcu_read_lock();
 	ops = rcu_dereference(lwtun_encaps[lwtstate->type]);
 	if (likely(ops && ops->xmit)) {
+		/* Encap pushes outer headers over the metadata; drop it. */
+		skb_metadata_clear(skb);
 		dev_xmit_recursion_inc();
 		ret = ops->xmit(skb);
 		dev_xmit_recursion_dec();
@@ -463,6 +467,8 @@ int lwtunnel_input(struct sk_buff *skb)
 	rcu_read_lock();
 	ops = rcu_dereference(lwtun_encaps[lwtstate->type]);
 	if (likely(ops && ops->input)) {
+		/* Encap pushes outer headers over the metadata; drop it. */
+		skb_metadata_clear(skb);
 		dev_xmit_recursion_inc();
 		ret = ops->input(skb);
 		dev_xmit_recursion_dec();


