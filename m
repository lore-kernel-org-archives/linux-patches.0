Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E565233ADB0;
	Tue, 21 Jul 2026 19:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661353; cv=none; b=qCb+EDanyegxnWpZheUIJ6ilnfxtRxqGiGw3rbLSksLmYwudFgzMXKGCTmOVhP0iovG97w2TfFKyYABiSWU2EaND683BnVxCLkyGaYgjL2sAJhAiUS3pFLXFJMPhKUsEo+2Exvq5J9Ee2xsfWwDjvEjvZBKqBHyF4RdhmGAOZ+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661353; c=relaxed/simple;
	bh=QFMDXWVx6/BMDzAqILWjfevzCNJFTWoy0zSx3FZ12KE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SvQ7TUyqI6396aPjhx/wVT0xv2sSqnmhtpO8hhiPSV66Lnx4MgaKxoP28FjJhCwSmIGXJpdMwDp4Y0f8CqU/RIHwpsgg9ET3ptye4rqZ0gyqDrIW3ZrzTgz1kW4FCmaTyLnICa7Z+vukPC7dLublvsO/X7Cwh0XW092kwojkAWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DBYgSCtZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DBYgSCtZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FF591F000E9;
	Tue, 21 Jul 2026 19:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661351;
	bh=wYPH1FdyAXNb0kZPz6Cv4iGc5Ko9K6B7UOXJbLYCCjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DBYgSCtZvvJEQgUBnCnciY3Wy9bXrsslf+Vftx5CxHzWn5OflisPSrsRvKo1CU0WV
	 uo2Q8AuKHHyUo5TNFN/j4uAB/3lFC4I7+zG9Q7bHc+OdSwuHdn12iDVhym2aVK5w6o
	 5awi4lVWG+kS/UlVKx/wa5gRPspeMepUke6Y/pF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Heiko Stuebner <heiko.stuebner@cherry.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0033/1276] af_unix: Dont use skb_recv_datagram() in unix_stream_read_skb().
Date: Tue, 21 Jul 2026 17:07:56 +0200
Message-ID: <20260721152446.826101748@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit d0aac85449dec992bb8dc2503f2cb9e94ef436db ]

unix_stream_read_skb() calls skb_recv_datagram() with MSG_DONTWAIT,
which is mostly equivalent to sock_error(sk) + skb_dequeue().

In the following patch, we will add a new field to cache the number
of bytes in the receive queue.  Then, we want to avoid introducing
atomic ops in the fast path, so we will reuse the receive queue lock.

As a preparation for the change, let's not use skb_recv_datagram()
in unix_stream_read_skb().

Note that sock_error() is now moved out of the u->iolock mutex as
the mutex does not synchronise the peer's close() at all.

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20250702223606.1054680-4-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Heiko Stuebner <heiko.stuebner@cherry.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 39 ++++++++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 17 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index a18a4b0229707f..f1e81843c1b0bc 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2720,6 +2720,7 @@ static struct sk_buff *manage_oob(struct sk_buff *skb, struct sock *sk,
 
 static int unix_stream_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 {
+	struct sk_buff_head *queue = &sk->sk_receive_queue;
 	struct unix_sock *u = unix_sk(sk);
 	struct sk_buff *skb;
 	int err;
@@ -2727,30 +2728,34 @@ static int unix_stream_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 	if (unlikely(READ_ONCE(sk->sk_state) != TCP_ESTABLISHED))
 		return -ENOTCONN;
 
-	mutex_lock(&u->iolock);
-	skb = skb_recv_datagram(sk, MSG_DONTWAIT, &err);
-	mutex_unlock(&u->iolock);
-	if (!skb)
+	err = sock_error(sk);
+	if (err)
 		return err;
 
-#if IS_ENABLED(CONFIG_AF_UNIX_OOB)
-	if (unlikely(skb == READ_ONCE(u->oob_skb))) {
-		bool drop = false;
+	mutex_lock(&u->iolock);
+	spin_lock(&queue->lock);
 
-		spin_lock(&sk->sk_receive_queue.lock);
-		if (likely(skb == u->oob_skb)) {
-			WRITE_ONCE(u->oob_skb, NULL);
-			drop = true;
-		}
-		spin_unlock(&sk->sk_receive_queue.lock);
+	skb = __skb_dequeue(queue);
+	if (!skb) {
+		spin_unlock(&queue->lock);
+		mutex_unlock(&u->iolock);
+		return -EAGAIN;
+	}
 
-		if (drop) {
-			kfree_skb_reason(skb, SKB_DROP_REASON_UNIX_SKIP_OOB);
-			return -EAGAIN;
-		}
+#if IS_ENABLED(CONFIG_AF_UNIX_OOB)
+	if (skb == u->oob_skb) {
+		WRITE_ONCE(u->oob_skb, NULL);
+		spin_unlock(&queue->lock);
+		mutex_unlock(&u->iolock);
+
+		kfree_skb_reason(skb, SKB_DROP_REASON_UNIX_SKIP_OOB);
+		return -EAGAIN;
 	}
 #endif
 
+	spin_unlock(&queue->lock);
+	mutex_unlock(&u->iolock);
+
 	return recv_actor(sk, skb);
 }
 
-- 
2.53.0



