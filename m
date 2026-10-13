Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CB231F91F6;
	Tue, 13 Oct 2026 12:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894960; cv=none; b=JqjVxm8PNws5WQg3BFzb9Z1Zl7jhWgzWvzIklY2WEnyNrlcCb2ezezPePdJtJCt2UO20Y+Y754GIC1FLlg7DeXDKjqAcCBqBBNVgIJbP8Qs7MgVzDZhp3TkUZ2QFbVPfTEg+879m9aP7WmVnrZZL3X2R5sD2Y1XXfSXCd2spWDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894960; c=relaxed/simple;
	bh=pgm8dVMmQk1Nos7VWm8yUAFd0ETSvvDvIIJTLD2dVT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DMMvxW4tDs9EE0Yk/lLqcBXLCH43AJXxdd3wIFhY2VXHdqMvnnmZJocyYDlCTYbKZaS86zN029HL6B0Kbe0B44MIdrH9LFyqhtXSUFdAgrFwtF2/8WhfJsMuDOd5nZYaTIEDIma3YVE6hG6VHdLZ5O10QPCqS6ibxStRogThkk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nMvLPmm6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nMvLPmm6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D28241F000FF;
	Tue, 13 Oct 2026 12:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894959;
	bh=x3Co2ZVf3Sjf0XNdj/iwB0czN0+uBpKuS9MsdQAjuds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nMvLPmm60/zPtCs/9PUjKE7k8IVJHmxJbx2ft7GVRZbLepWQIDzHp+LnY12tQeM+f
	 EtLIK300tU/mg1ryDw9x0xIvowXcWDjDqCUDlw9ci3lPxkC4hma5TaqTfaBciqyc1t
	 iw+XW2A67YZ4e5+j+GrATLzQ+FEPbenbGa5vhBMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cai Xinchen <caixinchen1@huawei.com>,
	Eric Dumazet <edumazet@google.com>,
	Wei Wang <weiwan@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 087/497] net: restrict SO_RESERVE_MEM to TCP sockets and cap max value
Date: Tue, 13 Oct 2026 13:34:14 +0200
Message-ID: <20261013112909.953156615@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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
index 5790d18ef2348..75db38fdfd35f 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1016,7 +1016,7 @@ static int sock_reserve_memory(struct sock *sk, int bytes)
 	bool charged;
 	int pages;
 
-	if (!mem_cgroup_sk_enabled(sk) || !sk_has_account(sk))
+	if (!mem_cgroup_sk_enabled(sk) || !sk_is_tcp(sk))
 		return -EOPNOTSUPP;
 
 	if (!bytes)
@@ -1619,7 +1619,7 @@ int sk_setsockopt(struct sock *sk, int level, int optname,
 	{
 		int delta;
 
-		if (val < 0) {
+		if (val < 0 || val > SZ_1G) {
 			ret = -EINVAL;
 			break;
 		}
-- 
2.53.0



