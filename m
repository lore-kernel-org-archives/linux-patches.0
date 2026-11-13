Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590847;
	b=urBVE9uZjsh2bxiE5MD8Kegib6O+tYesJcE7RjoU5U4AyYfkNNNH4Iya4SSQQwX+3cZr
	 j3YZn/PxvT3PmNT5ha4HUsSHY7mTsLo7S4xp51XqnHUasq+NDnBg3hTL1whtkOrYvpJPw
	 C8YBaVFBOt9RqwksMbofFvWYYY/KuzR1n1g/FtyNJ1/jSDhRO1l65u46ztGw3m/Xl5RbP
	 yGDUHLSritaTdHBynVScBFPJ1kdMgNjNkeGWruNxOPBzQu+xpPif4qKR/AbZTApznLlnO
	 XSNirTrVn3JM0D+huo9vYXH/W3GluPiom581nTzN/fZBV0sCic+me4FSMv/qUzdHaww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590847;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hpW/RKYW3iQvNj9/LrKo0DgS5EKlRA7hWl1stjPyzY0=;
	b=1wYFGG3EXKkw84hTKTUWCFfOJGn1rn4iAqqDLysgZhSd4wGrO1FCJlWJJUuzUEegjWrx
	 myp6gHR6z1Fx4eR5uJfzAQyOQ/DmAcLcdFMNK4G10Sb6kol3f7WNaslp38JSu71AjiSlQ
	 uolxXZEmEcGIPe4RykdThioQC8Eedui+4qd2QExIQ+fJuwsoLrQrquL4jb22nePZIUjXC
	 +GamIetnOzgrk6k9WZQ2a4kGIBaWPN3PWhaPgZlVaHFsL5VyVZWilUDeP0Pxu3ZbL/EMQ
	 kxE8USWJIewej7Ex1rAOVxImQ7hgKU2vOobvpXGwWaouHVs2lEVuCXlOlpUo8XDtSiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jTgtygni;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1DC606D490;
	Fri, 13 Nov 2026 17:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jTgtygni
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AA1E1F000C4;
	Fri, 13 Nov 2026 17:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590846;
	bh=hpW/RKYW3iQvNj9/LrKo0DgS5EKlRA7hWl1stjPyzY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jTgtygniKbr2l9xiXUiD2zdit2pwRw5E3cVyp2OZ8uDnoGUyt9tZ1rPN8B/DS0Ie5
	 0e+8Li9s1OxoCo1IZZuKUCfPi3MDaHQClVO5M5pZzP9Jh4JouFUhEqx03yq1IqKr0A
	 IJtd5iByif+3hGbCvroob7CKA47inNXcr+cA/Fhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seiji Nishikawa <snishika@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 047/670] nvme-tcp: fix io_work priority inversion when send_mutex is held
Date: Fri, 13 Nov 2026 10:43:31 -0500
Message-ID: <20261113153812.934167672@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
Signed-off-by: Seiji Nishikawa <snishika@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 67d02cfb47ec7..82cf9419a6be4 100644
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



