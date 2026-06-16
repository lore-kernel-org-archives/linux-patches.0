Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 673B03ACF15;
	Tue, 16 Jun 2026 18:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635574; cv=none; b=APFrr7PSIug1SITD5LbAov7KXvskEJdVEhRAmEIiG1RtdsMBO5HM5OG8RipARKDdCbiA3zyK4MVqV6DUB5d8xTorsWcBti7e5cDkfRKtF8TVVrcdX9z2ZLNPATyvCpQgQE1bA1TDK7WiH6NcUuB1dvV3/0Xl6PaQu6qZN7WcX6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635574; c=relaxed/simple;
	bh=Qyhuhv90lvSK2glXWZAhV2+PjuS5bDiNhjIg+ay6amw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sgzeeHDImMTyErzLRYZHiwWbIDTHTrTLSImYzuTbHPuqlQfm1qu5h9M6smkf3jdW1z+71+gOaIIi06Ymw45fzJVCh/65+ZFk7XM+ZVgvUJsZC04gL/kmdrroIo9Ccbpoh+OxWceh3aM02XR04vhMphIBshPIfExBhGRB4Tfj784=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wck6YaXm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wck6YaXm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C0491F000E9;
	Tue, 16 Jun 2026 18:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635573;
	bh=gnYzAn2rKjhNFuaMkizJ9auyqLELN48g5j6Zwe1zgLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wck6YaXm6AZLqpVDGinFc4Dw36fWLkdKIybWQgvBbHGZdzVVysxE4Mv49an7M2mJR
	 1e5ct/Ewa8GqU9OWU27jwn32X9/s0zN+KmNacrgkqQK9XlTYSejUfm9N1YsQNA+Xma
	 RI69mW1N1cJrpAOZCDkHfZ5yTLP1fYvsLXC2tuBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qi Tang <tpluszz77@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 074/342] ipv6: validate extension header length before copying to cmsg
Date: Tue, 16 Jun 2026 20:26:10 +0530
Message-ID: <20260616145051.691527473@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

From: Qi Tang <tpluszz77@gmail.com>

commit dd433671fef381fdaf7b530c631e6b782d66e224 upstream.

ip6_datagram_recv_specific_ctl() builds IPV6_{HOPOPTS,DSTOPTS,RTHDR}
cmsgs (and their IPV6_2292* legacy counterparts) by trusting the
on-wire hdrlen byte (ptr[1]) when computing the put_cmsg() length.
The length was validated only at parse time (ipv6_parse_hopopts(),
etc.).  An nftables payload-write expression can rewrite hdrlen after
parsing and before the skb reaches recvmsg; the write itself is
in-bounds but put_cmsg() then reads up to ((hdrlen+1) << 3) = 2040
bytes from an 8-byte header.  nftables is reachable from an
unprivileged user namespace, so this is an unprivileged
slab-out-of-bounds read:

  BUG: KASAN: slab-out-of-bounds in put_cmsg+0x3ac/0x540
   put_cmsg+0x3ac/0x540
   udpv6_recvmsg+0xca0/0x1250
   sock_recvmsg+0xdf/0x190
   ____sys_recvmsg+0x1b1/0x620

Add ipv6_get_exthdr_len() which validates that at least two bytes
are accessible before reading the hdrlen field, then checks the
computed length against skb_tail_pointer(skb), returning 0 on
failure.  Extension headers are kept in the linear skb area by
pskb_may_pull() during input, so skb_tail_pointer() is the correct
bound.

Use ipv6_get_exthdr_len() at all non-AH call sites: the five
standalone cmsg blocks (HbH, 2292HbH, 2292DSTOPTS x2, 2292RTHDR)
and the three standard cases in the extension-header walk loop
(DSTOPTS, ROUTING, default).  AH retains an inline bounds check
because its length formula differs ((ptr[1]+2)<<2).

The walk loop also gets a pre-read bounds check at the top to
validate ptr before any case accesses ptr[0] or ptr[1].

When the walk loop detects a corrupted header, return from the
function instead of continuing to process later socket options.

Cc: stable@vger.kernel.org
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Qi Tang <tpluszz77@gmail.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260523143245.2281415-1-tpluszz77@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/datagram.c |   54 ++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 46 insertions(+), 8 deletions(-)

--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -611,6 +611,18 @@ void ip6_datagram_recv_common_ctl(struct
 	}
 }
 
