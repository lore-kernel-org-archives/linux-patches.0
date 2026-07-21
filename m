Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D38593E49CF;
	Tue, 21 Jul 2026 22:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673210; cv=none; b=BQodsynxfkjLnI4tm7tCgQqsDRLvql1wpyjZrpAhTQcMnuxkfbIQFMXgYRBTRgmxALuJjR0TIjSnRlQRRtiX+WdDVwqwhWI6ZGL3857dXSIWaTharIxfbDdm5xj0/K3WxE2BhfUh02uhZkYF4FSDs4ul9BnXvw382cJsnemcKXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673210; c=relaxed/simple;
	bh=WccAXT4nYAw9KceQsH5m7NXuwzf23Eu8w3is62bsXik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TV+926z+7YmcV3k3+P3Y5CxfuRB6HoemqEotKEfWCxECJgkt49TZziOpLnIEIMheMX19/h5yB2HNvKIzFhlojsQaqrfL74qDrg6RbPLG2GIu+OoXIXIA3hwMi4KQ+wXipk7AHc9W9gg6bkJJb/oDO1tQS91s+u/UXs7+ermFHaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TERYAYyf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TERYAYyf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45BC81F000E9;
	Tue, 21 Jul 2026 22:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673208;
	bh=jOLs4jMDMkHiaN0E+IkoEcwf1bB7yBiGqeDM+myR9To=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TERYAYyfK9bPObubFB+tVVfUmF7PHyWy4CQ1sG7LXxV7ptBXf3Z3b4NUqpW6ZrOJ7
	 vyUI+N2vq5k5F4aYTJtDblDdtHJsdvYy1i3z/t9BHqdgQbwRHmoDsrEMiPNnCuGfAb
	 0azPbq0PMWa0AZrKl9yDB30QpTcqlpivW7m0JbnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chi Wang <wangchi@kylinos.cn>,
	Ricardo Robaina <rrobaina@redhat.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.10 074/699] audit: Fix data races of skb_queue_len() readers on audit_queue
Date: Tue, 21 Jul 2026 17:17:13 +0200
Message-ID: <20260721152357.374799427@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chi Wang <wangchi@kylinos.cn>

commit c9a71daaecb2fb1d8c704545cc0b1c920b9bf5d7 upstream.

Multiple readers access audit_queue.qlen via skb_queue_len() without
holding the queue lock or using READ_ONCE(), while kauditd writes to
this field via the skb_dequeue() → __skb_unlink() path with WRITE_ONCE()
protected by a spinlock. This constitutes data races.

All affected skb_queue_len(&audit_queue) call sites:
  - kauditd_thread() wait_event_freezable() condition
  - audit_receive_msg() AUDIT_GET handler (s.backlog assignment)
  - audit_receive() backlog check
  - audit_log_start() backlog check and pr_warn()

KCSAN reports the following conflicting access pattern (one example):
==================================================================
BUG: KCSAN: data-race in audit_log_start / skb_dequeue

write (marked) to 0xffffffff8512ee20 of 4 bytes by task 661 on cpu 57:
 skb_dequeue+0x70/0xf0
 kauditd_send_queue+0x71/0x220
 kauditd_thread+0x1cb/0x430
 kthread+0x1c2/0x210
 ret_from_fork+0x162/0x1a0
 ret_from_fork_asm+0x1a/0x30

read to 0xffffffff8512ee20 of 4 bytes by task 36586 on cpu 1:
 audit_log_start+0x2a0/0x6b0
 audit_core_dumps+0x64/0xa0
 do_coredump+0x14b/0x1260
 get_signal+0xeb2/0xf70
 arch_do_signal_or_restart+0x41/0x170
 exit_to_user_mode_loop+0xa2/0x1c0
 do_syscall_64+0x1a3/0x1c0
 entry_SYSCALL_64_after_hwframe+0x76/0xe0

value changed: 0x00000001 -> 0x00000000
==================================================================

Resolve the race by switching to lockless helper skb_queue_len_lockless(),
which internally uses READ_ONCE() and properly pairs with the WRITE_ONCE()
write accesses already present on the writer side.

Cc: stable@vger.kernel.org
Fixes: 3197542482df ("audit: rework audit_log_start()")
Signed-off-by: Chi Wang <wangchi@kylinos.cn>
Reviewed-by: Ricardo Robaina <rrobaina@redhat.com>
[PM: line length tweak]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/audit.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -912,7 +912,7 @@ main_queue:
 		 *       do the multicast send and rotate records from the
 		 *       main queue to the retry/hold queues */
 		wait_event_freezable(kauditd_wait,
-				     (skb_queue_len(&audit_queue) ? 1 : 0));
+				(skb_queue_len_lockless(&audit_queue) ? 1 : 0));
 	}
 
 	return 0;
@@ -1247,7 +1247,7 @@ static int audit_receive_msg(struct sk_b
 		s.rate_limit		   = audit_rate_limit;
 		s.backlog_limit		   = audit_backlog_limit;
 		s.lost			   = atomic_read(&audit_lost);
-		s.backlog		   = skb_queue_len(&audit_queue);
+		s.backlog		   = skb_queue_len_lockless(&audit_queue);
 		s.feature_bitmap	   = AUDIT_FEATURE_BITMAP_ALL;
 		s.backlog_wait_time	   = audit_backlog_wait_time;
 		s.backlog_wait_time_actual = atomic_read(&audit_backlog_wait_time_actual);
@@ -1588,7 +1588,7 @@ static void audit_receive(struct sk_buff
 
 	/* can't block with the ctrl lock, so penalize the sender now */
 	if (audit_backlog_limit &&
-	    (skb_queue_len(&audit_queue) > audit_backlog_limit)) {
+	    (skb_queue_len_lockless(&audit_queue) > audit_backlog_limit)) {
 		DECLARE_WAITQUEUE(wait, current);
 
 		/* wake kauditd to try and flush the queue */
@@ -1890,7 +1890,7 @@ struct audit_buffer *audit_log_start(str
 		long stime = audit_backlog_wait_time;
 
 		while (audit_backlog_limit &&
-		       (skb_queue_len(&audit_queue) > audit_backlog_limit)) {
+			(skb_queue_len_lockless(&audit_queue) > audit_backlog_limit)) {
 			/* wake kauditd to try and flush the queue */
 			wake_up_interruptible(&kauditd_wait);
 
@@ -1910,7 +1910,7 @@ struct audit_buffer *audit_log_start(str
 			} else {
 				if (audit_rate_check() && printk_ratelimit())
 					pr_warn("audit_backlog=%d > audit_backlog_limit=%d\n",
-						skb_queue_len(&audit_queue),
+						skb_queue_len_lockless(&audit_queue),
 						audit_backlog_limit);
 				audit_log_lost("backlog limit exceeded");
 				return NULL;


