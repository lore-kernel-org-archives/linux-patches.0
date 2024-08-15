Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FEA218D627;
	Thu, 15 Aug 2024 13:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729295; cv=none; b=eLy2JRx205bVq8zfeCQ0GQvwL0KfaumqWNNl93ClqEHgqObi8uKD4lJgUFcSCTQgwg4uEr39RMbO00K6MbP8PFg5kxpWTg5uMvVrtPpb0dJe6im7ke2gKpYIZ4nst19vkUwRqghyjdyYljI3/PehFfSlPJIrvKKGIlJNwrlM47M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729295; c=relaxed/simple;
	bh=70aId82YrltLrsM+2MdArZt9T1h/aiQ/ECBYDm7HskI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q1ub1RZLQ5NwPP/oAyyNoVDQuiMMa1/EZGk9MaVbJ4qUg5uHO+ShsbqkW5mZEqLBY3955ia/H2Ks47tvh1difKsYREwm7iGTkO+LdBwlp/8N1c0i76FcGukbdeklnkuXtYQ0CGtw/ZJQyVShTtYtilV26ZrklLN0P/+Qcc+6zXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FthvWmK/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FthvWmK/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1851C32786;
	Thu, 15 Aug 2024 13:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729295;
	bh=70aId82YrltLrsM+2MdArZt9T1h/aiQ/ECBYDm7HskI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FthvWmK/dgh2pSWmPqv30oaHN0t6uu7nrJAEzTFt5zaNQgGlfLCeBddcxST9vVtgH
	 fRIgowrJfyYAbtzTsqDAc0HCaNcOra1bGv4Oybdx4SkjYxwR7Bst8mawpGMC26jO1S
	 S7RhHi7fliyiwKhxZNmvjOF4HL7ciRhcM7vD2kQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 052/484] tcp: fix races in tcp_v[46]_err()
Date: Thu, 15 Aug 2024 15:18:30 +0200
Message-ID: <20240815131943.292954333@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a1ed81ff9a81d..44a9fa957301b 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -592,15 +592,10 @@ int tcp_v4_err(struct sk_buff *skb, u32 info)
 
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
index c9aee34ae469f..fedbce7ed853e 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -485,14 +485,10 @@ static int tcp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 
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



