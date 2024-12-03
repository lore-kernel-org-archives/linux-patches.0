Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A680023CE;
	Tue,  3 Dec 2024 16:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241787; cv=none; b=oAU1e6c9W/6OwcEbu5BMAY5/M8L5x0HlWDunktaZ97i1XAw8g4b9v7pGT6NxcPnCteYMBBJcPLvnFVyFCJOaldzaWnXJ+Pe74sYd2i+DwUtfrGWREjnTCdjDVOhmFNuDMhFWClIzc/ysv9W1Wic+jPcsH+c/Im9PgsPVsis/UOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241787; c=relaxed/simple;
	bh=mC5R6zZTgfu7TzCXrxoKShKtSc7qUVTfmhTg5YcVsL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bz7BUrTuQSk3XFHaxbgcvc2XK9WxgVZmu6PYYqef5kvmCftIgh26c3GteEBHP19xmpmZddiQOQQF2iJ5dNDRRVklOVdfd9reHAseQ99D53IIMzzqjg65FoJqZ/dFJ53oY0GWWCxaGAW0YYf4G/IcQaBqjajhst38tw5Q9wDJCwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YPieYCvk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YPieYCvk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F7BFC4CECF;
	Tue,  3 Dec 2024 16:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241787;
	bh=mC5R6zZTgfu7TzCXrxoKShKtSc7qUVTfmhTg5YcVsL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YPieYCvkwKFMTv0dCntE4VtPAIVa6SdGoQ1NVvOVFUd7CZ6wXkmx0nloiDH7lErMO
	 yHtztZguPfegXfQiEECZt6BMYIdyIWyxmGEbTCVaTDf4duYuiOkLZ+nchTghIM0xEI
	 tckoqWWhHaxBYttrY0544lWa2xrxvm1p+Fv/BF9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Levi Yun <yeoreum.yun@arm.com>,
	James Clark <james.clark@linaro.org>,
	Andi Kleen <ak@linux.intel.com>,
	nd@arm.com,
	howardchu95@gmail.com,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 475/826] perf stat: Close cork_fd when create_perf_stat_counter() failed
Date: Tue,  3 Dec 2024 15:43:22 +0100
Message-ID: <20241203144802.291243252@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Levi Yun <yeoreum.yun@arm.com>

[ Upstream commit e880a70f8046df0dd9089fa60dcb866a2cc69194 ]

When create_perf_stat_counter() failed, it doesn't close workload.cork_fd
open in evlist__prepare_workload(). This could make too many open file
error while __run_perf_stat() repeats.

Introduce evlist__cancel_workload to close workload.cork_fd and
wait workload.child_pid until exit to clear child process
when create_perf_stat_counter() is failed.

Signed-off-by: Levi Yun <yeoreum.yun@arm.com>
Reviewed-by: James Clark <james.clark@linaro.org>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Cc: nd@arm.com
Cc: howardchu95@gmail.com
Link: https://lore.kernel.org/r/20240925132022.2650180-2-yeoreum.yun@arm.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Stable-dep-of: 7f6ccb70e465 ("perf stat: Fix affinity memory leaks on error path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-stat.c | 50 +++++++++++++++++++++++++++------------
 tools/perf/util/evlist.c  | 19 +++++++++++++--
 tools/perf/util/evlist.h  |  1 +
 3 files changed, 53 insertions(+), 17 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 689a3d43c2584..2c46bdbd9914d 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -716,15 +716,19 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
 	}
 
 	if (!cpu_map__is_dummy(evsel_list->core.user_requested_cpus)) {
-		if (affinity__setup(&saved_affinity) < 0)
-			return -1;
+		if (affinity__setup(&saved_affinity) < 0) {
+			err = -1;
+			goto err_out;
+		}
 		affinity = &saved_affinity;
 	}
 
 	evlist__for_each_entry(evsel_list, counter) {
 		counter->reset_group = false;
-		if (bpf_counter__load(counter, &target))
-			return -1;
+		if (bpf_counter__load(counter, &target)) {
+			err = -1;
+			goto err_out;
+		}
 		if (!(evsel__is_bperf(counter)))
 			all_counters_use_bpf = false;
 	}
@@ -767,7 +771,8 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
 
 			switch (stat_handle_error(counter)) {
 			case COUNTER_FATAL:
-				return -1;
+				err = -1;
+				goto err_out;
 			case COUNTER_RETRY:
 				goto try_again;
 			case COUNTER_SKIP:
@@ -808,7 +813,8 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
 
 				switch (stat_handle_error(counter)) {
 				case COUNTER_FATAL:
-					return -1;
+					err = -1;
+					goto err_out;
 				case COUNTER_RETRY:
 					goto try_again_reset;
 				case COUNTER_SKIP:
@@ -833,8 +839,10 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
 			stat_config.unit_width = l;
 
 		if (evsel__should_store_id(counter) &&
-		    evsel__store_ids(counter, evsel_list))
-			return -1;
+		    evsel__store_ids(counter, evsel_list)) {
+			err = -1;
+			goto err_out;
+		}
 	}
 
 	if (evlist__apply_filters(evsel_list, &counter, &target)) {
@@ -855,20 +863,23 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
 		}
 
 		if (err < 0)
