Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC47E134B1
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:47:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54A34C4339E;
	Mon, 12 Jun 2023 10:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566853;
	bh=1nrQ5F6ekR10V8j/UcRgcOG4Erc+vhsRua3F4EN64Ng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s/LYMunbujD2AKpYPeo7leOHeuZ3os0O3zBlIj7Bbv7Ww82To0BIJ0GPie868I2qd
	 daO+6+Hn8bbd8x7Er282b6YeqUZHoGC7M8xdz/EO/pTb6SpNYGzYNlgKgDXown4/7O
	 46cJCNzAu1w0mJGRiDqOWDp5CSx0C07YUBaahPKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Simon Horman <simon.horman@corigine.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 049/160] rfs: annotate lockless accesses to sk->sk_rxhash
Date: Mon, 12 Jun 2023 12:26:21 +0200
Message-ID: <20230612101717.279538736@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101715.129581706@linuxfoundation.org>
References: <20230612101715.129581706@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 1e5c647c3f6d4f8497dedcd226204e1880e0ffb3 ]

Add READ_ONCE()/WRITE_ONCE() on accesses to sk->sk_rxhash.

This also prevents a (smart ?) compiler to remove the condition in:

if (sk->sk_rxhash != newval)
	sk->sk_rxhash = newval;

We need the condition to avoid dirtying a shared cache line.

Fixes: fec5e652e58f ("rfs: Receive Flow Steering")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sock.h | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 45e46a1c4afc6..f0654c44acf5f 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1152,8 +1152,12 @@ static inline void sock_rps_record_flow(const struct sock *sk)
 		 * OR	an additional socket flag
 		 * [1] : sk_state and sk_prot are in the same cache line.
 		 */
-		if (sk->sk_state == TCP_ESTABLISHED)
-			sock_rps_record_flow_hash(sk->sk_rxhash);
+		if (sk->sk_state == TCP_ESTABLISHED) {
+			/* This READ_ONCE() is paired with the WRITE_ONCE()
+			 * from sock_rps_save_rxhash() and sock_rps_reset_rxhash().
+			 */
+			sock_rps_record_flow_hash(READ_ONCE(sk->sk_rxhash));
+		}
 	}
 #endif
 }
@@ -1162,15 +1166,19 @@ static inline void sock_rps_save_rxhash(struct sock *sk,
 					const struct sk_buff *skb)
 {
 #ifdef CONFIG_RPS
-	if (unlikely(sk->sk_rxhash != skb->hash))
-		sk->sk_rxhash = skb->hash;
+	/* The following WRITE_ONCE() is paired with the READ_ONCE()
+	 * here, and another one in sock_rps_record_flow().
+	 */
+	if (unlikely(READ_ONCE(sk->sk_rxhash) != skb->hash))
+		WRITE_ONCE(sk->sk_rxhash, skb->hash);
 #endif
 }
 
 static inline void sock_rps_reset_rxhash(struct sock *sk)
 {
 #ifdef CONFIG_RPS
-	sk->sk_rxhash = 0;
+	/* Paired with READ_ONCE() in sock_rps_record_flow() */
+	WRITE_ONCE(sk->sk_rxhash, 0);
 #endif
 }
 
-- 
2.39.2



