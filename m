Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A353E0C7C;
	Mon,  4 May 2026 14:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904716; cv=none; b=oksOklgdEivIcb2WnRPaHzHgofJGGIo4dW7+jbt90RG4KAvTE2GzGq0d4+D7QTb07E4MgK7Sn4u4gnqtTR4Js/e3hY4AfvHC+j3gIM79JPv22kosFex8JfTdzlov6gjFmrMiryqo+/Yb/K5gVZUt0DMGHDzEYWWTOHAqmI2d40A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904716; c=relaxed/simple;
	bh=c6CXzDWKiroBIwxkt9DE55MuIPaYnIGyU06EzMQkFGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WLkgiqkOkOVZwfYFC32WwCxmOqJayrump2rEVQ6BmWnYOCS6pJ/kFer3zMb28k5BlbRQdID4pHZUkJYalVFg3r/vLkHnwaSRXjWrtE2RyNnsK56UkzfNA8FjLoDOg//BtGbBonqoAxyJ4g4Uar1Mft0DmjaRcIAmAccVk+OpXlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bvfp6g5i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bvfp6g5i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BA63C2BCB8;
	Mon,  4 May 2026 14:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904715;
	bh=c6CXzDWKiroBIwxkt9DE55MuIPaYnIGyU06EzMQkFGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bvfp6g5iceyXPkhR3fegNbjmRhSKMId2ywFPbRhikGB2qy+g1LJpNcZ9oNfPTBGKs
	 5OfGjFUMwTA00M1BhfYwA/85smwWj99yBg9Gx9nFF9wY9cz/lncrly6KgTsUGB4ncQ
	 O6kwIhsTN149wkre11x1fB8BEwtDMu6QCV1jvJWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Zhenzhong Wu <jt26wzz@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 147/215] tcp: call sk_data_ready() after listener migration
Date: Mon,  4 May 2026 15:52:46 +0200
Message-ID: <20260504135135.535632679@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1486,16 +1486,19 @@ void inet_csk_listen_stop(struct sock *s
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


