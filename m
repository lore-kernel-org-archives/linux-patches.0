Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A524E535E;
	Fri,  9 Oct 2026 14:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555712; cv=none; b=Gx4s3WVNvmPXe/AFH1qZ3H90fz/YHZHqoYW3eaLAJPemQ8uRlvWisuhIfBSBBSnGY0/k8MFT9zy0+apG9SGkZ0Wp9Uz8w/CSMdVvbxkKuHCRsRcFEUAnECSs9MSNWu+DcOmCrSd18HJep4S1BARVuZQOZDJmSmLxqC+8WU8skFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555712; c=relaxed/simple;
	bh=qNrIExy3zpYyc5DzShk09Gpq4tJx66jmUulOBzEGOmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pUAdjzywW3NRAebz4nz60RfveYbetu9OMYTIwc1KlwAVVmEVNSd0hsar/HwGrmeb8v/VcgLH5ZsAPp563Y99+zZVMxGvt1g2fw3v458+bGbXdRtoICnOp4IQlypxeWAceRYW7PUWjUFbkj99sq5Zo4sKo1Fa++x59dk+dj84g68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JwKHE1ut; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JwKHE1ut"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10E8A1F00893;
	Fri,  9 Oct 2026 14:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555710;
	bh=wBijhZ/Ir5W3yTNOQEvov+IIAkK6TfNKM0RmmY7LN24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JwKHE1utcjM2Pn8qF9qQPLc2V6rAMBH8GKO+ufszdkl933Dy5U1cvZXSDRCLPXSXT
	 opoa9EV638yLi8VNP5fGgE55ZYfFyENCc7wQn2Tw+CV0ApizbpqQNJpy1HGn2KH6lE
	 aIamif76oaVFmyxpSyuIQdyRv9T6ZIHrAWg+8H8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cai Xinchen <caixinchen1@huawei.com>,
	Eric Dumazet <edumazet@google.com>,
	Wei Wang <weiwan@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 103/403] net: restrict SO_RESERVE_MEM to TCP sockets and cap max value
Date: Fri,  9 Oct 2026 16:07:44 +0200
Message-ID: <20261009140954.494440595@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 37e02c42a00be692c06343e11779aadc45f45971 ]

Commit 2bb2f5fb21b0 ("net: add new socket option SO_RESERVE_MEM") and
commit d00c8ee31729 ("net: fix possible NULL deref in sock_reserve_memory")
only checked sk_has_account(sk), which is true for both TCP and UDP
sockets.

However, SO_RESERVE_MEM and sk_unused_reserved_mem() are currently only
supported by TCP:
- On UDP sockets, sk->sk_forward_alloc is protected by
  sk->sk_receive_queue.lock, whereas sock_reserve_memory() and
  sock_release_reserved_memory() only acquire lock_sock(sk). Concurrent
  UDP packet reception/release and setsockopt(SO_RESERVE_MEM) corrupt
  sk_forward_alloc and memcg accounting.
- udp_rmem_release() reclaims excess sk_forward_alloc without
  accounting for sk_unused_reserved_mem(sk).

Restrict sock_reserve_memory() to TCP sockets (sk_is_tcp(sk)) for now.
Supporting SO_RESERVE_MEM for UDP (acquiring sk_receive_queue.lock and
honoring sk_unused_reserved_mem() in udp_rmem_release()) can be done in
a future net-next series if needed.

In addition, reject val > SZ_1G with -EINVAL in
sk_setsockopt(SO_RESERVE_MEM). Without an upper bound, values near
INT_MAX cause sk_mem_pages(delta) and (pages << PAGE_SHIFT) to overflow
32-bit signed int, corrupting sk->sk_forward_alloc and
sk->sk_reserved_mem. Using a page-aligned cap (SZ_1G) ensures that the
page-rounded sk->sk_reserved_mem reported by getsockopt(SO_RESERVE_MEM)
can always be passed back to setsockopt(SO_RESERVE_MEM).

Fixes: 2bb2f5fb21b0 ("net: add new socket option SO_RESERVE_MEM")
Reported-by: Cai Xinchen <caixinchen1@huawei.com>
Closes: https://lore.kernel.org/netdev/5a88421d-10ef-4fca-9acb-85a27a3c1173@huawei.com/
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Wei Wang <weiwan@google.com>
Link: https://patch.msgid.link/20260925135244.3715196-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 0d5f167e6ce69..9031349d08c21 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1024,7 +1024,7 @@ static int sock_reserve_memory(struct sock *sk, int bytes)
 	bool charged;
 	int pages;
 
-	if (!mem_cgroup_sk_enabled(sk) || !sk_has_account(sk))
+	if (!mem_cgroup_sk_enabled(sk) || !sk_is_tcp(sk))
 		return -EOPNOTSUPP;
 
 	if (!bytes)
@@ -1645,7 +1645,7 @@ int sk_setsockopt(struct sock *sk, int level, int optname,
 	{
 		int delta;
 
-		if (val < 0) {
+		if (val < 0 || val > SZ_1G) {
 			ret = -EINVAL;
 			break;
 		}
-- 
2.53.0



