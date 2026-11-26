Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705276;
	b=ZSIpGv6stGcRbV8rB4/hRGy44XC+A6N37ZxJJLH2NrEZLf9bGwrprxFxMhm3IXKl023j
	 WnC0GDSNZW2ELjWr2GxnIECpCG2pwCguax89zg3JGy07TCy1zzsiTEE6N0pqJc8OxfoB+
	 x70qiZqOrN42LBFdI3JulqM9Pm/LuykwOA+zNZUpU0jJdszYqSnsS0t/qdSFGfRXh1/SP
	 Pdxdtju/u+Mq7wisViWmG24imRI3SC+EVye/zfk2N4kkEwaZCf/i1QaVvtxRrVGeO9jsd
	 36yYXqZQ5zEAofLyu2YLZZZHFatWQklCNBVwnVVcLQj9J9d8Ts8jiWuoAMfl6/D5XZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705276;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=l7ZM+rtRPeBt+MOnsbYJF1kjsX4Dr/2oHBUEyMB+aJ0=;
	b=tfrpk6S7B3tjygHUSEOAA3Te9xqO9Wu/3mZ3QBKy2mkIWlyY4MfPZwI7i4i7pq3332vk
	 GGwrCEpGJBDyKp7QatBs0dlqvB8q7AAWxJRpz6QWyNUwtVhwCweaStZKUyi8pVKGfyvAA
	 6lMR8QeIr4DJESQ6bDiwMK40sCp3HSf8YP2bZc+LxaUePX7zfiw/nGJ4Y2ozLpFHgw53y
	 Pr4jUQ9dK+W0kAvEVa8uivCLZ/Wr0ixDRsaEzp+UlR7WAIpxT6wkOA1p/hKaamhpMWNkz
	 utexRbNPQjtAFGy6AvTbL+epMQRxEm95fmdUSu96bQ6B+WW1hUnmRoKdyotRgGm+NJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gQftBmSw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B88606A31C;
	Thu, 26 Nov 2026 15:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gQftBmSw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE2BA1F000C0;
	Thu, 26 Nov 2026 15:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705276;
	bh=l7ZM+rtRPeBt+MOnsbYJF1kjsX4Dr/2oHBUEyMB+aJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gQftBmSwdLgiNN5Yq+YxF5lbgdTEVmsfyXqhbqSUGAchcLnYfp5KpBo4IuFcut3R8
	 im8hLH+JnVGiOqFsomkw6S2eK2KWQH6jaLLDlmiLzidv+d3W/Hm3h4/Lj9NaL7jXL4
	 IiCEsU87H9nszuEOeR793DYepwftLfx4/Pxjmv2w=
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
Subject: [PATCH 5.15 144/319] net: protect negative destination advice with RCU
Date: Thu, 26 Nov 2026 15:38:32 +0100
Message-ID: <20261126144009.999107696@linuxfoundation.org>
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
index 2b13a41cd99a9..77cef68c56335 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2159,10 +2159,13 @@ sk_dst_get(struct sock *sk)
 
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



