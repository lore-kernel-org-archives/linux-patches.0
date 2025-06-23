Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F0B15ADB4;
	Mon, 23 Jun 2025 22:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717277; cv=none; b=WkAcGn1Kmy9+f8GJ3vZoNwiw+P7DNNrci2FxJ3sHVqzNiuvxr6iZJ9mbMy4OVgW+5ZX+zy8zdtlTGSlvPcLHRlNnz45HmubqzkT6064zpT6PF0GbZdwSc8ZD6MIcBtE7Yh7MaNBhAKlROx4TcexiS99goIA73u544Z0HtOYj7/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717277; c=relaxed/simple;
	bh=xdJVQENc/zCK7p9Kip2Skd/TBis/GsPDZFPr9beU2gQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QEzYG7Z5rX0qDEbCR9kdCW4xoQE1ZfqiYaIiTKHFVPPM+TCk2H7XcQTfv71miSe5kcP1D5AAm+mZ8dfUOvmz5Bcz+KS1SK1w/lWmUTV1sdRKxcH623/1BCgHHvjnyAx6iMFiRzwHLnr7NveJOxBviJMK2kjSiVNVDPXDcv51FWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=arRk1s3C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="arRk1s3C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D3E4C4CEED;
	Mon, 23 Jun 2025 22:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717277;
	bh=xdJVQENc/zCK7p9Kip2Skd/TBis/GsPDZFPr9beU2gQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=arRk1s3CeLFSVAJL6rHgSFne0HGKmsvoV1b4dyK60CrbPmVvvifFb4LDthdxBOUoc
	 RBt07R0IV3oSTclAJPXThP0Yv7FwE4WT39Z46dEygeoEP9HKuVWFsxCGhEXHhespVb
	 BkddskAMlFCkVRISpe8KpWpp+BQRe6iZ0xUuBiW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemb@google.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 351/414] ipv6: replace ipcm6_init calls with ipcm6_init_sk
Date: Mon, 23 Jun 2025 15:08:08 +0200
Message-ID: <20250623130650.750492836@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Willem de Bruijn <willemb@google.com>

commit 096208592b09c2f5fc0c1a174694efa41c04209d upstream.

This initializes tclass and dontfrag before cmsg parsing, removing the
need for explicit checks against -1 in each caller.

Leave hlimit set to -1, because its full initialization
(in ip6_sk_dst_hoplimit) requires more state (dst, flowi6, ..).

This also prepares for calling sockcm_init in a follow-on patch.

Signed-off-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20250214222720.3205500-7-willemdebruijn.kernel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/ipv6.h  |    9 ---------
 net/ipv6/raw.c      |    8 +-------
 net/ipv6/udp.c      |    7 +------
 net/l2tp/l2tp_ip6.c |    8 +-------
 4 files changed, 3 insertions(+), 29 deletions(-)

--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -363,15 +363,6 @@ struct ipcm6_cookie {
 	struct ipv6_txoptions *opt;
 };
 
