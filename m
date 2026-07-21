Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1C646EC77;
	Tue, 21 Jul 2026 18:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659474; cv=none; b=KfihN5MZKt7C9psHABQM1duahsuWdFecV++/1WrNlqSd1XQHUd170C67sUkO7uGV6i+CMjTN1w3lUr33zC7nZO5vS1lt7ikW7Yhr+BU4MALXQhZYvCB6eEDbZxWFElnZJtKYn+kItE55hyIWwgR5SPqlLditavQXM9Kup5DJWCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659474; c=relaxed/simple;
	bh=qLzXw44CGmUHgq1KrZ+M5NEvcwaVrJq+T+yuu28Hkpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MCNkOcvOQU3nF6FUUqxRY9nnLKuXxkFDe1RZkBdKSMBIWTo3qUhQMmj3NyV9pky9MuBKycS2UGQyFtVG0Fxxd9Us3uTgoa2IcNJwzPbAusRSP3DjmkJmAsdnuGtXnavWN4pt1Ov4LTkda22u+srS68nHzdAZ6/5KPT4TZVlFNc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HSC4H/hj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HSC4H/hj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B4391F000E9;
	Tue, 21 Jul 2026 18:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659473;
	bh=7A8uGKo5iKR8prZPtnFrtzRaL9IhO7nGJ1GEaZd4QTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HSC4H/hjo2zyETmFtpQD6o8Bxr7xR1OCLocgL09d6mZ/lJ1SjpIbk7TNDwUY35WPC
	 hIvGoD79ySKcu3jYfL12zSnKWGeDQk/GqxgQX7ijlMQSzVPMc3Yf4zfpwW22OPHPS7
	 XX22895RfGWo+5V01Xr+jm0aSzJpOmiFEuj9nrls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Anastasov <ja@ssi.bg>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 6.18 1491/1611] ipvs: fix more places with wrong ipv6 transport offsets
Date: Tue, 21 Jul 2026 17:26:47 +0200
Message-ID: <20260721152548.979876224@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
 


