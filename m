Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207215;
	b=hjNehrkHUI10WI5Czlvcj1hshQRi2vvogIHt+ZyZkCZM2aC1FVg8zFy14WyTgc2aZ7HA
	 UwDq92rWztT4wPyY1YBI+s/uQ+/CCXr1n+fIs0XCWO3dCsxTcyMWZ/qG7lXdwXsK3xdWV
	 RDhtMhoL67Myq3sTP5R2gTCYn+jC6pljZAAg0rlq2HYOZj0SK35J0ExTMf2nCfEcD5qf0
	 UZLWn992VfEiCZPsKi2r9LTaS6FuLqrRjaDQbe/S222pCH3TZYkh7ELGwtIe92amw+bgr
	 iBH5sLb4JL4lLQNMDGYrk2JD1SyzHrOIpIhe/tyvf9AbOx4fjQHKqtejmqz09KddBHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207215;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q61spLJSxwHP6TE9pxkNcYouElSMbrNMJR1XAk+7xCE=;
	b=TMXU/WeHuMme47qInmkBrs0mFKPgbLZayqRO+ge8YnLqIqD766HLX6JDgVh6edPXuUbl
	 Qz7APzsT0JeBgnL1BRXfp5WdhZgUNjXVcUg77qCUfBx/geFH+3KACdmxu7gyf8ETweS+2
	 q0czs4RiVJR5psUlF/wzwaTGnG1XCbsFWny3GC0HYLpe7EEuycsk401Z5u41LVepZ4wcT
	 HDogI1IfJFEpqM2BLKBiJPeidU6B+vzWMnjfxoyAMJwmzwNXy03Ukeb2sWY1SWOsOHAke
	 o474o7/yIsnEZGIPOez6NRUXVgBmsIs3DQJ3iuwMNtZpEJ1UN3BRnHa56qZRppn5AUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="zm2/rwRN";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6FF606A31D;
	Wed, 28 Oct 2026 17:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zm2/rwRN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE2C01F01825;
	Wed, 28 Oct 2026 17:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207215;
	bh=Q61spLJSxwHP6TE9pxkNcYouElSMbrNMJR1XAk+7xCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zm2/rwRNVf+6TsH6HFEln9blgt0GBgxfQkkoErpFYtjaxnFhZcF5bbAqPOysCkyuQ
	 LgJjzw6607FOgKz6u4/eDrI6go7C8iDtU9YjLM32rZKQ7FrEy2h1cB53LEDojshssV
	 P62FW9RS2aykPoIy8ynDiWSf4uGilbGYGx2ptAW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 28/88] io_uring/io-wq: dont exit with a creation pending
Date: Wed, 28 Oct 2026 17:59:36 +0100
Message-ID: <20261028165942.778033757@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.107695352@linuxfoundation.org>
References: <20261028165942.107695352@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

Commit e231d2e8f80d3649ecd3851b7f2abdfbe606c04b upstream.

A worker that is the last one to go to sleep while work is pending asks
for another worker. io_wq_dec_running() bumps ->nr_running on behalf of
the new worker and queues create_worker_cb() as task_work for the owner
of the io-wq. Until that has run, everybody else takes it that a worker
is running which is going to look after the work list: io_wq_enqueue()
doesn't create one, and other workers that go to sleep don't find
themselves to be the last.

If the worker that made the request exits, io_worker_exit() cancels the
task_work, and io_worker_cancel_cb() drops ->nr_running without a look at
the work list:

worker A                   worker B                 io_wq_enqueue()
blocks, work is pending
  nr_running++
  queues create_worker_cb()
wakes, handles the work
idle timeout, decides to exit
                           picks up work 1
                                                    queues work 2
                                                    B is on the free list
                                                    still: wakes B
                           work 1 blocks
                             nr_running 2 -> 1
io_worker_exit()
  io_worker_cancel_cb()
    nr_running 1 -> 0

Work 2 has to wait for work 1, although there is room for more workers.
It takes an owner that doesn't get around to run its task_work for the
time of the idle timeout, less if the worker exits because its affinity
was changed or the io-wq is marked exit-on-idle.

Let the worker stay around until its request has been dealt with. Only
the worker itself sets ->create_state, so it can't be set behind its
back once it has decided to leave.

Fixes: 1d5f5ea7cb7d ("io-wq: remove worker to owner tw dependency")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-12-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io-wq.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -756,9 +756,13 @@ static int io_wq_worker(void *data)
 		 * idle-exit, drop the worker as well. This is used to avoid
 		 * keeping io-wq workers around for tasks that no longer have
 		 * any active io_uring instances.
+		 * Not as long as a request of ours for another worker is
+		 * pending, though. It is accounted as a running worker, which
+		 * others rely on, and io_worker_exit() would cancel it.
 		 */
-		if ((last_timeout && (exit_mask || acct->nr_workers > 1)) ||
-		    test_bit(IO_WQ_BIT_EXIT_ON_IDLE, &wq->state)) {
+		if (((last_timeout && (exit_mask || acct->nr_workers > 1)) ||
+		     test_bit(IO_WQ_BIT_EXIT_ON_IDLE, &wq->state)) &&
+		    !test_bit(0, &worker->create_state)) {
 			acct->nr_workers--;
 			if (test_and_clear_bit(IO_WORKER_F_FREE, &worker->flags))
 				hlist_nulls_del_init_rcu(&worker->nulls_node);


