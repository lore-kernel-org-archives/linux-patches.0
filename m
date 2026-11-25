Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621139;
	b=FoZ9b4YtOjbs78POHyRR6ikayXHL7CGHj35AoAl0wt0pd9hRdEmSkVZdpPqd/iSsCU5u
	 Ii6FDgcDAodDn2susa3rgvjlaAPoB9GkayXV3ZB1XxWcaI1jBpGxLoRSzS8De8oF8NIwg
	 jr1TQIDXZQVGXfMf24g60iVqNx2yghrnYa5Kk0NM7FXJOqZMW1/WjE+aQfhtHwLyOaMZh
	 WdXh5BvryFaatz9GGIdGkSuq6u9yft7pvg6ShX7bsg7sABn03FWVCTmFH5cS6+/aAXD8Z
	 Jrjrq8YxU53wADUQCMgIQUz08JU3wD9rNWVOEboA5r9WXwt9PdWnErGCF+u0WHRqEuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621139;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h0+5cY4bse2qcsM5PaYximLdz0adMRJtaihQfFkNX2U=;
	b=JSnbrmmfCYNXzUYzlORwL3I8LjsvVqeWcY7QtWvmOthNILRR487nrVomua7M3H0xOyJX
	 ZlWVg+x4PF2EJskW4A5UT+IVQ3E9m3m++7yCiwssD0mOVtQgzhUJ22q/KcAVYNCHZkvLK
	 2eRTomboF6VszKUPldqGavd3vlsaeMT0QtXhgfL1fbBskBIemJD6ZgGaaFFpwO8rRnVoU
	 TPV88/F/FD3zeGQh22Ckpj1CHxlOnCocF59SZhZuCUB9CifcNkt1SA2EoKanyo0F+6g4o
	 nsCS87s9OOyS6J4s8oPTE7q5VeCGmrZ0hUyisH2M2HodsQ54vgwlz/nd2s3kM2wqidA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lx64cpHQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E45C606A321;
	Wed, 25 Nov 2026 15:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lx64cpHQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15B421F000CF;
	Wed, 25 Nov 2026 15:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621138;
	bh=h0+5cY4bse2qcsM5PaYximLdz0adMRJtaihQfFkNX2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lx64cpHQUEnYH0gmuQHY0RsOgMeD2TKQgdih396vJe+N8Xf+fwxrg4zTqRnTD2aqq
	 cYmdeMn69Uoa06BjR7fqcKB1kZch46DcufoASPyPPZY2aF0+5Ty3tL/zyXbUrcv8Gu
	 d2ekr+pEzcetcTFK0+xrphIHVooz/QxC6OhV5G4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Octavian Purdila <tavip@google.com>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 134/990] tcp: do not let tcp_collapse() drive sk_forward_alloc negative
Date: Wed, 25 Nov 2026 15:25:01 +0100
Message-ID: <20261125143825.224734500@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 28db1353445bf..5d8da3c23e2c8 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5646,6 +5646,10 @@ tcp_collapse(struct sock *sk, struct sk_buff_head *list, struct rb_root *root,
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