-			return err;
+			goto err_out;
 
 		err = perf_event__synthesize_stat_events(&stat_config, NULL, evsel_list,
 							 process_synthesized_event, is_pipe);
 		if (err < 0)
-			return err;
+			goto err_out;
+
 	}
 
 	if (target.initial_delay) {
 		pr_info(EVLIST_DISABLED_MSG);
 	} else {
 		err = enable_counters();
-		if (err)
-			return -1;
+		if (err) {
+			err = -1;
+			goto err_out;
+		}
 	}
 
 	/* Exec the command, if any */
@@ -878,8 +889,10 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
 	if (target.initial_delay > 0) {
 		usleep(target.initial_delay * USEC_PER_MSEC);
 		err = enable_counters();
-		if (err)
-			return -1;
+		if (err) {
+			err = -1;
+			goto err_out;
+		}
 
 		pr_info(EVLIST_ENABLED_MSG);
 	}
@@ -899,7 +912,8 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
 		if (workload_exec_errno) {
 			const char *emsg = str_error_r(workload_exec_errno, msg, sizeof(msg));
 			pr_err("Workload failed: %s\n", emsg);
-			return -1;
+			err = -1;
+			goto err_out;
 		}
 
 		if (WIFSIGNALED(status))
@@ -946,6 +960,12 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
 		evlist__close(evsel_list);
 
 	return WEXITSTATUS(status);
+
+err_out:
+	if (forks)
+		evlist__cancel_workload(evsel_list);
+
+	return err;
 }
 
 static int run_perf_stat(int argc, const char **argv, int run_idx)
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index f14b7e6ff1dcc..a9df84692d4a8 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -48,6 +48,7 @@
 #include <sys/mman.h>
 #include <sys/prctl.h>
 #include <sys/timerfd.h>
+#include <sys/wait.h>
 
 #include <linux/bitops.h>
 #include <linux/hash.h>
@@ -1484,6 +1485,8 @@ int evlist__prepare_workload(struct evlist *evlist, struct target *target, const
 	int child_ready_pipe[2], go_pipe[2];
 	char bf;
 
+	evlist->workload.cork_fd = -1;
+
 	if (pipe(child_ready_pipe) < 0) {
 		perror("failed to create 'ready' pipe");
 		return -1;
@@ -1536,7 +1539,7 @@ int evlist__prepare_workload(struct evlist *evlist, struct target *target, const
 		 * For cancelling the workload without actually running it,
 		 * the parent will just close workload.cork_fd, without writing
 		 * anything, i.e. read will return zero and we just exit()
-		 * here.
+		 * here (See evlist__cancel_workload()).
 		 */
 		if (ret != 1) {
 			if (ret == -1)
@@ -1600,7 +1603,7 @@ int evlist__prepare_workload(struct evlist *evlist, struct target *target, const
 
 int evlist__start_workload(struct evlist *evlist)
 {
-	if (evlist->workload.cork_fd > 0) {
+	if (evlist->workload.cork_fd >= 0) {
 		char bf = 0;
 		int ret;
 		/*
@@ -1611,12 +1614,24 @@ int evlist__start_workload(struct evlist *evlist)
 			perror("unable to write to pipe");
 
 		close(evlist->workload.cork_fd);
+		evlist->workload.cork_fd = -1;
 		return ret;
 	}
 
 	return 0;
 }
 
+void evlist__cancel_workload(struct evlist *evlist)
+{
+	int status;
+
+	if (evlist->workload.cork_fd >= 0) {
+		close(evlist->workload.cork_fd);
+		evlist->workload.cork_fd = -1;
+		waitpid(evlist->workload.pid, &status, WNOHANG);
+	}
+}
+
 int evlist__parse_sample(struct evlist *evlist, union perf_event *event, struct perf_sample *sample)
 {
 	struct evsel *evsel = evlist__event2evsel(evlist, event);
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index bcc1c6984bb58..888fda751e1a6 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -186,6 +186,7 @@ int evlist__prepare_workload(struct evlist *evlist, struct target *target,
 			     const char *argv[], bool pipe_output,
 			     void (*exec_error)(int signo, siginfo_t *info, void *ucontext));
 int evlist__start_workload(struct evlist *evlist);
+void evlist__cancel_workload(struct evlist *evlist);
 
 struct option;
 
-- 
2.43.0



