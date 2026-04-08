Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3629A37F8C2;
	Wed,  8 Apr 2026 18:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671740; cv=none; b=Ki9dUqWhiDxrr03RxBpxfxdMEsJPIaor7+guirzc8lLaxAO6GyhDHKTeGVTR+r4UpnVKu5Oqnza8DChHotuQdCutz8iguYRY9cH9jeP1mqFarJDOs+l2Y3dM/kOFCnhzjtyhf0sKAgw86JBvbiqUXciz3bdq+sZTfl4eLvmxoCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671740; c=relaxed/simple;
	bh=WSihfRpsomFu1QARSYf1L8hmLOEim7/JzveErEIWVws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AMiLP+BMCwMOjID3qFfwgYfaB5WGVCQBNg2RWIbomex7HBOc4E2HNuzYp32TpSSgnMBYZpAKncz+0Lrlw8Viv2e4RMBnKkVrtdbMtm8CjwbfiatyPn+PVmULS3nwE9H3e6S/8VTxnbmGkE41hhTDe4ZUsOLe6XrC/14z5JLxfpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kvhE4vve; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kvhE4vve"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFC71C19421;
	Wed,  8 Apr 2026 18:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671740;
	bh=WSihfRpsomFu1QARSYf1L8hmLOEim7/JzveErEIWVws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kvhE4vvepKprn2iG4itUYuv6LbraSqWTsmOviMY3uIbAewp4duqdTCSNoY9BcTWF1
	 lOlqLU/hyfSt4GVEhdDAFjgkM/68ZUnIr2Yt/yls7hJ2XwKLX67BaIRGoeXKEFshtJ
	 v5bdxqntnWtrU2yWKtxZhaWk02zrZt7c2mZQ2c64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 048/312] tcp: Rearrange tests in inet_csk_bind_conflict().
Date: Wed,  8 Apr 2026 19:59:25 +0200
Message-ID: <20260408175935.530491319@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 58655bc0ad7ccdd5b53319bcc091cb81b6aee7c3 ]

The following patch adds code in the !inet_use_bhash2_on_bind(sk)
case in inet_csk_bind_conflict().

To avoid adding nest and make the change cleaner, this patch
rearranges tests in inet_csk_bind_conflict().

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: e537dd15d0d4 ("udp: Fix wildcard bind conflict check when using hash2")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/inet_connection_sock.c | 40 ++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 21 deletions(-)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index c7e4ceefe0269..abec5206a8d17 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -240,9 +240,10 @@ static int inet_csk_bind_conflict(const struct sock *sk,
 				  const struct inet_bind2_bucket *tb2, /* may be null */
 				  bool relax, bool reuseport_ok)
 {
-	bool reuseport_cb_ok;
-	struct sock_reuseport *reuseport_cb;
 	kuid_t uid = sock_i_uid((struct sock *)sk);
+	struct sock_reuseport *reuseport_cb;
+	bool reuseport_cb_ok;
+	struct sock *sk2;
 
 	rcu_read_lock();
 	reuseport_cb = rcu_dereference(sk->sk_reuseport_cb);
@@ -250,32 +251,29 @@ static int inet_csk_bind_conflict(const struct sock *sk,
 	reuseport_cb_ok = !reuseport_cb || READ_ONCE(reuseport_cb->num_closed_socks);
 	rcu_read_unlock();
 
-	/*
-	 * Unlike other sk lookup places we do not check
+	/* Conflicts with an existing IPV6_ADDR_ANY (if ipv6) or INADDR_ANY (if
+	 * ipv4) should have been checked already. We need to do these two
+	 * checks separately because their spinlocks have to be acquired/released
+	 * independently of each other, to prevent possible deadlocks
+	 */
+	if (inet_use_bhash2_on_bind(sk))
+		return tb2 && inet_bhash2_conflict(sk, tb2, uid, relax,
+						   reuseport_cb_ok, reuseport_ok);
+
+	/* Unlike other sk lookup places we do not check
 	 * for sk_net here, since _all_ the socks listed
 	 * in tb->owners and tb2->owners list belong
 	 * to the same net - the one this bucket belongs to.
 	 */
+	sk_for_each_bound(sk2, &tb->owners) {
+		if (!inet_bind_conflict(sk, sk2, uid, relax, reuseport_cb_ok, reuseport_ok))
+			continue;
 
-	if (!inet_use_bhash2_on_bind(sk)) {
-		struct sock *sk2;
-
-		sk_for_each_bound(sk2, &tb->owners)
-			if (inet_bind_conflict(sk, sk2, uid, relax,
-					       reuseport_cb_ok, reuseport_ok) &&
-			    inet_rcv_saddr_equal(sk, sk2, true))
-				return true;
-
-		return false;
+		if (inet_rcv_saddr_equal(sk, sk2, true))
+			return true;
 	}
 
-	/* Conflicts with an existing IPV6_ADDR_ANY (if ipv6) or INADDR_ANY (if
-	 * ipv4) should have been checked already. We need to do these two
-	 * checks separately because their spinlocks have to be acquired/released
-	 * independently of each other, to prevent possible deadlocks
-	 */
-	return tb2 && inet_bhash2_conflict(sk, tb2, uid, relax, reuseport_cb_ok,
-					   reuseport_ok);
+	return false;
 }
 
 /* Determine if there is a bind conflict with an existing IPV6_ADDR_ANY (if ipv6) or
-- 
2.51.0



