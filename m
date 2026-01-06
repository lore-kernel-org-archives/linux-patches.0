Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A0636CE1C;
	Tue,  6 Jan 2026 17:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722360; cv=none; b=OnDg209zAZlVUPbqc7q8J9eoukhJ21HoSwVZFi2RM32NR6rK8styGVwucrzewmtvVaxXvtMVcGNIxICoYHPtM1kj7B+rnrOryvK+9rCsid5/DYIOHYpNoJ26l2Gha2DNaz8UZS3Vi2YpaopUJzryfC2VjrzjAFYDaoiZn5Rw19s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722360; c=relaxed/simple;
	bh=UD6+4ER9Ai5UoFB4vxt898ubugE5tDg3kSepWZqaWa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AsKAY1YH1MLeQw4+rkY/qZjGl7hyJXfK3fslt7HqLKAI0rcSotf17NV4+CPxC+qafW2y7BM0uH/i4ZiNz7ssxKg3Dwx6/oxTcqy/OhnK0+WjCQ0bwu7YBEhgkiEk8r4BvwKsrgJOWUO3AGzTH3QeVY54rPsxoVfMUq+w3KhLKmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FCNR3yNF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FCNR3yNF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00390C116C6;
	Tue,  6 Jan 2026 17:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722360;
	bh=UD6+4ER9Ai5UoFB4vxt898ubugE5tDg3kSepWZqaWa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FCNR3yNF0YVYMIPIDkbyWe9LExKh3EopbUxds1lPvxFYnkJNZCCJ1IXCVBDJPidxk
	 ak2JzJfTiaX4qckyQYayD5bpFXq1quUlETzGxTNRxGvwVgXyn1PL1++6W0Ag9+stKO
	 RS0P3Yncsl/986yJo6Li6bP4y/8Oxugn1l4UAZ1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frode Nordahl <fnordahl@ubuntu.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.18 242/312] erspan: Initialize options_len before referencing options.
Date: Tue,  6 Jan 2026 18:05:16 +0100
Message-ID: <20260106170556.605308089@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Frode Nordahl <fnordahl@ubuntu.com>

commit 35ddf66c65eff93fff91406756ba273600bf61a3 upstream.

The struct ip_tunnel_info has a flexible array member named
options that is protected by a counted_by(options_len)
attribute.

The compiler will use this information to enforce runtime bounds
checking deployed by FORTIFY_SOURCE string helpers.

As laid out in the GCC documentation, the counter must be
initialized before the first reference to the flexible array
member.

After scanning through the files that use struct ip_tunnel_info
and also refer to options or options_len, it appears the normal
case is to use the ip_tunnel_info_opts_set() helper.

Said helper would initialize options_len properly before copying
data into options, however in the GRE ERSPAN code a partial
update is done, preventing the use of the helper function.

Before this change the handling of ERSPAN traffic in GRE tunnels
would cause a kernel panic when the kernel is compiled with
GCC 15+ and having FORTIFY_SOURCE configured:

memcpy: detected buffer overflow: 4 byte write of buffer size 0

Call Trace:
 <IRQ>
 __fortify_panic+0xd/0xf
 erspan_rcv.cold+0x68/0x83
 ? ip_route_input_slow+0x816/0x9d0
 gre_rcv+0x1b2/0x1c0
 gre_rcv+0x8e/0x100
 ? raw_v4_input+0x2a0/0x2b0
 ip_protocol_deliver_rcu+0x1ea/0x210
 ip_local_deliver_finish+0x86/0x110
 ip_local_deliver+0x65/0x110
 ? ip_rcv_finish_core+0xd6/0x360
 ip_rcv+0x186/0x1a0

Cc: stable@vger.kernel.org
Link: https://gcc.gnu.org/onlinedocs/gcc/Common-Variable-Attributes.html#index-counted_005fby-variable-attribute
Reported-at: https://launchpad.net/bugs/2129580
Fixes: bb5e62f2d547 ("net: Add options as a flexible array to struct ip_tunnel_info")
Signed-off-by: Frode Nordahl <fnordahl@ubuntu.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20251213101338.4693-1-fnordahl@ubuntu.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_gre.c  |    6 ++++--
 net/ipv6/ip6_gre.c |    6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -330,6 +330,10 @@ static int erspan_rcv(struct sk_buff *sk
 			if (!tun_dst)
 				return PACKET_REJECT;
 
+			/* MUST set options_len before referencing options */
+			info = &tun_dst->u.tun_info;
+			info->options_len = sizeof(*md);
+
 			/* skb can be uncloned in __iptunnel_pull_header, so
 			 * old pkt_md is no longer valid and we need to reset
 			 * it
@@ -344,10 +348,8 @@ static int erspan_rcv(struct sk_buff *sk
 			memcpy(md2, pkt_md, ver == 1 ? ERSPAN_V1_MDSIZE :
 						       ERSPAN_V2_MDSIZE);
 
-			info = &tun_dst->u.tun_info;
 			__set_bit(IP_TUNNEL_ERSPAN_OPT_BIT,
 				  info->key.tun_flags);
-			info->options_len = sizeof(*md);
 		}
 
 		skb_reset_mac_header(skb);
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -535,6 +535,10 @@ static int ip6erspan_rcv(struct sk_buff
 			if (!tun_dst)
 				return PACKET_REJECT;
 
+			/* MUST set options_len before referencing options */
+			info = &tun_dst->u.tun_info;
+			info->options_len = sizeof(*md);
+
 			/* skb can be uncloned in __iptunnel_pull_header, so
 			 * old pkt_md is no longer valid and we need to reset
 			 * it
@@ -543,7 +547,6 @@ static int ip6erspan_rcv(struct sk_buff
 			     skb_network_header_len(skb);
 			pkt_md = (struct erspan_metadata *)(gh + gre_hdr_len +
 							    sizeof(*ershdr));
-			info = &tun_dst->u.tun_info;
 			md = ip_tunnel_info_opts(info);
 			md->version = ver;
 			md2 = &md->u.md2;
@@ -551,7 +554,6 @@ static int ip6erspan_rcv(struct sk_buff
 						       ERSPAN_V2_MDSIZE);
 			__set_bit(IP_TUNNEL_ERSPAN_OPT_BIT,
 				  info->key.tun_flags);
-			info->options_len = sizeof(*md);
 
 			ip6_tnl_rcv(tunnel, skb, tpi, tun_dst, log_ecn_error);
 


