Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207949;
	b=DOYXl5X9ReYRk6F2tsz7Re2bVLmOt3isBg9xBudZsPhXAMbCTCP/84OIUGZ/vB13EkKp
	 N+dg5wHup7KUSwgmcgpnAqhGWKaoc0MfIo5lPY6ToQjbNFP9sf5UGaOfbuYL79c06CAna
	 nAkLBWPR/Ozkk9MDvMN+nRNhMUqgstQ7TZp9sPyFI24kHmr/wx9ITKapW+wHxm9Yelndu
	 xos1t1aV2PYPZGInmvVOk9onhZeNsRSHP50krlg7QXgLISEGGXIwhYd+8zJFVsOhSo+z9
	 ydr9NMDQ2X88C0vPJWjAjbVWiPmzIkKxPPk9yEDZQRRQYrSA8pjOMs2YSu8wGHW0YJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207949;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KtTwCFVW+20ltmNTwMz3I3rXcr6yv1gpMyAMp1nkKrg=;
	b=NwraAz66ZrF30dBSKTG0USgK27VjyVVOdlC/h1Yy7w0bpb4C5Prld1g7Tc+ac0sDnMWx
	 ATyezymD9Xav22+Vk+URq3eYPzyFtKAZTMUmPHgx3kWxdlxkW5TejsZo8ZwpzP/wFvwX2
	 nLWjuUlZJY6srz3Gbgzsso2ECPhgkzlhVq8cG9ADrhelWl1DYxZEK734vUuFo8LXjN3h6
	 o8jeWKmHdW5VbLwP6xln+KYpbyWqaCU37LJgJzg73GI0ZWDQUJKJVZ8ZLPx9cHvpHbbcf
	 8jmfaVktt+4xtAOFN2bEmL5jUVMEO4EyMbacR+HbSST30gl0bS7Sk05x9Z17V1s9EHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zj30vkMV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC80606A31D;
	Wed, 28 Oct 2026 17:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zj30vkMV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BBA51F01825;
	Wed, 28 Oct 2026 17:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207949;
	bh=KtTwCFVW+20ltmNTwMz3I3rXcr6yv1gpMyAMp1nkKrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zj30vkMVXnPTYd5n7Y/YXtwFAioJpikuaQXmqRsd2qTNgKju/gDjMUnwxzIFrRhNo
	 QXDt8nSkSI32+EiO1na7Jzb9jIO4TfBCWMe6QwMwWgD+z7fCFZe29FRj90Pp+hL7Do
	 aE8qlDJ+oEMPd/RNQIT1DnH2q6Jis2nCl7Xezrtg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 196/247] io_uring/io-wq: dont lose the signal that ends work
Date: Wed, 28 Oct 2026 17:59:59 +0100
Message-ID: <20261028165952.059212889@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

Commit 63c103279a95e82280092f2f4232e91e8117a252 upstream.

When a thread exits, only its tracked requests are cancelled. Then its
io-wq is torn down. io_wq_exit_workers() signals every worker, to get it
out of an interruptible sleep, and waits for all of them to exit. Before
they do, they go through the work that is left. Unbounded work is
cancelled. Bounded work is run, as it is expected to end by itself.

Not all of it does. An open has no file yet, so it counts as bounded, and
the open of a FIFO waits for the other end. That is what the signal is for.
But the workers are signalled once, and a worker that hasn't started the
work by then loses the signal:

  io_wq_exit_workers()               io_worker_handle_work()
    io_wq_worker_wake()
      set TIF_NOTIFY_SIGNAL
                                       io_assign_current_work()
                                         io_run_task_work()
                                           clear TIF_NOTIFY_SIGNAL
                                       io_wq_submit_work()
                                         fifo_open()
                                           wait_for_partner()
    wait_for_completion_timeout()

The thread never gets out of do_exit():

  IORING_OP_OPENAT of a FIFO without a writer, IOSQE_ASYNC
  exit of the thread that has submitted it

hangs in more than 9 of 10 attempts (4 CPUs, KVM), until the process is
killed.

Set TIF_NOTIFY_SIGNAL for bounded work that is started with IO_WQ_BIT_EXIT
set. The bit is set before the workers are signalled, and it is tested
after the flag has been cleared, with clear_notify_signal() providing the
barrier. So either the flag stays, or the bit is seen.

Work that is started while the io-wq exits is treated like work that is
being run at that time: it isn't interrupted unless it waits
interruptibly.

Fixes: afcc4015d1bf ("io-wq: provide an io_wq_put_and_exit() helper")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-4-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io-wq.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -598,9 +598,16 @@ static void io_worker_handle_work(struct
 
 			next_hashed = wq_next_work(work);
 
+			/*
+			 * io_wq_exit_workers() signals us once, so that we
+			 * don't sleep for ever. If that was before this work
+			 * became the current one, the signal is gone.
+			 */
 			if (do_kill &&
 			    (atomic_read(&work->flags) & IO_WQ_WORK_UNBOUND))
 				atomic_or(IO_WQ_WORK_CANCEL, &work->flags);
+			else if (do_kill)
+				set_notify_signal(current);
 			wq->do_work(work);
 			io_assign_current_work(worker, NULL);
 


