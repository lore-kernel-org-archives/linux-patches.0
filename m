Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30D41511E9B;
	Wed, 30 Sep 2026 16:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786493; cv=none; b=lod8PdPlZpCO0vQFxhla9ltEAeC+HeBguvlHD72lbm0vSkP2gSJVCKim54iA/nsFdHiWee4RqmvWue6JuCET4CP94TCt/E1ENuWvV+jmCWRArqMrTnARg4vv+9uesvklPac0aN9ePp4OZYl9T/KLNbIAQWenhORslBghzXTJ7ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786493; c=relaxed/simple;
	bh=TXhvgQwW4TCZTnSF9m+VYnD1x80FwrQMqzC9cWJhYRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CgEiPkazHrdfooqk2TxBg01NZVmExWngveAC775T7MXmZpeImZ3Lz4ugY1D+xQ2Tcf75snzBzRelr68KR0WVkPqchDZ5IOKyREA478gQgEBIM9ZxXyw/U7Fw3UoX8sNnvYt6myBE2JeE8g9CNNCDCGag1mOx9E2bux+fgTGRNSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VTxcp5u6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VTxcp5u6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A0D11F000FF;
	Wed, 30 Sep 2026 16:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786492;
	bh=TWaisB0y6WLk9Fx06b+Y9kkInEszsujgD3UjfReEFJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VTxcp5u6cay0SO7nZStN0pL3rlfKjGOVxRGdRi9V4aABnVXKH3tOU/5GsOIUEulmn
	 aoHX/I8komEW1GEDYnBc1aLkxiKfmHNDZFHcL6MrvJOspEX5ClabgOP0/z9lmMdKgn
	 8tTDJASwNIhQGhms4S/5PS1bjBECheJ+QUFYxe3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 837/982] ipvs: revalidate ihl before icmp_send
Date: Wed, 30 Sep 2026 17:26:13 +0200
Message-ID: <20260930152434.731536031@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e417fe52fef8f..41f09e29d221b 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -1781,6 +1781,12 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
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



