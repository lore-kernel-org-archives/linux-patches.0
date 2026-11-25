Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622039;
	b=HAI+1ahRs4mnrpUKAI6ywPN2XTaxz1IQO48gMn4xz6TovcU8wDlBGTjBnQOic7VRhbd1
	 +be/lArFHPH23cq9nLRraQ9GCP6oDx3YQDmSIpbdcpvNC9g9R3vBduP5tXQLzRCoGcAZW
	 OCyFn7NYctiqXj7xQp0SJ6vElArX3MK/taAbYVQYJ/t3uNnsRBha3ZT5sZ2pnxwRhix46
	 Pody0THA4IF6Scbm8zemVNuYK7g+P6+x8p922X1uyXvt6rMKgL6DFNMht9PWQ0QGNiJ+y
	 TVccW3f4f3Sr9Z3rvt8q9jtMHxlQ9AfPoCl7SFPh1lNEjEjEl3xj1wXEZW/ZTygM22w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622039;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pqnMQX5dr7mwse+ly2Uxz/rnk+E9Z9VW6q1/L5WPiJo=;
	b=jzRgLdBKdhfXODxrtTBX4kgDW5QS/+476aRQmD6LiIQiGoBIgpn1bfA393zEAaKH10W5
	 VwPq/AUo5Hqu5LHQJb5nFK+vTOOMQGsM/kgn9ZeKeBILEUoTYCJeICBI6Lo0469Oe/0uD
	 njCJNab7RyZKq83bZQNbaSxX4rM+QiwwcGMa7RUE4tKEsokWQo8DSSy9Mu8GUiLFqbwto
	 FNCdVzdGocVW9pQTvC3+7Omajw4QXb3Wbvac8/XH55iOlxBVGydUs3v/dlASCmPLNyjEP
	 n1kG7XjjIrzabqV8j1x2v5mwZOnJ4NtNAMItRX1t2KyR+LReQHIhY+b36MKMVUisXeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2D1j85Kh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D4B6606A321;
	Wed, 25 Nov 2026 15:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2D1j85Kh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A58611F000EE;
	Wed, 25 Nov 2026 15:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622039;
	bh=pqnMQX5dr7mwse+ly2Uxz/rnk+E9Z9VW6q1/L5WPiJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2D1j85KhG9qjxUO/mETDyAHQ8YGrZ9Ams0dNDitwvPiB1Twqy4t7E08c7IwyHlMNX
	 jHTjww59B6OX294biMBHKngp25hnyA9z479FerbfaFmEK+aaQpGQ0P2LrT+ALYTd4z
	 meZI/0gw7/HF/WYUHBxQvQGxhQQi5326F9owGSHs=
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
Subject: [PATCH 6.18 412/990] net: protect negative destination advice with RCU
Date: Wed, 25 Nov 2026 15:29:39 +0100
Message-ID: <20261125143831.750184418@linuxfoundation.org>
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
index fb91d72a955dd..49d4c25271bee 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2176,10 +2176,13 @@ sk_dst_get(const struct sock *sk)
 
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



