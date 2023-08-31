Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085548F4B
	for <patches@lists.linux.dev>; Thu, 31 Aug 2023 11:10:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 556B0C433C7;
	Thu, 31 Aug 2023 11:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693480244;
	bh=1nQaNXUJi+TND5gnZBOLUi3C4zE/HUNPNC734oSmNxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1gxLZwMRXnmCG1ueG1t2ew0nVUyLq3aWQeIPtuP1E3Bau+qqKXDGl460Vry/OucJv
	 mQmy0N6msMJX+UmUE+XPwP2ADmgRFgk0J6ACUW+BCLzFR1pA/ASLPldRGJ9u/vkfJP
	 viGwbRFusJdRFEvABaROYf2HSMBxbjYOmGKhLn1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Joel Fernandes <joel@joelfernandes.org>
Subject: [PATCH 5.10 10/11] rcu-tasks: Wait for trc_read_check_handler() IPIs
Date: Thu, 31 Aug 2023 13:10:02 +0200
Message-ID: <20230831110830.869197845@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230831110830.455765526@linuxfoundation.org>
References: <20230831110830.455765526@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul E. McKenney <paulmck@kernel.org>

commit cbe0d8d91415c9692fe88191940d98952b6855d9 upstream.

Currently, RCU Tasks Trace initializes the trc_n_readers_need_end counter
to the value one, increments it before each trc_read_check_handler()
IPI, then decrements it within trc_read_check_handler() if the target
task was in a quiescent state (or if the target task moved to some other
CPU while the IPI was in flight), complaining if the new value was zero.
The rationale for complaining is that the initial value of one must be
decremented away before zero can be reached, and this decrement has not
yet happened.

Except that trc_read_check_handler() is initiated with an asynchronous
smp_call_function_single(), which might be significantly delayed.  This
can result in false-positive complaints about the counter reaching zero.

This commit therefore waits for in-flight IPI handlers to complete before
decrementing away the initial value of one from the trc_n_readers_need_end
counter.

Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Cc: Joel Fernandes <joel@joelfernandes.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/rcu/tasks.h |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -1083,14 +1083,28 @@ static void check_all_holdout_tasks_trac
 	}
 }
 
+static void rcu_tasks_trace_empty_fn(void *unused)
+{
+}
+
 /* Wait for grace period to complete and provide ordering. */
 static void rcu_tasks_trace_postgp(struct rcu_tasks *rtp)
 {
+	int cpu;
 	bool firstreport;
 	struct task_struct *g, *t;
 	LIST_HEAD(holdouts);
 	long ret;
 
+	// Wait for any lingering IPI handlers to complete.  Note that
+	// if a CPU has gone offline or transitioned to userspace in the
+	// meantime, all IPI handlers should have been drained beforehand.
+	// Yes, this assumes that CPUs process IPIs in order.  If that ever
+	// changes, there will need to be a recheck and/or timed wait.
+	for_each_online_cpu(cpu)
+		if (smp_load_acquire(per_cpu_ptr(&trc_ipi_to_cpu, cpu)))
+			smp_call_function_single(cpu, rcu_tasks_trace_empty_fn, NULL, 1);
+
 	// Remove the safety count.
 	smp_mb__before_atomic();  // Order vs. earlier atomics
 	atomic_dec(&trc_n_readers_need_end);


