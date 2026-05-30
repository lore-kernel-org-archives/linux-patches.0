Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD0534104B;
	Sat, 30 May 2026 17:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163406; cv=none; b=f7HdCIxVMV1VkBoJlj8TtAuIOJoflNLFp8Z/4bpCVBtokoE3vVUTQihJyR3mB/IV/wPWtxr6c2B48tNpUTkMh9A+OedbAnpgKp9XBF7fTIywBnNKrU/VjAmMuX7Ycl9aAvPAbnQY4iMhDcu7R2giOgGiUEDzLj+Jo1KzXCp4cBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163406; c=relaxed/simple;
	bh=zNwBpnrJq+Cg5EfhA8KRzRLcVlI8R3rQL9ovlWEHT0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ozMDyV67F8+0WEM3pIEIk9CbG8aXMuj4TiChYB2iJ6JMyaI7UJuVK604hZ1GwUdJ5pQjX62zAcJVV9K1tHxVQsoPTKPTOO9tzgFgCdpf5/3waACbx8x6d8cV/ZiYh/3MHJYj2rBr7VFEA5aWRGh9E9dB0lWP/VTfhIftZSW/VIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EXhuv7aK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EXhuv7aK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F10E21F00893;
	Sat, 30 May 2026 17:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163405;
	bh=5BGV6UwswOOP4OY4Z8Xv8C1FBD0UwEqLHZfbIvaoqGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EXhuv7aKc5BT6VrliJagAY3bi+jcpQr4LMnx/x8Oxe3g6gxhsK+WqwOi5hcCRnplh
	 M6V8vcgUARXudC63q8NnFM2P07firXC1QeHGlptnP5eAFI2CA5LbqXgbLuzSwAOGv2
	 K7Z/RISbaLnkEUqptbBu5kBDesYwnU0UPuRG1lwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Zhenzhong Wu <jt26wzz@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 248/776] tcp: call sk_data_ready() after listener migration
Date: Sat, 30 May 2026 17:59:22 +0200
Message-ID: <20260530160246.941618292@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhenzhong Wu <jt26wzz@gmail.com>

commit 3864c6ba1e041bc75342353a70fa2a2c6f909923 upstream.

When inet_csk_listen_stop() migrates an established child socket from
a closing listener to another socket in the same SO_REUSEPORT group,
the target listener gets a new accept-queue entry via
inet_csk_reqsk_queue_add(), but that path never notifies the target
listener's waiters. A nonblocking accept() still works because it
checks the queue directly, but poll()/epoll_wait() waiters and
blocking accept() callers can also remain asleep indefinitely.

Call READ_ONCE(nsk->sk_data_ready)(nsk) after a successful migration
in inet_csk_listen_stop().

However, after inet_csk_reqsk_queue_add() succeeds, the ref acquired
in reuseport_migrate_sock() is effectively transferred to
nreq->rsk_listener. Another CPU can then dequeue nreq via accept()
or listener shutdown, hit reqsk_put(), and drop that listener ref.
Since listeners are SOCK_RCU_FREE, wrap the post-queue_add()
dereferences of nsk in rcu_read_lock()/rcu_read_unlock(), which also
covers the existing sock_net(nsk) access in that path.

The reqsk_timer_handler() path does not need the same changes for two
reasons: half-open requests become readable only after the final ACK,
where tcp_child_process() already wakes the listener; and once nreq is
visible via inet_ehash_insert(), the success path no longer touches
nsk directly.

Fixes: 54b92e841937 ("tcp: Migrate TCP_ESTABLISHED/TCP_SYN_RECV sockets in accept queues.")
Cc: stable@vger.kernel.org
Suggested-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Signed-off-by: Zhenzhong Wu <jt26wzz@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260422024554.130346-2-jt26wzz@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/inet_connection_sock.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -1251,16 +1251,19 @@ void inet_csk_listen_stop(struct sock *s
 			if (nreq) {
 				refcount_set(&nreq->rsk_refcnt, 1);
 
+				rcu_read_lock();
 				if (inet_csk_reqsk_queue_add(nsk, nreq, child)) {
 					__NET_INC_STATS(sock_net(nsk),
 							LINUX_MIB_TCPMIGRATEREQSUCCESS);
 					reqsk_migrate_reset(req);
+					READ_ONCE(nsk->sk_data_ready)(nsk);
 				} else {
 					__NET_INC_STATS(sock_net(nsk),
 							LINUX_MIB_TCPMIGRATEREQFAILURE);
 					reqsk_migrate_reset(nreq);
 					__reqsk_free(nreq);
 				}
+				rcu_read_unlock();
 
 				/* inet_csk_reqsk_queue_add() has already
 				 * called inet_child_forget() on failure case.


