Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B07A2EA73C;
	Tue, 15 Jul 2025 13:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586121; cv=none; b=JnBOcHV/m5DZvkWPOIIqz0xg+DBeevE7A+H+kIBQsamCHLoyuX3AxufGE9EggeiBhu1fc4UkdPHO0dIL02cL6uCryLAUaDtYcjHG/xU/j8sA5VxwVdhQz4v3nJ5tvWzZzSsEUHI/PkZ7xZF0FNdktmw5OZY3J67JWaTrNLCnDyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586121; c=relaxed/simple;
	bh=tThc9zRo53nLQRrGFMzY51P4UREHg52vuNGhn6dM1Cg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mcatFR9Qmru/K07sybEVBHTX55CGyY3DZ1VDJb8mSNbPdiUNeBkSdc46/GorV5FYTtZdn2N8T2ekXgeJT2ei0j54LYu6jVlBmto3V4PRXYXpERBjI+WZj0cO5Q7QjGMovup6votO7pNl+KQDgUJv8SsK6IO+XD+9BBsC1vNIbG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hFlQLsX2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hFlQLsX2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7147BC4CEE3;
	Tue, 15 Jul 2025 13:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586120;
	bh=tThc9zRo53nLQRrGFMzY51P4UREHg52vuNGhn6dM1Cg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hFlQLsX2CglAJgZMGPxeHmKgXNZ1NL1WXc+mq1/TPDG84FzA4LVbqf8P9dlZSJ2m7
	 B7TJxPFyZht/VwjQPTyq+3gS/W7jcup7DOvU03so5ejdCNgr94FlbP59NWX558vDbF
	 a65deEjV6Wya0DMD7kkn7u8njf4qNLNI11XEoxwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Xu Kuohai <xukuohai@huawei.com>,
	Pranav Tyagi <pranav.tyagi03@gmail.com>
Subject: [PATCH 5.15 23/77] bpf, sockmap: Fix skb refcnt race after locking changes
Date: Tue, 15 Jul 2025 15:13:22 +0200
Message-ID: <20250715130752.632132891@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130751.668489382@linuxfoundation.org>
References: <20250715130751.668489382@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: John Fastabend <john.fastabend@gmail.com>

commit a454d84ee20baf7bd7be90721b9821f73c7d23d9 upstream.

There is a race where skb's from the sk_psock_backlog can be referenced
after userspace side has already skb_consumed() the sk_buff and its refcnt
dropped to zer0 causing use after free.

The flow is the following:

  while ((skb = skb_peek(&psock->ingress_skb))
    sk_psock_handle_Skb(psock, skb, ..., ingress)
    if (!ingress) ...
    sk_psock_skb_ingress
       sk_psock_skb_ingress_enqueue(skb)
          msg->skb = skb
          sk_psock_queue_msg(psock, msg)
    skb_dequeue(&psock->ingress_skb)

The sk_psock_queue_msg() puts the msg on the ingress_msg queue. This is
what the application reads when recvmsg() is called. An application can
read this anytime after the msg is placed on the queue. The recvmsg hook
will also read msg->skb and then after user space reads the msg will call
consume_skb(skb) on it effectively free'ing it.

But, the race is in above where backlog queue still has a reference to
the skb and calls skb_dequeue(). If the skb_dequeue happens after the
user reads and free's the skb we have a use after free.

The !ingress case does not suffer from this problem because it uses
sendmsg_*(sk, msg) which does not pass the sk_buff further down the
stack.

The following splat was observed with 'test_progs -t sockmap_listen':

  [ 1022.710250][ T2556] general protection fault, ...
  [...]
  [ 1022.712830][ T2556] Workqueue: events sk_psock_backlog
  [ 1022.713262][ T2556] RIP: 0010:skb_dequeue+0x4c/0x80
  [ 1022.713653][ T2556] Code: ...
  [...]
  [ 1022.720699][ T2556] Call Trace:
  [ 1022.720984][ T2556]  <TASK>
  [ 1022.721254][ T2556]  ? die_addr+0x32/0x80^M
  [ 1022.721589][ T2556]  ? exc_general_protection+0x25a/0x4b0
  [ 1022.722026][ T2556]  ? asm_exc_general_protection+0x22/0x30
  [ 1022.722489][ T2556]  ? skb_dequeue+0x4c/0x80
  [ 1022.722854][ T2556]  sk_psock_backlog+0x27a/0x300
  [ 1022.723243][ T2556]  process_one_work+0x2a7/0x5b0
  [ 1022.723633][ T2556]  worker_thread+0x4f/0x3a0
  [ 1022.723998][ T2556]  ? __pfx_worker_thread+0x10/0x10
  [ 1022.724386][ T2556]  kthread+0xfd/0x130
  [ 1022.724709][ T2556]  ? __pfx_kthread+0x10/0x10
  [ 1022.725066][ T2556]  ret_from_fork+0x2d/0x50
  [ 1022.725409][ T2556]  ? __pfx_kthread+0x10/0x10
  [ 1022.725799][ T2556]  ret_from_fork_asm+0x1b/0x30
  [ 1022.726201][ T2556]  </TASK>

To fix we add an skb_get() before passing the skb to be enqueued in the
engress queue. This bumps the skb->users refcnt so that consume_skb()
and kfree_skb will not immediately free the sk_buff. With this we can
be sure the skb is still around when we do the dequeue. Then we just
need to decrement the refcnt or free the skb in the backlog case which
we do by calling kfree_skb() on the ingress case as well as the sendmsg
case.

Before locking change from fixes tag we had the sock locked so we
couldn't race with user and there was no issue here.

Fixes: 799aa7f98d53e ("skmsg: Avoid lock_sock() in sk_psock_backlog()")
Reported-by: Jiri Olsa  <jolsa@kernel.org>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Tested-by: Xu Kuohai <xukuohai@huawei.com>
Tested-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/bpf/20230901202137.214666-1-john.fastabend@gmail.com
Signed-off-by: Pranav Tyagi <pranav.tyagi03@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/skmsg.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -608,12 +608,18 @@ static int sk_psock_skb_ingress_self(str
 static int sk_psock_handle_skb(struct sk_psock *psock, struct sk_buff *skb,
 			       u32 off, u32 len, bool ingress)
 {
+	int err = 0;
+
 	if (!ingress) {
 		if (!sock_writeable(psock->sk))
 			return -EAGAIN;
 		return skb_send_sock(psock->sk, skb, off, len);
 	}
-	return sk_psock_skb_ingress(psock, skb, off, len);
+	skb_get(skb);
+	err = sk_psock_skb_ingress(psock, skb, off, len);
+	if (err < 0)
+		kfree_skb(skb);
+	return err;
 }
 
 static void sk_psock_skb_state(struct sk_psock *psock,
@@ -693,9 +699,7 @@ static void sk_psock_backlog(struct work
 		/* The entire skb sent, clear state */
 		sk_psock_skb_state(psock, state, 0, 0);
 		skb = skb_dequeue(&psock->ingress_skb);
-		if (!ingress) {
-			kfree_skb(skb);
-		}
+		kfree_skb(skb);
 	}
 end:
 	mutex_unlock(&psock->work_mutex);


