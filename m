Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E721404BF6;
	Tue, 21 Jul 2026 21:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670428; cv=none; b=mxYUbn8k6t4JeAgoeN6/MU+c3xeq0YwNZuXu7D4AY/DcU0LprnHRHXXrp/IZ0mDNGnozJlEgiyn5+3vtDr/TThO/86NKUP5XTRfi3AA/f9awVS+AGPqGYDAfzFRyInlGjGepDglX4HzrZGhdmJ1G+6W3/69i20jfGeBCJS3FwB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670428; c=relaxed/simple;
	bh=AF+cY1rRHOoextQ5qRHC6uCgCK8HT8d6AEfNY+ki7rY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PpimkiSm2a4af55FJq6NvOQnCZuedi6brPpEauF3LMi1E0znJzI9MKB/F9MEUZFAiymTKh9LUtK9T27u2/9Lvg/EC2WISj1fcm2udWHBacZ/x3r2qO3dmDevGLrO2v9sJDqe/AOGZ3vC6LKTo3zy+byXW1VFKr8ZPAkU0p/DeDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FcbVikvP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FcbVikvP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A3431F000E9;
	Tue, 21 Jul 2026 21:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670425;
	bh=QMMq2OeSe04B2iGmqqjhuD8GKNDkVmUhb04luaTTKvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FcbVikvPm+MP5T0yNwRecc/0+cJ9gnBK/p2qy6LaPyAncamKxfpsqB9retr3B6zjg
	 OJNLPohQyVo+ZnnpOuIL93CSm/m5/Pygp8OYNSrLtJHuUmuTybG6q2vHNdcYHJawvj
	 mM7RT+5v+yB+JJw+jbfOZAJzME8zmvc+WFVEui3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Anastasov <ja@ssi.bg>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 6.1 0926/1067] ipvs: fix more places with wrong ipv6 transport offsets
Date: Tue, 21 Jul 2026 17:25:27 +0200
Message-ID: <20260721152445.247761999@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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
 


