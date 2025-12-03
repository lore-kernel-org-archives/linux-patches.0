Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9561343D6A;
	Wed,  3 Dec 2025 16:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777843; cv=none; b=Lt+T8tBFyUFEl3xSM3RsF57Nblte1fwHlNGGgrONXxjx5sX03IBUI+V3QFaXhIgZ+EPWv+k7ZVWrn0CZWNPcauypH+LkYA6jRJCutmOHZPJ1wb8siHVFAU8h1PY3jm8dtAa5LsV9JrhG+0fnWceHlWvyyh6s+UEwMkdzkBXvNok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777843; c=relaxed/simple;
	bh=sPwBB2fuWFqCR09Tl6XaJXE3teQe5Su+faOaQreoG/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EgCvN16dpdq8YNS9qFP24EpuxCf965pgtaD2eLSCI5/cOA7yottS00wUtaq0j0arHXKRKPj+yh3DgWIzr9weX5w5HhoKqrLY0uexOUf2LX1jR8akgJMYfbh6Bg7wF/3G9KUrgNOMfZpP6tHYB3hCryLCeoQ0FzbHRvvmtEaRWk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LVFATipz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LVFATipz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4299FC4CEF5;
	Wed,  3 Dec 2025 16:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777843;
	bh=sPwBB2fuWFqCR09Tl6XaJXE3teQe5Su+faOaQreoG/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LVFATipzysLlWzcq6lP9lG7iV343I1qVxGcbqd3F+nMUHwWPXToZR+KpOVDjcEp/7
	 DG+3xJ1DWsyMf433vdlarmySZH5+jXGQCwJlWWn63+6+diBNDTmcLxh5/S69ZBLoh5
	 7KoW+eIsQxmjHpQjwHWVE8uhwLdYU7vohnnRzvNc=
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
Subject: [PATCH 5.15 163/392] ipv6: np->rxpmtu race annotation
Date: Wed,  3 Dec 2025 16:25:13 +0100
Message-ID: <20251203152420.077057400@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6ff25c3e9d5a4..586e972cbcd53 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -474,7 +474,7 @@ static int rawv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	if (flags & MSG_ERRQUEUE)
 		return ipv6_recv_error(sk, msg, len, addr_len);
 
-	if (np->rxpmtu && np->rxopt.bits.rxpmtu)
+	if (np->rxopt.bits.rxpmtu && READ_ONCE(np->rxpmtu))
 		return ipv6_recv_rxpmtu(sk, msg, len, addr_len);
 
 	skb = skb_recv_datagram(sk, flags, noblock, &err);
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index f05c09f7165a4..21f34a3a4e8ec 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -361,7 +361,7 @@ int udpv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	if (flags & MSG_ERRQUEUE)
 		return ipv6_recv_error(sk, msg, len, addr_len);
 
-	if (np->rxpmtu && np->rxopt.bits.rxpmtu)
+	if (np->rxopt.bits.rxpmtu && READ_ONCE(np->rxpmtu))
 		return ipv6_recv_rxpmtu(sk, msg, len, addr_len);
 
 try_again:
-- 
2.51.0



