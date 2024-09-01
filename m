Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67493183CA3;
	Sun,  1 Sep 2024 16:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208498; cv=none; b=qhIf3+Cn0uhWGd3KGrDd5wRG6pBuEPQejHtktlmUAxk/u/OYkxLujwBN7hkFdxZUiAN81+7hbcsD0Hz+B09a+q7cm8Yyh+pioqvaphSexGUepxWcLkxQCrJKQYdIjd09hUmcx/5f/VCwBIKvyIfJcEYaRnon49sqDbXZMletGrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208498; c=relaxed/simple;
	bh=2g71342dXKGLNaoXBYyGXVpgqQqD+xpZji5M598HD7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NKER8XPKRf5tWrDrAseG9EC5sMObtLXK1OSKPYSpovqXqwh4debYPOzi8gk56EjYW++hu6Yv8nzHds23cbmh4UNs//uuNhx+008jKRWmzkPD7GMp+9hAjMxFiS4zaUiMrUpfGpIzRITDoiv1MgeL01iPXjPIR8PhcAazZzyQlFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y/QEydw2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y/QEydw2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEF74C4CEC3;
	Sun,  1 Sep 2024 16:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208498;
	bh=2g71342dXKGLNaoXBYyGXVpgqQqD+xpZji5M598HD7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y/QEydw2OYe2KDubpdSFXKA9SPwNpNmTDOBOIo5P925UiaeFDEbkQDoLDv8G54R3g
	 1EW3C6b824/NK5oCc+xd1ezCurLWN+ValGQTrADm/vRwk6thXD1Zb6EAL1IczGfI8L
	 Syp9lkyFnikRSyNt0tFs39bClfUpnWd8hIVDpo+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 101/149] netfilter: nf_tables_ipv6: consider network offset in netdev/egress validation
Date: Sun,  1 Sep 2024 18:16:52 +0200
Message-ID: <20240901160821.257876915@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 70c261d500951cf3ea0fcf32651aab9a65a91471 ]

>From netdev/egress, skb->len can include the ethernet header, therefore,
subtract network offset from skb->len when validating IPv6 packet length.

Fixes: 42df6e1d221d ("netfilter: Introduce egress hook")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables_ipv6.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_tables_ipv6.h b/include/net/netfilter/nf_tables_ipv6.h
index 467d59b9e5334..a0633eeaec977 100644
--- a/include/net/netfilter/nf_tables_ipv6.h
+++ b/include/net/netfilter/nf_tables_ipv6.h
@@ -31,8 +31,8 @@ static inline int __nft_set_pktinfo_ipv6_validate(struct nft_pktinfo *pkt)
 	struct ipv6hdr *ip6h, _ip6h;
 	unsigned int thoff = 0;
 	unsigned short frag_off;
+	u32 pkt_len, skb_len;
 	int protohdr;
-	u32 pkt_len;
 
 	ip6h = skb_header_pointer(pkt->skb, skb_network_offset(pkt->skb),
 				  sizeof(*ip6h), &_ip6h);
@@ -43,7 +43,8 @@ static inline int __nft_set_pktinfo_ipv6_validate(struct nft_pktinfo *pkt)
 		return -1;
 
 	pkt_len = ntohs(ip6h->payload_len);
-	if (pkt_len + sizeof(*ip6h) > pkt->skb->len)
+	skb_len = pkt->skb->len - skb_network_offset(pkt->skb);
+	if (pkt_len + sizeof(*ip6h) > skb_len)
 		return -1;
 
 	protohdr = ipv6_find_hdr(pkt->skb, &thoff, -1, &frag_off, &flags);
-- 
2.43.0



