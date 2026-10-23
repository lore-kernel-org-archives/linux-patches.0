Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774250;
	b=G+uurluNUt0j6rDsvQtt5o1pFkcTQ3CryVbV42kmS14bN0h4SVSGJcF5paWnvTGkq01s
	 ERpnnPM81IOBY+pFaiSTTZa731uzbCJ09ywTZv7brsO5J9mIdYfEcJtAIwTj/V7msBfI9
	 LoELwIo0b8UG1+RRAtKdhGUa2NeguPKtZTpnDBnNHKDtXRKFS44TrQO6OzU8rEukMxpl7
	 rlOMqf/NI4ENM6bGprbD52L7R5OnqiJvcogfU5UNlNLEXQpEJwacvt7kEYmN/adocLYou
	 DB+shGgocI/rfP7JAWQL1HukPM94F+MNrKJDbLOhkgH8e9tmuA8oCgHK/5s7wEmGc7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774250;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/Ksugo1b0Q0EupsQUFmYIBLSjCAG8euoIH0IDVUiUjs=;
	b=uuHT8Lsx3xStigQEE0fI2/lJzYKznEVXZCWVaK1lGDMb4l69ciVSkam1/AUrNp8s4S40
	 JVZwU410v4ZPPb+w7WALFFqNz0zIyB3Rjy03n9j9PRdqYaqcmGtR5jn5G3FPiDZBu1VyH
	 XtUBuArgpKcDN33Oho+9Xl6DYsmqWJZWCrr44gcYdUIbVXZeNxwZULrX9dUxvCpPHowlK
	 wAPopevPXes16ZgmowCViVX+jeBu8scAcDng2KcjYjKcU9DTzTrSadnL2kT0ztk5Oy337
	 mYGAaArHZLdifB2lELqwST/kwlobuPPYC2YNt33/oPNy5CIcVKvaK7sE3rDBUAJlN5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WQEsCp9J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2FC7606A31B;
	Fri, 23 Oct 2026 16:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WQEsCp9J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38E551F01828;
	Fri, 23 Oct 2026 16:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774249;
	bh=/Ksugo1b0Q0EupsQUFmYIBLSjCAG8euoIH0IDVUiUjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WQEsCp9JgLSfTVhu7iNN/OlU/IGQDIOhP10eGk38IAf0QHJTo0s3c63IUZgEeCj+k
	 ynP12wbvJVG2hUsno0sKlkRMB+dPXfYG6V0v8yF3tZUdymUF067ekkBfhL6u21Jhls
	 X5jOvZ2bb7XdO4gIGo59O8e9eWSd0GYDZIbNC9L4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiangyu Bu <xbu@meta.com>,
	Tejun Heo <tj@kernel.org>,
	Dan Schatzberg <schatzberg.dan@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 170/193] sched_ext: Fix stall when a task enqueued with SCX_ENQ_LAST lands back on its CPUs local DSQ
Date: Fri, 23 Oct 2026 18:37:27 +0200
Message-ID: <20261023163718.236096813@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

From: Tejun Heo <tj@kernel.org>

[ Upstream commit 7a9df76679633cf26e0fea882a684012c6ec245a ]

With SCX_OPS_ENQ_LAST, the last runnable task on a CPU is passed to
ops.enqueue() instead of being kept running. Exiting tasks without
SCX_OPS_ENQ_EXITING, migration disabled tasks without
SCX_OPS_ENQ_MIGRATION_DISABLED and tasks on an offline rq skip ops.enqueue()
and go straight to the local DSQ. This happens in put_prev_task_scx() after
the pick has settled on idle, so nothing reschedules the CPU, which idles
with the task queued until an unrelated wakeup lands on it or the watchdog
fires.

scx_mitosis, which sets SCX_OPS_ENQ_LAST without SCX_OPS_ENQ_EXITING, hit
this during mass cgroup teardown: exiting tasks stuck in exit_mmap() for
over 40 seconds.

A task put on the local DSQ runs, as anywhere else. If the SCX_ENQ_LAST
enqueue left the task on this CPU's local DSQ, set need_resched on the task
being switched in, as proxy_resched_idle() does. resched_curr() would flag
the task being put instead, and __schedule() clears that right after the
pick.

Fixes: f0e1a0643a59 ("sched_ext: Implement BPF extensible scheduler class")
Cc: stable@vger.kernel.org # v6.12+
Reported-by: Xiangyu Bu <xbu@meta.com>
Link: https://github.com/sched-ext/scx/pull/3870
Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Dan Schatzberg <schatzberg.dan@gmail.com>
[ sashal: adjusted context for do_enqueue_task() in the existing sched_ext file layout. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c          |   13 +++++++++++--
 kernel/sched/ext_internal.h |    5 +++--
 2 files changed, 14 insertions(+), 4 deletions(-)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -2409,8 +2409,7 @@ static void put_prev_task_scx(struct rq
 		/*
 		 * If @p is runnable but we're about to enter a lower
 		 * sched_class, %SCX_OPS_ENQ_LAST must be set. Tell
-		 * ops.enqueue() that @p is the only one available for this cpu,
-		 * which should trigger an explicit follow-up scheduling event.
+		 * ops.enqueue() that @p is the only one available for this cpu.
 		 *
 		 * Core scheduling can force this CPU idle while @p stays
 		 * runnable. @p's cookie then won't match the core's, so skip
@@ -2420,6 +2419,16 @@ static void put_prev_task_scx(struct rq
 			WARN_ON_ONCE(sched_cpu_cookie_match(rq, p) &&
 				     !(sch->ops.flags & SCX_OPS_ENQ_LAST));
 			do_enqueue_task(rq, p, SCX_ENQ_LAST, -1);
+
+			/*
+			 * A task put on the local DSQ runs, as anywhere else.
+			 * Here the insert can't reschedule on its own: the pick
+			 * has settled on @next and @p is still curr, so
+			 * resched_curr() would flag @p and __schedule() clears
+			 * that right after the pick. Flag @next instead.
+			 */
+			if (p->scx.dsq == &rq->scx.local_dsq)
+				set_tsk_need_resched(next);
 		} else {
 			do_enqueue_task(rq, p, 0, -1);
 		}
--- a/kernel/sched/ext_internal.h
+++ b/kernel/sched/ext_internal.h
@@ -949,8 +949,9 @@ enum scx_enq_flags {
 	 * %SCX_OPS_ENQ_LAST is specified, they're ops.enqueue()'d with the
 	 * %SCX_ENQ_LAST flag set.
 	 *
-	 * The BPF scheduler is responsible for triggering a follow-up
-	 * scheduling event. Otherwise, Execution may stall.
+	 * If the task is queued on the local DSQ of the CPU it was running on,
+	 * it continues to run. Otherwise, the CPU goes idle. A scheduler that
+	 * wants a full dispatch cycle on the CPU should kick it.
 	 */
 	SCX_ENQ_LAST		= 1LLU << 41,
 


