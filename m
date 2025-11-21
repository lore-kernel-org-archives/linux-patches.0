Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB9A34C127;
	Fri, 21 Nov 2025 13:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732805; cv=none; b=tyVQZeAm7ncJOSNEXwno56r+Mvc5J4zOAv3Kc6LeZulncc+2h6LPP+nn/Wg8BXkOAaESKDe5AjTK9RI+WORroqqJuDA4Dn97WtMwcc2K3ks2LyyBk0ha/vIyd15XzMUIRC82ms0Q0MpHGnVpfvXj+v8R2G9qPb6wx3HtaK5EGJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732805; c=relaxed/simple;
	bh=EF3fpOLeSqisRI3E1Zg9azN8sQly8UIJuzZ2uxMx3GQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R1e4xcq6JgZU5/CrCdeLtUFuoou5FI7OCntUESi7KjUAZdfvMj2koHXTfyKamsJiq3RdJC7pidiniacSHFkqprRSogo/EggklZfbEnb6RNUvpTqoK/F+8S1rw0BLi1HnXL6XyfwD6WdOq7RNgzh4UXnEdBSJIguNIGKVpsg9Yw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gIQ0f7Zr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gIQ0f7Zr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D032DC4CEF1;
	Fri, 21 Nov 2025 13:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732805;
	bh=EF3fpOLeSqisRI3E1Zg9azN8sQly8UIJuzZ2uxMx3GQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gIQ0f7ZrwykooiyttoNHbW1fZ3SNVdgkUHJ5A4Gs9XcHmOnQz7ZJFw4NhAhzK1fHq
	 Ls/ZcK4639pgqN4GtqFo6L3PtRQ9nnaIeix1AaIC6QiYoAZcVTiye1g8+Y9gUB/q0x
	 aKa9IlW8JSDaD9dshl45pERt3rS4uQc0ylBsTN6Y=
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
Subject: [PATCH 6.6 250/529] ipv6: np->rxpmtu race annotation
Date: Fri, 21 Nov 2025 14:09:09 +0100
Message-ID: <20251121130239.912392329@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4f526606bc894..7d72633ea0198 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -438,7 +438,7 @@ static int rawv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	if (flags & MSG_ERRQUEUE)
 		return ipv6_recv_error(sk, msg, len, addr_len);
 
-	if (np->rxpmtu && np->rxopt.bits.rxpmtu)
+	if (np->rxopt.bits.rxpmtu && READ_ONCE(np->rxpmtu))
 		return ipv6_recv_rxpmtu(sk, msg, len, addr_len);
 
 	skb = skb_recv_datagram(sk, flags, &err);
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 9ff8e723402ba..6df2459f25618 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -347,7 +347,7 @@ int udpv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	if (flags & MSG_ERRQUEUE)
 		return ipv6_recv_error(sk, msg, len, addr_len);
 
-	if (np->rxpmtu && np->rxopt.bits.rxpmtu)
+	if (np->rxopt.bits.rxpmtu && READ_ONCE(np->rxpmtu))
 		return ipv6_recv_rxpmtu(sk, msg, len, addr_len);
 
 try_again:
-- 
2.51.0



