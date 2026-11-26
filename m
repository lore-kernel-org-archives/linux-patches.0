Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705175;
	b=vc0qeSYwg/6D1ggYBF8nXf2Q6MA37iNIWAiMbfExfpq63D0G5kxJZ4ii1nbwax3Sk015
	 DVwWatkxZES9LHVBar5Bm5XpScBl8SeQPXmiCMkHIcXzb+gYkFdxerAQDZribJlZSGh0Z
	 5hoyJG4AQRE3cSzHYY0V56kSNvkiZGd6denTVAPK40Xv1l1KkFggs3fARxdBmsc1EUg4T
	 8MLQWfdvQEb7qiBqsSJufTgaWz7enwJGhuMrQSeWTHQOXSE7OvFfik3c4OZvLvaY95lpR
	 S2roPa3IbnvArfhW+FndgJfyO+WTJHpyzdCSyTNHhRxENIKDeQ0fd23Q/MmpF2rZ6RQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705175;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=63Ed54N++zsawnDRSCNxVjeoNjTLHsK5KtCaL9SlDRM=;
	b=XgGV9YafL1BF7qW5SiPsMY3DehAJdcxkZyWg7AHPQgaUoyR8t1yvabZvoIRz1aOkmEjC
	 29wlNhbuJt/kTaKCrVCjLZPSX4H3iwvcAIE2UdL+/RSduY+bBJ4sPtw39X1ulT43kOFnn
	 XLUIqC6Byb/psNTQX+oypYctKEPHXklqKO6sc9kPsDfy6SzBh6r0soqy9zPHkHPtHeGJ9
	 wRbMd4rlwc5uBsvfZkPZuNMVp9WZ+2lH762pG5LBgVBEKQJ4KZepuOXifxT8gOe5aW7r/
	 LwTYjKnji1BE/YMMpUtJtDqIb/gDj8ekBLO3SqFhR5cnAbzd1zcqkwTaViRq2m1PRYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rp2oMVGU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A18606A31C;
	Thu, 26 Nov 2026 14:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rp2oMVGU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26DB61F000CF;
	Thu, 26 Nov 2026 14:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705174;
	bh=63Ed54N++zsawnDRSCNxVjeoNjTLHsK5KtCaL9SlDRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rp2oMVGUAhLN/RagaccdsxouBmz+4h3dJQF9eN2oVMVgXm341j9w8GOjoNPVmoeBj
	 GM66SG/5zWRUrUkqHZ2666IJradqpKuy+XIyXhv+Hfg3hOgfF+FrkQ5wNOMkNbYKPE
	 LUd8emnWEVJqvct4817A1+wndl5QFS3kSNlqxkkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Soheil Hassas Yeganeh <soheil@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 108/319] ipv6/tcp: small drop monitor changes
Date: Thu, 26 Nov 2026 15:37:56 +0100
Message-ID: <20261126144009.182676620@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 12c8691de30734a29b84cae35a4bf1cccca6ad0a ]

Two kfree_skb() calls must be replaced by consume_skb()
for skbs that are not technically dropped.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: fafbc4051123 ("tcp: ipv6: free ireq->ipv6_opt after an RCU grace period")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/tcp_ipv6.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index c950d4907cd61..723831e2cc65d 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -572,7 +572,7 @@ static int tcp_v6_send_synack(const struct sock *sk, struct dst_entry *dst,
 static void tcp_v6_reqsk_destructor(struct request_sock *req)
 {
 	kfree(inet_rsk(req)->ipv6_opt);
-	kfree_skb(inet_rsk(req)->pktopts);
+	consume_skb(inet_rsk(req)->pktopts);
 }
 
 #ifdef CONFIG_TCP_MD5SIG
@@ -1582,7 +1582,7 @@ static int tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
 		}
 	}
 
-	kfree_skb(opt_skb);
+	consume_skb(opt_skb);
 	return 0;
 }
 
-- 
2.53.0



