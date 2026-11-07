Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063740;
	b=Vu789bDSFGrtMD37vL8b+diNdhZpA5eQ3pMxqERxPNFv4DfbjtL9gqjLHhLQ4YSjmFLV
	 8eH/Q4yOxjwvAmk3VCY0ZowqC2lWGP45tgmu6iQZ96qhpatyIGlS2Df+vBVSGdW49G7PO
	 KKS2oJEvgs+jnEf8OCRpQW0b8tDjZRhBalUaVGqbzBda4f8O0K4cO8u5ZSG8CvlbKlo1G
	 ra9D1/fGZ7LQhxPdvIysoDw5ykCiCQnWfkyoEx+vIBiquSNMOBL173B1L2/DY1soGH1qz
	 fOFJDM2g8CKl+59bcOnElnYssMX/JCcpZB9xa/453vOmAGLQt9M+9a2k9MzcSKt9Itw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063740;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5xSw3MTQoQIfXdmyb8v8wq6J6wQCuDalL0TDXSnX0sg=;
	b=cOe18QFzP1nwuyV6tSrQbafCXqZ5RjbpvQxKN00dFq02Y8eylEdpCplOJCYhI5fZN+56
	 qxYAfmf1J+M7ONTX0+ar0FBSmM6Qkn7Q9CHXj7MlVMxuMy34+ajjDkITuR/iXyifrHW7i
	 OQ86oPE/R1LrYX5vCAstzLZQ8Sy/qLHex1hbJtvcdprbY0HtgBeBv/gRqZhlzjyTDuCZY
	 JDxp/JMCdljonuhdnvL6td6ng25sjud7Ps9t1MabcUyU9DbL4lhFT7hbttG06HEY8FAVx
	 9dOrFBtD2O7r19y+0Pj28q2DSi2OFkTjXHU9WkPReed4dFUjzWo7R/2ty9hAvr7yyQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="mTtPWy/m";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F878606A32D;
	Sat,  7 Nov 2026 15:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mTtPWy/m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D9601F0089F;
	Sat,  7 Nov 2026 15:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063740;
	bh=5xSw3MTQoQIfXdmyb8v8wq6J6wQCuDalL0TDXSnX0sg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mTtPWy/mezQUVYZHVncp71FFPzjO1OXAg2qL6uYwmcCBprs1B9kmAiRpjUmYOSA1E
	 LQKYgaQtcptLvbwHnN2Q/EuvZNH1ob39rFXKsEP+EJh3lAMFBTWtif7J5UjA0RJGao
	 60fnsEfVj15rydTCBfCncM6u7SrtK4jQlGUeQORQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seiji Nishikawa <snishika@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 835/869] nvme-tcp: fix io_work priority inversion when send_mutex is held
Date: Sat,  7 Nov 2026 08:58:37 -0500
Message-ID: <20261107134921.209535330@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 5d7581a1dc41d..94495b0228714 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1450,9 +1450,11 @@ static void nvme_tcp_io_work(struct work_struct *w)
 
 	do {
 		bool pending = false;
+		bool got_send_mutex = false;
 		int result;
 
 		if (mutex_trylock(&queue->send_mutex)) {
+			got_send_mutex = true;
 			result = nvme_tcp_try_send(queue);
 			mutex_unlock(&queue->send_mutex);
 			if (result > 0)
@@ -1467,8 +1469,13 @@ static void nvme_tcp_io_work(struct work_struct *w)
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



