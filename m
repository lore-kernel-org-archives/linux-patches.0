Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624816;
	b=pI3EcpKuURICQoKI/HX+T16uZP2VfJVjMtIgh+zS3wUWorMd/c5r1NL+5rp2Kg4gjSAG
	 f4yp0rZye1AAukwiPivSvx4Ox20UlIIlhzbN/oqavqEaGC3KDexGlVpLVgkhd3hwBY/8U
	 02f5A0zRHp6ytastLpc8pvKMcxDyVRXOSAjYsOyxpx+ItHEXyYt7KkyX8fEaoUmIeqIlU
	 SPbtPmoMB9yk5o1TnnxjRzE/P9KRjmHLVBDfTjWcYvQI54cpZCobqenHJ2gA5Jsj7ADYX
	 AE8ELDqCqDZYx2RIAHJF/5+J1Ygv1MMof/8TcMPi8V6KPZW88Q4DFLDPaOq+3Wxzt/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624816;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ekut9a/zZtUhMQNU972vDKt2eDrmCaiGjYIM81Aaee0=;
	b=D8XkoCXh4gwmQP/n1oFCH4JqZxc+jS/lR0OkxXQJ4SXNVWFgoqDew1BccWrJskQZ/ITx
	 WdZZOBB4Y8N2iC3OIG9YyXbs3GtgN6Zs4LwbwUi42BvGV6d7zXQ5IptuAK4EJOL1oXBaB
	 L3DscWQiexmdJtt21/EHuZPGFD19qzuy75VpiVBytrhISLiQwWFd7e5+n6kOKaFkLMeRt
	 nIKak47rkEON+AN2LaCzVcs0LXvLcGaAkMIQqWBorBVPtbPV7yozWs9LmdPY03tS0xE+1
	 1b4ypXQTVjssAaoaYUlore2FRxpdD8vzF/MzP+j8AhHq6H/vyZhNkkmPNPhrRUB5kfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z9NtzLQy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09AA4606A33C;
	Wed, 25 Nov 2026 16:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z9NtzLQy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED8751F000C0;
	Wed, 25 Nov 2026 16:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624815;
	bh=Ekut9a/zZtUhMQNU972vDKt2eDrmCaiGjYIM81Aaee0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z9NtzLQyuvRGno61IbMoOpvfaAOj+0Xt6mIW4dYtSHQoCdiOWdonU68/kZiLr9w2k
	 BtE6Ub0xPTSkwjXtEuBpQwWQHgerrEt8xcdil0TMkpdMQgDrz59utVCs6moaKHFd+p
	 XLNnuQdcColu2dnndM2Ia6ac4//XUnVypO+t7C3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 314/816] net: protect negative destination advice with RCU
Date: Wed, 25 Nov 2026 15:31:02 +0100
Message-ID: <20261125143856.467379280@linuxfoundation.org>
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

From: Kyle Zeng <kylebot@openai.com>

[ Upstream commit 4b77d2792c3e482afa108c08f224ea6fa396d80b ]

SO_CNX_ADVICE calls __dst_negative_advice() while holding the socket
lock. Connected UDP sends can still invalidate or replace sk_dst_cache
without that lock. A concurrent sk_dst_check() can drop the final
destination reference and allow an RCU callback to destroy it while
__dst_negative_advice() retains only a borrowed pointer. This can cause
a use-after-free while accessing dst->ops or running the negative_advice
callback.

The writer-side ordering fixed by commit 92f1655aa2b2 ("net: fix
__dst_negative_advice() race") does not protect this reader from an
independent cache replacement.

Hold an RCU read-side critical section across the lookup and callback.
This follows the datagram release callbacks and covers IPv4, IPv6, and
XFRM advice without changing cache-reset or reference-ownership rules.

Fixes: a87cb3e48ee8 ("net: Facility to report route quality of connected sockets")
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20261104131744.1056562-1-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sock.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 79e409bf3d13a..6f1da04c9794b 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2135,10 +2135,13 @@ sk_dst_get(const struct sock *sk)
 
 static inline void __dst_negative_advice(struct sock *sk)
 {
-	struct dst_entry *dst = __sk_dst_get(sk);
+	struct dst_entry *dst;
 
+	rcu_read_lock();
+	dst = __sk_dst_get(sk);
 	if (dst && dst->ops->negative_advice)
 		dst->ops->negative_advice(sk, dst);
+	rcu_read_unlock();
 }
 
 static inline void dst_negative_advice(struct sock *sk)
-- 
2.53.0



