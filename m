Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A4415C158;
	Sun,  7 Sep 2025 20:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277131; cv=none; b=VzWQ6ropBvCJLuoKuxJDkuUgu+QaBVQrOYLsj4js6UKbtpXL7kyTLmYnU8J6orFXlIj5BwFXIyj49Cl8wwxH4mZ+TeP6y1xgFqMWSHs9DVeLAKPkIeK4NXKEBJlLIDF/mnw3NddDjO926b71leQwh9+K9YyfGFfl9FptdQzCPj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277131; c=relaxed/simple;
	bh=3jLUxKBRlW7mCaRuuEqTOlnh1yDyKz1kIPl/O/l9vKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L7Ga8bJWPtFjQ3PAvcXaZHXKw5vPCVSiJ59PLw8AhAIoGpHJlQkrDF3+mw5UPdGwFYsJYRykbzOqdShSbKEpsLQIlV/JFj7x2Zfsudyk0FF1Pc42J1h6oOQZiDt5kG7RDYLOTQKBR11GOYmsD0A2t/NX+C25vW/G7/cMmbWu+sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cB2fxhrd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cB2fxhrd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D6A3C4CEF0;
	Sun,  7 Sep 2025 20:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277130;
	bh=3jLUxKBRlW7mCaRuuEqTOlnh1yDyKz1kIPl/O/l9vKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cB2fxhrdnGvn4pLcsvNkKTqUh2l9ADPe4k5S48cDwb5wrWErcr+czXrnAgLuaBR6b
	 cEQAbVZCvROa8tLba1kfo2n9ZOiehfBbtmIZo+nXEQX+DOvKlMogBdkoA11gK5NXT/
	 kRHV13dN5o0ty6xmTTOgPZ1nPildJQ9VJXAWO9rQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+54cbbfb4db9145d26fc2@syzkaller.appspotmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 096/175] io_uring/msg_ring: ensure io_kiocb freeing is deferred for RCU
Date: Sun,  7 Sep 2025 21:58:11 +0200
Message-ID: <20250907195617.117187904@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

Commit fc582cd26e888b0652bc1494f252329453fd3b23 upstream.

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
(cherry picked from commit fc582cd26e888b0652bc1494f252329453fd3b23)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/io_uring_types.h |   12 ++++++++++--
 io_uring/msg_ring.c            |    4 ++--
 2 files changed, 12 insertions(+), 4 deletions(-)

--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -646,8 +646,16 @@ struct io_kiocb {
 	atomic_t			refs;
 	bool				cancel_seq_set;
 	struct io_task_work		io_task_work;
-	/* for polled requests, i.e. IORING_OP_POLL_ADD and async armed poll */
-	struct hlist_node		hash_node;
+	union {
+		/*
+		 * for polled requests, i.e. IORING_OP_POLL_ADD and async armed
+		 * poll
+		 */
+		struct hlist_node	hash_node;
+
+		/* for private io_kiocb freeing */
+		struct rcu_head		rcu_head;
+	};
 	/* internal polling, see IORING_FEAT_FAST_POLL */
 	struct async_poll		*apoll;
 	/* opcode allocated if it needs to store data for async defer */
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
 
@@ -91,7 +91,7 @@ static int io_msg_remote_post(struct io_
 {
 	req->task = READ_ONCE(ctx->submitter_task);
 	if (!req->task) {
-		kmem_cache_free(req_cachep, req);
+		kfree_rcu(req, rcu_head);
 		return -EOWNERDEAD;
 	}
 	req->opcode = IORING_OP_NOP;


