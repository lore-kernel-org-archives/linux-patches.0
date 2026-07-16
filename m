Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0663161AD;
	Thu, 16 Jul 2026 14:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210772; cv=none; b=VFbDf1j/oOkUYhcj3KcFiYvzKr0j83wQUn2++k5AVHBxWdT+IlO7mng1qgMoc3aVVBgD+F0pkdFRoEbgoWqsQ9m4Ergk2S42El/JaORUMUCPe9JNB2NsYxwHf5eoVmmvQg16EpwlJCf7neNibekobsyluXa4e5fwvT9DWwBDFTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210772; c=relaxed/simple;
	bh=VK8qWq9dMaxcXthrDsO48xbXNOogI9XCL+2Ew4iDd6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tX4VY+S3CiwzeC83OKHgCv/zzj+4DTgfHZdslXYrHQyCBe5E24U7/NPvegDA+BqV3626WcDxVqdbmLdOBPC3PF/T66fmZ0vASyw43D1lNYFH9K2EQFuyzhDmYTCNRXmgScuCwRqYczHXmIT81DiAEhftL24sgt9Id9bpd76K0MY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jtXtImly; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jtXtImly"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 876291F00A3F;
	Thu, 16 Jul 2026 14:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210771;
	bh=eLCXZdCzO86XNGyCtklH2ne+i04COz6nvZ0i064Rwgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jtXtImlyMf3+apmxpdt8IvW8WmsgJ+mbzu8hqSsu7BkjlZLIAaYZ57HG2sTR5hDzj
	 r2/lM7ypEdTibWbg4E6va16P8fUAmeOPv2TvBeeCkjssw4LddjfHDwcAflvV7lWEuG
	 zUJ/CfJHMCIfwdbj0MWfIPpNXatLLnP/MoOR2eHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chi Wang <wangchi@kylinos.cn>,
	Ricardo Robaina <rrobaina@redhat.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.18 173/480] audit: Fix data races of skb_queue_len() readers on audit_queue
Date: Thu, 16 Jul 2026 15:28:40 +0200
Message-ID: <20260716133048.452703926@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -946,7 +946,7 @@ main_queue:
 		 *       do the multicast send and rotate records from the
 		 *       main queue to the retry/hold queues */
 		wait_event_freezable(kauditd_wait,
-				     (skb_queue_len(&audit_queue) ? 1 : 0));
+				(skb_queue_len_lockless(&audit_queue) ? 1 : 0));
 	}
 
 	return 0;
@@ -1279,7 +1279,7 @@ static int audit_receive_msg(struct sk_b
 		s.rate_limit		   = audit_rate_limit;
 		s.backlog_limit		   = audit_backlog_limit;
 		s.lost			   = atomic_read(&audit_lost);
-		s.backlog		   = skb_queue_len(&audit_queue);
+		s.backlog		   = skb_queue_len_lockless(&audit_queue);
 		s.feature_bitmap	   = AUDIT_FEATURE_BITMAP_ALL;
 		s.backlog_wait_time	   = audit_backlog_wait_time;
 		s.backlog_wait_time_actual = atomic_read(&audit_backlog_wait_time_actual);
@@ -1622,7 +1622,7 @@ static void audit_receive(struct sk_buff
 
 	/* can't block with the ctrl lock, so penalize the sender now */
 	if (audit_backlog_limit &&
-	    (skb_queue_len(&audit_queue) > audit_backlog_limit)) {
+	    (skb_queue_len_lockless(&audit_queue) > audit_backlog_limit)) {
 		DECLARE_WAITQUEUE(wait, current);
 
 		/* wake kauditd to try and flush the queue */
@@ -1928,7 +1928,7 @@ struct audit_buffer *audit_log_start(str
 		long stime = audit_backlog_wait_time;
 
 		while (audit_backlog_limit &&
-		       (skb_queue_len(&audit_queue) > audit_backlog_limit)) {
+			(skb_queue_len_lockless(&audit_queue) > audit_backlog_limit)) {
 			/* wake kauditd to try and flush the queue */
 			wake_up_interruptible(&kauditd_wait);
 
@@ -1948,7 +1948,7 @@ struct audit_buffer *audit_log_start(str
 			} else {
 				if (audit_rate_check() && printk_ratelimit())
 					pr_warn("audit_backlog=%d > audit_backlog_limit=%d\n",
-						skb_queue_len(&audit_queue),
+						skb_queue_len_lockless(&audit_queue),
 						audit_backlog_limit);
 				audit_log_lost("backlog limit exceeded");
 				return NULL;


