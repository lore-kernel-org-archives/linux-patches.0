Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD5F34888E;
	Wed,  3 Dec 2025 16:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779376; cv=none; b=govxVygyEdSl0VRtRhRJsEjLsD6aqApLzmcy1E/8L14JI3/onW5fpwuA+x+qvQvKtZfIEGuQdSiPfIbB/K+HLeZyHzg+hQ8y5MVGrtHNh1FZmIfFHwKcHMocB0Xm1DPq3QrAdLCw1FPhu8gpDZEHgKo9gpozPWEXOdRQAef41/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779376; c=relaxed/simple;
	bh=338BkyryfSihX1sYcQh7Fj2it/ubda7Ciw/QyGBSb+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q3/+WxynuvjGW/SQBtdmGn/54TYR9WDcD6p5Clkhr5Z9nI5uVYMPPMc8lelvBjB33dIFUXwgLkSQ7xMV4PNWGCu983nbddl+d/Iddp7+2vIJ1vfWh6+5EMyk/ts9aIgZPAO0xp+0X3upi5cPr56OWMyP1h2hC2HRIjnRuh9O4so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GBJVnEXu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GBJVnEXu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E49AC4CEF5;
	Wed,  3 Dec 2025 16:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779376;
	bh=338BkyryfSihX1sYcQh7Fj2it/ubda7Ciw/QyGBSb+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GBJVnEXuz7vBnfiENs0af3Cg24wutG+gVre+J1Wj7j2QdKwcXDSvzHiNzVjZBWk84
	 zUqZtgL1I4jDLkmjO9xRxW3HWZoq795VTgtGEQWDszyh0+pRwa0o1rbV7QU8MsIM4+
	 t/3boyn5dq4P5K33FOLENE2jHAbfkRj42NaCisJE=
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
Subject: [PATCH 6.1 238/568] ipv6: np->rxpmtu race annotation
Date: Wed,  3 Dec 2025 16:24:00 +0100
Message-ID: <20251203152449.437658572@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 9fba1eb39e2f74d2002c5cbcf1d4435d37a4f752 ]

Add READ_ONCE() annotations because np->rxpmtu can be changed
while udpv6_recvmsg() and rawv6_recvmsg() read it.

Since this is a very rarely used feature, and that udpv6_recvmsg()
and rawv6_recvmsg() read np->rxopt anyway, change the test order
so that np->rxpmtu does not need to be in a hot cache line.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20250916160951.541279-4-edumazet@google.com
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/raw.c | 2 +-
 net/ipv6/udp.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index dc31752a7edcc..c644300680ba6 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -437,7 +437,7 @@ static int rawv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	if (flags & MSG_ERRQUEUE)
 		return ipv6_recv_error(sk, msg, len, addr_len);
 
-	if (np->rxpmtu && np->rxopt.bits.rxpmtu)
+	if (np->rxopt.bits.rxpmtu && READ_ONCE(np->rxpmtu))
 		return ipv6_recv_rxpmtu(sk, msg, len, addr_len);
 
 	skb = skb_recv_datagram(sk, flags, &err);
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 4b063aa37e389..184fc7a5e4d17 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -364,7 +364,7 @@ int udpv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	if (flags & MSG_ERRQUEUE)
 		return ipv6_recv_error(sk, msg, len, addr_len);
 
-	if (np->rxpmtu && np->rxopt.bits.rxpmtu)
+	if (np->rxopt.bits.rxpmtu && READ_ONCE(np->rxpmtu))
 		return ipv6_recv_rxpmtu(sk, msg, len, addr_len);
 
 try_again:
-- 
2.51.0



