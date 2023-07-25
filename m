Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF1D41ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:26:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60F39C433CB;
	Tue, 25 Jul 2023 11:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284369;
	bh=F7PoIq55H4DQZ0kzjQ/vJZDTCsckSefymbwhRlMQaOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FPIb/2u93Hud2wwuwFQGcYQ8zln5V8eOWWaAZO4vzh6981W09B2/EhBoPVRXTf4L/
	 yMoAz8cYcDC3eD0qYgUUOO77pUUYgAYZBxQ0nXyrDuWu5FAUzhQHHHUyzzlXUKpa+s
	 LLoDjdX/bYMsMHR8OdcMvuQS5w3Ho/FTN5HuFMJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paul E. McKenney" <paulmck@kernel.org>,
	"Joel Fernandes (Google)" <joel@joelfernandes.org>
Subject: [PATCH 5.10 331/509] rcu-tasks: Simplify trc_read_check_handler() atomic operations
Date: Tue, 25 Jul 2023 12:44:30 +0200
Message-ID: <20230725104608.860158097@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: "Paul E. McKenney" <paulmck@kernel.org>

[ Upstream commit 96017bf9039763a2e02dcc6adaa18592cd73a39d ]

Currently, trc_wait_for_one_reader() atomically increments
the trc_n_readers_need_end counter before sending the IPI
invoking trc_read_check_handler().  All failure paths out of
trc_read_check_handler() and also from the smp_call_function_single()
within trc_wait_for_one_reader() must carefully atomically decrement
this counter.  This is more complex than it needs to be.

This commit therefore simplifies things and saves a few lines of
code by dispensing with the atomic decrements in favor of having
trc_read_check_handler() do the atomic increment only in the success case.
In theory, this represents no change in functionality.

Cc: <stable@vger.kernel.org> # 5.10.x
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/rcu/tasks.h |   20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -841,32 +841,24 @@ static void trc_read_check_handler(void
 
 	// If the task is no longer running on this CPU, leave.
 	if (unlikely(texp != t)) {
-		if (WARN_ON_ONCE(atomic_dec_and_test(&trc_n_readers_need_end)))
-			wake_up(&trc_wait);
 		goto reset_ipi; // Already on holdout list, so will check later.
 	}
 
 	// If the task is not in a read-side critical section, and
 	// if this is the last reader, awaken the grace-period kthread.
 	if (likely(!READ_ONCE(t->trc_reader_nesting))) {
-		if (WARN_ON_ONCE(atomic_dec_and_test(&trc_n_readers_need_end)))
-			wake_up(&trc_wait);
-		// Mark as checked after decrement to avoid false
-		// positives on the above WARN_ON_ONCE().
 		WRITE_ONCE(t->trc_reader_checked, true);
 		goto reset_ipi;
 	}
 	// If we are racing with an rcu_read_unlock_trace(), try again later.
-	if (unlikely(READ_ONCE(t->trc_reader_nesting) < 0)) {
-		if (WARN_ON_ONCE(atomic_dec_and_test(&trc_n_readers_need_end)))
-			wake_up(&trc_wait);
+	if (unlikely(READ_ONCE(t->trc_reader_nesting) < 0))
 		goto reset_ipi;
-	}
 	WRITE_ONCE(t->trc_reader_checked, true);
 
 	// Get here if the task is in a read-side critical section.  Set
 	// its state so that it will awaken the grace-period kthread upon
 	// exit from that critical section.
+	atomic_inc(&trc_n_readers_need_end); // One more to wait on.
 	WARN_ON_ONCE(READ_ONCE(t->trc_reader_special.b.need_qs));
 	WRITE_ONCE(t->trc_reader_special.b.need_qs, true);
 
@@ -960,21 +952,15 @@ static void trc_wait_for_one_reader(stru
 		if (per_cpu(trc_ipi_to_cpu, cpu) || t->trc_ipi_to_cpu >= 0)
 			return;
 
-		atomic_inc(&trc_n_readers_need_end);
 		per_cpu(trc_ipi_to_cpu, cpu) = true;
 		t->trc_ipi_to_cpu = cpu;
 		rcu_tasks_trace.n_ipis++;
-		if (smp_call_function_single(cpu,
-					     trc_read_check_handler, t, 0)) {
+		if (smp_call_function_single(cpu, trc_read_check_handler, t, 0)) {
 			// Just in case there is some other reason for
 			// failure than the target CPU being offline.
 			rcu_tasks_trace.n_ipis_fails++;
 			per_cpu(trc_ipi_to_cpu, cpu) = false;
 			t->trc_ipi_to_cpu = cpu;
-			if (atomic_dec_and_test(&trc_n_readers_need_end)) {
-				WARN_ON_ONCE(1);
-				wake_up(&trc_wait);
-			}
 		}
 	}
 }


