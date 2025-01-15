Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C388248BD5;
	Wed, 15 Jan 2025 10:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937610; cv=none; b=KD+527DGwTBTYO7fN1fFb5cXfn1EIQbWs5NOcqc4vO021QwSjaUKrlkdmN/ZU6MvofISZV0ksxFuuUz6ZbKkh00sXiMFrvItaCaNZr2KDV9ykA6K3SEe+EGFgdGlm1D/OgZozM50SCbNpFANjR+8cGVdL8G80MIAIXj6h6WtRe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937610; c=relaxed/simple;
	bh=QpDo9IxZzWsEGsXlC1RTy2pFrm6sUTxRpIRaSJ+svec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LqY1uEmyH5sZtpz5YrBcUB9esJqkc9T/maZwDN8ickg/giRdCOS+TCYaPVGTFagzdSdFhdkLCtwNtkFqz5RPBZfPmmxDdo5uBUGWlBXFZmGcP8i/569RlH4aupAUCg81mu5o3LKsYOI50CBunxGcWSP9DjUFYOamcDQWTGo+63s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GHEuKE6Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GHEuKE6Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47F1BC4CEE1;
	Wed, 15 Jan 2025 10:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937609;
	bh=QpDo9IxZzWsEGsXlC1RTy2pFrm6sUTxRpIRaSJ+svec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GHEuKE6Z/kQLqkkn98toJTp4KCtlRYbGFQKpxwSta87NK+q7YgKHd14VwQgHTxjqc
	 se4FogaH/3NkWZVcmOI27Fl59X/Eg9Gn/qacBbi93MeS7ts43wDvoPNNtdivkezieT
	 rmYWiF0o8Tl1ta0vrskLaqveW/QgCqzmSx2jreXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 23/92] tcp: Annotate data-race around sk->sk_mark in tcp_v4_send_reset
Date: Wed, 15 Jan 2025 11:36:41 +0100
Message-ID: <20250115103548.457824198@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
References: <20250115103547.522503305@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 80fb40baba19e25a1b6f3ecff6fc5c0171806bde ]

This is a follow-up to 3c5b4d69c358 ("net: annotate data-races around
sk->sk_mark"). sk->sk_mark can be read and written without holding
the socket lock. IPv6 equivalent is already covered with READ_ONCE()
annotation in tcp_v6_send_response().

Fixes: 3c5b4d69c358 ("net: annotate data-races around sk->sk_mark")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/f459d1fc44f205e13f6d8bdca2c8bfb9902ffac9.1736244569.git.daniel@iogearbox.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_ipv4.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 984435cb1013..805b1a9eca1c 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -832,7 +832,7 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 	sock_net_set(ctl_sk, net);
 	if (sk) {
 		ctl_sk->sk_mark = (sk->sk_state == TCP_TIME_WAIT) ?
-				   inet_twsk(sk)->tw_mark : sk->sk_mark;
+				   inet_twsk(sk)->tw_mark : READ_ONCE(sk->sk_mark);
 		ctl_sk->sk_priority = (sk->sk_state == TCP_TIME_WAIT) ?
 				   inet_twsk(sk)->tw_priority : sk->sk_priority;
 		transmit_time = tcp_transmit_time(sk);
-- 
2.39.5



