Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E241D2EE262;
	Tue, 31 Mar 2026 16:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974998; cv=none; b=WKq93HGsmEq1CrwPRK35jbUM+V3sKDXFCItA7EOjDua7w17PUUMFibjCmRdNTv/8k2BzRWt6m/WSkiVsUPlsDYr56l9sawK0XBuYYmsFRFhlWxKJnTrA9UeXRpmT3EC7Ltq94Z3XtSWAfiGmTx14ZJ1K61rHJxeWFvgZXkjXBpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974998; c=relaxed/simple;
	bh=DGoZ8UmQvH7ZPx8maGGvvhRqOEys+KsXK37ESwkC7zI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kd6loPeW+LttYsSLgseFzPJjJ3ZxlB8kOwH+XVb0wUp32ej5tto8t0dJOh1tHt4DzPMrQgcUB5iV4k7iuRFeAIXRoAY5wYrRGb94sQP7JUj+jzmLRNmAjFibrFnWj4ZICDQdWsgSU+9acyrSv718phD47E808OpNzJkhxH9Gs/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hsg7ahL2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hsg7ahL2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77D9EC19423;
	Tue, 31 Mar 2026 16:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974997;
	bh=DGoZ8UmQvH7ZPx8maGGvvhRqOEys+KsXK37ESwkC7zI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hsg7ahL22UtzM7F5kOvO84JBSdxYOXAWgU+jmuTD8kctsueAQ53r+o2truWg38Rx2
	 1s5D8ryFp4Hq7sAvMSj+KUsvWcrL6E03rB2oUpfjJUV4CiYHfMhL90MZ1McZLdbO20
	 nbWps0j1crABobxMdM17xVK7GVQuXHaATPEcBukg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Onyshchuk <oandrew@meta.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 123/342] udp: Fix wildcard bind conflict check when using hash2
Date: Tue, 31 Mar 2026 18:19:16 +0200
Message-ID: <20260331161803.534004119@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin KaFai Lau <martin.lau@kernel.org>

[ Upstream commit e537dd15d0d4ad989d56a1021290f0c674dd8b28 ]

When binding a udp_sock to a local address and port, UDP uses
two hashes (udptable->hash and udptable->hash2) for collision
detection. The current code switches to "hash2" when
hslot->count > 10.

"hash2" is keyed by local address and local port.
"hash" is keyed by local port only.

The issue can be shown in the following bind sequence (pseudo code):

bind(fd1,  "[fd00::1]:8888")
bind(fd2,  "[fd00::2]:8888")
bind(fd3,  "[fd00::3]:8888")
bind(fd4,  "[fd00::4]:8888")
bind(fd5,  "[fd00::5]:8888")
bind(fd6,  "[fd00::6]:8888")
bind(fd7,  "[fd00::7]:8888")
bind(fd8,  "[fd00::8]:8888")
bind(fd9,  "[fd00::9]:8888")
bind(fd10, "[fd00::10]:8888")

/* Correctly return -EADDRINUSE because "hash" is used
 * instead of "hash2". udp_lib_lport_inuse() detects the
 * conflict.
 */
bind(fail_fd, "[::]:8888")

/* After one more socket is bound to "[fd00::11]:8888",
 * hslot->count exceeds 10 and "hash2" is used instead.
 */
bind(fd11, "[fd00::11]:8888")
bind(fail_fd, "[::]:8888")      /* succeeds unexpectedly */

The same issue applies to the IPv4 wildcard address "0.0.0.0"
and the IPv4-mapped wildcard address "::ffff:0.0.0.0". For
example, if there are existing sockets bound to
"192.168.1.[1-11]:8888", then binding "0.0.0.0:8888" or
"[::ffff:0.0.0.0]:8888" can also miss the conflict when
hslot->count > 10.

TCP inet_csk_get_port() already has the correct check in
inet_use_bhash2_on_bind(). Rename it to
inet_use_hash2_on_bind() and move it to inet_hashtables.h
so udp.c can reuse it in this fix.

Fixes: 30fff9231fad ("udp: bind() optimisation")
Reported-by: Andrew Onyshchuk <oandrew@meta.com>
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260319181817.1901357-1-martin.lau@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/inet_hashtables.h   | 14 ++++++++++++++
 net/ipv4/inet_connection_sock.c | 20 +++-----------------
 net/ipv4/udp.c                  |  2 +-
 3 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
