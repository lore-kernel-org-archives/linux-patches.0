Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB412C1595;
	Sun,  7 Jun 2026 10:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828793; cv=none; b=NFle8HRg+2KnDDLP9kf4e8RV4Pj21akVDu0xgsNLZ2QiFc/ycEb1M7/r8Ls2sFUsE19/nw98Pnqh3pc4QFfgvT5zZyvYclP/EybhkIzEu1r1AE1T8rXUW5hZq5cBPqIEoECe7O8msfymhTjCdMKC8mlzR2EKW8NtcSAd/5nR7e0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828793; c=relaxed/simple;
	bh=56uzZXdSZ1WeZeLSHfy1CmSQQam/TzuM2jFzLvcb59U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UTNTHKh1WKnTvSi3kpznhY6Ql3/o3JRxzdyG2lIRuNFS/1yabvLL1bpLnHieiFKZjGeue95ahrWbUy6tVspkvYINfXmSyHn19vDeHHVHArNLENaA5ozWWp0ZCtomLmzqIz3LBVzpz2cXtomnflpsJOjC0MHVV1bVUKkyQxo5Cio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IsLl+7I8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IsLl+7I8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 955681F00893;
	Sun,  7 Jun 2026 10:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828792;
	bh=YyMmM7MaNylWQqa7hceTWchpuEL+GmfZGfZzuuzt3+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IsLl+7I8yQhWwGWwbIA+PqotxMyTb8QFZqa7nebr1PytiZ8NvQPpqcHrZ8b2cnvOA
	 Nx5R3LfnecQ3sVjSimYM3Hun/N6UbOh+FXlOnPZF8JKdcUtLQT/+3QujdoyE1mmOgB
	 /FtITVXBluloFRpo2vmrd9Liw63N9UEYLt8rohQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qi Tang <tpluszz77@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 216/332] ipv6: validate extension header length before copying to cmsg
Date: Sun,  7 Jun 2026 11:59:45 +0200
Message-ID: <20260607095735.993558926@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -618,6 +618,18 @@ void ip6_datagram_recv_common_ctl(struct
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
@@ -644,7 +656,10 @@ void ip6_datagram_recv_specific_ctl(stru
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
@@ -665,26 +680,37 @@ void ip6_datagram_recv_specific_ctl(stru
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
 
@@ -706,19 +732,31 @@ void ip6_datagram_recv_specific_ctl(stru
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


