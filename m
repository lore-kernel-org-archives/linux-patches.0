Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713654071DA;
	Sun,  7 Jun 2026 10:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827376; cv=none; b=XCCt/lBeqceM5kP+Clm+ZW3vVUv4YL9Z3Sty+Fo77Bqv3bb+NAXCmeGL0OJbQ3Th6Pg2zEKg1gb45X/Qf1E21Bxa7iqa9QgG+emrK8+Gf4iXuC/NF98XFVh18New/D6epfsRxBK/xFIpHqxrBoTIgf8yDghUSwWt51tNphyJVwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827376; c=relaxed/simple;
	bh=OFihKPREbREYtcxDRzraHfZbZgGBsj5wRVjXBRQycms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=th6igREASPHqXa+l6hw5rIk1pfo4yjoooozd0Yesi2+mb8nGvDldnVytDWN3XzUm7DeQFHX7DQ7seZdlcG88W2eV9Mr9jbnhLqz87sBEzoNAMmmgJklghwcwnkp6uV8v2tv0shCjTBWg4XoInr2Cr0BaWEGHUOfQ+jW2UfTDpHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=can+/x7F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="can+/x7F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B608B1F00893;
	Sun,  7 Jun 2026 10:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827375;
	bh=SEKqhB9Qy/iK02YqfGPqB23ioiX8H34OdbYZ6/QSnHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=can+/x7FJxvyV7TLcvIG4KObKrvRTiDBWrD7S9QfWAsJBhGT5vykKn4GdHyWiNtHV
	 3DpbKVr0/ya+wYUg/md90FStiMnue7XWLsKF3XEPhvDXE5n+sNgMzCiPf0Pkp5TKX8
	 LVNWtnH4ksqY9JHS6DCIZS5qsQ8/YxYgybk++xMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damiano Melotti <melotti@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 056/315] tunnels: do not assume transport header in iptunnel_pmtud_check_icmp()
Date: Sun,  7 Jun 2026 11:57:23 +0200
Message-ID: <20260607095729.662907615@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index d5a63155a05597..4b5fd4b13722ca 100644
--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -280,7 +280,6 @@ static int iptunnel_pmtud_build_icmp(struct sk_buff *skb, int mtu)
  */
 static int iptunnel_pmtud_check_icmp(struct sk_buff *skb, int mtu)
 {
-	const struct icmphdr *icmph = icmp_hdr(skb);
 	const struct iphdr *iph = ip_hdr(skb);
 
 	if (mtu < 576 || iph->frag_off != htons(IP_DF))
@@ -291,9 +290,17 @@ static int iptunnel_pmtud_check_icmp(struct sk_buff *skb, int mtu)
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



