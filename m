Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD471339866;
	Thu, 28 May 2026 20:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000581; cv=none; b=M+8fBMObctCuXGQR6z4010ZeIgy5tkRO0JKaT9dduoo9aewEqhQmJB3KL2FPhAdXtIgZRQpLYssOPocExJ97rbE9Mr4crFFmQbIPpm5/f4mPtPyNuV9JyUikPGNZvrTWwWhyaG/sb1dfvp8/5K8Sd4ykHb7RyGd+OEaH0+kUFp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000581; c=relaxed/simple;
	bh=ZB2V8FBqYdPuqyYOG8CB7Rrqb19V5f+LBseirG1AhEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OVs2T0M1QwSJeAUCQT7mNIi9mG/ZLlh8KpPDToxS3LKsmH12jMY6wGwSNUSShqAZfNeEMQx3tKYEirG3pMVNISeB2r1pefDdSaZmkb5J5BMttTUWizesmV/uCwkZ1m0jLIC6Tgl2jsnXjhY19dEnQRiKpeQIeJ6HtyIelN8qfhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gj6lLht1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gj6lLht1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4775D1F000E9;
	Thu, 28 May 2026 20:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000579;
	bh=VtseP8hiz/zwcntRi/uO3UlQlkYvX5uMkdv9EPD53Fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gj6lLht1dqjSM+LLIsjZVsbrITgKZ25fssveWHFFA8o44hodfT5kIl9dZMNXwiwsM
	 s5L4BTyZyibIZGuB0FD8FGZjex9xFqqPSldgpHdo0CmmbprwZnUDyGVFozOLgqsR0H
	 RFBtZyAjeFYYrwJcS0d8vX5mjSGDlaKx57ENe0eo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 096/272] af_unix: Fix UAF read of tail->len in unix_stream_data_wait()
Date: Thu, 28 May 2026 21:47:50 +0200
Message-ID: <20260528194632.067001284@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

From: Jann Horn <jannh@google.com>

commit be309f8eae8b474a4a617eaae01324da996fc719 upstream.

