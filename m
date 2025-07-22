Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A2938FA3;
	Tue, 22 Jul 2025 14:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193001; cv=none; b=goba3EQ8adMAfFaUYwDOnIi7KRYFZObA5IosBWuGdwNLSFEauSeY5y6OEF/4addtIR6umlD7HhuISrEkCIagedgUcUG3z2JXGakYLwlUAuo9sEqjwKvXk39xrkY2PhaqdjGGvZeczNHS9Ep6hfUevGbiIYPu65f0guTgJjPpx6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193001; c=relaxed/simple;
	bh=pDuGp6lEMtlgqXlbDl5d+5AniSbWaZ+oPnk6w7Fi8Ao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ADXVbTpcv5DX3UbLJvgtz8wkP53yueLfUeoLpsDmwOKThk7SrhBE0dIbxrV1WYxTrGJ99pnVAtHVgu5UhFpMkuVjnbzWI9UYYr4DHjK5LRNV3hnbIAFcB0owsdP7Og7bUvjc2xP/sDyzJ0Z3BsyEv3HkJntVAP447odNb1X9ih8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=raYWmWAN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="raYWmWAN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 197E6C4CEEB;
	Tue, 22 Jul 2025 14:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193001;
	bh=pDuGp6lEMtlgqXlbDl5d+5AniSbWaZ+oPnk6w7Fi8Ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=raYWmWAN63lZR/JCFtT5aD1r0147VIjNzOyG7smMbCRA+kmAgtBTU+zBbtBr0UcLU
	 1s5SkuaOEcfyQ6zz7Y0s+hZP+cRTYTM7Zuft+c3deuEY1shMZjSikei/v0CgSg36mN
	 7TiyQRlB/WDjsmR+zANVf7zRLdCeCJKAnZkdztVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 121/158] net: fix segmentation after TCP/UDP fraglist GRO
Date: Tue, 22 Jul 2025 15:45:05 +0200
Message-ID: <20250722134345.254469795@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e04ebe651c334..3a9c5c14c310e 100644
--- a/net/ipv4/tcp_offload.c
+++ b/net/ipv4/tcp_offload.c
@@ -355,6 +355,7 @@ struct sk_buff *tcp_gro_receive(struct list_head *head, struct sk_buff *skb,
 		flush |= skb->ip_summed != p->ip_summed;
 		flush |= skb->csum_level != p->csum_level;
 		flush |= NAPI_GRO_CB(p)->count >= 64;
+		skb_set_network_header(skb, skb_gro_receive_network_offset(skb));
 
 		if (flush || skb_gro_receive_list(p, skb))
 			mss = 1;
diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index 845730184c5d3..5de47dd5e9093 100644
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



