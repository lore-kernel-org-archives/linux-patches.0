Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826850;
	b=rDqMRgyPX3PLKtaNtaD6T1pdMEjAO1cGJtjuwR68BmXp6TgFgzQsgRtvDy6vDarXuJlN
	 2L/+oLfstHx/8S+ulIS4uj6q9+UxE/bWGowbD/10w2cTdLhUOgKAep1hc5dz0vGpIqdUZ
	 +BbiaUP7AhN8SLHv4xQa8YP4oP4HZeucakoayY1ORwQ8yYtRoCGC2Y8cT66DT9gUDJK/I
	 XPYtCXOLxyv1Ah+hc7AmKKrCnoXDMCNwib2kk/i3R2yoBJ+JOcU8HdqS3bheCkjFby6+M
	 tijKYl+w3RVG5gnuB6pUaxU2fXJoeE//svnUk44yoaayse9wQXxERA4EdhZqfyKjyAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826850;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ctJUAvK+kWG3ZBE55sqOApMmvokJrwtUaJbtmH9vNQw=;
	b=B/inmuK2vhOfFfS61CX/e44k934kLZDon+ITG57YpMZxe2Tc+lHbfZ01+bTlIdaQgbn9
	 SHHnC1KEiPn8PUIpLX0XYUn5Pl99OUuQPBHGgQ1l7eMypioQt0juqqnrbvRsg26XeWugK
	 M+QqQ1V+TUVolq+7yoB38qlQSM+pF5erEtA5h0Emk5A2uD8+6JMoBOujilSxkKZMsu4rH
	 lCtGGAFwwXonzEoPbpmvuvLIjszj+BuTE4AxqBLrt2/xP9ydQ5Lje5OVCP3JzvsXzfjzv
	 r4afKjr0wS1Tzu3moukZS4Enxggv0n74LRQ6D/b/YMKRTDY74TudOlvY46A/QwUjWnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HpKLHKpW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C8E6070423;
	Wed,  4 Nov 2026 21:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HpKLHKpW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6251F1F00A02;
	Wed,  4 Nov 2026 21:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826849;
	bh=ctJUAvK+kWG3ZBE55sqOApMmvokJrwtUaJbtmH9vNQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HpKLHKpWfBeqbJcxolTwa15xYv164m8Ong6d+lGs/Pf+3T3/Vc9UA4i3/aSZa2GE0
	 Y8YEAfyQK4y9begc2qGxEFRSHiPTmMyjpPdE3kGvLdpKKD9nVl30bFuE5qZJluS+ll
	 Xruk6caEXZGzx8qtPT3Da8EKNP1l/HEF9wGQdmvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 017/547] io_uring/waitid: own the request before clearing ->head
Date: Wed,  4 Nov 2026 16:03:21 -0500
Message-ID: <20261104211038.863859886@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit c254eec4364b9f4b4cbdce43be3fb4df5a651a70 ]

io_waitid_remove_wq() only takes the wait queue lock if ->head is set.
io_waitid_wait() clears ->head first thing, before it tries to become the
owner of the request by bumping ->refs. If somebody else owns the request
at that point, nothing keeps it from completing the request while the
wake up handler is still going to touch it:

CPU0 (io_waitid_wait)                 CPU1 (io_waitid, holds a ref)
list_del_init(&wait->entry)
smp_store_release(&iw->head, NULL)
                                      __do_wait() finds another child
                                      io_waitid_remove_wq()
                                        // ->head == NULL, no locking
                                      io_waitid_finish(), IOU_COMPLETE
                                      // request freed and reused
atomic_fetch_inc(&iw->refs)

The same goes for __io_waitid_cancel() if it claims the request in that
window. ->refs is part of the per opcode data of the request, so this
increments whatever the next user of the request keeps there. If that
happens to be zero, the handler concludes that it owns the request, and
queues io_waitid_cb() for it. With the window held open by a delay, and
the request reused for a receive that is waiting for data:

  BUG: KASAN: slab-use-after-free in __wake_up_common+0x1ca/0x1f0
   __wake_up_sync_key+0x36/0x50
   sock_def_readable+0xf1/0x420
   unix_stream_sendmsg+0x60b/0x1110
  Allocated by task 87:
   io_arm_apoll+0x1ed/0x940
  Freed by task 87:
   __io_submit_flush_completions+0x118d/0x1a10
   tctx_task_work_run+0x327/0x950

Only clear ->head once the handler owns the request. If it doesn't, the
owner finds ->head set and has to wait for the lock, which is held by the
caller of the handler. Deleting the already deleted entry again is
harmless.

Fixes: ab673c1bcaf2 ("io_uring/waitid: use io_waitid_remove_wq() consistently")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-1-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/waitid.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/io_uring/waitid.c b/io_uring/waitid.c
index 9ad8eadc5b8f7..f9211446efd44 100644
--- a/io_uring/waitid.c
+++ b/io_uring/waitid.c
@@ -268,12 +268,18 @@ static int io_waitid_wait(struct wait_queue_entry *wait, unsigned mode,
 		return 0;
 
 	list_del_init(&wait->entry);
-	smp_store_release(&iw->head, NULL);
 
-	/* cancel is in progress */
+	/*
+	 * Cancel or issue is in progress. Leave ->head alone, so that whoever
+	 * owns the request has to take the wait queue lock, which we hold,
+	 * before it can complete and free it.
+	 */
 	if (atomic_fetch_inc(&iw->refs) & IO_WAITID_REF_MASK)
 		return 1;
 
+	/* pairs with the smp_load_acquire() in io_waitid_remove_wq() */
+	smp_store_release(&iw->head, NULL);
+
 	req->io_task_work.func = io_waitid_cb;
 	__io_req_task_work_add(req, IOU_F_TWQ_IN_WAKE);
 	return 1;
-- 
2.53.0



