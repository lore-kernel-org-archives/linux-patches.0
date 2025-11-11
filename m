Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F9FE2820A0;
	Tue, 11 Nov 2025 01:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824860; cv=none; b=dpR43Bu+ylWY1CKkFK5gCoheEF2CpAeeuTLznBo4LbusPZ7TtIP7/Wtww8vS1cXFACmkrL6mHvrWlHqkrEbXmZtRvlPXiQo9NV74abRYO7BQadLtA/4CghxtivxXdJqjIYEYDECJnAaZf4oA4+1h1TfWA4G0rr8OqfaMnchXKKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824860; c=relaxed/simple;
	bh=Q0mmcAp9ukSV7Y6o22jj2iCxpP+FsTWj1Zfl9FYzTDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gm3Jb7ezktyXxjIDI4FPcbrPS1rwKGxWb0N5Fu36kCdQZKb/pUvZiuT7GX9jy0TzNDjpmCmIB4Duecp+2nhpAvubtYjWRZZRW60EgM12kIoLXwX2EWEM7HcWUDp7/AOlbOPxU8ahHU2t2iczulor7VG4Y8zYmABtvo5dYAKIs1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TkSP8aDK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TkSP8aDK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C19C8C116B1;
	Tue, 11 Nov 2025 01:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824860;
	bh=Q0mmcAp9ukSV7Y6o22jj2iCxpP+FsTWj1Zfl9FYzTDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TkSP8aDK5+xi4ab1Mp27/HMvi/GVi74YHTN8BNaHuKXL2t1j3H6USeL/sBCnNof8u
	 vQ3C4P40QDw8lO27ZblcR9JdhY9DIpS2kL7DRpWdCd+tqAP8uLr1fWXu5mcuDWzKtp
	 hpKmx4wISvMaHpoEYn4ARD8rAsnc3qd6Qma3I5rA=
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
Subject: [PATCH 6.17 586/849] ipv6: np->rxpmtu race annotation
Date: Tue, 11 Nov 2025 09:42:36 +0900
Message-ID: <20251111004550.590768869@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 4c3f8245c40f1..eceef8af1355f 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -445,7 +445,7 @@ static int rawv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	if (flags & MSG_ERRQUEUE)
 		return ipv6_recv_error(sk, msg, len, addr_len);
 
-	if (np->rxpmtu && np->rxopt.bits.rxpmtu)
+	if (np->rxopt.bits.rxpmtu && READ_ONCE(np->rxpmtu))
 		return ipv6_recv_rxpmtu(sk, msg, len, addr_len);
 
 	skb = skb_recv_datagram(sk, flags, &err);
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 6a68f77da44b5..7f53fcc82a9ec 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -479,7 +479,7 @@ int udpv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	if (flags & MSG_ERRQUEUE)
 		return ipv6_recv_error(sk, msg, len, addr_len);
 
-	if (np->rxpmtu && np->rxopt.bits.rxpmtu)
+	if (np->rxopt.bits.rxpmtu && READ_ONCE(np->rxpmtu))
 		return ipv6_recv_rxpmtu(sk, msg, len, addr_len);
 
 try_again:
-- 
2.51.0



