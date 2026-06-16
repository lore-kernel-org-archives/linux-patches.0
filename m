Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF1F93C09E1;
	Tue, 16 Jun 2026 18:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633129; cv=none; b=GkjmTXHg1SzMs+c0WXNF/8b9OrpZMl38ewu68AVy1aSop5uoddlmdIeb+egMsKAsGT+ukGNJkr8EdCQ/TEQtxS0Wz3fw2BnvGmeALUlApi9V0wp581qWW8MtBnxy5uvHun0fQbbvkQ3eQO0LuNFhgQfwhquwejhlwTRZ3B2r4mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633129; c=relaxed/simple;
	bh=6JelwhtKkyx8n02Ei2O0R9i+dzu3TH4YGH/p0kGdXto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lg2GNiEsx9MIebvxOZHOBy8b2qSaskUsoCbIYGjbH/z7H/xX6BoCKOg4iC0bpA9Iipyu85oxTRGVt1FL8VENqUzIb2e7dvloFGUrvJvnAm2tTFSJFtq/KgVlNF88LGgYl+wa7FqyFlCaajN6kRPVx6yWAO6CbynCror9+6by2jQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dMwKErvE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dMwKErvE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A00CD1F000E9;
	Tue, 16 Jun 2026 18:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633128;
	bh=5zOorEBYf0N8EiNtRPJd7dV0eNEwxI7VzI2mv+NDpkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dMwKErvE6ja1Dh+1815084UKm5Ohxi2Ps3ZBvujBruDLdz615oUEyvgYG/jssKIyu
	 VetKTqyZ+w1cqdwkggbo7eI3SAHRAYoZGeJL+EfrqnWaDQXZAUDJSIsCFypa86WI+N
	 MLNgLEZDZ1+7DKTP/CR1n6+Kx1F1U0H5FNujrRAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damiano Melotti <melotti@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 024/411] tunnels: do not assume transport header in iptunnel_pmtud_check_icmp()
Date: Tue, 16 Jun 2026 20:24:22 +0530
Message-ID: <20260616145101.653349994@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 509323077ef79a26ba0c60bb556e45c12c398b2d ]

In some cases, iptunnel_pmtud_check_icmp() can be called while
skb transport header is not set.

This triggers an out-of-bound access, because
(typeof(skb->transport_header))~0U is 65535.

Access the icmp header based on IPv4 network header,
after making sure icmp->type is present in skb linear part.

Note that iptunnel_pmtud_check_icmpv6()) is fine.

Fixes: 4cb47a8644cc ("tunnels: PMTU discovery support for directly bridged IP packets")
Reported-by: Damiano Melotti <melotti@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260522115512.1519110-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_tunnel_core.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
index 4d80bbcd15d5a4..f535b875a02b88 100644
--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -262,7 +262,6 @@ static int iptunnel_pmtud_build_icmp(struct sk_buff *skb, int mtu)
  */
 static int iptunnel_pmtud_check_icmp(struct sk_buff *skb, int mtu)
 {
-	const struct icmphdr *icmph = icmp_hdr(skb);
 	const struct iphdr *iph = ip_hdr(skb);
 
 	if (mtu < 576 || iph->frag_off != htons(IP_DF))
@@ -273,9 +272,17 @@ static int iptunnel_pmtud_check_icmp(struct sk_buff *skb, int mtu)
 	    ipv4_is_lbcast(iph->saddr)  || ipv4_is_multicast(iph->saddr))
 		return 0;
 
-	if (iph->protocol == IPPROTO_ICMP && icmp_is_err(icmph->type))
-		return 0;
+	if (iph->protocol == IPPROTO_ICMP) {
+		const struct icmphdr *icmph;
 
+		if (!pskb_network_may_pull(skb, iph->ihl * 4 +
+						offsetofend(struct icmphdr, type)))
+			return 0;
+		iph = ip_hdr(skb);
+		icmph = (void *)iph + iph->ihl * 4;
+		if (icmp_is_err(icmph->type))
+			return 0;
+	}
 	return iptunnel_pmtud_build_icmp(skb, mtu);
 }
 
-- 
2.53.0



