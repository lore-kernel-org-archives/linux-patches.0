Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624819;
	b=APLBBLiwuSSzjXG3v4M9JqOd/LN6MNtFGUN+TkA9wQ2A1O+Q4UMqTI4amTPSdJ+H+Hn1
	 J/h/mTK7Fyesja1EXbiqKZlimdxoqdQ8mPxB0vxOcaC4RENAg9xZ5wgZJJN9CXNDJuKUs
	 flc7ND8EAryFEn89+a8i87tmgk5rZ1Fdgmh9h/mhrUqNdWIOicaE5hUCi6m0dmnhyjhHr
	 d9DNheAi51uARWERwUFPz23Q7jMX00ZhR9Hdc8jMfuv55cWEfZA5LkhG31qFqmm3j4zFp
	 P0V4Nh5IfQR3f/V0snRTlC5mcIlxKkwxBdzt0CnC9flGBEQqxfAUc/aPPHEJ78ab+sQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624819;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E2AekYoHW5HohHYChCisSutPz8AWXioabggJqSQ2Cy8=;
	b=jjCgTOOs9CRX3TBD7ceuk0xymfVZF9W5Q/ewnXO/P5hE5JwLUnvrndYXvAcfO+CicjIr
	 HSS5A+tUcEkysnX+HIwsRc5TQWKA/8qKcwumQIN8BrvCpIMbRuI2akRyC0I8WQq2jGh3C
	 g///C2miztoX956ivOl6SgtywDy27H6mYNkbeADh7wkb5lgR/9r6NdaCxyDhV2cvS6TAw
	 OokcVxuJD5xGjgMuQRW2rfo/LTwRqfvIIEx+ukt4FIXk1A2rilSUiF9m7en6XbLo8XnGE
	 X2W/iqe7CrbLlVeDHb/Vuj8vGFCEkOqzHCIrSxKAZ4dfvc34b2vkJ1OgVGwJVZZ8z5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JfG1iert;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36842606A33A;
	Wed, 25 Nov 2026 16:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JfG1iert
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 320891F000C0;
	Wed, 25 Nov 2026 16:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624818;
	bh=E2AekYoHW5HohHYChCisSutPz8AWXioabggJqSQ2Cy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JfG1iertNnyLzVzldNG1mVFuhVyZTC2jccP/b7qTM4nknlj44hx6Axt9HYypKEWAg
	 2cergsvC/Drp39pHJu/1PUSzaKJiky9jinrD++HEhklaUXuUqmWHCzG+1fSyaWeZdp
	 Yi46KcZrbppJ+oM4LJ6ayCcDXzzCHOc5zSA6acP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 315/816] net: require a full socket in sock_confirm_neigh()
Date: Wed, 25 Nov 2026 15:31:03 +0100
Message-ID: <20261125143856.489543806@linuxfoundation.org>
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

[ Upstream commit c78b47704934e44442f4e48bfdcc99039e3b85a5 ]

An skb can retain dst_pending_confirm after its original output and
socket owner have changed. For example, a raw MSG_CONFIRM packet can
cross veth, have a TCP request socket assigned by TPROXY, and be bridged
into gretap. Neighbor output for the outer packet then calls
sock_confirm_neigh() with the request socket in skb->sk.

The helper unconditionally treats a non-NULL skb->sk as a full socket
when accessing sk_dst_pending_confirm. TCP request and TIME_WAIT sockets
do not contain that field. This produces an out-of-bounds four-byte read
and, if the word is nonzero, an out-of-bounds four-byte zero write. A
KASAN-enabled kernel reports:

  BUG: KASAN: slab-out-of-bounds in ip_finish_output2+0xc9f/0xd60
  Read of size 4 at addr ffff8880bdc3d880 by task tproxy_dst_conf/1771

Require sk_fullsock() before accessing the socket field, moving the
existing helper earlier in the header to make it available here. Keep
neigh_confirm() independent of the socket type so the skb's neighbor
confirmation still works, including for socketless packets. This also
covers the IPv6, VRF, and BPF neighbor-output callers.

Fixes: 4ff0620354f2 ("net: add dst_pending_confirm flag to skbuff")
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20261104132900.1071940-1-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sock.h | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 6f1da04c9794b..0c08d70490e31 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2190,6 +2190,14 @@ struct dst_entry *__sk_dst_check(struct sock *sk, u32 cookie);
 
 struct dst_entry *sk_dst_check(struct sock *sk, u32 cookie);
 
+/* This helper checks if a socket is a full socket,
+ * ie _not_ a timewait or request socket.
+ */
+static inline bool sk_fullsock(const struct sock *sk)
+{
+	return (1 << sk->sk_state) & ~(TCPF_TIME_WAIT | TCPF_NEW_SYN_RECV);
+}
+
 static inline void sk_dst_confirm(struct sock *sk)
 {
 	if (!READ_ONCE(sk->sk_dst_pending_confirm))
@@ -2201,7 +2209,8 @@ static inline void sock_confirm_neigh(struct sk_buff *skb, struct neighbour *n)
 	if (skb_get_dst_pending_confirm(skb)) {
 		struct sock *sk = skb->sk;
 
-		if (sk && READ_ONCE(sk->sk_dst_pending_confirm))
+		if (sk && sk_fullsock(sk) &&
+		    READ_ONCE(sk->sk_dst_pending_confirm))
 			WRITE_ONCE(sk->sk_dst_pending_confirm, 0);
 		neigh_confirm(n);
 	}
@@ -2832,14 +2841,6 @@ skb_sk_is_prefetched(struct sk_buff *skb)
 #endif /* CONFIG_INET */
 }
 
-/* This helper checks if a socket is a full socket,
- * ie _not_ a timewait or request socket.
- */
-static inline bool sk_fullsock(const struct sock *sk)
-{
-	return (1 << sk->sk_state) & ~(TCPF_TIME_WAIT | TCPF_NEW_SYN_RECV);
-}
-
 static inline bool
 sk_is_refcounted(struct sock *sk)
 {
-- 
2.53.0



