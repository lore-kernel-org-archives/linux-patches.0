Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C2E19528
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:33:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39461C433D2;
	Mon, 12 Jun 2023 10:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686565999;
	bh=af8uFrWTOi3GEG0AEEc2Q+3qZyFkqdVeb6Y8CFQ5Fss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uQG6Mb2INDIfO2xqVHz55WkLqYvN4iZN2p7tBBhKemsY+4hydOdBjalg10m2YGLqr
	 UCC0Z5yvhZALeShzzP5qRYttL7zTu6j7j/2GbJDdEZBNueYfQxkG4nNAz48BggPpQQ
	 ZQdf4/kwiBMLeVkK030dQA7s02mrtJYpVdkJ6lMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Simon Horman <simon.horman@corigine.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 26/68] rfs: annotate lockless accesses to sk->sk_rxhash
Date: Mon, 12 Jun 2023 12:26:18 +0200
Message-ID: <20230612101659.507635367@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101658.437327280@linuxfoundation.org>
References: <20230612101658.437327280@linuxfoundation.org>
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
index 3da0601b573ed..51b499d745499 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1073,8 +1073,12 @@ static inline void sock_rps_record_flow(const struct sock *sk)
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
@@ -1083,15 +1087,19 @@ static inline void sock_rps_save_rxhash(struct sock *sk,
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



