Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 723664E4305;
	Wed, 30 Sep 2026 15:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783806; cv=none; b=eUOfKOH93PLADPO5g1BoMoz0bgUY+He05JpT88ge6VJlUPGPg9mfPfci8DYweqOBDqfJRewWwvRDDCNrZ6BWXdh/3g9xraMipm2bPMksgJBmYHVdVKkI60P5vJ6hPvJNLmbS9hxIGP6PAbG/Vae+nDhxBLmJdCrOcVF7FRWV6Go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783806; c=relaxed/simple;
	bh=VQ1EGnFJzW7fUoBgcLoImYLuoBHJ4MLi7xMoCkTNX98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kE1PYZMf6ThOjZmvfxpRQjkRyAepzKmmN8fFhvjtvr32xmQEkAHBBBBX3nnnBskDc4jd7IQG5aH/PSZ71PmegVdU524yIgy+Mel4n+qAJDsBOXTCvVlfssz0nIfawgkBUuu/2ZthEJvfS0a7aiubkGpVKmLaAhvTH/uWia30yhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0/DKYqQp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0/DKYqQp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23F851F00893;
	Wed, 30 Sep 2026 15:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783795;
	bh=YmHMdABzioxcn6s8JPXAbaQ2oNa1Eu2ycB3hlLQwHtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0/DKYqQpG4xcQnPx2FgjbMrzITHDfqj/ydkv366rxVqVGfSxP1Lfir3M0XHnNdVCG
	 rDbpEXk9fLIZ93kPQZMjlYvtAT86pgPFijVuw6MvFp/ffKZs6kixXGMCVR8+1UR5/r
	 r6PuCQK1hAn0na6YrS7ldNE+MbzMw6Zo6kIM1Ug0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 498/595] ipvs: revalidate ihl before icmp_send
Date: Wed, 30 Sep 2026 17:26:31 +0200
Message-ID: <20260930152358.407833132@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Anastasov <ja@ssi.bg>

[ Upstream commit e290145564886d6a3038810c621f738c1fe9fa51 ]

While the outer IP header is already pulled into the skb head, we must
be careful and revalidate the embedded headers after reading them from
the skb frags to prevent possible out-of-bounds access.

One such place reported by Sashiko is ip_vs_in_icmp() where local
process can change the ihl field and after pskb_may_pull() we can see
larger value. Even if icmp_send() has checks to prevent out-of-bounds
access, play safe and add check to drop the packet if the ihl field is
changed.  As the outer headers are pulled, make sure the transport
header is updated too, it was used before commit 7fcc2fe39fed ("net:
icmp: avoid invalid transport header access in icmp_send tracepoint")

Fixes: f2edb9f7706d ("ipvs: implement passive PMTUD for IPIP packets")
Link: https://sashiko.dev/#/patchset/20260806105211.34622-1-ja%40ssi.bg
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipvs/ip_vs_core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index c3d2e70bb007b..a49dd1a2ed08e 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -1841,6 +1841,12 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
 		/* Ensure the IP header is present in headroom */
 		if (!pskb_may_pull(skb, hlen_orig))
 			goto ignore_tunnel;
+		skb_set_transport_header(skb, hlen_orig);
+		/* Before now we may used ihl from skb frag, revalidate it after
+		 * copying it into skb head to prevent out-of-bounds access
+		 */
+		if (ip_hdr(skb)->ihl * 4 != hlen_orig)
+			goto ignore_tunnel;
 		IP_VS_DBG(12, "Sending ICMP for %pI4->%pI4: t=%u, c=%u, i=%u\n",
 			&ip_hdr(skb)->saddr, &ip_hdr(skb)->daddr,
 			type, code, ntohl(info));
-- 
2.53.0



