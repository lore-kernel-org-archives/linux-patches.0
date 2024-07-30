Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3821C1A6161;
	Tue, 30 Jul 2024 16:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356712; cv=none; b=aqqJei7W6u0R39KmmAQ4pGgI3gfS/nKbQw37Yjf310H13NmeLyzX9FFpaUeXZyFuVpONoVCwQ1FwlrX7ggyjqJLaN1MFavjkthB0EP/gy110Eegkr5B6gYvY5wWyWvOgy4l2s6MjlNbJIlADL5o7ohqYeaKmgHrn+jFaj3LkG28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356712; c=relaxed/simple;
	bh=8SaPuN4NzdGHKgv8E//+bZYA1N6LVe1uSMB+S3BqMvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MgiQ/CWrL5ltc3uNQMJSg1C2/7S3mB6yS9Gk2CzfA6dOlDcyYfQeXsLQ8hJXbO5n+2t2/Ru3CzopLmcP6uVR4kWgBbbOYmsrssIFX9fC7RlFtZSUqnoe/zUHAfrnvE/ocKrjdTbr6vJQJehoOZKEhmNWqp8ufhsli+hIsWbFVU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1tfHPFlp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1tfHPFlp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CA93C32782;
	Tue, 30 Jul 2024 16:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356712;
	bh=8SaPuN4NzdGHKgv8E//+bZYA1N6LVe1uSMB+S3BqMvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1tfHPFlphj9CvI3xH0qgoep1AfQsejWn8udr3iY/fA58mQifkZCxZ+WGA1GdLV5ge
	 CM+F4MiU2Nloi+Z50dp0jvGY/5yTNu1KoiroQfhiLsQp85ZPFnbchjRYTZz7LrjvVQ
	 XA+rfSDEJ3+QLJeyPffd/ACxyVL8QDEj1vajt94w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 176/809] tcp: fix races in tcp_v[46]_err()
Date: Tue, 30 Jul 2024 17:40:52 +0200
Message-ID: <20240730151731.556210382@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index b710958393e64..a541659b6562b 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -611,15 +611,10 @@ int tcp_v4_err(struct sk_buff *skb, u32 info)
 
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
index 729faf8bd366a..3385faf1d5dcb 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -490,14 +490,10 @@ static int tcp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 
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



