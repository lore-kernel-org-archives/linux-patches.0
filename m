Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028342;
	b=HMY8FDdAnIxfEefKia3W/9D/Wnq+hJqa80aDOPDTbiC2+sYrX3fxo0q13Q59yPhZNxU2
	 XM4+hRTcWBLp9oJ69ecF3QrSIhEmFhjuFn7VrFGJ8FOZfKE/jzVvaXTbeyvaMNpWEto9q
	 dKIm+KUYKPwpyyjsC0WWL2ThbE5L23BCvpHXhKc9h4DmlMqgzXQy5rMiqStPrie/PLT6c
	 c76fEAuRDL1qKKluqWX43kSE35oPEdTVDkwIF5zne3QnobIdcVOwc8xkVX3K/lvAbqids
	 CNqkM5wqfFYdIlmyPE/DLjqvFNHQcI/xuUpMNbw8l7sVrxXmy0Xt9Nc8l9W4hNqnIbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028342;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RTYV66DNto46o6/hCay9fZPn7IjXCSnMSbw0090g7GE=;
	b=ahp2uSy7Ej3hrxM30HpbbFNcAHHdlFL6yelrLpmfjdSJ7MqI2ac7+wrD9BsTdwClRDhc
	 WpoSZeZGWD1uVWxRB84VHv48npwGEHRuQzoAILVTmip911/sfndxRsCB4Hw+J9u57Uazx
	 RpNrhHDSZDWOfD9JqftS0rwtoKt4MI4yy5HVwqoI1MToONf3qk0GnNRoblL7G0ggD3+3m
	 MTmFvVY/STn0wjQPZpTgra50O7SYjaK24bda6GJ5ME/fZ3rIrxunfQlm1FHtwpNgiIiqa
	 JHu8epXXT0tHzgs0V0ZuQbo8VCFC6x2V8syS2ym4DgoqCVwSit4WyWqoMa7KsdpglEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wZzvOjGn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C42606A320;
	Wed, 18 Nov 2026 18:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wZzvOjGn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89A371F000C4;
	Wed, 18 Nov 2026 18:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028342;
	bh=RTYV66DNto46o6/hCay9fZPn7IjXCSnMSbw0090g7GE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wZzvOjGnoonWAKKUPwmUWxGUrro+XQi61pG3vRwy5ysYq4jIB9qiCeQaiDPD6W8bX
	 /z1ZaBzop4hbFlK/AyrNT99ud2aSX1bDaShNoeonuwXWHpZRbXl+gWvIvkK6Rky3cT
	 VMTOPnTXoonfVv76X1mUungnDB5mVamspF7Uu1VE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2111/2151] tcp: initialize mapped children before route lookup
Date: Wed, 18 Nov 2026 16:04:06 +0100
Message-ID: <20261118150238.594722822@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 5b145ee0d0bb3..b5517f9af5465 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1804,6 +1804,12 @@ struct sock *tcp_v4_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
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
@@ -1813,10 +1819,6 @@ struct sock *tcp_v4_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
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



