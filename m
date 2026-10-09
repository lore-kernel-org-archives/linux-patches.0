Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B61D24DBD62;
	Fri,  9 Oct 2026 14:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556162; cv=none; b=eqLtG+PcHTzRmVWk+grXCyClR0Hl7jqcqZ01/pw79a/utjiTKNr4yk/fd0UNQ4D+/v64534sywNikFAACHabCGjk4ykf7x9qS3RZql21pcXqhJukwfgPXcJ52BUWDOKPZJLTpP4PYpXUuiWDCJwr+Xu5sf25ma6hK/CZor/qIjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556162; c=relaxed/simple;
	bh=BqVH/u2gRI5coZzTsnYlHQjcsP1tUmaazuHD+u+QtOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s3VrvpuITC6cg0P3HzsWSdcNXaHbUdcFzj3Ygp1UmWOZxCrFjNNfe5woXzcunTGufGhJRm15FK1gLll8vUxI8MhwOLoHZszcuj/ikbiBdfHpgIQjRJ00dZoLKW/XrZS8KE1Lp9ZrxpTCWJEFmpC6UybdwMTbk+uArnh1rxADHbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pA4nfCxd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pA4nfCxd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1670F1F000FF;
	Fri,  9 Oct 2026 14:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556161;
	bh=DDnGWFn/YWJZ/sdldBBTljW/mP1YiPdBH9sAThf4XbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pA4nfCxdvrlI5wfhCV3ZWbwQL5gP8euPs90wtifm+EdcbwWai4MC9UwnXcSpEn+NG
	 FbNBYbK63JnGd7MR/d7uZN7kgPBSedxpZGr11YhVuOPaCkyTnDLKtYLCpEB2pOIqoU
	 4+0SlgL7/izTtPXF12QiHAo5BFd1kEoix795YK78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cai Xinchen <caixinchen1@huawei.com>,
	Eric Dumazet <edumazet@google.com>,
	Wei Wang <weiwan@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 130/428] net: restrict SO_RESERVE_MEM to TCP sockets and cap max value
Date: Fri,  9 Oct 2026 16:07:47 +0200
Message-ID: <20261009140949.040843297@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 4395509ab9dcd..e4503ea6fd0cf 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1034,7 +1034,7 @@ static int sock_reserve_memory(struct sock *sk, int bytes)
 	bool charged;
 	int pages;
 
-	if (!mem_cgroup_sk_enabled(sk) || !sk_has_account(sk))
+	if (!mem_cgroup_sk_enabled(sk) || !sk_is_tcp(sk))
 		return -EOPNOTSUPP;
 
 	if (!bytes)
@@ -1661,7 +1661,7 @@ int sk_setsockopt(struct sock *sk, int level, int optname,
 	{
 		int delta;
 
-		if (val < 0) {
+		if (val < 0 || val > SZ_1G) {
 			ret = -EINVAL;
 			break;
 		}
-- 
2.53.0



