Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DF782253F7;
	Thu, 12 Dec 2024 16:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019770; cv=none; b=SMcLqxZXGZuUTecHf2FziZdvJ7cUXqERhLGAT57KA4OO6G4qsvnE/ODO4OHrk0bYve0NRZga7HUJGC8vrJF/TWqIXUs96eb+GqmaoST1tue4vEtteXErUdwDckrU43tzJE4TXkxzHz1Q7587O1Ural4bewg0/PIRXsTF1pZP/f0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019770; c=relaxed/simple;
	bh=N2yCpeUHfitCTGeolK6iNFb5SkIg7QORChopS/n4HnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Enh0yiNJHaTk7NEDkjeF+Kxfq4JdZwKBToU4husk5RgZ22JLJsfZ0baGMqT3AxjbQo7f9+7Ndj2qWGPZENOdMB1NebQ5Tz4HhB3mxgqHOdsqpxll21je2wieF1h8PkcNqYEA3CDekywzb5CKnUdtqUKKgDRG88o7ZdDCOH+DdQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TZuA//jw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TZuA//jw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 416FAC4CED3;
	Thu, 12 Dec 2024 16:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019770;
	bh=N2yCpeUHfitCTGeolK6iNFb5SkIg7QORChopS/n4HnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TZuA//jwBp4y28qeTybLRkqsXEFhger/uSNsT1H+SXB+iwfY8oA6RonrLkE1yvfpS
	 /B+obqZjjOqjANTAVSaL0QmqS6tA2hS38HFlIK6bJ3jlt6WsXTbE9xN8cP/zkDAUiM
	 +rDrwnuQk8BJ60bxqW8j1+v2WAAfJpkxCrnFJECM=
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
Subject: [PATCH 6.1 263/772] perf stat: Close cork_fd when create_perf_stat_counter() failed
Date: Thu, 12 Dec 2024 15:53:28 +0100
Message-ID: <20241212144400.783929759@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index bdd8dd54fdb63..79e058ff8a33a 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -756,15 +756,19 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
 		evlist__set_leader(evsel_list);
 
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
@@ -805,7 +809,8 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
 
 			switch (stat_handle_error(counter)) {
 			case COUNTER_FATAL:
-				return -1;
+				err = -1;
+				goto err_out;
 			case COUNTER_RETRY:
 				goto try_again;
 			case COUNTER_SKIP:
@@ -846,7 +851,8 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
 
 				switch (stat_handle_error(counter)) {
 				case COUNTER_FATAL:
-					return -1;
+					err = -1;
+					goto err_out;
 				case COUNTER_RETRY:
 					goto try_again_reset;
 				case COUNTER_SKIP:
@@ -871,8 +877,10 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
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
@@ -893,20 +901,23 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
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
@@ -916,8 +927,10 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
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
@@ -937,7 +950,8 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
 		if (workload_exec_errno) {
 			const char *emsg = str_error_r(workload_exec_errno, msg, sizeof(msg));
 			pr_err("Workload failed: %s\n", emsg);
-			return -1;
+			err = -1;
+			goto err_out;
 		}
 
 		if (WIFSIGNALED(status))
@@ -986,6 +1000,12 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
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
index ca08e6dc8b232..dca6843ea3225 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -42,6 +42,7 @@
 #include <sys/mman.h>
 #include <sys/prctl.h>
 #include <sys/timerfd.h>
+#include <sys/wait.h>
 
 #include <linux/bitops.h>
 #include <linux/hash.h>
@@ -1392,6 +1393,8 @@ int evlist__prepare_workload(struct evlist *evlist, struct target *target, const
 	int child_ready_pipe[2], go_pipe[2];
 	char bf;
 
+	evlist->workload.cork_fd = -1;
+
 	if (pipe(child_ready_pipe) < 0) {
 		perror("failed to create 'ready' pipe");
 		return -1;
@@ -1444,7 +1447,7 @@ int evlist__prepare_workload(struct evlist *evlist, struct target *target, const
 		 * For cancelling the workload without actually running it,
 		 * the parent will just close workload.cork_fd, without writing
 		 * anything, i.e. read will return zero and we just exit()
-		 * here.
+		 * here (See evlist__cancel_workload()).
 		 */
 		if (ret != 1) {
 			if (ret == -1)
@@ -1508,7 +1511,7 @@ int evlist__prepare_workload(struct evlist *evlist, struct target *target, const
 
 int evlist__start_workload(struct evlist *evlist)
 {
-	if (evlist->workload.cork_fd > 0) {
+	if (evlist->workload.cork_fd >= 0) {
 		char bf = 0;
 		int ret;
 		/*
@@ -1519,12 +1522,24 @@ int evlist__start_workload(struct evlist *evlist)
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
index 16734c6756b3c..dc2197069cdc6 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -187,6 +187,7 @@ int evlist__prepare_workload(struct evlist *evlist, struct target *target,
 			     const char *argv[], bool pipe_output,
 			     void (*exec_error)(int signo, siginfo_t *info, void *ucontext));
 int evlist__start_workload(struct evlist *evlist);
+void evlist__cancel_workload(struct evlist *evlist);
 
 struct option;
 
-- 
2.43.0



