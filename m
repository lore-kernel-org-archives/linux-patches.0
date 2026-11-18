Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022001;
	b=49K/5hKFU8EvTxIWhN2qorRSjfylgsQaF9CUfZ5AjaPDcQ6m/TzSAsLaiT+D53yN1kKh
	 esEyug2CKv+GB98zzHPKoCtKCDG8OMa5+KmCiw7krKIDepWcgUIUjFUFCezrB8aXPlfa+
	 Ig1GHd3ApKNyrdRzq/GnprIQATlgXWEuDRLjPrq4Wo4nGhI6Kk1Muqk3WKkEh4ADdWBne
	 PJePN7Bl+IMPoG7CCwGFA2TVqUlSf/CWavEbGuXwePbt30p5APeS7norNVz/k5EJIrxAp
	 VXK63IsGxU88e9QkG6KbNhcLhGeOMSsYvVVdsO9rIZJ/JQ3jMCYiDmNdho3HPMfMGtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022001;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gdBZyhvStUvcw9/k/0pLS9BYLl7x66YyyM+HRsZtfrk=;
	b=TUDShIRuoXvjezpFjb4rQIbuM+iftAUpbgNW/wY9zZWZkyuPN7jd39/0cbYUV50/3ELo
	 KuhQn8VihtxbFcAtUZQwQypVWm59L2PLqSE7hqI55oPNpP1FER5+LbOvjwuV4iSrJex3X
	 Sv9RpJa6AAuSL/mBuoQJ8CKzy5i4JrTnWQUjtKdHOpm6fvum1vs/e11OvAFNvd+xMD1pi
	 M6a125BKU7+wgNG4h8h/he8UxS7kNa2EgBQ3xBFgh/ck0yT8bLKiT4QxnQG6RHNlcwwk5
	 02b7btB6jS1Tz0CRDHhef4ktGimAz0tjkGGr+Hqf6kdYdes1EDxDk7ss/TrpNLBGsmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fwWozU4x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1532F606A31C;
	Wed, 18 Nov 2026 17:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fwWozU4x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DA6B1F000C4;
	Wed, 18 Nov 2026 17:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022000;
	bh=gdBZyhvStUvcw9/k/0pLS9BYLl7x66YyyM+HRsZtfrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fwWozU4xPc0LZS9w0H4V2PBYbzR/lS+MRjaAe1i2+QcFvpQ78kD4ab6LU0gl355au
	 ttSGH8wlCd+ijjg7EDGe+2EYbiktOTu/vUgqa1RQT0DWmmr7rxBGuuDvG+Rh0VR+Bx
	 i+Qd/Es3Xj7tWYM2r3+kW8H8IzJ75VjTIrbzuxV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Zhewei Yuan <yzwlhm@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2508/2651] tcp: Fix fastreuse cache initialization on first bind
Date: Wed, 18 Nov 2026 16:02:28 +0100
Message-ID: <20261118150415.049995091@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhewei Yuan <yzwlhm@gmail.com>

[ Upstream commit 947ccedf683ed6cc53c1f88ac9eb8747e4567ed6 ]

inet_csk_update_fastreuse() initializes the reuse caches only when
tb->bhash2 is empty, but both inet_csk_get_port() and
__inet_inherit_port() link tb2 before calling it, so the first-bind
branch is never taken.

As a result, SO_REUSEADDR binds never get fastreuse=1 and keep
scanning existing owners, and SO_REUSEPORT starts in STRICT instead
of ANY.

Initialize the caches when tb2 is the only entry in tb->bhash2 and has
no owners. Timewait sockets are also linked on tb2->owners, so this is
equivalent to the old hlist_empty(&tb->owners) test.

Found by manual code inspection and confirmed with GDB. Binding 16000
SO_REUSEADDR sockets to one address/port in a KVM guest takes 4.18 s
before and 19.4 ms after this patch. Existing bind/reuse selftests
pass. Analysis and testing were assisted by an AI tool (Codex).

Fixes: 8002d44fe84d ("tcp: Check hlist_empty(&tb->bhash2) instead of hlist_empty(&tb->owners).")
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Signed-off-by: Zhewei Yuan <yzwlhm@gmail.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>
Link: https://patch.msgid.link/20261026095208.58504-1-yzwlhm@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/inet_connection_sock.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index a1fe2531cb590..71b0c344579f3 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -446,7 +446,8 @@ void inet_csk_update_fastreuse(const struct sock *sk,
 {
 	bool reuse = sk->sk_reuse && sk->sk_state != TCP_LISTEN;
 
-	if (hlist_empty(&tb->bhash2)) {
+	if (hlist_is_singular_node(&tb2->bhash_node, &tb->bhash2) &&
+	    hlist_empty(&tb2->owners)) {
 		tb->fastreuse = reuse;
 		if (sk->sk_reuseport) {
 			tb->fastreuseport = FASTREUSEPORT_ANY;
-- 
2.53.0



