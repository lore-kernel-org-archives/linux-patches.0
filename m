Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6105A209695;
	Wed, 19 Mar 2025 14:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395232; cv=none; b=d2AYqpTssdgDloLxTnqpUYKCZL6yCSIF/hr1cKczyX0ymeQQCPMMrPS7d/tbdJU1yBlcKTyfIRRAq8EzXh7A4pFA1vGhNMxEkeDfmu6lF9lAWxo5eeImhP5dZ+KpnGQoi24YcK2isHoQ4LyAYSEYlGcB9se6rsM38DV8Q+eFyfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395232; c=relaxed/simple;
	bh=5wjBLUJnYgAhA2YgYs4dtot1FjwWEvnn36DOujLyd1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=auIJjN0xeQ3GKlLU1VW0cQjnUzStMV1lLKIReuqhLi12TybRGay1531x1sFEmlIekNHMw50snsplajgMGcCdBFoob3qkCmvSrIoBSLpfGgc7iSyGA4majMGuCQ1/LttYSV9QcuVxCzZn/2pq1XhxmGFzEtlQUQa/8YaaSEfSNbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yeONeDH/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yeONeDH/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3109CC4CEE4;
	Wed, 19 Mar 2025 14:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395232;
	bh=5wjBLUJnYgAhA2YgYs4dtot1FjwWEvnn36DOujLyd1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yeONeDH/M5LnYo71UU0wKspVF2UuSbE0iRiTDhxvmgcdEGw8UaVfKnpFumPEgZ4rv
	 /VhaoIHZuX6LgaVZwxLI+HAEgOm7jjsb1QNmA+nVhXDA+c9F+8kAa8JBEU5AXQsViq
	 nipg6G9V3cGcdufc4TS/G6gBZAmR5rHdu7BVqYXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2074b1a3d447915c6f1c@syzkaller.appspotmail.com,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 103/166] io_uring: fix error pbuf checking
Date: Wed, 19 Mar 2025 07:31:14 -0700
Message-ID: <20250319143022.806800517@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

Commit bcc87d978b834c298bbdd9c52454c5d0a946e97e upstream.

Syz reports a problem, which boils down to NULL vs IS_ERR inconsistent
error handling in io_alloc_pbuf_ring().

KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
RIP: 0010:__io_remove_buffers+0xac/0x700 io_uring/kbuf.c:341
Call Trace:
 <TASK>
 io_put_bl io_uring/kbuf.c:378 [inline]
 io_destroy_buffers+0x14e/0x490 io_uring/kbuf.c:392
 io_ring_ctx_free+0xa00/0x1070 io_uring/io_uring.c:2613
 io_ring_exit_work+0x80f/0x8a0 io_uring/io_uring.c:2844
 process_one_work kernel/workqueue.c:3231 [inline]
 process_scheduled_works+0xa2c/0x1830 kernel/workqueue.c:3312
 worker_thread+0x86d/0xd40 kernel/workqueue.c:3390
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Cc: stable@vger.kernel.org
Reported-by: syzbot+2074b1a3d447915c6f1c@syzkaller.appspotmail.com
Fixes: 87585b05757dc ("io_uring/kbuf: use vm_insert_pages() for mmap'ed pbuf ring")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/c5f9df20560bd9830401e8e48abc029e7cfd9f5e.1721329239.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/kbuf.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -510,8 +510,10 @@ static int io_alloc_pbuf_ring(struct io_
 	ring_size = reg->ring_entries * sizeof(struct io_uring_buf_ring);
 
 	bl->buf_ring = io_pages_map(&bl->buf_pages, &bl->buf_nr_pages, ring_size);
-	if (!bl->buf_ring)
+	if (IS_ERR(bl->buf_ring)) {
+		bl->buf_ring = NULL;
 		return -ENOMEM;
+	}
 	bl->is_mapped = 1;
 	bl->is_mmap = 1;
 	return 0;


