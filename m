Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C571046D54F;
	Tue, 21 Jul 2026 15:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648630; cv=none; b=mjbyfY05vQ/LQ1lqwcxY9c596ScsBKpoLHoayNIXb04t5XxJWpfjHxdHcmiMNPlSwH7CKfr2HTuXMgUPS+CTzd9HMWn0Ko5fM7Y9vP4Qy8V0KXbrvXCuOQihkdtFG0JM/a+sK40xJi4v4Dc3l5Oz//gjHYJr2Sjd4f55/TdMmVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648630; c=relaxed/simple;
	bh=Fj1nEucQM5zc0VmbmFUe2wW+fPsDY2PqaZy4OyOZOTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LZ4gr3M0QW/gUha7sQlUNMrjCDpktdKFaf9bdnnobd1TbP9sQZYSJsSTGhiTJ9q69lQmToLbmM9PUq5ypQ4hRTU6m8gmSA35PGF6SJLTNXyV0aOpjXEUBK7QIFuNF8YVhfCZ+zzPtTvlD5R4qxNbbd0jeoQ5Va+9errDXxYj4rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KN4S3lXX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KN4S3lXX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3719D1F00A3A;
	Tue, 21 Jul 2026 15:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648629;
	bh=NUqnXSY3BCiQGmJdJa58dKiayUCOd4Jr0d1syZKWeqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KN4S3lXXyqISzoHdPNrs0j8uTYxt5/gN2dVkjQsKM7sboxOxOpGhpD5/hqDaF4QIp
	 w9nPwoVz3XDRio+dasCdJlLNQy+f+v2fDiURuDGFUgO/Gkl0cxFbHd4I+8/xzE1u2n
	 nZNLfCqz0SNF7H2IuIbL1XAfIzFLe6PK9phSprbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Crystal Wood <crwood@redhat.com>,
	Tomas Glozar <tglozar@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0228/2077] rtla: Stop the record trace on interrupt
Date: Tue, 21 Jul 2026 16:58:21 +0200
Message-ID: <20260721152558.056404194@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Crystal Wood <crwood@redhat.com>

[ Upstream commit f03a59f949176ce4312cb466245d1243aaf40389 ]

Before, when rtla got a signal, it stopped the main trace but not the
record trace.  With "--on-end trace", this can lead to
save_trace_to_file() failing to keep up, especially on a debug kernel.
Plus, it adds post-stoppage noise to the trace file.

Signed-off-by: Crystal Wood <crwood@redhat.com>
Fixes: c73cab9dbed0 ("rtla/timerlat_hist: Stop timerlat tracer on signal")
Fixes: a4dfce7559d7 ("rtla/timerlat_top: Stop timerlat tracer on signal")
Fixes: 3aadb65db5d6 ("rtla/timerlat: Add action on end feature")
Link: https://lore.kernel.org/r/20260512173731.2151841-1-crwood@redhat.com
Signed-off-by: Tomas Glozar <tglozar@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/tracing/rtla/src/common.c   | 19 +++++++++++--------
 tools/tracing/rtla/src/common.h   |  1 -
 tools/tracing/rtla/src/timerlat.c |  2 +-
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/tools/tracing/rtla/src/common.c b/tools/tracing/rtla/src/common.c
index bc9d01ddd10295..bfeccc6222e5bc 100644
--- a/tools/tracing/rtla/src/common.c
+++ b/tools/tracing/rtla/src/common.c
@@ -10,7 +10,7 @@
 
 #include "common.h"
 
-struct trace_instance *trace_inst;
+struct osnoise_tool *trace_tool;
 volatile int stop_tracing;
 int nr_cpus;
 
@@ -21,12 +21,16 @@ static void stop_trace(int sig)
 		 * Stop requested twice in a row; abort event processing and
 		 * exit immediately
 		 */
-		tracefs_iterate_stop(trace_inst->inst);
+		if (trace_tool)
+			tracefs_iterate_stop(trace_tool->trace.inst);
 		return;
 	}
 	stop_tracing = 1;
-	if (trace_inst)
-		trace_instance_stop(trace_inst);
+	if (trace_tool) {
+		trace_instance_stop(&trace_tool->trace);
+		if (trace_tool->record)
+			trace_instance_stop(&trace_tool->record->trace);
+	}
 }
 
 /*
@@ -255,11 +259,10 @@ int run_tool(struct tool_ops *ops, int argc, char *argv[])
 	tool->params = params;
 
 	/*
-	 * Save trace instance into global variable so that SIGINT can stop
-	 * the timerlat tracer.
+	 * Expose the tool to signal handlers so they can stop the trace.
 	 * Otherwise, rtla could loop indefinitely when overloaded.
 	 */
-	trace_inst = &tool->trace;
+	trace_tool = tool;
 
 	retval = ops->apply_config(tool);
 	if (retval) {
@@ -267,7 +270,7 @@ int run_tool(struct tool_ops *ops, int argc, char *argv[])
 		goto out_free;
 	}
 
-	retval = enable_tracer_by_name(trace_inst->inst, ops->tracer);
+	retval = enable_tracer_by_name(tool->trace.inst, ops->tracer);
 	if (retval) {
 		err_msg("Failed to enable %s tracer\n", ops->tracer);
 		goto out_free;
diff --git a/tools/tracing/rtla/src/common.h b/tools/tracing/rtla/src/common.h
index 8921807bda988c..505babf386373b 100644
--- a/tools/tracing/rtla/src/common.h
+++ b/tools/tracing/rtla/src/common.h
@@ -54,7 +54,6 @@ struct osnoise_context {
 	int			opt_workload;
 };
 
-extern struct trace_instance *trace_inst;
 extern volatile int stop_tracing;
 
 struct hist_params {
diff --git a/tools/tracing/rtla/src/timerlat.c b/tools/tracing/rtla/src/timerlat.c
index f8c057518d2237..637f68d684f5f5 100644
--- a/tools/tracing/rtla/src/timerlat.c
+++ b/tools/tracing/rtla/src/timerlat.c
@@ -202,7 +202,7 @@ void timerlat_analyze(struct osnoise_tool *tool, bool stopped)
 		 * If the trace did not stop with --aa-only, at least print
 		 * the max known latency.
 		 */
-		max_lat = tracefs_instance_file_read(trace_inst->inst, "tracing_max_latency", NULL);
+		max_lat = tracefs_instance_file_read(tool->trace.inst, "tracing_max_latency", NULL);
 		if (max_lat) {
 			printf("  Max latency was %s\n", max_lat);
 			free(max_lat);
-- 
2.53.0