-static inline void ipcm6_init(struct ipcm6_cookie *ipc6)
-{
-	*ipc6 = (struct ipcm6_cookie) {
-		.hlimit = -1,
-		.tclass = -1,
-		.dontfrag = -1,
-	};
-}
-
 static inline void ipcm6_init_sk(struct ipcm6_cookie *ipc6,
 				 const struct sock *sk)
 {
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -777,7 +777,7 @@ static int rawv6_sendmsg(struct sock *sk
 	fl6.flowi6_mark = READ_ONCE(sk->sk_mark);
 	fl6.flowi6_uid = sk->sk_uid;
 
-	ipcm6_init(&ipc6);
+	ipcm6_init_sk(&ipc6, sk);
 	ipc6.sockc.tsflags = READ_ONCE(sk->sk_tsflags);
 	ipc6.sockc.mark = fl6.flowi6_mark;
 
@@ -890,9 +890,6 @@ static int rawv6_sendmsg(struct sock *sk
 	if (hdrincl)
 		fl6.flowi6_flags |= FLOWI_FLAG_KNOWN_NH;
 
-	if (ipc6.tclass < 0)
-		ipc6.tclass = np->tclass;
-
 	fl6.flowlabel = ip6_make_flowinfo(ipc6.tclass, fl6.flowlabel);
 
 	dst = ip6_dst_lookup_flow(sock_net(sk), sk, &fl6, final_p);
@@ -903,9 +900,6 @@ static int rawv6_sendmsg(struct sock *sk
 	if (ipc6.hlimit < 0)
 		ipc6.hlimit = ip6_sk_dst_hoplimit(np, &fl6, dst);
 
-	if (ipc6.dontfrag < 0)
-		ipc6.dontfrag = inet6_test_bit(DONTFRAG, sk);
-
 	if (msg->msg_flags&MSG_CONFIRM)
 		goto do_confirm;
 
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1399,7 +1399,7 @@ int udpv6_sendmsg(struct sock *sk, struc
 	int is_udplite = IS_UDPLITE(sk);
 	int (*getfrag)(void *, char *, int, int, int, struct sk_buff *);
 
-	ipcm6_init(&ipc6);
+	ipcm6_init_sk(&ipc6, sk);
 	ipc6.gso_size = READ_ONCE(up->gso_size);
 	ipc6.sockc.tsflags = READ_ONCE(sk->sk_tsflags);
 	ipc6.sockc.mark = READ_ONCE(sk->sk_mark);
@@ -1608,9 +1608,6 @@ do_udp_sendmsg:
 
 	security_sk_classify_flow(sk, flowi6_to_flowi_common(fl6));
 
-	if (ipc6.tclass < 0)
-		ipc6.tclass = np->tclass;
-
 	fl6->flowlabel = ip6_make_flowinfo(ipc6.tclass, fl6->flowlabel);
 
 	dst = ip6_sk_dst_lookup_flow(sk, fl6, final_p, connected);
@@ -1656,8 +1653,6 @@ back_from_confirm:
 	WRITE_ONCE(up->pending, AF_INET6);
 
 do_append_data:
-	if (ipc6.dontfrag < 0)
-		ipc6.dontfrag = inet6_test_bit(DONTFRAG, sk);
 	up->len += ulen;
 	err = ip6_append_data(sk, getfrag, msg, ulen, sizeof(struct udphdr),
 			      &ipc6, fl6, dst_rt6_info(dst),
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -547,7 +547,7 @@ static int l2tp_ip6_sendmsg(struct sock
 	fl6.flowi6_mark = READ_ONCE(sk->sk_mark);
 	fl6.flowi6_uid = sk->sk_uid;
 
-	ipcm6_init(&ipc6);
+	ipcm6_init_sk(&ipc6, sk);
 
 	if (lsa) {
 		if (addr_len < SIN6_LEN_RFC2133)
@@ -634,9 +634,6 @@ static int l2tp_ip6_sendmsg(struct sock
 
 	security_sk_classify_flow(sk, flowi6_to_flowi_common(&fl6));
 
-	if (ipc6.tclass < 0)
-		ipc6.tclass = np->tclass;
-
 	fl6.flowlabel = ip6_make_flowinfo(ipc6.tclass, fl6.flowlabel);
 
 	dst = ip6_dst_lookup_flow(sock_net(sk), sk, &fl6, final_p);
@@ -648,9 +645,6 @@ static int l2tp_ip6_sendmsg(struct sock
 	if (ipc6.hlimit < 0)
 		ipc6.hlimit = ip6_sk_dst_hoplimit(np, &fl6, dst);
 
-	if (ipc6.dontfrag < 0)
-		ipc6.dontfrag = inet6_test_bit(DONTFRAG, sk);
-
 	if (msg->msg_flags & MSG_CONFIRM)
 		goto do_confirm;
 


