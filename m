Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 630BF47143A;
	Tue, 21 Jul 2026 20:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664215; cv=none; b=iMAkRe1jX8izyimZyEEBtfpHR8FnqdAvLuSyYzEm1xj0zoZwiBWnQYBQ/X2lN1ffFY0olTnxI1+YUQLAmiNzmut+CZzJeGG/NHb/2DfVPmF+c8LnvCuK0EWASE4v68k/28b/MQyzh7DHE4SXdWzqASA6rPYr08BphkK/nyX+k9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664215; c=relaxed/simple;
	bh=XNlHdjxI1AuaWw+gGxelr1Vhl9qSFemwVeA85BnOYUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h3YnUWbMzcx97GQF6itAsddLVzoDaeuSAr/oBUDw17s3CN9HjZc1ZQQ7P9kOrUy6xlHchW6Gs3anAIvU1RsFpsHVbedhKBmXiXzp0Ms3p42qX+7ngrbl+E1Q800/Ysu+U+RWCcppC839RN5Ofl1SFObSU6VY5wb61yoFCrVaQnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CvxwKjVC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CvxwKjVC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45C421F00A3A;
	Tue, 21 Jul 2026 20:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664212;
	bh=8fTY5VIR8O7fefgBBP8CFd4226LUPIJ2eflsa/6kH6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CvxwKjVC+1W9bw+kJXl73MhBxR2APs8tcd3jZaXU6BAaih8qNA487UdMMPpagOsOk
	 4RI4zh75HtyfazDYal3duH/rPJEGbVyP1sh4aeHZcm76XML7Cv/iWA4B7ZnAkOappq
	 C8NXoLS5Bz7Zw9ctsTCapa5eEzuOFb4n1uIZS4A4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Anastasov <ja@ssi.bg>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 6.12 1116/1276] ipvs: fix more places with wrong ipv6 transport offsets
Date: Tue, 21 Jul 2026 17:25:59 +0200
Message-ID: <20260721152510.968641953@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Anastasov <ja@ssi.bg>

commit b3fe4cbd583895987935a9bdad01c8f9d3a02310 upstream.

Sashiko reports for more incorrect IPv6 transport offsets.

The app code for TCP was assuming IPv4 network header
even after the ipvsh argument was provided. This can
cause problems with apps over IPv6. As for the only
official app in the kernel tree (FTP) this problem is
harmless because we use Netfilter to mangle the FTP
ports and we do not adjust the TCP seq numbers.

Also, provide correct offset of the ICMPV6 header in
ip_vs_out_icmp_v6() for correct checksum checks when
the IPv6 packet has extension headers.

Fixes: d12e12299a69 ("ipvs: add ipv6 support to ftp")
Fixes: 2a3b791e6e11 ("IPVS: Add/adjust Netfilter hook functions and helpers for v6")
Cc: stable@vger.kernel.org
Link: https://sashiko.dev/#/patchset/20260706101624.69471-1-zhaoyz24%40mails.tsinghua.edu.cn
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/ipvs/ip_vs_app.c  |   10 ++++------
 net/netfilter/ipvs/ip_vs_core.c |    3 +--
 2 files changed, 5 insertions(+), 8 deletions(-)

--- a/net/netfilter/ipvs/ip_vs_app.c
+++ b/net/netfilter/ipvs/ip_vs_app.c
@@ -362,14 +362,13 @@ static inline int app_tcp_pkt_out(struct
 				  struct ip_vs_iphdr *ipvsh)
 {
 	int diff;
-	const unsigned int tcp_offset = ip_hdrlen(skb);
 	struct tcphdr *th;
 	__u32 seq;
 
-	if (skb_ensure_writable(skb, tcp_offset + sizeof(*th)))
+	if (skb_ensure_writable(skb, ipvsh->len + sizeof(*th)))
 		return 0;
 
-	th = (struct tcphdr *)(skb_network_header(skb) + tcp_offset);
+	th = (struct tcphdr *)(skb_network_header(skb) + ipvsh->len);
 
 	/*
 	 *	Remember seq number in case this pkt gets resized
@@ -439,14 +438,13 @@ static inline int app_tcp_pkt_in(struct
 				 struct ip_vs_iphdr *ipvsh)
 {
 	int diff;
-	const unsigned int tcp_offset = ip_hdrlen(skb);
 	struct tcphdr *th;
 	__u32 seq;
 
-	if (skb_ensure_writable(skb, tcp_offset + sizeof(*th)))
+	if (skb_ensure_writable(skb, ipvsh->len + sizeof(*th)))
 		return 0;
 
-	th = (struct tcphdr *)(skb_network_header(skb) + tcp_offset);
+	th = (struct tcphdr *)(skb_network_header(skb) + ipvsh->len);
 
 	/*
 	 *	Remember seq number in case this pkt gets resized
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -1041,8 +1041,7 @@ static int ip_vs_out_icmp_v6(struct netn
 	snet.in6 = ciph.saddr.in6;
 	offset = ciph.len;
 	return handle_response_icmp(AF_INET6, skb, &snet, ciph.protocol, cp,
-				    pp, offset, sizeof(struct ipv6hdr),
-				    hooknum);
+				    pp, offset, ipvsh->len, hooknum);
 }
 #endif
 


