Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B321E343D6A;
	Tue, 11 Nov 2025 01:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824099; cv=none; b=LSZSGZFOLcbHfnQ8EavPV2U5NEgHPPnlbwuAYffqoPJceXIHv4dzUCOzM+nGFEDMHc4TvErBp5U0GQRvK9qZB3vcpVQ9C2+UeDcwIROt1eMUUWcEhPRq+p0Vr10jWYx0ETYUIfBrOlv3ch6GXStrTGxsgDcLQVB678cnOxUaNM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824099; c=relaxed/simple;
	bh=KjMvWbDPJUEVes2yndLr4E8dWSR18jHtmhuHnRwOM6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ASmaM+VfX6jD95Lno0yp5JsODmbnKJJ69iUx9nv8K1dEnOGtiYLThbfkyaJDDwMSUqRxmRSs2kLiFgbl9R9z5nB7v52n35iWy1FUDZ+iQjXDQN1pt32Q9L2oOpdUy0uQQhG6kblQhXt0YtrVl9h5gRe2YYYPJ0OoaKmqBUJ6LXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SXLpcvwj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SXLpcvwj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D805C113D0;
	Tue, 11 Nov 2025 01:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824099;
	bh=KjMvWbDPJUEVes2yndLr4E8dWSR18jHtmhuHnRwOM6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SXLpcvwjYGrttU3xkEPJGm16KwsnVlqUjVLWR3IzTmLdrqjUXnk4IBTqS/L7/HzfT
	 QTrpPdkZqHlwchYfHvI0Teq2tYAFofZgCQapkVv+Lmu2P+hLxX5WaZNE8s8oIgppsG
	 NCd0pWmIpoQeg7Y9v37HvtEknCtkEJKENHe8Dy/o=
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
Subject: [PATCH 6.12 387/565] ipv6: np->rxpmtu race annotation
Date: Tue, 11 Nov 2025 09:44:03 +0900
Message-ID: <20251111004535.578610128@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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
index 328419e05c815..d148f1b03c5d0 100644
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
index 57e38e5e4be92..9b93df668025d 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -394,7 +394,7 @@ int udpv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	if (flags & MSG_ERRQUEUE)
 		return ipv6_recv_error(sk, msg, len, addr_len);
 
-	if (np->rxpmtu && np->rxopt.bits.rxpmtu)
+	if (np->rxopt.bits.rxpmtu && READ_ONCE(np->rxpmtu))
 		return ipv6_recv_rxpmtu(sk, msg, len, addr_len);
 
 try_again:
-- 
2.51.0



