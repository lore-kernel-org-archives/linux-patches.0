Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A0641946AB;
	Wed,  3 Jul 2024 11:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005808; cv=none; b=gbbv3tKd4Bp9ahuZ+juwsWcJSiPJw9VgLVLbjMXyXCLxJfD3jsop8/NQ27IGjxIPUNgtomhiQMA81nZxEKvelwBSHPyuOV1l777U0EdCLFIZlsuRnd8A54CovhVlDdVi9gtmOBUWWyhC0x6BCMmU6BRZT770XQakehwzlcpyxw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005808; c=relaxed/simple;
	bh=w/i80iSX82giSjU8dxpBCLksebIkKKpw9pnMxjfN2dM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aAmy/PB9ixI4S3n+JyjaxLopic2nUnYO17u7Wv6mzwkWvzNOLrvk+IDuXGw2W4gAzj9uw1CiKPHy+YuWGF6XwhoUIAh1ifBjQFGvxVEbxPdxQELEXGtcePGegWth4zASR4DE6+V2Imj/BJbLwUEGfqjdmxowlaAmLrwUnS/2zkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YkJRfnx9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YkJRfnx9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4DF7C2BD10;
	Wed,  3 Jul 2024 11:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005808;
	bh=w/i80iSX82giSjU8dxpBCLksebIkKKpw9pnMxjfN2dM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YkJRfnx9EkqkMwlqir2EcV4S0YwBJPxVSh3IuU/2A/zDd6PmoceHhqzvCPCrdSoBx
	 NrLU+oiZJR3SNZ+oCTyBWJExQmJuxeXJUcITPZvMVEgUlJyf0G8Qq6lnz9iNOa04dY
	 86O9Tg2J9forWIEHcgj7AmvIMhjypUqugftJw5l0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianguo Wu <wujianguo@chinatelecom.cn>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 203/356] seg6: fix parameter passing when calling NF_HOOK() in End.DX4 and End.DX6 behaviors
Date: Wed,  3 Jul 2024 12:38:59 +0200
Message-ID: <20240703102920.782772977@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 59454285d5c58..f15f3cb1d5ec2 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -427,8 +427,8 @@ static int input_action_end_dx6(struct sk_buff *skb,
 
 	if (static_branch_unlikely(&nf_hooks_lwtunnel_enabled))
 		return NF_HOOK(NFPROTO_IPV6, NF_INET_PRE_ROUTING,
-			       dev_net(skb->dev), NULL, skb, NULL,
-			       skb_dst(skb)->dev, input_action_end_dx6_finish);
+			       dev_net(skb->dev), NULL, skb, skb->dev,
+			       NULL, input_action_end_dx6_finish);
 
 	return input_action_end_dx6_finish(dev_net(skb->dev), NULL, skb);
 drop:
@@ -477,8 +477,8 @@ static int input_action_end_dx4(struct sk_buff *skb,
 
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



