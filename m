Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C81143C55;
	Thu, 13 Jun 2024 11:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279814; cv=none; b=n8nHKDW9BjF34yj1XMdHPqZGQWVaFLd2w8zyrhg7qyqvp/mg7SxIIcpU14HJse5Xk+EHHct9FnPCa2Xwx4CSbUMl5cc/De30rYnSFR2aNji1NRgazxiWPExl5wCZ6MRScOXPoEt2C7cxzuLy1rLMVNkQgh0ooMfKgx2+JhDWVa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279814; c=relaxed/simple;
	bh=00U4CHykbZ93jA+8XqLPfe+7cH8K2Z8l0qQfZZbPr9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s/Qw5pBFW/Wbf1YREXGAeLLl2lwEjaTWFLAGixLuasH+76K/XcL14OgFPWKn7MN8XY+xxsqNNOPLHAUx7fAGJSe4PkM8DCThaZlosg8ERSD4bDxt18uGrSJ1YAQimsyCeMZxHvncfmm8JyNg9Ewt7l9SZTXiBX8KZSW8EdaonF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rTff/jVF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rTff/jVF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B4A8C2BBFC;
	Thu, 13 Jun 2024 11:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279814;
	bh=00U4CHykbZ93jA+8XqLPfe+7cH8K2Z8l0qQfZZbPr9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rTff/jVFA0aPN4UWBBI8bxjZrJa35JL+E/cenACFWbbONaXzhZbKkNY7R6aGJF7JI
	 0wdq6qsXODNw2gDrwUKT7hfMG/p5Qzo6OOXmjjkMz0YgN9fYHoOq559dQ3fJwyWbQy
	 vF8SiZaTMjhQAHgeIj04ghgmlnYAcG+HSV1wtMZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 045/202] tcp: minor optimization in tcp_add_backlog()
Date: Thu, 13 Jun 2024 13:32:23 +0200
Message-ID: <20240613113229.510301703@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit d519f350967a60b85a574ad8aeac43f2b4384746 ]

If packet is going to be coalesced, sk_sndbuf/sk_rcvbuf values
are not used. Defer their access to the point we need them.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: ec00ed472bdb ("tcp: avoid premature drops in tcp_add_backlog()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_ipv4.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 0dd917c5a7da6..1567072071633 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1678,8 +1678,7 @@ int tcp_v4_early_demux(struct sk_buff *skb)
 
 bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb)
 {
-	u32 limit = READ_ONCE(sk->sk_rcvbuf) + READ_ONCE(sk->sk_sndbuf);
-	u32 tail_gso_size, tail_gso_segs;
+	u32 limit, tail_gso_size, tail_gso_segs;
 	struct skb_shared_info *shinfo;
 	const struct tcphdr *th;
 	struct tcphdr *thtail;
@@ -1786,7 +1785,7 @@ bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb)
 	 * to reduce memory overhead, so add a little headroom here.
 	 * Few sockets backlog are possibly concurrently non empty.
 	 */
-	limit += 64*1024;
+	limit = READ_ONCE(sk->sk_rcvbuf) + READ_ONCE(sk->sk_sndbuf) + 64*1024;
 
 	if (unlikely(sk_add_backlog(sk, skb, limit))) {
 		bh_unlock_sock(sk);
-- 
2.43.0



