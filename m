Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0406513C90B;
	Tue, 25 Jun 2024 10:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309704; cv=none; b=datjaDDNbf+VKmgNUGjUXU/Vn4QZGonQv/fuXC77iT352LHR8a3oVb5FTnfb2MXxXhByOhVLbRWqirqp1gKul3/Ag169d1UWgxxeBvi4K/rwiAhouCX0DhjbSPm3/kxxxuhVMUVQd+FyMdyMOBvTNS2xOrCwXhHYUC1gfiDjPws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309704; c=relaxed/simple;
	bh=J32zr8wup2aeUhVUVTZjxoLI8cE0bux4fAxHKCarn88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AJTpNV1iQ+QLjwK//ZYsE225i2m+ewQp1DE+Ze8jbpXBkh/ed+n6Rc0FLcM9XdS273K2EJeHXwPGtzFUlJtb3kMFNyyCAgyphRHx4giGqBKbTfcU06BhAtMn3UfUn1dv8hnkJhX4WJ+8AsyWd10nSvXTm/kFLxVn2OgGzbNhjq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vm0SA+PX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vm0SA+PX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B7D3C32781;
	Tue, 25 Jun 2024 10:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309703;
	bh=J32zr8wup2aeUhVUVTZjxoLI8cE0bux4fAxHKCarn88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vm0SA+PXKJ33xP5qJCJmPUaMcG0ew4hlNgiceg+Cvs0VhuVJmaeZB/vidPoJZkDy/
	 eFG3lwV5pcdYpmnHE4NDXV0AqklVJEV06vugU4s9wA9RDVk7twgvGs3/gKmU5BzRch
	 464FQuTAj1HzEcP5EXHZ0cx/j5YeEGD/rgpIgOHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianguo Wu <wujianguo@chinatelecom.cn>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 074/131] seg6: fix parameter passing when calling NF_HOOK() in End.DX4 and End.DX6 behaviors
Date: Tue, 25 Jun 2024 11:33:49 +0200
Message-ID: <20240625085528.755194670@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianguo Wu <wujianguo@chinatelecom.cn>

[ Upstream commit 9a3bc8d16e0aacd65c31aaf23a2bced3288a7779 ]

input_action_end_dx4() and input_action_end_dx6() are called NF_HOOK() for
PREROUTING hook, in PREROUTING hook, we should passing a valid indev,
and a NULL outdev to NF_HOOK(), otherwise may trigger a NULL pointer
dereference, as below:

    [74830.647293] BUG: kernel NULL pointer dereference, address: 0000000000000090
    [74830.655633] #PF: supervisor read access in kernel mode
    [74830.657888] #PF: error_code(0x0000) - not-present page
    [74830.659500] PGD 0 P4D 0
    [74830.660450] Oops: 0000 [#1] PREEMPT SMP PTI
    ...
    [74830.664953] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
    [74830.666569] RIP: 0010:rpfilter_mt+0x44/0x15e [ipt_rpfilter]
    ...
    [74830.689725] Call Trace:
    [74830.690402]  <IRQ>
    [74830.690953]  ? show_trace_log_lvl+0x1c4/0x2df
    [74830.692020]  ? show_trace_log_lvl+0x1c4/0x2df
    [74830.693095]  ? ipt_do_table+0x286/0x710 [ip_tables]
    [74830.694275]  ? __die_body.cold+0x8/0xd
    [74830.695205]  ? page_fault_oops+0xac/0x140
    [74830.696244]  ? exc_page_fault+0x62/0x150
    [74830.697225]  ? asm_exc_page_fault+0x22/0x30
    [74830.698344]  ? rpfilter_mt+0x44/0x15e [ipt_rpfilter]
    [74830.699540]  ipt_do_table+0x286/0x710 [ip_tables]
    [74830.700758]  ? ip6_route_input+0x19d/0x240
    [74830.701752]  nf_hook_slow+0x3f/0xb0
    [74830.702678]  input_action_end_dx4+0x19b/0x1e0
    [74830.703735]  ? input_action_end_t+0xe0/0xe0
    [74830.704734]  seg6_local_input_core+0x2d/0x60
    [74830.705782]  lwtunnel_input+0x5b/0xb0
    [74830.706690]  __netif_receive_skb_one_core+0x63/0xa0
    [74830.707825]  process_backlog+0x99/0x140
    [74830.709538]  __napi_poll+0x2c/0x160
    [74830.710673]  net_rx_action+0x296/0x350
    [74830.711860]  __do_softirq+0xcb/0x2ac
    [74830.713049]  do_softirq+0x63/0x90

input_action_end_dx4() passing a NULL indev to NF_HOOK(), and finally
trigger a NULL dereference in rpfilter_mt()->rpfilter_is_loopback():

    static bool
    rpfilter_is_loopback(const struct sk_buff *skb,
          	       const struct net_device *in)
    {
            // in is NULL
            return skb->pkt_type == PACKET_LOOPBACK ||
          	 in->flags & IFF_LOOPBACK;
    }

Fixes: 7a3f5b0de364 ("netfilter: add netfilter hooks to SRv6 data plane")
Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/seg6_local.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index 8370726ae7bf1..33cb0381b5749 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -554,8 +554,8 @@ static int input_action_end_dx6(struct sk_buff *skb,
 
 	if (static_branch_unlikely(&nf_hooks_lwtunnel_enabled))
 		return NF_HOOK(NFPROTO_IPV6, NF_INET_PRE_ROUTING,
-			       dev_net(skb->dev), NULL, skb, NULL,
-			       skb_dst(skb)->dev, input_action_end_dx6_finish);
+			       dev_net(skb->dev), NULL, skb, skb->dev,
+			       NULL, input_action_end_dx6_finish);
 
 	return input_action_end_dx6_finish(dev_net(skb->dev), NULL, skb);
 drop:
@@ -604,8 +604,8 @@ static int input_action_end_dx4(struct sk_buff *skb,
 
 	if (static_branch_unlikely(&nf_hooks_lwtunnel_enabled))
 		return NF_HOOK(NFPROTO_IPV4, NF_INET_PRE_ROUTING,
-			       dev_net(skb->dev), NULL, skb, NULL,
-			       skb_dst(skb)->dev, input_action_end_dx4_finish);
+			       dev_net(skb->dev), NULL, skb, skb->dev,
+			       NULL, input_action_end_dx4_finish);
 
 	return input_action_end_dx4_finish(dev_net(skb->dev), NULL, skb);
 drop:
-- 
2.43.0



