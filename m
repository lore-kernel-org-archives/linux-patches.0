Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C490B17BEC0;
	Thu, 15 Aug 2024 14:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732126; cv=none; b=SCkz9+UdMPWnNtwkdCpxsdVaIsOMLQupmjooqt3TkR6x9g+74kVaI2spsyFocz+UYrdOLZbZFNgPZhs1zcMTLK+TFJwE6V/Xg9pZepCxnG0oglwavfZtfiBAnV3jlKwyINoKLyRHsNpMmtAfBISD6lHnEE8ifuZfZURrIESsvyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732126; c=relaxed/simple;
	bh=Ue9twnTG66oKXARVWe+oUYzO5aHGqC4OR6bD2HijYbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ihAVAIhjR5G+/yMOWE1Rw/SuaHdpfZJaqa20eNZhyIwRmWrVCpZB7w9avehSKWpX+k7vRAID+fPcIV8PA5yAw+Lho8xhRe2+e08yFIbN5Ie1iy7DpzvfLcIMKzvKibnfIPo8nYOlzxfPJ9zm0rYJvgNExgzc0qE1e5ko6EK6i3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H6qm+Dv6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H6qm+Dv6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C57FC32786;
	Thu, 15 Aug 2024 14:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732126;
	bh=Ue9twnTG66oKXARVWe+oUYzO5aHGqC4OR6bD2HijYbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H6qm+Dv6PolnDRsxYyOe0kcXRe2kTLz5VMxPtWYyKdVmrT2xFofODgV6WH/uvtN9P
	 rN4TuvP3TNZzElDuPusB9kUxY21nXtwvmkTR0Z9X5XEuvLYlOW/lcBFKXpzwg26z0X
	 dHphx48zYN95mpeKqRVHcFoCYTu8faEAHr2Xkt7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ismael Luceno <iluceno@suse.de>,
	Julian Anastasov <ja@ssi.bg>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 051/352] ipvs: Avoid unnecessary calls to skb_is_gso_sctp
Date: Thu, 15 Aug 2024 15:21:57 +0200
Message-ID: <20240815131921.212954235@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



