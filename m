Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065589;
	b=4HC3/Py8LurA6W0s5MeJLcV3Cl+Du+/kgtMF6JuHpMId1PYYZEMlfC9uPANzrvIt+qvl
	 NqWWfIJUNpMZfG2bAIUqlZBD5ZPy8Au2bkvGphBKSVb+KTjPEp2IUgYGcrSeOrP0hKMp6
	 YPf+JJm1zjDhgxeVesG8Je8yhKFwog0uNu6tlKOp3U4xMZVa5b+J8+A0ttOSTTj5iLP6F
	 7Ws+hNVtsBOE5U6EUkqGMMonoFlsZLMGcf0V3vgoi+yjUeM/ZKHamHGiPyQ1CC8ujwZ+0
	 FsQu8ahxB6pEdbJ2JoDIp/ywlihbAa2WagRJyeiQq1jer+QXZdkIQSmLyISSM1HxEGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065589;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h/VY2C7/DETMQYCNolJLxw9YQHOf+Qo8Mtl+kKEl+Nw=;
	b=REznkbG3j2StP08HHr8j7ZVmOJbv9BOpyPNscA+UVvoeoiEXGirj+hUSu+97O0ER3XPY
	 nquoJ1CHrNeBtOqFYIqoJPik4VyIO/zlMdoZVHSbgTAwJAPcFmVCdKzmYK15RkdgYama+
	 4e8g3JO/0QmbLg/mZIx2Qmlvh+fiW4tkczRGTuXy3bdiRN/GwW9VODfeBMjSU6C2/VWAy
	 FuUP3XWEaR3hzKyy99kjrkSluptuzJugUkGoiTkjm4J9SwLDwIDYZpCSnWGtCKGnWAMi1
	 NAWRi77mtLRuOaXC9Kg38Mg9IMD4Q08yWocfnLylTYQvpui5PWSwfTk9dG4VKLsPRQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cYJdAA3l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E4C606A32C;
	Sat,  7 Nov 2026 15:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cYJdAA3l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D2C01F0089F;
	Sat,  7 Nov 2026 15:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065588;
	bh=h/VY2C7/DETMQYCNolJLxw9YQHOf+Qo8Mtl+kKEl+Nw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cYJdAA3lrHkkZZbN9CFfmvDIAhhNHOlOQf0eXXWvrsnee7Iid4NndyqOdFWKTURNg
	 u/+n6fEBSLVcVcTHra8ucplOpwvcgiZCCkaCr3yl+aSJ3n8xtCuQuKh/AbWt9CYHu1
	 lcreZmZETRYy/po3XeAwdW9SsL+4CSRmtTuQyYbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seiji Nishikawa <snishika@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1209/1257] nvme-tcp: fix io_work priority inversion when send_mutex is held
Date: Sat,  7 Nov 2026 08:58:25 -0500
Message-ID: <20261107135012.736841370@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Seiji Nishikawa <snishika@redhat.com>

[ Upstream commit 5db358f3a7f9c33717622c1597d15c4c91997b19 ]

Commit f42d4796ee10 ("nvme-tcp: fix I/O stalls on congested sockets")
added a check in nvme_tcp_io_work() that sets pending to true when the
queue has pending requests and the socket is writeable. The check is
placed after the mutex_trylock() block, so it also runs when
mutex_trylock(&queue->send_mutex) failed and io_work did not send
anything.

When .queue_rq sends a request directly from its own context, it holds
send_mutex and can give up the CPU in lock_sock_nested() when another
task needs the CPU, for example the io_work kworker of the same queue,
which runs on the same CPU. Then io_work cannot take send_mutex, but
the requests are still on req_list and the socket is writeable, so
pending is set to true. io_work loops until the deadline and queues
itself again on io_cpu, without sleeping.

This is a priority inversion. io_work runs on the high priority
nvme_tcp_wq and cannot make progress until send_mutex is released, but
it keeps running. The task holding send_mutex runs at normal priority
and needs the CPU to release it. The scheduler keeps giving the CPU to
io_work, so the task holding send_mutex may not run again, and the
requests on the queue are not sent and time out.

This is the same problem that commit 70f437fb4395 ("nvme-tcp: fix
io_work priority inversion") fixed. That commit removed
"pending = !llist_empty(&queue->req_list)" from the path where
mutex_trylock() fails, and let the task holding send_mutex queue
io_work again in nvme_tcp_queue_request() after it releases the mutex.
The new check brings back the same behavior in a different form.

Two things make this easier to hit. nvme_tcp_queue_request() sends
directly only when it runs on io_cpu, so the task that takes send_mutex
is on the same CPU as the io_work kworker of that queue when it takes
the mutex. Also, when the tasks are in a cgroup with the cpu controller
enabled, the whole group competes with the nice -20 kworker as one
entity, so each task in the group gets even less CPU time.

We hit this on a 6 CPU VM running a database on nvme-tcp storage. In
the vmcore, 2 tasks held send_mutex of 2 queues and were runnable in
lock_sock_nested() for 103 seconds, while the kworkers for those queues
kept running io_work on their CPUs. All database tasks were in one
cgroup, which got only about 0.3% of the CPU against the nice -20
kworker. Requests timed out, and blk_mq_timeout_work() waited in
synchronize_srcu() for the tasks still in .queue_rq.

Only do the pending check if io_work could take send_mutex. If it could
not, the task holding send_mutex sends what it can in
nvme_tcp_send_all(), and queues io_work again after it releases the
mutex if requests are still pending, so no request is left behind.

Fixes: f42d4796ee10 ("nvme-tcp: fix I/O stalls on congested sockets")
Cc: stable@vger.kernel.org # v6.16+
Signed-off-by: Seiji Nishikawa <snishika@redhat.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 129966ffeb9c5..54b49bc10dc34 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1446,9 +1446,11 @@ static void nvme_tcp_io_work(struct work_struct *w)
 
 	do {
 		bool pending = false;
+		bool got_send_mutex = false;
 		int result;
 
 		if (mutex_trylock(&queue->send_mutex)) {
+			got_send_mutex = true;
 			result = nvme_tcp_try_send(queue);
 			mutex_unlock(&queue->send_mutex);
 			if (result > 0)
@@ -1463,8 +1465,13 @@ static void nvme_tcp_io_work(struct work_struct *w)
 		else if (unlikely(result < 0))
 			return;
 
-		/* did we get some space after spending time in recv? */
-		if (nvme_tcp_queue_has_pending(queue) &&
+		/*
+		 * did we get some space after spending time in recv?
+		 * Only check this if we could take send_mutex. Otherwise
+		 * the task holding it sends the requests and queues io_work
+		 * again after it releases the mutex.
+		 */
+		if (got_send_mutex && nvme_tcp_queue_has_pending(queue) &&
 		    sk_stream_is_writeable(queue->sock->sk))
 			pending = true;
 
-- 
2.53.0



