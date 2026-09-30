Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4673C4DDB23;
	Wed, 30 Sep 2026 16:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787022; cv=none; b=aG6vAjjAHO4ce4BfgFG13RboOXvFixSNYSC2BVOifnYBkm5g4nXfxt31LCNYFHAbo9BHUmvvn94z4UCvLeWOZ6nMFwmeLUQ5MxBaMvg0+5JrPxR7dQMEqwovAAZ4SvGS19q4MZfsL8OJMv6yUebJxvDth07PlPmJyETQ2cF5+YE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787022; c=relaxed/simple;
	bh=XxRVG+VaTgKjYh2/lYSmKal8OGkOTWYwDBmTE5SBcuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fBxcgXynxVYvlJAdGWx482vc9TPZlrhSZOWPNXcNoTQdL3lpEyJyBR8bCJGfvdI9avNnbnYJC0nsooAadlAHXFEYqoZZNZldzDpWu0bMb4ji68ZCro4Kt1bg+ZKOFx8aONJFaouapbkUdCFdkZCE55Xoe0r+N3lJJ+stb5TwpBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uefRihwK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uefRihwK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1AB71F000FF;
	Wed, 30 Sep 2026 16:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787021;
	bh=Q5835S/o+YrULsSxb26YbRAyor2Iv1WDylds6jUCJBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uefRihwKa/EsA/R7fq4UJ7ztvytLUtm450kG/hCV3GHhPPzkXkLsgXBzNsYgoww2R
	 HpckUC6tAR6cT/Ax1RJA61UWS30xpIRzI9jESm7oJBtPmNwXOIA37HcK+WvG1LCiyI
	 KbG1/CXbKMIbB26ZVdo6txAKfi6NXiIvgMxu+NTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 084/457] ipvs: revalidate ihl before icmp_send
Date: Wed, 30 Sep 2026 17:23:09 +0200
Message-ID: <20260930152347.862290711@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index eb806813292ad..6802ce5cb1de4 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -1961,6 +1961,12 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
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



