Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07BEF30E0DC;
	Tue, 31 Mar 2026 16:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974364; cv=none; b=M/sH+4WFzV7trS7QyWkTqTgtpHrbqxAgolCflHjXhuNgW8kYLDHyOg5ZQ/RkGJMuxmmiQel4NwUin9g2YA1MMHiTwo0z9NsrzRc699UXsjeoDOqfDU3OW5Y5rLYOUAJDd1PufsS9dbbv5AcxON26ssn8BSWQE2R2nWi4BjZldYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974364; c=relaxed/simple;
	bh=TH2iaBmB4ttyIcfJ0k3j0Xk+C1yxaqRWPrZu5eyPqU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KdWZ6QjhQFlz12AvboDZiIIvSmdsNSUiolrhJ9U5DB252u2GxMlT7kjpuO/eqoUgK3AdQtPGb6uTXdIqJQ+/DemweVEJxi23AOtGPX2YaDHdAzgQF25jHzJpwRj7+BnXXwVVsJwVi8FNkMor+cM2LDrNyrlq2AMXAAclhkO7bbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e0Q30hHv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e0Q30hHv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9716FC19424;
	Tue, 31 Mar 2026 16:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974363;
	bh=TH2iaBmB4ttyIcfJ0k3j0Xk+C1yxaqRWPrZu5eyPqU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e0Q30hHvXjAKu1ckNzkff/RvIfWNVbf8077cLQ/f7mmpdLQXjtPzEi1MFkkOFVTjD
	 7py6dL07nk2jYKc7UZjX24wXbe4lFzYDtWv42oAD/ZnJGDK/5DfO7vtmb4H0xmGpuU
	 pub9T3u2bOHuctpultVwHGzpfXw+e4Eg12S8nOdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 057/175] tcp: Rearrange tests in inet_csk_bind_conflict().
Date: Tue, 31 Mar 2026 18:20:41 +0200
Message-ID: <20260331161731.880919956@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4a53c538dcaa1..e7751bfab92bb 100644
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



