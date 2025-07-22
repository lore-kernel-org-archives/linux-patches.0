Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9234C2E1C53;
	Tue, 22 Jul 2025 14:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193718; cv=none; b=GJnmc7x4VH4efsMuM3Wec5ER0n5dfVPQN3vCEhxqVtPEBlb8Ap/YU5CO1r60Jn2O1OkFDSMxaGZxC4uNFC+9gNoM9usDG9L/VtcYRAozPiED+x6sx/m+LMOeAdPNHwzzcYKCUwOaEBdsKd/I90Ubx6+yn81mVjTS51vYnZ+QMiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193718; c=relaxed/simple;
	bh=TzcwkN//7n6DQC1YTL8bEHa9xqJH4Qz5sDEsGoe6dNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KznnNYvXpCiQ67XvqJUGada9hWZRaxXON8F9W2N2SpICAiuqLCuF3nDvsn6RWB8eBloiXY6jVNk9+JshkWMMT9/3HYisxMv4GhFbY9HaVxlAIM/L/Q76aWnki8JjHG6YCHkuzB1zOdi7dkCfovMrpy8KPuD3qpgo7YnAE+OxneQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F2EDT8VP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F2EDT8VP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0308FC4CEF1;
	Tue, 22 Jul 2025 14:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193718;
	bh=TzcwkN//7n6DQC1YTL8bEHa9xqJH4Qz5sDEsGoe6dNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F2EDT8VPXsd3onrMcF8oMn/w4b+wjtrOL1DS4oVg/BAEojwBjao2TzKcKOfFwwXQc
	 UsqZli86XBGF5InBqdxxpVnIv/8RunsuyuUNLMA3pEuCw2MeNBlxN+WRHt0qfg8TYB
	 RcBaRdr3WPlfEr4FHD3oE6arGnTyJqRiJfE5jDQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 144/187] net: fix segmentation after TCP/UDP fraglist GRO
Date: Tue, 22 Jul 2025 15:45:14 +0200
Message-ID: <20250722134351.153179323@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 9f735b6f8a77d7be7f8b0765dc93587774832cb1 ]

Since "net: gro: use cb instead of skb->network_header", the skb network
header is no longer set in the GRO path.
This breaks fraglist segmentation, which relies on ip_hdr()/tcp_hdr()
to check for address/port changes.
Fix this regression by selectively setting the network header for merged
segment skbs.

Fixes: 186b1ea73ad8 ("net: gro: use cb instead of skb->network_header")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20250705150622.10699-1-nbd@nbd.name
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_offload.c | 1 +
 net/ipv4/udp_offload.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
index d293087b426df..be5c2294610e5 100644
--- a/net/ipv4/tcp_offload.c
+++ b/net/ipv4/tcp_offload.c
@@ -359,6 +359,7 @@ struct sk_buff *tcp_gro_receive(struct list_head *head, struct sk_buff *skb,
 		flush |= skb->ip_summed != p->ip_summed;
 		flush |= skb->csum_level != p->csum_level;
 		flush |= NAPI_GRO_CB(p)->count >= 64;
+		skb_set_network_header(skb, skb_gro_receive_network_offset(skb));
 
 		if (flush || skb_gro_receive_list(p, skb))
 			mss = 1;
diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index 9b295b2878bef..a1aca63086777 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -604,6 +604,7 @@ static struct sk_buff *udp_gro_receive_segment(struct list_head *head,
 					NAPI_GRO_CB(skb)->flush = 1;
 					return NULL;
 				}
+				skb_set_network_header(skb, skb_gro_receive_network_offset(skb));
 				ret = skb_gro_receive_list(p, skb);
 			} else {
 				skb_gro_postpull_rcsum(skb, uh,
-- 
2.39.5



