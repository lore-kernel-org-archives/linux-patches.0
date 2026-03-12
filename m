Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93AA53242AC;
	Thu, 12 Mar 2026 20:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773347129; cv=none; b=PLcyZ8NH/ZSlhSAmnYqDo+WnqvP/ZTFaPDSW+3SHW9GCupJqygtm/m+xDCaLwaZXftcMbLoWEhIG8vyVDGJmcjNqqBTWuM661VuFbNUGQMkoXIYUXEF2Iv+7QC2HiYiHEfYKmyqZgWUv7SKOks+PSxqpT2bJJWkuy1y1Bj6D9AU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773347129; c=relaxed/simple;
	bh=AGbY+ec5GOXGCZ9hWggqCJ/ShoVblDKGpjx1hj8gNNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oVxJZ+oPHzpR4DDvKqYdUxo7bSw9jUEMVEcuj3CBA1LzjaURq0i8GojItLU/xnjjAsqZaVirTpYi3lJo4S4Ng92j3EdQiokm1+5ohqjoQvogB88Y/lpFGLiuAPWKF1prFFdxDjYTLtc+x/zmzsymvbbReO2YMXF1l2LUWGNDGhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tNEYFAZ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tNEYFAZ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F184C4CEF7;
	Thu, 12 Mar 2026 20:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773347129;
	bh=AGbY+ec5GOXGCZ9hWggqCJ/ShoVblDKGpjx1hj8gNNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tNEYFAZ8zueomDcRYV8CHOZMlhYXN/wiYE6tHgw4IhIE/u4zl298oZrJDm/IWNdLw
	 evuC8+EC4QreE8opKVVby3nKqKcu/E9WG7Ff4GF14M2dDesADM5Bx4uRPAHoWIdDpk
	 0+X3vXtQR3RC003OvA8VDtlnIYvImVipftCbrGRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2e2cf5331207053b8106@syzkaller.appspotmail.com,
	Allison Henderson <achender@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 211/265] net/rds: Fix circular locking dependency in rds_tcp_tune
Date: Thu, 12 Mar 2026 21:09:58 +0100
Message-ID: <20260312201025.941565451@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Allison Henderson <achender@kernel.org>

[ Upstream commit 6a877ececd6daa002a9a0002cd0fbca6592a9244 ]

syzbot reported a circular locking dependency in rds_tcp_tune() where
sk_net_refcnt_upgrade() is called while holding the socket lock:

======================================================
WARNING: possible circular locking dependency detected
======================================================
kworker/u10:8/15040 is trying to acquire lock:
ffffffff8e9aaf80 (fs_reclaim){+.+.}-{0:0},
at: __kmalloc_cache_noprof+0x4b/0x6f0

but task is already holding lock:
ffff88805a3c1ce0 (k-sk_lock-AF_INET6){+.+.}-{0:0},
at: rds_tcp_tune+0xd7/0x930

The issue occurs because sk_net_refcnt_upgrade() performs memory
allocation (via get_net_track() -> ref_tracker_alloc()) while the
socket lock is held, creating a circular dependency with fs_reclaim.

Fix this by moving sk_net_refcnt_upgrade() outside the socket lock
critical section. This is safe because the fields modified by the
sk_net_refcnt_upgrade() call (sk_net_refcnt, ns_tracker) are not
accessed by any concurrent code path at this point.

v2:
  - Corrected fixes tag
  - check patch line wrap nits
  - ai commentary nits

Reported-by: syzbot+2e2cf5331207053b8106@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=2e2cf5331207053b8106
Fixes: 3a58f13a881e ("net: rds: acquire refcount on TCP sockets")
Signed-off-by: Allison Henderson <achender@kernel.org>
Link: https://patch.msgid.link/20260227202336.167757-1-achender@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/tcp.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/rds/tcp.c b/net/rds/tcp.c
index 3cc2f303bf786..b66dfcc3efaa0 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -495,18 +495,24 @@ bool rds_tcp_tune(struct socket *sock)
 	struct rds_tcp_net *rtn;
 
 	tcp_sock_set_nodelay(sock->sk);
-	lock_sock(sk);
 	/* TCP timer functions might access net namespace even after
 	 * a process which created this net namespace terminated.
 	 */
 	if (!sk->sk_net_refcnt) {
-		if (!maybe_get_net(net)) {
-			release_sock(sk);
+		if (!maybe_get_net(net))
 			return false;
-		}
+		/*
+		 * sk_net_refcnt_upgrade() must be called before lock_sock()
+		 * because it does a GFP_KERNEL allocation, which can trigger
+		 * fs_reclaim and create a circular lock dependency with the
+		 * socket lock.  The fields it modifies (sk_net_refcnt,
+		 * ns_tracker) are not accessed by any concurrent code path
+		 * at this point.
+		 */
 		sk_net_refcnt_upgrade(sk);
 		put_net(net);
 	}
+	lock_sock(sk);
 	rtn = net_generic(net, rds_tcp_netid);
 	if (rtn->sndbuf_size > 0) {
 		sk->sk_sndbuf = rtn->sndbuf_size;
-- 
2.51.0



