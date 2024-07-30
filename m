Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2537187FF2;
	Tue, 30 Jul 2024 16:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355401; cv=none; b=OKQmYUDXi1bQYdnSocWqJGYGODo/M3xsHwBTmxFszQq3biE7aTSyO+5l1XauswBt1t+2xG2rTnOJo9UKiY4iEENO+g741L/7U/fJ06D3QI/hRYbdUZ0lJDZpDVSCRcxCxVqEiQv22ER07KK0WeRfPA35mi0GFFN5BuAfrZswMOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355401; c=relaxed/simple;
	bh=nHkUvoVkv2J1EI872uSSaeQ5HemuwbXWEci6GEt7Mg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k/OK5ls2y4bY7qs9+eUEZ9qfs9rtDHLK2eD6l8QipLV+dfZNhNMJOku3tsrnCuRUm0ed94ToJUT04tdURgkye0cKKgZ+O9JIc8obsKGmajNWRP1hWwypVNiOJQJwv4yjA0mTwBV2CBiOV1wWE58W+CE1z9p+GhF/aEa1Wtui2Eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OBA3cKiL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OBA3cKiL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60D41C4AF0A;
	Tue, 30 Jul 2024 16:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355400;
	bh=nHkUvoVkv2J1EI872uSSaeQ5HemuwbXWEci6GEt7Mg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OBA3cKiLO2ytJmWvD8Xpmg/nRU/qhEOvOajH7fL93G1Ll8UOPU2iL60edoS6uKRWU
	 fIrsdVEXftOmxDEdF7QEiuYkHRkM0RWKfiV3G9asC3UF65NvPRLeUUtkLY2sunnfhB
	 rvCiZOJ6/6SIs4FSYmJj5/d7W8TCKrDDRvD4muk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 090/440] tcp: fix races in tcp_v[46]_err()
Date: Tue, 30 Jul 2024 17:45:23 +0200
Message-ID: <20240730151619.274604754@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 16098fcafde2b..c64ba4f8ddaa9 100644
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
index 35bfca93af6ad..eb6fc0e2a4533 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -492,14 +492,10 @@ static int tcp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 
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



