Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 378E9522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:19:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4DFEC433C9;
	Sun,  9 Jul 2023 11:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688901577;
	bh=01+Cv8T9BhI7lJ+URBtfjzsek9TMJmj9tY0z3tBbS2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P3iWJgODbrE/Ae4qnJjUSadGLQpQM0m9BOMw8Cbj3c/5NmKJsOfxQk91N5OzbKLPO
	 fjqt//LOvjTzhZbNPElq0lfoEomggkz0Ydj+cfCfn71hg8mHEFOfCeoGAExVY1/L0b
	 zOo8W15L7Av1TW2gPeS5kVTPZ4aFRdzr/DH+3Xoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	"Joel Fernandes (Google)" <joel@joelfernandes.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 062/431] rcu/rcuscale: Move rcu_scale_*() after kfree_scale_cleanup()
Date: Sun,  9 Jul 2023 13:10:10 +0200
Message-ID: <20230709111452.597118752@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Qiuxu Zhuo <qiuxu.zhuo@intel.com>

[ Upstream commit bf5ddd736509a7d9077c0b6793e6f0852214dbea ]

This code-movement-only commit moves the rcu_scale_cleanup() and
rcu_scale_shutdown() functions to follow kfree_scale_cleanup().
This is code movement is in preparation for a bug-fix patch that invokes
kfree_scale_cleanup() from rcu_scale_cleanup().

Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Reviewed-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Stable-dep-of: 23fc8df26dea ("rcu/rcuscale: Stop kfree_scale_thread thread(s) after unloading rcuscale")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/rcuscale.c | 194 +++++++++++++++++++++---------------------
 1 file changed, 97 insertions(+), 97 deletions(-)

diff --git a/kernel/rcu/rcuscale.c b/kernel/rcu/rcuscale.c
index 4120f94030c3c..dd25d306559a5 100644
--- a/kernel/rcu/rcuscale.c
+++ b/kernel/rcu/rcuscale.c
@@ -522,89 +522,6 @@ rcu_scale_print_module_parms(struct rcu_scale_ops *cur_ops, const char *tag)
 		 scale_type, tag, nrealreaders, nrealwriters, verbose, shutdown);
 }
 
