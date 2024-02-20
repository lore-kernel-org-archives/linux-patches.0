Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FCDB151CCC;
	Tue, 20 Feb 2024 21:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464182; cv=none; b=qY8zlpwkj8oE8IN8D+qnmAZRxJz7qYHoqkheJJXZUx8/vIi3xPjvcNUZcTeqRKWEoPHL8eCr5ES3ResZa3LkKIwbrN1JcbByGorAtYpLm9CAgKALaxJDxZ1s0UeOZ79obBe9RUUu6ZSc2gxz9oVK1FFpP/rdQglW1m2peL8E5EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464182; c=relaxed/simple;
	bh=jpru4Hr85FyPk+uGqq/3X/3d9H+ZtS/GGAcPOvQPx0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dstjFdW9V7dOEQnQ1jXBE1oFe/UYe5WQlxKL2m2Z2bbZxuK0Aw/EOye7X9t99/N5415QNYs9FeLoDTBjPa7zYOkFHliDlZK5MDroVK/2hivLc1vzW7iHNbFf6G4/eZK9eCGwe7h9qX8v+t7kGBKQVK0piVDQytPMRzT0cdbTd1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q2K1fvL1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q2K1fvL1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A49DFC433F1;
	Tue, 20 Feb 2024 21:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464182;
	bh=jpru4Hr85FyPk+uGqq/3X/3d9H+ZtS/GGAcPOvQPx0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q2K1fvL1Qq42IxdCetaAea0vX737kmE0QAI3IndQFW1SsbOdJ9J9/+V4C73BMKCm+
	 1Aox4ext50spQLVXoYbbKvEhEdoyves7hsP/n5BT7PgOnVKdK5hYbMb40wnWKo4x00
	 Yynx+ItwPeL1jXZVOCiYjECopPv1T3KrazmIp+2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sili Luo <rootlab@huawei.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.6 248/331] can: j1939: Fix UAF in j1939_sk_match_filter during setsockopt(SO_J1939_FILTER)
Date: Tue, 20 Feb 2024 21:56:04 +0100
Message-ID: <20240220205645.617844308@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Oleksij Rempel <o.rempel@pengutronix.de>

commit efe7cf828039aedb297c1f9920b638fffee6aabc upstream.

Lock jsk->sk to prevent UAF when setsockopt(..., SO_J1939_FILTER, ...)
modifies jsk->filters while receiving packets.

Following trace was seen on affected system:
 ==================================================================
 BUG: KASAN: slab-use-after-free in j1939_sk_recv_match_one+0x1af/0x2d0 [can_j1939]
 Read of size 4 at addr ffff888012144014 by task j1939/350

 CPU: 0 PID: 350 Comm: j1939 Tainted: G        W  OE      6.5.0-rc5 #1
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
 Call Trace:
  print_report+0xd3/0x620
  ? kasan_complete_mode_report_info+0x7d/0x200
  ? j1939_sk_recv_match_one+0x1af/0x2d0 [can_j1939]
  kasan_report+0xc2/0x100
  ? j1939_sk_recv_match_one+0x1af/0x2d0 [can_j1939]
  __asan_load4+0x84/0xb0
  j1939_sk_recv_match_one+0x1af/0x2d0 [can_j1939]
  j1939_sk_recv+0x20b/0x320 [can_j1939]
  ? __kasan_check_write+0x18/0x20
  ? __pfx_j1939_sk_recv+0x10/0x10 [can_j1939]
  ? j1939_simple_recv+0x69/0x280 [can_j1939]
  ? j1939_ac_recv+0x5e/0x310 [can_j1939]
  j1939_can_recv+0x43f/0x580 [can_j1939]
  ? __pfx_j1939_can_recv+0x10/0x10 [can_j1939]
  ? raw_rcv+0x42/0x3c0 [can_raw]
  ? __pfx_j1939_can_recv+0x10/0x10 [can_j1939]
  can_rcv_filter+0x11f/0x350 [can]
  can_receive+0x12f/0x190 [can]
  ? __pfx_can_rcv+0x10/0x10 [can]
  can_rcv+0xdd/0x130 [can]
  ? __pfx_can_rcv+0x10/0x10 [can]
  __netif_receive_skb_one_core+0x13d/0x150
  ? __pfx___netif_receive_skb_one_core+0x10/0x10
  ? __kasan_check_write+0x18/0x20
  ? _raw_spin_lock_irq+0x8c/0xe0
  __netif_receive_skb+0x23/0xb0
  process_backlog+0x107/0x260
  __napi_poll+0x69/0x310
  net_rx_action+0x2a1/0x580
  ? __pfx_net_rx_action+0x10/0x10
  ? __pfx__raw_spin_lock+0x10/0x10
  ? handle_irq_event+0x7d/0xa0
  __do_softirq+0xf3/0x3f8
  do_softirq+0x53/0x80
  </IRQ>
  <TASK>
  __local_bh_enable_ip+0x6e/0x70
  netif_rx+0x16b/0x180
  can_send+0x32b/0x520 [can]
  ? __pfx_can_send+0x10/0x10 [can]
  ? __check_object_size+0x299/0x410
  raw_sendmsg+0x572/0x6d0 [can_raw]
  ? __pfx_raw_sendmsg+0x10/0x10 [can_raw]
  ? apparmor_socket_sendmsg+0x2f/0x40
  ? __pfx_raw_sendmsg+0x10/0x10 [can_raw]
  sock_sendmsg+0xef/0x100
  sock_write_iter+0x162/0x220
  ? __pfx_sock_write_iter+0x10/0x10
  ? __rtnl_unlock+0x47/0x80
  ? security_file_permission+0x54/0x320
  vfs_write+0x6ba/0x750
  ? __pfx_vfs_write+0x10/0x10
  ? __fget_light+0x1ca/0x1f0
  ? __rcu_read_unlock+0x5b/0x280
  ksys_write+0x143/0x170
  ? __pfx_ksys_write+0x10/0x10
  ? __kasan_check_read+0x15/0x20
  ? fpregs_assert_state_consistent+0x62/0x70
  __x64_sys_write+0x47/0x60
  do_syscall_64+0x60/0x90
  ? do_syscall_64+0x6d/0x90
  ? irqentry_exit+0x3f/0x50
  ? exc_page_fault+0x79/0xf0
  entry_SYSCALL_64_after_hwframe+0x6e/0xd8

 Allocated by task 348:
  kasan_save_stack+0x2a/0x50
  kasan_set_track+0x29/0x40
  kasan_save_alloc_info+0x1f/0x30
  __kasan_kmalloc+0xb5/0xc0
  __kmalloc_node_track_caller+0x67/0x160
  j1939_sk_setsockopt+0x284/0x450 [can_j1939]
  __sys_setsockopt+0x15c/0x2f0
  __x64_sys_setsockopt+0x6b/0x80
  do_syscall_64+0x60/0x90
  entry_SYSCALL_64_after_hwframe+0x6e/0xd8

 Freed by task 349:
  kasan_save_stack+0x2a/0x50
  kasan_set_track+0x29/0x40
  kasan_save_free_info+0x2f/0x50
  __kasan_slab_free+0x12e/0x1c0
  __kmem_cache_free+0x1b9/0x380
  kfree+0x7a/0x120
  j1939_sk_setsockopt+0x3b2/0x450 [can_j1939]
  __sys_setsockopt+0x15c/0x2f0
  __x64_sys_setsockopt+0x6b/0x80
  do_syscall_64+0x60/0x90
  entry_SYSCALL_64_after_hwframe+0x6e/0xd8

