Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624212;
	b=Qjy3xys9rA8MmaAT9gMBk6fTsJHmZ0Wa4k3p5xyWAH8ogCmR+jKywZUxCLAHE2bKLo6v
	 cDpt6+ou1M/NhLYcFNfR7V2iuVhQ/c22NPYyTGR2gsPK4sE+mlF9z12Ni0vdS5LkZcc8H
	 QQ9vmUdbJFNSGF2xPh+GLwwH2/ceAmIL2/cZvUg1Hj38oMkfIq2GvoEP7H/NaQuR2sDJI
	 qMMP05aPrBZmN7MUA83AmbL3tbzUemkxgrGESeNis5bLCrzNr97Gb4+0X01KxZwRAYCSe
	 7UxvNXXDmNGedsINu4bD+ppqSK2+mp7sGLdP6O2w9qwVON2pvlI7paGwtAtY22twEyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624212;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BMl3yCZg95aUR5sOHRQFqaxMUhzgxOeXOjwSSqPBsSo=;
	b=KSnuu8Yb7XgZ7ZW+J53wLNhC4TMGIh09Z+VnbMdhqY1HPwyXwT003d+3Apgpdc2GjUGx
	 6guPbRGBIUZ9Rl4PB6Xpky2nhGWgoqIuynZHd+qbUvNCzmCErPw9d4t9fK0VzruSAfrFQ
	 RRI4PPHqLxUvapHO04TBgbRR8qHsPZEPxSJvLxtPmkW73gALmWNi11T85O5QqK/sSjf6I
	 /je1C0hHWrImnM2bmCD7VG4c1p44+JaDvTI7mOLsELzOCtrDc+edHl0mUnozKExm8MEKU
	 v0vz3wmK9Ivp8oFw3w7unBmWXo08LpPJsAWu700CKD62chWc5BQhap59p9H7t3DMn7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EifaqjwY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 782F1606A32D;
	Wed, 25 Nov 2026 16:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EifaqjwY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10DD51F000CA;
	Wed, 25 Nov 2026 16:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624211;
	bh=BMl3yCZg95aUR5sOHRQFqaxMUhzgxOeXOjwSSqPBsSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EifaqjwYKHUXn9okgNOVgFfTy1mPPLjQgmavO2tD/iFgugyVeRVr2fxLWLHvJysZq
	 eYChZBxlzvKnGG8Pi5nO6ItYRwAf+jeWOZBKhCUkaG2qsKP1rpfxxYB9aE69NOrbDY
	 Situud79VzvewemRJINML2AM1YtIk6FgqEMnbosw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Octavian Purdila <tavip@google.com>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 118/816] tcp: do not let tcp_collapse() drive sk_forward_alloc negative
Date: Wed, 25 Nov 2026 15:27:46 +0100
Message-ID: <20261125143851.943292805@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit 031c403d13e5046750e2abebd4e770631e7c4627 ]

tcp_collapse() charges each newly allocated skb with skb_set_owner_r()
before the skbs it replaces are freed, without scheduling memory first.

Since sk_mem_uncharge() reclaims eagerly, sk->sk_forward_alloc has no
cushion and can become negative. This can be durable when the collapsed
skbs had a high payload/truesize ratio or were partially read, because
the new skbs can have a bigger total truesize than the old ones.

A negative sk_forward_alloc then confuses tcp_wmem_schedule(), which
can return a negative length to tcp_sendmsg_locked(), triggering
a WARN_ON_ONCE(bytes > INT_MAX) in check_copy_size().

Call sk_forced_mem_schedule() before charging nskb.

Fixes: 4890b686f408 ("net: keep sk->sk_forward_alloc as small as possible")
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Signed-off-by: Octavian Purdila <tavip@google.com>
Signed-off-by: Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index c11faca825ff9..e529ecb9b42b8 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5534,6 +5534,10 @@ tcp_collapse(struct sock *sk, struct sk_buff_head *list, struct rb_root *root,
 			__skb_queue_before(list, skb, nskb);
 		else
 			__skb_queue_tail(&tmp, nskb); /* defer rbtree insertion */
+		/* nskb is charged before the skbs it replaces are freed.
+		 * Make sure sk->sk_forward_alloc can not become negative.
+		 */
+		sk_forced_mem_schedule(sk, nskb->truesize);
 		skb_set_owner_r(nskb, sk);
 		mptcp_skb_ext_move(nskb, skb);
 
-- 
2.53.0



