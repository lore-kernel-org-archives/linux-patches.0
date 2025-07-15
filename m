Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48B812E498B;
	Tue, 15 Jul 2025 13:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586833; cv=none; b=DVPIKXXHXlyCz9al+xlys7HeldINPZbSXW9fW/So7I8cRWbHLCY2WNvKTrfq/Kqar6rssTvIfL8pSCfRc4KANJRG6ECC8detU1uxBTT6juEN5fIv0vXvzqLwz+WuviOsvU/B3W6zo3w6NeUBgvmQJ66kBSaokhOAgfFSjc2TcXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586833; c=relaxed/simple;
	bh=eL0CY1csAHfwSap++gtrqAZqmuopaLLy2I/OBAk4XTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IQv3m+tzWlE63rXG3ZIv/FBl2xQkgMw8HsvUj6GoZ55rx4YTsoCkpV7jX9/QnVk5rTuNvjeDTP59qGU39oGxKUNKwxYgKK2vi8mruasNiE6iV47jOzrQbPghLYDAUzEm5sHwWnAPrBbwZEoT6V8lZnETePqeQ8/uYUoXtvyvgjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FIps1ktP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FIps1ktP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B7DC4CEF1;
	Tue, 15 Jul 2025 13:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586833;
	bh=eL0CY1csAHfwSap++gtrqAZqmuopaLLy2I/OBAk4XTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FIps1ktPRrxFCkkZ4U1hBAboKa/nx4KyWh83TZzdbX7lHzQqzFCpIJkpVVS0vwMyf
	 LYHX1I534pMzt51TzYiTNhgEa6i+mbp0AuStcOsgfMtPuPT7UZQvkdhDiKq+2705rv
	 XVFjy8gU1WMocoMkcuYr4I+0EYtLwk/Eebu7qLRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+54cbbfb4db9145d26fc2@syzkaller.appspotmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.15 066/192] io_uring/msg_ring: ensure io_kiocb freeing is deferred for RCU
Date: Tue, 15 Jul 2025 15:12:41 +0200
Message-ID: <20250715130817.586486772@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit fc582cd26e888b0652bc1494f252329453fd3b23 upstream.

syzbot reports that defer/local task_work adding via msg_ring can hit
a request that has been freed:

CPU: 1 UID: 0 PID: 19356 Comm: iou-wrk-19354 Not tainted 6.16.0-rc4-syzkaller-00108-g17bbde2e1716 #0 PREEMPT(full)
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:408 [inline]
 print_report+0xd2/0x2b0 mm/kasan/report.c:521
 kasan_report+0x118/0x150 mm/kasan/report.c:634
 io_req_local_work_add io_uring/io_uring.c:1184 [inline]
 __io_req_task_work_add+0x589/0x950 io_uring/io_uring.c:1252
 io_msg_remote_post io_uring/msg_ring.c:103 [inline]
 io_msg_data_remote io_uring/msg_ring.c:133 [inline]
 __io_msg_ring_data+0x820/0xaa0 io_uring/msg_ring.c:151
 io_msg_ring_data io_uring/msg_ring.c:173 [inline]
 io_msg_ring+0x134/0xa00 io_uring/msg_ring.c:314
 __io_issue_sqe+0x17e/0x4b0 io_uring/io_uring.c:1739
 io_issue_sqe+0x165/0xfd0 io_uring/io_uring.c:1762
 io_wq_submit_work+0x6e9/0xb90 io_uring/io_uring.c:1874
 io_worker_handle_work+0x7cd/0x1180 io_uring/io-wq.c:642
 io_wq_worker+0x42f/0xeb0 io_uring/io-wq.c:696
 ret_from_fork+0x3fc/0x770 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

which is supposed to be safe with how requests are allocated. But msg
ring requests alloc and free on their own, and hence must defer freeing
to a sane time.

Add an rcu_head and use kfree_rcu() in both spots where requests are
freed. Only the one in io_msg_tw_complete() is strictly required as it
has been visible on the other ring, but use it consistently in the other
spot as well.

This should not cause any other issues outside of KASAN rightfully
complaining about it.

Link: https://lore.kernel.org/io-uring/686cd2ea.a00a0220.338033.0007.GAE@google.com/
Reported-by: syzbot+54cbbfb4db9145d26fc2@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Fixes: 0617bb500bfa ("io_uring/msg_ring: improve handling of target CQE posting")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/io_uring_types.h |    2 ++
 io_uring/msg_ring.c            |    4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -701,6 +701,8 @@ struct io_kiocb {
 		struct hlist_node	hash_node;
 		/* For IOPOLL setup queues, with hybrid polling */
 		u64                     iopoll_start;
+		/* for private io_kiocb freeing */
+		struct rcu_head		rcu_head;
 	};
 	/* internal polling, see IORING_FEAT_FAST_POLL */
 	struct async_poll		*apoll;
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -82,7 +82,7 @@ static void io_msg_tw_complete(struct io
 		spin_unlock(&ctx->msg_lock);
 	}
 	if (req)
-		kmem_cache_free(req_cachep, req);
+		kfree_rcu(req, rcu_head);
 	percpu_ref_put(&ctx->refs);
 }
 
@@ -90,7 +90,7 @@ static int io_msg_remote_post(struct io_
 			      int res, u32 cflags, u64 user_data)
 {
 	if (!READ_ONCE(ctx->submitter_task)) {
-		kmem_cache_free(req_cachep, req);
+		kfree_rcu(req, rcu_head);
 		return -EOWNERDEAD;
 	}
 	req->opcode = IORING_OP_NOP;