-static void
-rcu_scale_cleanup(void)
-{
-	int i;
-	int j;
-	int ngps = 0;
-	u64 *wdp;
-	u64 *wdpp;
-
-	/*
-	 * Would like warning at start, but everything is expedited
-	 * during the mid-boot phase, so have to wait till the end.
-	 */
-	if (rcu_gp_is_expedited() && !rcu_gp_is_normal() && !gp_exp)
-		SCALEOUT_ERRSTRING("All grace periods expedited, no normal ones to measure!");
-	if (rcu_gp_is_normal() && gp_exp)
-		SCALEOUT_ERRSTRING("All grace periods normal, no expedited ones to measure!");
-	if (gp_exp && gp_async)
-		SCALEOUT_ERRSTRING("No expedited async GPs, so went with async!");
-
-	if (torture_cleanup_begin())
-		return;
-	if (!cur_ops) {
-		torture_cleanup_end();
-		return;
-	}
-
-	if (reader_tasks) {
-		for (i = 0; i < nrealreaders; i++)
-			torture_stop_kthread(rcu_scale_reader,
-					     reader_tasks[i]);
-		kfree(reader_tasks);
-	}
-
-	if (writer_tasks) {
-		for (i = 0; i < nrealwriters; i++) {
-			torture_stop_kthread(rcu_scale_writer,
-					     writer_tasks[i]);
-			if (!writer_n_durations)
-				continue;
-			j = writer_n_durations[i];
-			pr_alert("%s%s writer %d gps: %d\n",
-				 scale_type, SCALE_FLAG, i, j);
-			ngps += j;
-		}
-		pr_alert("%s%s start: %llu end: %llu duration: %llu gps: %d batches: %ld\n",
-			 scale_type, SCALE_FLAG,
-			 t_rcu_scale_writer_started, t_rcu_scale_writer_finished,
-			 t_rcu_scale_writer_finished -
-			 t_rcu_scale_writer_started,
-			 ngps,
-			 rcuscale_seq_diff(b_rcu_gp_test_finished,
-					   b_rcu_gp_test_started));
-		for (i = 0; i < nrealwriters; i++) {
-			if (!writer_durations)
-				break;
-			if (!writer_n_durations)
-				continue;
-			wdpp = writer_durations[i];
-			if (!wdpp)
-				continue;
-			for (j = 0; j < writer_n_durations[i]; j++) {
-				wdp = &wdpp[j];
-				pr_alert("%s%s %4d writer-duration: %5d %llu\n",
-					scale_type, SCALE_FLAG,
-					i, j, *wdp);
-				if (j % 100 == 0)
-					schedule_timeout_uninterruptible(1);
-			}
-			kfree(writer_durations[i]);
-		}
-		kfree(writer_tasks);
-		kfree(writer_durations);
-		kfree(writer_n_durations);
-	}
-
-	/* Do torture-type-specific cleanup operations.  */
-	if (cur_ops->cleanup != NULL)
-		cur_ops->cleanup();
-
-	torture_cleanup_end();
-}
-
 /*
  * Return the number if non-negative.  If -1, the number of CPUs.
  * If less than -1, that much less than the number of CPUs, but
@@ -624,20 +541,6 @@ static int compute_real(int n)
 	return nr;
 }
 
-/*
- * RCU scalability shutdown kthread.  Just waits to be awakened, then shuts
- * down system.
- */
-static int
-rcu_scale_shutdown(void *arg)
-{
-	wait_event_idle(shutdown_wq, atomic_read(&n_rcu_scale_writer_finished) >= nrealwriters);
-	smp_mb(); /* Wake before output. */
-	rcu_scale_cleanup();
-	kernel_power_off();
-	return -EINVAL;
-}
-
 /*
  * kfree_rcu() scalability tests: Start a kfree_rcu() loop on all CPUs for number
  * of iterations and measure total time and number of GP for all iterations to complete.
@@ -874,6 +777,103 @@ kfree_scale_init(void)
 	return firsterr;
 }
 
+static void
+rcu_scale_cleanup(void)
+{
+	int i;
+	int j;
+	int ngps = 0;
+	u64 *wdp;
+	u64 *wdpp;
+
+	/*
+	 * Would like warning at start, but everything is expedited
+	 * during the mid-boot phase, so have to wait till the end.
+	 */
+	if (rcu_gp_is_expedited() && !rcu_gp_is_normal() && !gp_exp)
+		SCALEOUT_ERRSTRING("All grace periods expedited, no normal ones to measure!");
+	if (rcu_gp_is_normal() && gp_exp)
+		SCALEOUT_ERRSTRING("All grace periods normal, no expedited ones to measure!");
+	if (gp_exp && gp_async)
+		SCALEOUT_ERRSTRING("No expedited async GPs, so went with async!");
+
+	if (torture_cleanup_begin())
+		return;
+	if (!cur_ops) {
+		torture_cleanup_end();
+		return;
+	}
+
+	if (reader_tasks) {
+		for (i = 0; i < nrealreaders; i++)
+			torture_stop_kthread(rcu_scale_reader,
+					     reader_tasks[i]);
+		kfree(reader_tasks);
+	}
+
+	if (writer_tasks) {
+		for (i = 0; i < nrealwriters; i++) {
+			torture_stop_kthread(rcu_scale_writer,
+					     writer_tasks[i]);
+			if (!writer_n_durations)
+				continue;
+			j = writer_n_durations[i];
+			pr_alert("%s%s writer %d gps: %d\n",
+				 scale_type, SCALE_FLAG, i, j);
+			ngps += j;
+		}
+		pr_alert("%s%s start: %llu end: %llu duration: %llu gps: %d batches: %ld\n",
+			 scale_type, SCALE_FLAG,
+			 t_rcu_scale_writer_started, t_rcu_scale_writer_finished,
+			 t_rcu_scale_writer_finished -
+			 t_rcu_scale_writer_started,
+			 ngps,
+			 rcuscale_seq_diff(b_rcu_gp_test_finished,
+					   b_rcu_gp_test_started));
+		for (i = 0; i < nrealwriters; i++) {
+			if (!writer_durations)
+				break;
+			if (!writer_n_durations)
+				continue;
+			wdpp = writer_durations[i];
+			if (!wdpp)
+				continue;
+			for (j = 0; j < writer_n_durations[i]; j++) {
+				wdp = &wdpp[j];
+				pr_alert("%s%s %4d writer-duration: %5d %llu\n",
+					scale_type, SCALE_FLAG,
+					i, j, *wdp);
+				if (j % 100 == 0)
+					schedule_timeout_uninterruptible(1);
+			}
+			kfree(writer_durations[i]);
+		}
+		kfree(writer_tasks);
+		kfree(writer_durations);
+		kfree(writer_n_durations);
+	}
+
+	/* Do torture-type-specific cleanup operations.  */
+	if (cur_ops->cleanup != NULL)
+		cur_ops->cleanup();
+
+	torture_cleanup_end();
+}
+
+/*
+ * RCU scalability shutdown kthread.  Just waits to be awakened, then shuts
+ * down system.
+ */
+static int
+rcu_scale_shutdown(void *arg)
+{
+	wait_event_idle(shutdown_wq, atomic_read(&n_rcu_scale_writer_finished) >= nrealwriters);
+	smp_mb(); /* Wake before output. */
+	rcu_scale_cleanup();
+	kernel_power_off();
+	return -EINVAL;
+}
+
 static int __init
 rcu_scale_init(void)
 {
-- 
2.39.2



