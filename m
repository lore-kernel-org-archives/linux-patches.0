Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1B61420A5;
	Tue, 27 Feb 2024 14:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042471; cv=none; b=Mwv7WX4QLcWXT5WzRKu8/pn9R/NcH2THfnhVJu3tYPF/ocU3tLLU2ccyLBbyBDTQhSwEJufZMrmpmcdPp/D0h7uxIStsq7SH9KjZIc6s30j7YmVzmusqUPJhs0aEHZvZ4+17eTGxB/ahse/2s9mKpImDSY66n8nlA0wbhPIGFVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042471; c=relaxed/simple;
	bh=tymbMX35c4EvM6lftbxTZE5GhUtg8nt2rcanNJ+5RBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mmLHMCd9mskgogxHrxL25XhXQ6W9feJeXHXi0FkUXEXDFo3zGZoLgZJgQjoYfKq0mPNTeIGklJBDMomBFvxYx8JsNJBgV1d3VKMqbc0qpKiGUKs3FhNpK27lsC1KswirNjBubrRrVWWZXk0esl6tGUawNf8NwltH3rstPcyl4WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q5Cqk07M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q5Cqk07M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3386C433C7;
	Tue, 27 Feb 2024 14:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042471;
	bh=tymbMX35c4EvM6lftbxTZE5GhUtg8nt2rcanNJ+5RBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q5Cqk07Mt7i52rlkCjp77WrsD9DW9/jJNheJ1lgLrQ6/Wn7RRRX07O1eeqIV01iX+
	 FEnpGN5gZ/JKqWIW1dRnFGTUPQjokyM+VwcmT0bOxvcg6IiCY+7gyNced1WAzxykIl
	 ee/WNbZXt2xxMYN2pn9AYJme47LK7QrwfsqSYqMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 273/299] netfilter: nft_flow_offload: release dst in case direct xmit path is used
Date: Tue, 27 Feb 2024 14:26:24 +0100
Message-ID: <20240227131634.465588695@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 8762785f459be1cfe6fcf7285c123aad6a3703f0 ]

Direct xmit does not use it since it calls dev_queue_xmit() to send
packets, hence it calls dst_release().

kmemleak reports:

unreferenced object 0xffff88814f440900 (size 184):
  comm "softirq", pid 0, jiffies 4294951896
  hex dump (first 32 bytes):
    00 60 5b 04 81 88 ff ff 00 e6 e8 82 ff ff ff ff  .`[.............
    21 0b 50 82 ff ff ff ff 00 00 00 00 00 00 00 00  !.P.............
  backtrace (crc cb2bf5d6):
    [<000000003ee17107>] kmem_cache_alloc+0x286/0x340
    [<0000000021a5de2c>] dst_alloc+0x43/0xb0
    [<00000000f0671159>] rt_dst_alloc+0x2e/0x190
    [<00000000fe5092c9>] __mkroute_output+0x244/0x980
    [<000000005fb96fb0>] ip_route_output_flow+0xc0/0x160
    [<0000000045367433>] nf_ip_route+0xf/0x30
    [<0000000085da1d8e>] nf_route+0x2d/0x60
    [<00000000d1ecd1cb>] nft_flow_route+0x171/0x6a0 [nft_flow_offload]
    [<00000000d9b2fb60>] nft_flow_offload_eval+0x4e8/0x700 [nft_flow_offload]
    [<000000009f447dbb>] expr_call_ops_eval+0x53/0x330 [nf_tables]
    [<00000000072e1be6>] nft_do_chain+0x17c/0x840 [nf_tables]
    [<00000000d0551029>] nft_do_chain_inet+0xa1/0x210 [nf_tables]
    [<0000000097c9d5c6>] nf_hook_slow+0x5b/0x160
    [<0000000005eccab1>] ip_forward+0x8b6/0x9b0
    [<00000000553a269b>] ip_rcv+0x221/0x230
    [<00000000412872e5>] __netif_receive_skb_one_core+0xfe/0x110

Fixes: fa502c865666 ("netfilter: flowtable: simplify route logic")
Reported-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_flow_table_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 7502d6d73a600..a0571339239c4 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -132,6 +132,7 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 		       ETH_ALEN);
 		flow_tuple->out.ifidx = route->tuple[dir].out.ifindex;
 		flow_tuple->out.hw_ifidx = route->tuple[dir].out.hw_ifindex;
+		dst_release(dst);
 		break;
 	case FLOW_OFFLOAD_XMIT_XFRM:
 	case FLOW_OFFLOAD_XMIT_NEIGH:
-- 
2.43.0



