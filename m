Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D8422E7379;
	Thu, 28 May 2026 20:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000027; cv=none; b=L2GKNBKYRUJkx+7gmLOFs+ds+szdjwi+Dw7J0UPJC/HN9B4DRK66V+p31RNHPq4FbWq5AHz/c2c29H6iZPntWBsV/2WyR0fV+THI17VTdXI8Hv+MBCZXfOokfBH/LKOSjvywmANPd9kVLmVl6kWdWut1CDiSaOzcXmTRB/j49Iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000027; c=relaxed/simple;
	bh=rLSfbLG61J4aVjeCHoyxdJGqMoYWnlOrT3t7/BhcEX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h0URsSUuUWeP0IyOKfCCLmlcNWHcHc8cTaEul90Ty6NqmXhEOwEnJ5y4Mjj1k3BJLUn+22hMxXa0pKNf5EduqNBQOb6nXRPqKUI49goyC/9VK+Ofvual3PCwfPQDewcBpvplmGYRbL6Q72zt4CFuCLwa2tDZQvsYAjRer7k4xyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WBJcITC3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WBJcITC3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB3491F000E9;
	Thu, 28 May 2026 20:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000026;
	bh=B34LusKSQy/NoTamNHwx3Q4yQ3QiQHST+l/b7aaLu/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WBJcITC37B5OID2PAH4u4CcR6ovvzqJIN5GV+352Z8nesnVrUXfsHl0eiG2/qpWQy
	 oZGspSfo0z9Ffw+WpwZU15+MkSd7Wna+hn19pEyRTkV4O9W4vKiTgPO93zAYzNkHUK
	 9A21r+63jhtvttuY/zkfnGN2oHf87SjtJpiBvM5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damiano Melotti <melotti@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 229/377] tcp: Fix out-of-bounds access for twsk in tcp_ao_established_key().
Date: Thu, 28 May 2026 21:47:47 +0200
Message-ID: <20260528194645.023204832@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 03cb001ef87b3f8d859cf7f96329acf3d6235d29 ]

lockdep_sock_is_held() was added in tcp_ao_established_key()
by the cited commit.

It can be called from tcp_v[46]_timewait_ack() with twsk.

Since it does not have sk->sk_lock, the lockdep annotation
results in out-of-bound access.

  $ pahole -C tcp_timewait_sock vmlinux | grep size
  	/* size: 288, cachelines: 5, members: 8 */
  $ pahole -C sock vmlinux | grep sk_lock
  	socket_lock_t              sk_lock;              /*   440   192 */

Let's not use lockdep_sock_is_held() for TCP_TIME_WAIT.

Fixes: 6b2d11e2d8fc ("net/tcp: Add missing lockdep annotations for TCP-AO hlist traversals")
Reported-by: Damiano Melotti <melotti@google.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260508120853.4098365-1-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_ao.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_ao.c b/net/ipv4/tcp_ao.c
index 849a69c1f497f..aa624434b5556 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -116,7 +116,8 @@ struct tcp_ao_key *tcp_ao_established_key(const struct sock *sk,
 {
 	struct tcp_ao_key *key;
 
-	hlist_for_each_entry_rcu(key, &ao->head, node, lockdep_sock_is_held(sk)) {
+	hlist_for_each_entry_rcu(key, &ao->head, node,
+				 sk_fullsock(sk) && lockdep_sock_is_held(sk)) {
 		if ((sndid >= 0 && key->sndid != sndid) ||
 		    (rcvid >= 0 && key->rcvid != rcvid))
 			continue;
-- 
2.53.0



