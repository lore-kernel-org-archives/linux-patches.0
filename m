Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE9953A7;
	Fri,  6 Dec 2024 15:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497624; cv=none; b=IXDtVyttv+2oh6rouGdBb8A9v8xU9NO54YNQeGCKfOdRbwHpx01Nm+pAgwZDIa/rcjP19rXqyyp9sCWeH2Y4iEnVwpoMKVCrStfNLm3OFZbRR31f7N2SvKeRk5bdbwYgqoXSNwWDYsmJmACvQCbAPxzQzCkP2mxw+SpiRkFf6Ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497624; c=relaxed/simple;
	bh=gPf/vi5CwQeV/sqzL7NpLqFay0ZtbxON7d1DGyN9UaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qxvd6u6QTRGqbaofBVX5vMTkC5EexonjLDEfV1iXaSiawXxNx5GQvMuRlcb8/LaRfRqTB88daqQo78Mg1wbLxHwcOqSY0nBNv6pBKmtPymnZlFkmxrEs+NdWIyLbHg5BPyk4J0zg5zd1p6zrkMJm5bXBQXQONIeXEL1el27VxTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pvo/53+s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pvo/53+s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09863C4CED1;
	Fri,  6 Dec 2024 15:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497624;
	bh=gPf/vi5CwQeV/sqzL7NpLqFay0ZtbxON7d1DGyN9UaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pvo/53+sa9tiuzkqXbbrhJ153pIRViDuE04MjVJGLQioXB5gEMVtm851UEmzEXxhN
	 ltjjS/UzC2U4BcYX+CTPu4N6o/Idc1BzTQksCXSIxsuLu79NtEea+2++nX2A2DiIHK
	 hQJqsw2XL7i/Hm9fbrh7MXXOCLQ71hO4B2QIaAeQ=
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
Subject: [PATCH 6.6 342/676] perf stat: Close cork_fd when create_perf_stat_counter() failed
Date: Fri,  6 Dec 2024 15:32:41 +0100
Message-ID: <20241206143706.707728313@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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
index 78c1049221810..8bc526e1cb5f4 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -712,15 +712,19 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
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
@@ -763,7 +767,8 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
 
 			switch (stat_handle_error(counter)) {
 			case COUNTER_FATAL:
-				return -1;
+				err = -1;
+				goto err_out;
 			case COUNTER_RETRY:
 				goto try_again;
 			case COUNTER_SKIP:
@@ -804,7 +809,8 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
 
 				switch (stat_handle_error(counter)) {
 				case COUNTER_FATAL:
-					return -1;
+					err = -1;
+					goto err_out;
 				case COUNTER_RETRY:
 					goto try_again_reset;
 				case COUNTER_SKIP:
@@ -829,8 +835,10 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
 			stat_config.unit_width = l;
 
 		if (evsel__should_store_id(counter) &&
-		    evsel__store_ids(counter, evsel_list))
-			return -1;
+		    evsel__store_ids(counter, evsel_list)) {
+			err = -1;
+			goto err_out;
+		}
 	}
 
 	if (evlist__apply_filters(evsel_list, &counter)) {
@@ -851,20 +859,23 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
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
@@ -874,8 +885,10 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
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
@@ -895,7 +908,8 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
 		if (workload_exec_errno) {
 			const char *emsg = str_error_r(workload_exec_errno, msg, sizeof(msg));
 			pr_err("Workload failed: %s\n", emsg);
-			return -1;
+			err = -1;
+			goto err_out;
 		}
 
 		if (WIFSIGNALED(status))
@@ -942,6 +956,12 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
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
index eb1dd29c538d5..1eadb4f7c1b9d 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -46,6 +46,7 @@
 #include <sys/mman.h>
 #include <sys/prctl.h>
 #include <sys/timerfd.h>
+#include <sys/wait.h>
 
 #include <linux/bitops.h>
 #include <linux/hash.h>
@@ -1412,6 +1413,8 @@ int evlist__prepare_workload(struct evlist *evlist, struct target *target, const
 	int child_ready_pipe[2], go_pipe[2];
 	char bf;
 
+	evlist->workload.cork_fd = -1;
+
 	if (pipe(child_ready_pipe) < 0) {
 		perror("failed to create 'ready' pipe");
 		return -1;
@@ -1464,7 +1467,7 @@ int evlist__prepare_workload(struct evlist *evlist, struct target *target, const
 		 * For cancelling the workload without actually running it,
 		 * the parent will just close workload.cork_fd, without writing
 		 * anything, i.e. read will return zero and we just exit()
-		 * here.
+		 * here (See evlist__cancel_workload()).
 		 */
 		if (ret != 1) {
 			if (ret == -1)
@@ -1528,7 +1531,7 @@ int evlist__prepare_workload(struct evlist *evlist, struct target *target, const
 
 int evlist__start_workload(struct evlist *evlist)
 {
-	if (evlist->workload.cork_fd > 0) {
+	if (evlist->workload.cork_fd >= 0) {
 		char bf = 0;
 		int ret;
 		/*
@@ -1539,12 +1542,24 @@ int evlist__start_workload(struct evlist *evlist)
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
index cb91dc9117a27..12f929ffdf920 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -184,6 +184,7 @@ int evlist__prepare_workload(struct evlist *evlist, struct target *target,
 			     const char *argv[], bool pipe_output,
 			     void (*exec_error)(int signo, siginfo_t *info, void *ucontext));
 int evlist__start_workload(struct evlist *evlist);
+void evlist__cancel_workload(struct evlist *evlist);
 
 struct option;
 
-- 
2.43.0