unix_stream_data_wait() does skb_peek_tail(&sk->sk_receive_queue) without
holding any lock that prevents SKBs on that queue from being dequeued and
freed.
This has been the case since commit 79f632c71bea ("unix/stream: fix
peeking with an offset larger than data in queue").
The first consequence of this is that the pointer comparison
`tail != last` can be false even if `last` semantically refers to an
already-freed SKB while `tail` is a new SKB allocated at the same address;
which can cause unix_stream_data_wait() to wrongly keep blocking after new
data has arrived, but only in a weird scenario where a peeking recv() and
a normal recv() on the same socket are racing, which is probably not a
real problem.

But since commit 2b514574f7e8 ("net: af_unix: implement splice for stream
af_unix sockets"), `tail` is actually dereferenced, which can cause UAF in
the following race scenario (where test_setup() runs single-threaded,
and afterwards, test_thread1() and test_thread2() run concurrently in
two threads:
```
static int socks[2];
void test_setup(void) {
  socketpair(AF_UNIX, SOCK_STREAM, 0, socks);
  send(socks[1], "A", 1, 0);
  int peekoff = 1;
  setsockopt(socks[0], SOL_SOCKET, SO_PEEK_OFF, &peekoff, sizeof(peekoff));
}
void test_thread1(void) {
  char dummy;
  recv(socks[0], &dummy, 1, MSG_PEEK);
}
void test_thread2(void) {
  char dummy;
  recv(socks[0], &dummy, 1, 0);
  shutdown(socks[1], SHUT_WR);
}
```

when racing like this:
```
thread1                       thread2
unix_stream_read_generic
  mutex_lock(&u->iolock)
  skb_peek(&sk->sk_receive_queue)
  skb_peek_next(skb, &sk->sk_receive_queue)
  mutex_unlock(&u->iolock)
                              unix_stream_read_generic
                                unix_state_lock(sk)
                                skb_peek(&sk->sk_receive_queue)
                                unix_state_unlock(sk)
  unix_stream_data_wait
    unix_state_lock(sk)
    tail = skb_peek_tail(&sk->sk_receive_queue)
                                spin_lock(&sk->sk_receive_queue.lock)
                                __skb_unlink(skb, &sk->sk_receive_queue)
                                spin_unlock(&sk->sk_receive_queue.lock)
                                consume_skb(skb) [frees the SKB]
    `tail != last`: false
    `tail`: true
    `tail->len != last_len` ***UAF***
```

Fix the UAF by removing the read of tail->len; checking tail->len would
only make sense if SKBs in the receive queue of a UNIX socket could grow,
which can no longer happen.

Kuniyuki explained:

> When commit 869e7c62486e ("net: af_unix: implement stream sendpage
> support") added sendpage() support, data could be appended to the last
> skb in the receiver's queue.
>
> That's why we needed to check if the length of the last skb was changed
> while waiting for new data in unix_stream_data_wait().
>
> However, commit a0dbf5f818f9 ("af_unix: Support MSG_SPLICE_PAGES") and
> commit 57d44a354a43 ("unix: Convert unix_stream_sendpage() to use
> MSG_SPLICE_PAGES") refactored sendmsg(), and now data is always added
> to a new skb.

That means this fix is not suitable for kernels before 6.5.

Fixes: 2b514574f7e8 ("net: af_unix: implement splice for stream af_unix sockets")
Cc: stable@vger.kernel.org # 6.5.x
Signed-off-by: Jann Horn <jannh@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260518-b4-unix-recv-wait-hotfix-v2-1-83e29ce8ad31@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/unix/af_unix.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2570,8 +2570,7 @@ static int unix_read_skb(struct sock *sk
  *	Sleep until more data has arrived. But check for races..
  */
 static long unix_stream_data_wait(struct sock *sk, long timeo,
-				  struct sk_buff *last, unsigned int last_len,
-				  bool freezable)
+				  struct sk_buff *last, bool freezable)
 {
 	unsigned int state = TASK_INTERRUPTIBLE | freezable * TASK_FREEZABLE;
 	struct sk_buff *tail;
@@ -2584,7 +2583,6 @@ static long unix_stream_data_wait(struct
 
 		tail = skb_peek_tail(&sk->sk_receive_queue);
 		if (tail != last ||
-		    (tail && tail->len != last_len) ||
 		    sk->sk_err ||
 		    (sk->sk_shutdown & RCV_SHUTDOWN) ||
 		    signal_pending(current) ||
@@ -2779,7 +2777,6 @@ static int unix_stream_read_generic(stru
 	int flags = state->flags;
 	bool check_creds = false;
 	struct scm_cookie scm;
-	unsigned int last_len;
 	struct unix_sock *u;
 	int copied = 0;
 	int err = 0;
@@ -2825,7 +2822,6 @@ redo:
 			goto unlock;
 		}
 		last = skb = skb_peek(&sk->sk_receive_queue);
-		last_len = last ? last->len : 0;
 
 again:
 #if IS_ENABLED(CONFIG_AF_UNIX_OOB)
@@ -2859,8 +2855,7 @@ again:
 
 			mutex_unlock(&u->iolock);
 
-			timeo = unix_stream_data_wait(sk, timeo, last,
-						      last_len, freezable);
+			timeo = unix_stream_data_wait(sk, timeo, last, freezable);
 
 			if (signal_pending(current)) {
 				err = sock_intr_errno(timeo);
@@ -2877,7 +2872,6 @@ unlock:
 		while (skip >= unix_skb_len(skb)) {
 			skip -= unix_skb_len(skb);
 			last = skb;
-			last_len = skb->len;
 			skb = skb_peek_next(skb, &sk->sk_receive_queue);
 			if (!skb)
 				goto again;
@@ -2950,7 +2944,6 @@ unlock:
 
 			skip = 0;
 			last = skb;
-			last_len = skb->len;
 			unix_state_lock(sk);
 			skb = skb_peek_next(skb, &sk->sk_receive_queue);
 			if (skb)


