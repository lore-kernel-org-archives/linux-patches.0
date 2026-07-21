Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 323F746D549;
	Tue, 21 Jul 2026 19:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661165; cv=none; b=dqQdRd4AKN68R3lZVM7e+b6rGVnoFf7mKICD1RKt/F5PuNukfW83uFIcxkw7VeQ1k+qO6wMHjtU34qMiVDtKTGgH2goWW3bV5ZIcpfSIOdIUnJRPi1vdSfuX3PCZNa+37jcTcRNFvLso0cMomMXtWPtHUd0XwW/G3KOdonVZKDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661165; c=relaxed/simple;
	bh=QfGqD+bKn1HHjXSvK/2l651pTmz7lxAWivTS6SwcFhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TOzs9LnGJ04gklY0+wGV5dHJoBHvttfoAVsmJqsVJpdAQ5xgPPVt0P+ar3ZoTxeZK/RwAtpRyqiAUSLixf35xldzjkrjrv7eLtiXnMPl96Y1kEYp4dgyE/i6E5YfYWmF7Fc2CdRRweBm3z96sNsJEW+oU+5/TdHdCcbsETV1gbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AWw2JOVz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AWw2JOVz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 932541F000E9;
	Tue, 21 Jul 2026 19:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661164;
	bh=gqMQ+Vrv0NUf+Xd26jCTRw8Eko1RvhINOzk2Au2aGdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AWw2JOVz24XL3uzNStBoL4ACPWmavZwDOgEak/pDz7zeynLMCj3qoe3432dYXHcRm
	 hk/Cr/RpmbCozCE4DnTp5huqnF/HtF+1KMBlqBwd8sy5BZ+i9wX5HdyaNwyuX2y/uZ
	 xxyPiMjlxtG5/6iogha8IU1eYR5FG0DUomRZ8kYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1256/2077] net: lwtunnel: Drop skb metadata before LWT encapsulation
Date: Tue, 21 Jul 2026 17:15:29 +0200
Message-ID: <20260721152622.439021358@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Sitnicki <jakub@cloudflare.com>

[ Upstream commit c00320b0e355c4bf0ae4743a53b4180fea237546 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/lwtunnel.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/core/lwtunnel.c b/net/core/lwtunnel.c
index f9d76d85d04fd0..b01a395d9a9660 100644
--- a/net/core/lwtunnel.c
+++ b/net/core/lwtunnel.c
@@ -350,6 +350,8 @@ int lwtunnel_output(struct net *net, struct sock *sk, struct sk_buff *skb)
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
-- 
2.53.0



