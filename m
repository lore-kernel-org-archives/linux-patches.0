Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 798E942E426;
	Tue, 25 Aug 2026 13:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665315; cv=none; b=JP8CX8v3NeQiZLrv7cs3H+4cW/M4XmOzjKg+U1sopvMxrKRUUiA4F4jvf/tLfzy+4MzdIKcY606RB5qfDKII4FrRzthQ936/JgG2ttCsMrQ6Lx1YznMG+A7n/R4Ny+C4r/vgasjYiDKTyJO+TVCecco+7nNzIBiCavbe7+AGNSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665315; c=relaxed/simple;
	bh=Er4Lcrog1YN3DUaU86ht2BxA9kDzq+P1bqibqmOZRAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WG/IJ00fyEWlrOazOz5EFibH8msXoM/l2HD53EKBjWNHXeMpVXoNKMFSsgKrGsuTJVXZcItzKsS0gXpoyjJ/eiaRTm9yxZ7mP4W42xR3mQJC5xVvlqkLV954Y1vCGN6h5ppdVRL9xxHNbRr3zXPFLur8WTnqQoLVl8i+LwPGZ/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YiSt0GQK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YiSt0GQK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1E0F1F000E9;
	Tue, 25 Aug 2026 13:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665314;
	bh=O+90FlvgsUTBHGPQhOmtql++xFSj002vzxLHTzNt5uQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YiSt0GQKlzcLy1rFhOufVc0PIiS1KoTRYpoy5/K/Lajff5LVhezHT/CwyvB8w8UGg
	 b1meq1+iNaaZa8YsUJSKIpY3CjsnWK7sINem18D4yUq7hNsw55pHBBXzIlnrYLob3e
	 fl8M4l5A8QyxQis2PABjd9YVDQDhdoublVZiiwEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	"Xiang Mei (Microsoft)" <xmei5@asu.edu>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 72/94] xfrm: fix sk_dst_cache double-free in xfrm_user_policy()
Date: Tue, 25 Aug 2026 15:26:08 +0200
Message-ID: <20260825132544.702318552@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.887883084@linuxfoundation.org>
References: <20260825132541.887883084@linuxfoundation.org>
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
index b9049c2297bd5..f463c7bd5321d 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2975,7 +2975,7 @@ int xfrm_user_policy(struct sock *sk, int optname, sockptr_t optval, int optlen)
 	if (sockptr_is_null(optval) && !optlen) {
 		xfrm_sk_policy_insert(sk, XFRM_POLICY_IN, NULL);
 		xfrm_sk_policy_insert(sk, XFRM_POLICY_OUT, NULL);
-		__sk_dst_reset(sk);
+		sk_dst_reset(sk);
 		return 0;
 	}
 
@@ -3015,7 +3015,7 @@ int xfrm_user_policy(struct sock *sk, int optname, sockptr_t optval, int optlen)
 	if (err >= 0) {
 		xfrm_sk_policy_insert(sk, err, pol);
 		xfrm_pol_put(pol);
-		__sk_dst_reset(sk);
+		sk_dst_reset(sk);
 		err = 0;
 	}
 
-- 
2.53.0



