Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB9D3389DE8;
	Tue, 10 Mar 2026 11:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142170; cv=none; b=ixmU6ncRh86RnyAmbv+kt862zSWA1BmVCsbBNvJdbq+kLcQE923ImTg0laHsduC+IWNnTSsjo02rXmixjxibKKe4GsCeOa3xIOQwC+rF+UfWcTQ6LLDCi4ScqnH1x5jeXayJiyw2fbufzDMq/q/KfFD3D4zxutb3Pq3jfmmuvJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142170; c=relaxed/simple;
	bh=xXjCCA3FdQ9RoF366iZKkj/s+p6BWouloAyVZgF0yws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ngVV6E1hIndrd84X55bcmfLMuYn3nN9T1itFC6zZR4ROgo9RDhKQeiM4aUrZGD9cOaMuoOxUJKbr1oK90B96xTycHGeFiHfAGaE5cOaKPeFWIf+WSVMrIfpkiuY4W+cI/Rth7QmyyR1nGOAHe9AnjoTy4BUj5E98JmTR+UeqKjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R/whardb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R/whardb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08FD4C2BC9E;
	Tue, 10 Mar 2026 11:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142170;
	bh=xXjCCA3FdQ9RoF366iZKkj/s+p6BWouloAyVZgF0yws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R/whardb66uIwmfc3DTrTVvWOmGTm5sFmy7KZiR4tubIT6L5y0dOgrWKD37mAGXrE
	 4WUkWkn6rSh3Rv1JQ5YCWErl0E3dUNTZvccvyuEstiKTrjr0VwoBgL1Byu2qH7ZthI
	 MHEIU8mbP2w4o7OoZUIsc+4OLW4ljlMixibNN+qMtLkAgEJF/NOt67UbWyvyItkbj6
	 /OwNH8nxb4seTW6KUAUTpgnhH9AX8maxUPHwfyy4A1NxEM7R9pzJtiHRDUx5O3Yicp
	 A/5ftZv2vvY01yQPQmNUcOb/lkURh8MkS7b8O64v2PcGyXpUiav0NEJ4j+OkBzT+h6
	 tUimav5SUKOAg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Allison Henderson <achender@kernel.org>,
	syzbot+2e2cf5331207053b8106@syzkaller.appspotmail.com,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 259/314] net/rds: Fix circular locking dependency in rds_tcp_tune
Date: Tue, 10 Mar 2026 07:18:38 -0400
Message-ID: <a09e5210129af175fd7548d993c13a1e62c27070.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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

