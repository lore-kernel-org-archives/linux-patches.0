Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033249;
	b=pvoCemyClmJLnU4sbnE+EOXIM1EoQTLqonw6kojMAVu3S9HKXzpaveEUT8xAoP7jtMwZ
	 JUXJZxQcaiiKlm10NeWpJwdA8D5MBr60tqV2sVTaJwMWk9n5GVAZ+H/xe0xBwkckQNAxa
	 UpvFXZVJnvjn4vmewFmRwYy3ZXlZCmynbOuWB3F4ZxkzGci9QxoBi2mYPVHNP8tfZP4uo
	 /NjoTq9qxSjm+qk3QTwQ8l4aup9B+D/HM7FqqpTrn6DfeZWBRKh2ZEb4fUiEYzTGcMP+/
	 iVL0BKqoqJsdPAAO/w64KnI7XFqVDdFYhEeZNhNABjh6U1ITFjTOJePUxrMhgnxlYww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033249;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RgwAnQyJfyQDV2cGnh0Cu+4AppA84JGBiqSOIgeJAuQ=;
	b=lRyX+7ZBU7vjxU+U8oR7gm6FnJ00lKLkjQP0Qs0e0+Yn09EgBamygj5pqZBJ7zy+n1kb
	 HeYPJAtKV58dffLhFLveqqmRP3mAVkA6Ha4cmjKvBLyS/MV8ZlNP2vxwgfVGTZl+NCd1s
	 JdUphicUel7ZPDh9+wkKSbEdsD8oH4CTKWr+fUEbabZ6pAokIG3v/ftvBcyL9HtmLJoyp
	 cRKHqmqBilAV1ZbEbrVX3twHFUHNx3G2fxVXnQGk40pF1ffOkPK1ewoDuoqlOvwLZtwE1
	 /AxJz7Sd7VL6m1Sdorjp4EuZjjEDeXKt1hQjjr+3yDNonFU2C601Dwb6hzjqN4rTrIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="LrZ9a/dp";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B321606A333;
	Wed, 18 Nov 2026 20:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LrZ9a/dp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E9AA1F000C4;
	Wed, 18 Nov 2026 20:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033249;
	bh=RgwAnQyJfyQDV2cGnh0Cu+4AppA84JGBiqSOIgeJAuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LrZ9a/dpUkqUMgb73hNItRnpnTGmQNVvdgc2VxeVETrsvGDnLMfREMGpaBKCFI45K
	 UUEUalJ7JYkcJwCAgN3Ohum8hIKU8SqA7q9RNmybPB9cYlg0C6jyBdg5lZGoMWwMio
	 IVNvwbpzmG8S95UQ+AFCDt8qeBdfVGeceJv9Sqi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1702/1756] tcp: initialize mapped children before route lookup
Date: Wed, 18 Nov 2026 16:03:49 +0100
Message-ID: <20261118150117.402039884@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Zeng <kylebot@openai.com>

[ Upstream commit b7ff0e7a9ae3df2f123807a7e670bc348b1e1b9d ]

IPv4 passive opens on a dual-stack listener go through
tcp_v4_syn_recv_sock() with tcp_v6_mapped_child_init() as the optional
initializer. The callback currently runs after the output route lookup.
If that lookup fails, tcp_done() destroys a clone whose pinet6 and
ipv6_fl_list still refer to the listener's state.

With the flowlabel list head in inet_sock, fl6_free_socklist() walks
the clone's list and RCU-frees its nodes without unlinking them from the
live listener. Subsequent flowlabel operations can use or free the nodes
again. Commit 858d2a4f67ff ("tcp: fix potential race in
tcp_v6_syn_recv_sock()") moved the initializer before ehash insertion,
but did not cover this error path.

Invoke the existing initializer after the IPv4 fields it consumes have
been set, but before route lookup can fail. It needs neither the
destination nor sk_setup_caps(), and all later disposal paths remain
covered.

Fixes: 1c17f4373d4d ("ipv6: Move ipv6_fl_list from ipv6_pinfo to inet_sock.")
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20261028154101.2153360-1-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_ipv4.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index c32ec598930b1..b42630611afc7 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1790,6 +1790,12 @@ struct sock *tcp_v4_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
 	if (READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_reflect_tos))
 		newinet->tos = tcp_rsk(req)->syn_tos & ~INET_ECN_MASK;
 
+#if IS_ENABLED(CONFIG_IPV6)
+	/* Detach IPv6 state before a route lookup can fail. */
+	if (opt_child_init)
+		opt_child_init(newsk, sk);
+#endif
+
 	if (!dst) {
 		dst = inet_csk_route_child_sock(sk, newsk, req);
 		if (!dst)
@@ -1799,10 +1805,6 @@ struct sock *tcp_v4_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
 	}
 	sk_setup_caps(newsk, dst);
 
-#if IS_ENABLED(CONFIG_IPV6)
-	if (opt_child_init)
-		opt_child_init(newsk, sk);
-#endif
 	tcp_ca_openreq_child(newsk, dst);
 
 	tcp_sync_mss(newsk, dst4_mtu(dst));
-- 
2.53.0