Fixes: 9d71dd0c70099 ("can: add support of SAE J1939 protocol")
Reported-by: Sili Luo <rootlab@huawei.com>
Suggested-by: Sili Luo <rootlab@huawei.com>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: stable@vger.kernel.org
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://lore.kernel.org/all/20231020133814.383996-1-o.rempel@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/j1939/j1939-priv.h |    1 +
 net/can/j1939/socket.c     |   22 ++++++++++++++++++----
 2 files changed, 19 insertions(+), 4 deletions(-)

--- a/net/can/j1939/j1939-priv.h
+++ b/net/can/j1939/j1939-priv.h
@@ -301,6 +301,7 @@ struct j1939_sock {
 
 	int ifindex;
 	struct j1939_addr addr;
+	spinlock_t filters_lock;
 	struct j1939_filter *filters;
 	int nfilters;
 	pgn_t pgn_rx_filter;
--- a/net/can/j1939/socket.c
+++ b/net/can/j1939/socket.c
@@ -262,12 +262,17 @@ static bool j1939_sk_match_dst(struct j1
 static bool j1939_sk_match_filter(struct j1939_sock *jsk,
 				  const struct j1939_sk_buff_cb *skcb)
 {
-	const struct j1939_filter *f = jsk->filters;
-	int nfilter = jsk->nfilters;
+	const struct j1939_filter *f;
+	int nfilter;
+
+	spin_lock_bh(&jsk->filters_lock);
+
+	f = jsk->filters;
+	nfilter = jsk->nfilters;
 
 	if (!nfilter)
 		/* receive all when no filters are assigned */
-		return true;
+		goto filter_match_found;
 
 	for (; nfilter; ++f, --nfilter) {
 		if ((skcb->addr.pgn & f->pgn_mask) != f->pgn)
@@ -276,9 +281,15 @@ static bool j1939_sk_match_filter(struct
 			continue;
 		if ((skcb->addr.src_name & f->name_mask) != f->name)
 			continue;
-		return true;
+		goto filter_match_found;
 	}
+
+	spin_unlock_bh(&jsk->filters_lock);
 	return false;
+
+filter_match_found:
+	spin_unlock_bh(&jsk->filters_lock);
+	return true;
 }
 
 static bool j1939_sk_recv_match_one(struct j1939_sock *jsk,
@@ -401,6 +412,7 @@ static int j1939_sk_init(struct sock *sk
 	atomic_set(&jsk->skb_pending, 0);
 	spin_lock_init(&jsk->sk_session_queue_lock);
 	INIT_LIST_HEAD(&jsk->sk_session_queue);
+	spin_lock_init(&jsk->filters_lock);
 
 	/* j1939_sk_sock_destruct() depends on SOCK_RCU_FREE flag */
 	sock_set_flag(sk, SOCK_RCU_FREE);
@@ -703,9 +715,11 @@ static int j1939_sk_setsockopt(struct so
 		}
 
 		lock_sock(&jsk->sk);
+		spin_lock_bh(&jsk->filters_lock);
 		ofilters = jsk->filters;
 		jsk->filters = filters;
 		jsk->nfilters = count;
+		spin_unlock_bh(&jsk->filters_lock);
 		release_sock(&jsk->sk);
 		kfree(ofilters);
 		return 0;


