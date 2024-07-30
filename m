Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F395118B491;
	Tue, 30 Jul 2024 16:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356211; cv=none; b=pVWY+GlM3FbBL08zrN+rUa1qYN2cqhGI+xXyPwYq7oARTlvQWAxpAS55u9lRIV/EvS+8SV3v/e+JGZ8COeB67CUZd8ZHSFKkoaFlT/xKQ7Ax+wilyvaVr7C3NmGXpSeUGdLyV913wn0boB4p1syQLt9Sv2jELcB4TrTVvqoypn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356211; c=relaxed/simple;
	bh=TungPDSBvGniqiButLJu7ZDGJ4Ogm7kx66Pz1xX8ZtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BWayfVxyFNYwxnhIfmI+UdRa+r6rwIK71zEvYjs5pxvRf3xa8P+wYwWBdhKAADKWOGnNRfZ3qXg+YmUIw4HiCm30rBMverX3LijErm8EOeU9bzz+7ZV0nAocFQmae3n+1Pxkk4Rujid4gAvrykmJGk9llmOHaMDBXvT4wSh3tag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=diW/20tg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="diW/20tg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2288FC32782;
	Tue, 30 Jul 2024 16:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356210;
	bh=TungPDSBvGniqiButLJu7ZDGJ4Ogm7kx66Pz1xX8ZtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=diW/20tgi3DNtzi0CsBML99QKH4zB/Krmp/3qg0+vNeoUSGcHtma1mew96no5U9Hf
	 PO8B9y0xuv6diDghJk1AXlqcPaDn2u1c82+pEYQ8oBG+CRvzaJdXXvvq/+pqwgDOea
	 9F5WrzXizi4fmMmuef5llenSDxAdb6+hnWutia9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 124/568] tcp: fix races in tcp_v[46]_err()
Date: Tue, 30 Jul 2024 17:43:51 +0200
Message-ID: <20240730151644.720954362@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit fde6f897f2a184546bf5516ac736523ef24dc6a7 ]

These functions have races when they:

1) Write sk->sk_err
2) call sk_error_report(sk)
3) call tcp_done(sk)

As described in prior patches in this series:

An smp_wmb() is missing.
We should call tcp_done() before sk_error_report(sk)
to have consistent tcp_poll() results on SMP hosts.

Use tcp_done_with_error() where we centralized the
correct sequence.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Link: https://lore.kernel.org/r/20240528125253.1966136-5-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_ipv4.c | 11 +++--------
 net/ipv6/tcp_ipv6.c | 10 +++-------
 2 files changed, 6 insertions(+), 15 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 7c2ca4df0daa3..48ec2c1777d45 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -602,15 +602,10 @@ int tcp_v4_err(struct sk_buff *skb, u32 info)
 
 		ip_icmp_error(sk, skb, err, th->dest, info, (u8 *)th);
 
-		if (!sock_owned_by_user(sk)) {
-			WRITE_ONCE(sk->sk_err, err);
-
-			sk_error_report(sk);
-
-			tcp_done(sk);
-		} else {
+		if (!sock_owned_by_user(sk))
+			tcp_done_with_error(sk, err);
+		else
 			WRITE_ONCE(sk->sk_err_soft, err);
-		}
 		goto out;
 	}
 
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 07bcb690932e1..d0034916d386b 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -488,14 +488,10 @@ static int tcp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 
 		ipv6_icmp_error(sk, skb, err, th->dest, ntohl(info), (u8 *)th);
 
-		if (!sock_owned_by_user(sk)) {
-			WRITE_ONCE(sk->sk_err, err);
-			sk_error_report(sk);		/* Wake people up to see the error (see connect in sock.c) */
-
-			tcp_done(sk);
-		} else {
+		if (!sock_owned_by_user(sk))
+			tcp_done_with_error(sk, err);
+		else
 			WRITE_ONCE(sk->sk_err_soft, err);
-		}
 		goto out;
 	case TCP_LISTEN:
 		break;
-- 
2.43.0



