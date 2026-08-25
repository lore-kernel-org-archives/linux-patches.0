Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6CD62F8E90;
	Tue, 25 Aug 2026 14:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666459; cv=none; b=Khf9uF9HjRGRs9ioBPLanOYMwqGkpjGtUPm1j2Z+Cg4NKgAhfi/GYa6bh3f4C4LqVnB48hljgXVwAngC3Hx+JtogZhHmc3xCGdtPM+a3qcC2YTw1Gy1xWPZsBZJY8FMtY8Eq+YXV05eNtqRCPJnTdEmqGyaIu5sYOBOpM4NLpII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666459; c=relaxed/simple;
	bh=RAwLZROrSr+WyHp/XkytohfXvXgzlQIrb1uOZ5tjUvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tKWbwnoqDGDt4hWY4GlzRg+uXp3Dhq+Lot+9lsAApn3jDcki4GMnmG1EnIHubixEzzRWXpB+4SqpRp9KhUeJ5bFi4Dw5LLdZlvgsp1WBDS8NztBroB2+uPGqmbb/9O7MSvx2/toac9wV/P8HCrLYo8R0eZPAyghkY1v0jJF+6FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0SA3GVxH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0SA3GVxH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 197FE1F000E9;
	Tue, 25 Aug 2026 14:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666458;
	bh=F76eUdNyr3A1ozlFpT5TNBJb1sf5/Q8Kh2GsdxshxGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0SA3GVxHhnycvTIiQFUtIryn1UAThkdQsEEcNZ7+fSKomTVYptKg8j0K3EkGR+a48
	 kiQNr5fZ/4Zx45QOxQolGyoW1vjMB5Am+eK7gpuO8dM8DiygshnpHEyp9/l2XKBlFz
	 VHK+MED1y59H6KVa7dvxJlXUrzkCpJo+lwUhdJpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	"Xiang Mei (Microsoft)" <xmei5@asu.edu>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 49/57] xfrm: fix sk_dst_cache double-free in xfrm_user_policy()
Date: Tue, 25 Aug 2026 15:27:11 +0200
Message-ID: <20260825132543.253167518@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.342390421@linuxfoundation.org>
References: <20260825132541.342390421@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang Mei (Microsoft) <xmei5@asu.edu>

[ Upstream commit c283e9ada7fcb7dd4b10592623086b2e6d2f9925 ]

xfrm_user_policy() clears the socket dst cache with __sk_dst_reset(),
i.e. the non-atomic __sk_dst_set(sk, NULL): it reads sk_dst_cache with
rcu_dereference_protected(), stores NULL and dst_release()s the old dst.
That is only safe if no other thread modifies sk_dst_cache concurrently.

For a connected UDP socket that does not hold: the transmit fast path
(udp_sendmsg -> sk_dst_check -> sk_dst_reset) resets the cache locklessly
with an atomic xchg(). A per-socket policy change racing a send can make
both sides observe the same old dst and each dst_release() it, dropping
the socket's single reference twice and freeing the xfrm_dst bundle while
it is still referenced:

  BUG: KASAN: slab-use-after-free in dst_release
  Write of size 4 at addr ffff88801897b6c0 by task exploit/155
  Call Trace:
   ...
   dst_release (... ./include/linux/rcuref.h:109)
   xfrm_user_policy (./include/net/sock.h:2239 ./include/net/sock.h:2256 net/xfrm/xfrm_state.c:3053)
   do_ip_setsockopt (net/ipv4/ip_sockglue.c:1347)
   ip_setsockopt (net/ipv4/ip_sockglue.c:1417)
   do_sock_setsockopt (net/socket.c:2368)
   __sys_setsockopt (net/socket.c:2393)
   __x64_sys_setsockopt (net/socket.c:2396)
   do_syscall_64 (arch/x86/entry/syscall_64.c:94)
   entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)

Reachable by an unprivileged user via a user+network namespace.

Use the atomic sk_dst_reset() so the cache is cleared and released with a
single xchg(): whichever side wins releases the dst once, the other sees
NULL and does nothing. Behaviour is otherwise unchanged.

Fixes: 2b06cdf3e688 ("xfrm: Clear sk_dst_cache when applying per-socket policy.")
Fixes: be8f8284cd89 ("net: xfrm: allow clearing socket xfrm policies.")
Reported-by: AutonomousCodeSecurity@microsoft.com
Signed-off-by: Xiang Mei (Microsoft) <xmei5@asu.edu>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_state.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 10f974d5ebee6..c5412f2e3b208 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2399,7 +2399,7 @@ int xfrm_user_policy(struct sock *sk, int optname, sockptr_t optval, int optlen)
 	if (sockptr_is_null(optval) && !optlen) {
 		xfrm_sk_policy_insert(sk, XFRM_POLICY_IN, NULL);
 		xfrm_sk_policy_insert(sk, XFRM_POLICY_OUT, NULL);
-		__sk_dst_reset(sk);
+		sk_dst_reset(sk);
 		return 0;
 	}
 
@@ -2439,7 +2439,7 @@ int xfrm_user_policy(struct sock *sk, int optname, sockptr_t optval, int optlen)
 	if (err >= 0) {
 		xfrm_sk_policy_insert(sk, err, pol);
 		xfrm_pol_put(pol);
-		__sk_dst_reset(sk);
+		sk_dst_reset(sk);
 		err = 0;
 	}
 
-- 
2.53.0



