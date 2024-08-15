Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4CAA176ADE;
	Thu, 15 Aug 2024 13:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729434; cv=none; b=lSGyb/N0hlZlII45xMKI87rXWsHp5b5CJuem60h4fZCEbicq9w26wOkRahScPU3Cvs0615tG+tvjv91xnneBBjwbXSC7eU4zQrYIwAJU/9FR0nUw14xzcNrfbSNt3vSzpU66Ufidt7MRNJYrPZfetXm6K7VJDweoxmwlp/ILYDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729434; c=relaxed/simple;
	bh=bnCs1GK4LoWDXUu6vc53zWbhCcphXr0RnguEHICcQQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B4a+oQwVWa5W/I5Xjh2rgav/ZHRH46s64fYRykQ1onlLNrrW9oc3nIxraJPeqlrblSuDbuvovXC/k4r49o/KH+KDFGjh5o6+sjFLToCNBlO0GM7amfwWoYCv1uVcPNPsCCMZT1EkFkJfXAmjrg3O3+dg7L9y7QnqlcverWxqRuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1wmxvUAy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1wmxvUAy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CCAFC32786;
	Thu, 15 Aug 2024 13:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729434;
	bh=bnCs1GK4LoWDXUu6vc53zWbhCcphXr0RnguEHICcQQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1wmxvUAyTJKMqgdz9N//111Yw1pvCjKtq83LK760uLR7dghh7QqEZk+9ViOBZ/fKr
	 8zVirYhe/07Cp2ePyMwygQZ6Ig6VZtCfaNg6gMBIWzpRVkeohHUYhC0t+2aQqhXOdj
	 IyYpCeAYJPSFZRDM0DdqC0Kvdl7hATnJEWPDCBr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ismael Luceno <iluceno@suse.de>,
	Julian Anastasov <ja@ssi.bg>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 065/484] ipvs: Avoid unnecessary calls to skb_is_gso_sctp
Date: Thu, 15 Aug 2024 15:18:43 +0200
Message-ID: <20240815131943.794761398@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

From: Ismael Luceno <iluceno@suse.de>

[ Upstream commit 53796b03295cf7ab1fc8600016fa6dfbf4a494a0 ]

In the context of the SCTP SNAT/DNAT handler, these calls can only
return true.

Fixes: e10d3ba4d434 ("ipvs: Fix checksumming on GSO of SCTP packets")
Signed-off-by: Ismael Luceno <iluceno@suse.de>
Acked-by: Julian Anastasov <ja@ssi.bg>
Acked-by: Simon Horman <horms@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipvs/ip_vs_proto_sctp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_proto_sctp.c b/net/netfilter/ipvs/ip_vs_proto_sctp.c
index 1e689c7141271..83e452916403d 100644
--- a/net/netfilter/ipvs/ip_vs_proto_sctp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_sctp.c
@@ -126,7 +126,7 @@ sctp_snat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
 	if (sctph->source != cp->vport || payload_csum ||
 	    skb->ip_summed == CHECKSUM_PARTIAL) {
 		sctph->source = cp->vport;
-		if (!skb_is_gso(skb) || !skb_is_gso_sctp(skb))
+		if (!skb_is_gso(skb))
 			sctp_nat_csum(skb, sctph, sctphoff);
 	} else {
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
@@ -175,7 +175,7 @@ sctp_dnat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
 	    (skb->ip_summed == CHECKSUM_PARTIAL &&
 	     !(skb_dst(skb)->dev->features & NETIF_F_SCTP_CRC))) {
 		sctph->dest = cp->dport;
-		if (!skb_is_gso(skb) || !skb_is_gso_sctp(skb))
+		if (!skb_is_gso(skb))
 			sctp_nat_csum(skb, sctph, sctphoff);
 	} else if (skb->ip_summed != CHECKSUM_PARTIAL) {
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
-- 
2.43.0



