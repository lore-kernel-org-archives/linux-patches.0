Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831612;
	b=EdlU+gRL9gFWQggLsxHGINrrOVxMpOWVHpE+xwaUiKnyiShl913cgRTNnqY2xyFpLMc3
	 xxSre4MOUqT0jdaqziDx7p1FuL1dlT0wIirj37WcI2+Z/Y6VzEtpNl6td7Kh7CpUeg/Dz
	 xp2uiRZYERUg2IN2jDuy/dbLMmT0Fda16VfnRJFGtDJq6G24A8T5Js0+2msUjlR1dSIHK
	 Xs2hsmWnb6WgmsjScusx7nHkG9VReYf37thGHBITER+6NsLUZu9cDQkLtHW9BZURemG8N
	 0tKouHcQAnGUVP7DkHZip8ynOL9sDHgTE3g+OZNq3gAtLOjR3Lzg1SA3fOcu1PqWMWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831612;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JyLYRhPBKxPtItcEScmL4UAasy0gdZ3t62G2y054qPc=;
	b=fP3JeF8BoiQD73wWmB6BeF4Q6BiBtB7g4KuTfOWeh9FicTrgSPjvBtPZDcPpBvclOcRQ
	 +rNB5IPM1aNEulGd4Nu3JWkI0n797wQpD8+1HDRbzGwAoDjKW4OhqLtGF+omHxQ7MaW7m
	 NV8BYlxLldaLCN1dswTNfBNOhdDcrDBoAkDkBSgxJzhms7KgRsFTK+M74fQmGhwX2cS9X
	 2JE/KLqyTl08lS57hiXBNlrMPSHVkY7CQMTpN/aR449mjCqhwr0yY/LV7k+yCJZ2oxYgQ
	 pc9+nKpjIDO9yg7H9gLDoNXI50A1aTe6f1kYLPKDqPklbcMl0hP3yWXpcksjS//C7zw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="c1s8tgD/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4B10606A326;
	Wed,  4 Nov 2026 22:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c1s8tgD/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FA0A1F00919;
	Wed,  4 Nov 2026 22:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831611;
	bh=JyLYRhPBKxPtItcEScmL4UAasy0gdZ3t62G2y054qPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c1s8tgD/q2woYb0xjAzYWyGC9UMS5+0Arn5EsMb7LU5/kJVci2pibzf68dRuKbt4m
	 6xmWBH+jSfdxOVODQhlbV/91JdEnj3yb9zc0+RDLDrcT2TtmN+bnghDr7SjkVphwG6
	 MqS+7d6og9/auQyURfhjFn0IpbCxq+aPGOY0jwIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Cheng-Yang Chou <yphbchou0911@gmail.com>,
	Kuba Piecuch <jpiecuch@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0810/1005] sched_ext: Fix scx_flush_disable_work() UAF race
Date: Wed,  4 Nov 2026 16:09:03 -0500
Message-ID: <20261104211106.041103861@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Cheng-Yang Chou <yphbchou0911@gmail.com>

[ Upstream commit d99f7a32f09dccbe396187370ec1a74a31b73d7e ]

scx_flush_disable_work() calls irq_work_sync() followed by
kthread_flush_work() to ensure that the disable kthread work has
fully completed before bpf_scx_unreg() frees the SCX scheduler.

However, a concurrent scx_vexit() (e.g., triggered by a watchdog stall)
creates a race window between scx_claim_exit() and irq_work_queue():

  CPU A (scx_vexit (watchdog))        CPU B (bpf_scx_unreg)
  ----                                ----
  scx_claim_exit()
    atomic_try_cmpxchg(NONE->kind)
  stack_trace_save()
  vscnprintf()
                                      scx_disable()
                                        scx_claim_exit() -> FAIL
                                      scx_flush_disable_work()
                                        irq_work_sync()      // no-op: not queued yet
                                        kthread_flush_work() // no-op: not queued yet
                                      kobject_put(&sch->kobj) -> free %sch
  irq_work_queue() -> UAF on %sch
  scx_disable_irq_workfn()
    kthread_queue_work() -> UAF

The root cause is that CPU B's scx_flush_disable_work() returns after
syncing an irq_work that has not yet been queued, while CPU A is still
executing the code between scx_claim_exit() and irq_work_queue().

Loop until exit_kind reaches SCX_EXIT_DONE or SCX_EXIT_NONE, draining
disable_irq_work and disable_work in each pass. This ensures that any
work queued after the previous check is caught, while also correctly
handling cases where no disable was triggered (e.g., the
scx_sub_enable_workfn() abort path).

Fixes: 510a27055446 ("sched_ext: sync disable_irq_work in bpf_scx_unreg()")
Reported-by: https://sashiko.dev/#/patchset/20260424100221.32407-1-icheng%40nvidia.com
Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Cheng-Yang Chou <yphbchou0911@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
[ Sync error_irq_work instead of disable_irq_work. ]
Signed-off-by: Kuba Piecuch <jpiecuch@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/ext.c b/kernel/sched/ext.c
index d2460a88fba35..78f15ddc0aa5a 100644
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -4217,8 +4217,13 @@ static void scx_disable(struct scx_sched *sch, enum scx_exit_kind kind)
  */
 static void scx_flush_disable_work(struct scx_sched *sch)
 {
-	irq_work_sync(&sch->error_irq_work);
-	kthread_flush_work(&sch->disable_work);
+	int kind;
+
+	do {
+		irq_work_sync(&sch->error_irq_work);
+		kthread_flush_work(&sch->disable_work);
+		kind = atomic_read(&sch->exit_kind);
+	} while (kind != SCX_EXIT_NONE && kind != SCX_EXIT_DONE);
 }
 
 static void dump_newline(struct seq_buf *s)
-- 
2.53.0



