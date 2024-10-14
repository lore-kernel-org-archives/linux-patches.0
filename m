Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A60571AB52F;
	Mon, 14 Oct 2024 14:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916834; cv=none; b=WNBVI+pyTQgQ715LQWa85xqhibec/65h4fYd6lFHXxQRiXYh3f9gqAB7sRWfDsf6JkOdedriLV0FU3XHSS0Ly0rU6ERxKj95Pm3F5YEzgqqWwL3ygbCGiqgpiFskTBra6FCphMq27UCcPVUGO7LYN31B7lMYQYdkF+NkDR8LS/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916834; c=relaxed/simple;
	bh=La8qHGhjEz6FS/7czkaDLzCnB1utsPt6BXf9g4o0hHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g4Ip4gZ/3zDzvONuJVUzWDceIf22kYDgO97z0tc9eJlUK0oyRTaw0xwRYn+BTOw+WP194gRBbCTujuDVm6/w0NZX+y7EO7W8x75etvSZ0VOOWe8+dYeLGqlhGld5y1hgQPKxTuN0qM9BpX8zdxezK5qvhLEYiZLo5goIAwl+k5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WJwaWwFp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WJwaWwFp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16002C4CECF;
	Mon, 14 Oct 2024 14:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916834;
	bh=La8qHGhjEz6FS/7czkaDLzCnB1utsPt6BXf9g4o0hHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WJwaWwFpqVVHxvMThacWhvL9TmvzlaetEh0AdkzMVAVgMA9fZG/tQtVGrZXxQX1fO
	 vCi9bNe7aE8QaJempeqS0Voz/nfDiGdm1E/9cPzIGecwonQpmZDf4Ro11Qu6jceKz/
	 iWpU4jkon0MFzSHxDoICtY9ThGYLIE/LbmET2Jh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Jihong <yangjihong1@huawei.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 036/213] perf sched: Move start_work_mutex and work_done_wait_mutex initialization to perf_sched__replay()
Date: Mon, 14 Oct 2024 16:19:02 +0200
Message-ID: <20241014141044.400434907@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Jihong <yangjihong1@huawei.com>

[ Upstream commit c6907863519cf97ee09653cc8ec338a2328c2b6f ]

The start_work_mutex and work_done_wait_mutex are used only for the
'perf sched replay'. Put their initialization in perf_sched__replay () to
reduce unnecessary actions in other commands.

Simple functional testing:

  # perf sched record perf bench sched messaging
  # Running 'sched/messaging' benchmark:
  # 20 sender and receiver processes per group
  # 10 groups == 400 processes run

       Total time: 0.197 [sec]
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 14.952 MB perf.data (134165 samples) ]

  # perf sched replay
  run measurement overhead: 108 nsecs
  sleep measurement overhead: 65658 nsecs
  the run test took 999991 nsecs
  the sleep test took 1079324 nsecs
  nr_run_events:        42378
  nr_sleep_events:      43102
  nr_wakeup_events:     31852
  target-less wakeups:  17
  multi-target wakeups: 712
  task      0 (             swapper:         0), nr_events: 10451
  task      1 (             swapper:         1), nr_events: 3
  task      2 (             swapper:         2), nr_events: 1
  <SNIP>
  task    717 (     sched-messaging:     74483), nr_events: 152
  task    718 (     sched-messaging:     74484), nr_events: 1944
  task    719 (     sched-messaging:     74485), nr_events: 73
  task    720 (     sched-messaging:     74486), nr_events: 163
  task    721 (     sched-messaging:     74487), nr_events: 942
  task    722 (     sched-messaging:     74488), nr_events: 78
  task    723 (     sched-messaging:     74489), nr_events: 1090
  ------------------------------------------------------------
  #1  : 1366.507, ravg: 1366.51, cpu: 7682.70 / 7682.70
  #2  : 1410.072, ravg: 1370.86, cpu: 7723.88 / 7686.82
  #3  : 1396.296, ravg: 1373.41, cpu: 7568.20 / 7674.96
  #4  : 1381.019, ravg: 1374.17, cpu: 7531.81 / 7660.64
  #5  : 1393.826, ravg: 1376.13, cpu: 7725.25 / 7667.11
  #6  : 1401.581, ravg: 1378.68, cpu: 7594.82 / 7659.88
  #7  : 1381.337, ravg: 1378.94, cpu: 7371.22 / 7631.01
  #8  : 1373.842, ravg: 1378.43, cpu: 7894.92 / 7657.40
  #9  : 1364.697, ravg: 1377.06, cpu: 7324.91 / 7624.15
  #10 : 1363.613, ravg: 1375.72, cpu: 7209.55 / 7582.69
  # echo $?
  0

Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/r/20240206083228.172607-2-yangjihong1@huawei.com
Stable-dep-of: 1a5efc9e13f3 ("libsubcmd: Don't free the usage string")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-sched.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 42185da0f000a..2d36b06d4d877 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -3329,15 +3329,20 @@ static int perf_sched__map(struct perf_sched *sched)
 
 static int perf_sched__replay(struct perf_sched *sched)
 {
+	int ret;
 	unsigned long i;
 
+	mutex_init(&sched->start_work_mutex);
+	mutex_init(&sched->work_done_wait_mutex);
+
 	calibrate_run_measurement_overhead(sched);
 	calibrate_sleep_measurement_overhead(sched);
 
 	test_calibrations(sched);
 
-	if (perf_sched__read_events(sched))
-		return -1;
+	ret = perf_sched__read_events(sched);
+	if (ret)
+		goto out_mutex_destroy;
 
 	printf("nr_run_events:        %ld\n", sched->nr_run_events);
 	printf("nr_sleep_events:      %ld\n", sched->nr_sleep_events);
@@ -3362,7 +3367,11 @@ static int perf_sched__replay(struct perf_sched *sched)
 
 	sched->thread_funcs_exit = true;
 	destroy_tasks(sched);
-	return 0;
+
+out_mutex_destroy:
+	mutex_destroy(&sched->start_work_mutex);
+	mutex_destroy(&sched->work_done_wait_mutex);
+	return ret;
 }
 
 static void setup_sorting(struct perf_sched *sched, const struct option *options,
@@ -3600,8 +3609,6 @@ int cmd_sched(int argc, const char **argv)
 	unsigned int i;
 	int ret = 0;
 
-	mutex_init(&sched.start_work_mutex);
-	mutex_init(&sched.work_done_wait_mutex);
 	sched.curr_thread = calloc(MAX_CPUS, sizeof(*sched.curr_thread));
 	if (!sched.curr_thread) {
 		ret = -ENOMEM;
@@ -3689,8 +3696,6 @@ int cmd_sched(int argc, const char **argv)
 	free(sched.curr_pid);
 	free(sched.cpu_last_switched);
 	free(sched.curr_thread);
-	mutex_destroy(&sched.start_work_mutex);
-	mutex_destroy(&sched.work_done_wait_mutex);
 
 	return ret;
 }
-- 
2.43.0