+static u16 ipv6_get_exthdr_len(const struct sk_buff *skb, const u8 *ptr)
+{
+	u16 len;
+
+	if (ptr + 2 > skb_tail_pointer(skb))
+		return 0;
+
+	len = (ptr[1] + 1) << 3;
+
+	return (len <= skb_tail_pointer(skb) - ptr) ? len : 0;
+}
+
 void ip6_datagram_recv_specific_ctl(struct sock *sk, struct msghdr *msg,
 				    struct sk_buff *skb)
 {
@@ -637,7 +649,10 @@ void ip6_datagram_recv_specific_ctl(stru
 	/* HbH is allowed only once */
 	if (np->rxopt.bits.hopopts && (opt->flags & IP6SKB_HOPBYHOP)) {
 		u8 *ptr = nh + sizeof(struct ipv6hdr);
-		put_cmsg(msg, SOL_IPV6, IPV6_HOPOPTS, (ptr[1]+1)<<3, ptr);
+		u16 len = ipv6_get_exthdr_len(skb, ptr);
+
+		if (len)
+			put_cmsg(msg, SOL_IPV6, IPV6_HOPOPTS, len, ptr);
 	}
 
 	if (opt->lastopt &&
@@ -658,26 +673,37 @@ void ip6_datagram_recv_specific_ctl(stru
 			unsigned int len;
 			u8 *ptr = nh + off;
 
+			if (ptr + 2 > skb_tail_pointer(skb))
+				return;
+
 			switch (nexthdr) {
 			case IPPROTO_DSTOPTS:
 				nexthdr = ptr[0];
-				len = (ptr[1] + 1) << 3;
+				len = ipv6_get_exthdr_len(skb, ptr);
+				if (!len)
+					return;
 				if (np->rxopt.bits.dstopts)
 					put_cmsg(msg, SOL_IPV6, IPV6_DSTOPTS, len, ptr);
 				break;
 			case IPPROTO_ROUTING:
 				nexthdr = ptr[0];
-				len = (ptr[1] + 1) << 3;
+				len = ipv6_get_exthdr_len(skb, ptr);
+				if (!len)
+					return;
 				if (np->rxopt.bits.srcrt)
 					put_cmsg(msg, SOL_IPV6, IPV6_RTHDR, len, ptr);
 				break;
 			case IPPROTO_AH:
 				nexthdr = ptr[0];
 				len = (ptr[1] + 2) << 2;
+				if (ptr + len > skb_tail_pointer(skb))
+					return;
 				break;
 			default:
 				nexthdr = ptr[0];
-				len = (ptr[1] + 1) << 3;
+				len = ipv6_get_exthdr_len(skb, ptr);
+				if (!len)
+					return;
 				break;
 			}
 
@@ -699,19 +725,31 @@ void ip6_datagram_recv_specific_ctl(stru
 	}
 	if (np->rxopt.bits.ohopopts && (opt->flags & IP6SKB_HOPBYHOP)) {
 		u8 *ptr = nh + sizeof(struct ipv6hdr);
-		put_cmsg(msg, SOL_IPV6, IPV6_2292HOPOPTS, (ptr[1]+1)<<3, ptr);
+		u16 len = ipv6_get_exthdr_len(skb, ptr);
+
+		if (len)
+			put_cmsg(msg, SOL_IPV6, IPV6_2292HOPOPTS, len, ptr);
 	}
 	if (np->rxopt.bits.odstopts && opt->dst0) {
 		u8 *ptr = nh + opt->dst0;
-		put_cmsg(msg, SOL_IPV6, IPV6_2292DSTOPTS, (ptr[1]+1)<<3, ptr);
+		u16 len = ipv6_get_exthdr_len(skb, ptr);
+
+		if (len)
+			put_cmsg(msg, SOL_IPV6, IPV6_2292DSTOPTS, len, ptr);
 	}
 	if (np->rxopt.bits.osrcrt && opt->srcrt) {
 		struct ipv6_rt_hdr *rthdr = (struct ipv6_rt_hdr *)(nh + opt->srcrt);
-		put_cmsg(msg, SOL_IPV6, IPV6_2292RTHDR, (rthdr->hdrlen+1) << 3, rthdr);
+		u16 len = ipv6_get_exthdr_len(skb, (u8 *)rthdr);
+
+		if (len)
+			put_cmsg(msg, SOL_IPV6, IPV6_2292RTHDR, len, rthdr);
 	}
 	if (np->rxopt.bits.odstopts && opt->dst1) {
 		u8 *ptr = nh + opt->dst1;
-		put_cmsg(msg, SOL_IPV6, IPV6_2292DSTOPTS, (ptr[1]+1)<<3, ptr);
+		u16 len = ipv6_get_exthdr_len(skb, ptr);
+
+		if (len)
+			put_cmsg(msg, SOL_IPV6, IPV6_2292DSTOPTS, len, ptr);
 	}
 	if (np->rxopt.bits.rxorigdstaddr) {
 		struct sockaddr_in6 sin6;


