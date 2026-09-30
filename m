Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE94355819;
	Wed, 30 Sep 2026 17:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790211; cv=none; b=k2nzROIomijweA/1l8KboIIvoF7ZA4SGXQRQYdqPnijguoh3QAAV7vr0TWrbcqPdr/pA6ln9zcHOw7fhxowMsemVadxSA1mL/FfUeBObblh2YhQMflJY3dvScY1P7E2+r/QzMkpXSoQALWsYenIzjfAg6nYallfb/CrljBK/r/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790211; c=relaxed/simple;
	bh=nSCFKxnh4PjDtGNQXxuSobW8oxeztrh86AAJCxmb600=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TfuF7iHeJDhoVeoADLaIae7Z0qOFCnVPHLzBQgaVhsxg/vooY0xDu9afkBfc7NnU6BuhlSrifQtEkB7boIcbkdqaYc4Pl4nRaHMe9MRfqvGKQwZAIS++dL/FTIDuc/iGO7LVtXE9nCulOmte+79MXyTXuoJvaUj/bgqxPozq3rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZeJc69ln; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZeJc69ln"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFF2E1F000FF;
	Wed, 30 Sep 2026 17:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790210;
	bh=rdgoPZ4Zn5OecCW0bu4Jp4H31FYt0IwUGrfduef+dMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZeJc69lnteEMfUr2nFjuHF0Y5cPvOfIJhfROUNMU2ytJltaBm37R+VCDScuCYwZfC
	 sCzSmgFB5utSGhrUiGCx3grE4D1XoTTEDvpwwPetmZniXafpDCe3T98biS9dHOj8WK
	 Jtukw5bknyu6SQHTR7qMKCF3LDBM9NMZgxz3P9yU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	David Ahern <dsahern@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 750/877] ipv6: reorganise struct ipv6_pinfo
Date: Wed, 30 Sep 2026 17:27:41 +0200
Message-ID: <20260930152430.881695563@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit b76543b21fbcfbb96332fd80cc0d85bbcd72d8f0 ]

Move fields used in tx fast path at the beginning of the structure,
and seldom used ones at the end.

Note that rxopt is also in the first cache line.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20250916160951.541279-5-edumazet@google.com
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 8d6cd1885085 ("ipv6: flowlabel: cap duplicate leases per socket")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/ipv6.h |   33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

--- a/include/linux/ipv6.h
+++ b/include/linux/ipv6.h
@@ -212,18 +212,21 @@ struct inet6_cork {
 
 /* struct ipv6_pinfo - ipv6 private area */
 struct ipv6_pinfo {
+	/* Used in tx path (inet6_csk_route_socket(), ip6_xmit()) */
 	struct in6_addr 	saddr;
-	struct in6_pktinfo	sticky_pktinfo;
+	__be32			flow_label;
+	u32			dst_cookie;
+	struct ipv6_txoptions __rcu	*opt;
+	s16			hop_limit;
+	u8			pmtudisc;
+	u8			tclass;
 #ifdef CONFIG_IPV6_SUBTREES
 	bool			saddr_cache;
 #endif
 	const struct in6_addr		*daddr_cache;
 
-	__be32			flow_label;
-	__u32			frag_size;
-
-	s16			hop_limit;
 	u8			mcast_hops;
+	u32			frag_size;
 
 	int			ucast_oif;
 	int			mcast_oif;
@@ -231,7 +234,7 @@ struct ipv6_pinfo {
 	/* pktoption flags */
 	union {
 		struct {
-			__u16	srcrt:1,
+			u16	srcrt:1,
 				osrcrt:1,
 			        rxinfo:1,
 			        rxoinfo:1,
@@ -248,29 +251,25 @@ struct ipv6_pinfo {
 				recvfragsize:1;
 				/* 1 bits hole */
 		} bits;
-		__u16		all;
+		u16		all;
 	} rxopt;
 
 	/* sockopt flags */
-	__u8			srcprefs;	/* 001: prefer temporary address
+	u8			srcprefs;	/* 001: prefer temporary address
 						 * 010: prefer public address
 						 * 100: prefer care-of address
 						 */
-	__u8			pmtudisc;
-	__u8			min_hopcount;
-	__u8			tclass;
+	u8			min_hopcount;
 	__be32			rcv_flowinfo;
+	struct in6_pktinfo	sticky_pktinfo;
 
-	__u32			dst_cookie;
+	struct sk_buff		*pktoptions;
+	struct sk_buff		*rxpmtu;
+	struct inet6_cork	cork;
 
 	struct ipv6_mc_socklist	__rcu *ipv6_mc_list;
 	struct ipv6_ac_socklist	*ipv6_ac_list;
 	struct ipv6_fl_socklist __rcu *ipv6_fl_list;
-
-	struct ipv6_txoptions __rcu	*opt;
-	struct sk_buff		*pktoptions;
-	struct sk_buff		*rxpmtu;
-	struct inet6_cork	cork;
 };
 
 /* We currently use available bits from inet_sk(sk)->inet_flags,