index 5a979dcab5383..6d936e9f2fd32 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -264,6 +264,20 @@ inet_bhashfn_portaddr(const struct inet_hashinfo *hinfo, const struct sock *sk,
 	return &hinfo->bhash2[hash & (hinfo->bhash_size - 1)];
 }
 
+static inline bool inet_use_hash2_on_bind(const struct sock *sk)
+{
+#if IS_ENABLED(CONFIG_IPV6)
+	if (sk->sk_family == AF_INET6) {
+		if (ipv6_addr_any(&sk->sk_v6_rcv_saddr))
+			return false;
+
+		if (!ipv6_addr_v4mapped(&sk->sk_v6_rcv_saddr))
+			return true;
+	}
+#endif
+	return sk->sk_rcv_saddr != htonl(INADDR_ANY);
+}
+
 struct inet_bind_hashbucket *
 inet_bhash2_addr_any_hashbucket(const struct sock *sk, const struct net *net, int port);
 
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 97d57c52b9ad9..d587c5df84389 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -153,20 +153,6 @@ bool inet_sk_get_local_port_range(const struct sock *sk, int *low, int *high)
 }
 EXPORT_SYMBOL(inet_sk_get_local_port_range);
 
-static bool inet_use_bhash2_on_bind(const struct sock *sk)
-{
-#if IS_ENABLED(CONFIG_IPV6)
-	if (sk->sk_family == AF_INET6) {
-		if (ipv6_addr_any(&sk->sk_v6_rcv_saddr))
-			return false;
-
-		if (!ipv6_addr_v4mapped(&sk->sk_v6_rcv_saddr))
-			return true;
-	}
-#endif
-	return sk->sk_rcv_saddr != htonl(INADDR_ANY);
-}
-
 static bool inet_bind_conflict(const struct sock *sk, struct sock *sk2,
 			       kuid_t uid, bool relax,
 			       bool reuseport_cb_ok, bool reuseport_ok)
@@ -258,7 +244,7 @@ static int inet_csk_bind_conflict(const struct sock *sk,
 	 * checks separately because their spinlocks have to be acquired/released
 	 * independently of each other, to prevent possible deadlocks
 	 */
-	if (inet_use_bhash2_on_bind(sk))
+	if (inet_use_hash2_on_bind(sk))
 		return tb2 && inet_bhash2_conflict(sk, tb2, uid, relax,
 						   reuseport_cb_ok, reuseport_ok);
 
@@ -375,7 +361,7 @@ inet_csk_find_open_port(const struct sock *sk, struct inet_bind_bucket **tb_ret,
 		head = &hinfo->bhash[inet_bhashfn(net, port,
 						  hinfo->bhash_size)];
 		spin_lock_bh(&head->lock);
-		if (inet_use_bhash2_on_bind(sk)) {
+		if (inet_use_hash2_on_bind(sk)) {
 			if (inet_bhash2_addr_any_conflict(sk, port, l3mdev, relax, false))
 				goto next_port;
 		}
@@ -561,7 +547,7 @@ int inet_csk_get_port(struct sock *sk, unsigned short snum)
 				check_bind_conflict = false;
 		}
 
-		if (check_bind_conflict && inet_use_bhash2_on_bind(sk)) {
+		if (check_bind_conflict && inet_use_hash2_on_bind(sk)) {
 			if (inet_bhash2_addr_any_conflict(sk, port, l3mdev, true, true))
 				goto fail_unlock;
 		}
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index fbdbb65676e0d..bbb076c6042b2 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -287,7 +287,7 @@ int udp_lib_get_port(struct sock *sk, unsigned short snum,
 	} else {
 		hslot = udp_hashslot(udptable, net, snum);
 		spin_lock_bh(&hslot->lock);
-		if (hslot->count > 10) {
+		if (inet_use_hash2_on_bind(sk) && hslot->count > 10) {
 			int exist;
 			unsigned int slot2 = udp_sk(sk)->udp_portaddr_hash ^ snum;
 
-- 
2.51.0



