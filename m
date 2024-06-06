Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0738A198E79;
	Thu,  6 Jun 2024 14:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683464; cv=none; b=GxhGrJMos94s3ryg3eJG75J0+88croAn6Zhaw3O3T2GU/gvYDMwnE1IYvL1+M3bu6Do+BaCnXhLl8avmyFUGKJ/YeDQK5upuWl6+lwbQMutPka/PuV5iQghzZqqACW3HJIyqrdEs3rUJIB4W9bCLD78oyloTCh0zEVF+/P/KG7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683464; c=relaxed/simple;
	bh=CBlLdC8XXOYzAIVr2OONu7iWu43XjnIScSJ7SW03OjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A77qVGmngAUwLnMsmqBep1+7xyYfsctHglr94UxdDQc7JTz7NjweFtcX3f46EosgFSvTLgbOiIx3JiEC/L+hct3kpI/X+1m5J6kPZM/CEQozOfC+Q6BnUttApuFaiIIlYJMlZj35lUGvjsLqkLIqCMaB8k0q56xuJfrwMt6l4lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rE1bLWJY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rE1bLWJY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C59E2C2BD10;
	Thu,  6 Jun 2024 14:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683463;
	bh=CBlLdC8XXOYzAIVr2OONu7iWu43XjnIScSJ7SW03OjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rE1bLWJY+b1uOwQlKgNNYpnNDRm4T7nF0du2WcvC6JyLSa1Dsr/rRzqwnU2felXh5
	 DmbQJJSERjzg0TJlQXsz7eR9vacD8ym/eajX0oyJG9GfPrNjC35OcIzJ34jt916LJ9
	 n2i0GbmL6PotEXCCTLLRkNJLiaNhK+uaW60YzSSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ian Rogers <irogers@google.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andi Kleen <ak@linux.intel.com>,
	Athira Jajeev <atrajeev@linux.vnet.ibm.com>,
	Changbin Du <changbin.du@huawei.com>,
	Colin Ian King <colin.i.king@gmail.com>,
	Dmitrii Dolgov <9erthalion6@gmail.com>,
	German Gomez <german.gomez@arm.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@arm.com>,
	Jiri Olsa <jolsa@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Kajol Jain <kjain@linux.ibm.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Leo Yan <leo.yan@linaro.org>,
	Li Dong <lidong@vivo.com>,
	Liam Howlett <liam.howlett@oracle.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Ming Wang <wangming01@loongson.cn>,
	Namhyung Kim <namhyung@kernel.org>,
	Nick Terrell <terrelln@fb.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Sandipan Das <sandipan.das@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	"Steinar H. Gunderson" <sesse@google.com>,
	Vincent Whitchurch <vincent.whitchurch@axis.com>,
	Wenyu Liu <liuwenyu7@huawei.com>,
	Yang Jihong <yangjihong1@huawei.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 408/744] perf machine thread: Remove exited threads by default
Date: Thu,  6 Jun 2024 16:01:20 +0200
Message-ID: <20240606131745.552633248@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Ian Rogers <irogers@google.com>

[ Upstream commit 9ffa6c7512ca7aaeb30e596e2c247cb1fae7123a ]

'struct thread' values hold onto references to mmaps, DSOs, etc. When a
thread exits it is necessary to clean all of this memory up by removing
the thread from the machine's threads. Some tools require this doesn't
happen, such as auxtrace events, 'perf report' if offcpu events exist or
if a task list is being generated, so add a 'struct symbol_conf' member
to make the behavior optional. When an exited thread is left in the
machine's threads, mark it as exited.

This change relates to commit 40826c45eb0b8856 ("perf thread: Remove
notion of dead threads") . Dead threads were removed as they had a
reference count of 0 and were difficult to reason about with the
reference count checker. Here a thread is removed from threads when it
exits, unless via symbol_conf the exited thread isn't remove and is
marked as exited. Reference counting behaves as it normally does.

Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Athira Jajeev <atrajeev@linux.vnet.ibm.com>
Cc: Changbin Du <changbin.du@huawei.com>
Cc: Colin Ian King <colin.i.king@gmail.com>
Cc: Dmitrii Dolgov <9erthalion6@gmail.com>
Cc: German Gomez <german.gomez@arm.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@arm.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: K Prateek Nayak <kprateek.nayak@amd.com>
Cc: Kajol Jain <kjain@linux.ibm.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Li Dong <lidong@vivo.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Ming Wang <wangming01@loongson.cn>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Nick Terrell <terrelln@fb.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: Sandipan Das <sandipan.das@amd.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Steinar H. Gunderson <sesse@google.com>
Cc: Vincent Whitchurch <vincent.whitchurch@axis.com>
Cc: Wenyu Liu <liuwenyu7@huawei.com>
Cc: Yang Jihong <yangjihong1@huawei.com>
Link: https://lore.kernel.org/r/20231102175735.2272696-6-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: aaf494cf483a ("perf annotate: Fix annotation_calc_lines() to pass correct address to get_srcline()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-report.c   |  7 +++++++
 tools/perf/util/machine.c     | 10 +++++++---
 tools/perf/util/session.c     |  5 +++++
 tools/perf/util/symbol_conf.h |  3 ++-
 tools/perf/util/thread.h      | 14 ++++++++++++++
 5 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index dcedfe00f04db..749246817aed3 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -1411,6 +1411,13 @@ int cmd_report(int argc, const char **argv)
 	if (ret < 0)
 		goto exit;
 
+	/*
+	 * tasks_mode require access to exited threads to list those that are in
+	 * the data file. Off-cpu events are synthesized after other events and
+	 * reference exited threads.
+	 */
+	symbol_conf.keep_exited_threads = true;
+
 	annotation_options__init(&report.annotation_opts);
 
 	ret = perf_config(report__config, &report);
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index e6a8d758f6fe4..7c6874804660e 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -2158,9 +2158,13 @@ int machine__process_exit_event(struct machine *machine, union perf_event *event
 	if (dump_trace)
 		perf_event__fprintf_task(event, stdout);
 
-	if (thread != NULL)
-		thread__put(thread);
-
+	if (thread != NULL) {
+		if (symbol_conf.keep_exited_threads)
+			thread__set_exited(thread, /*exited=*/true);
+		else
+			machine__remove_thread(machine, thread);
+	}
+	thread__put(thread);
 	return 0;
 }
 
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 1e9aa8ed15b64..c6afba7ab1a51 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -115,6 +115,11 @@ static int perf_session__open(struct perf_session *session, int repipe_fd)
 		return -1;
 	}
 
+	if (perf_header__has_feat(&session->header, HEADER_AUXTRACE)) {
+		/* Auxiliary events may reference exited threads, hold onto dead ones. */
+		symbol_conf.keep_exited_threads = true;
+	}
+
 	if (perf_data__is_pipe(data))
 		return 0;
 
diff --git a/tools/perf/util/symbol_conf.h b/tools/perf/util/symbol_conf.h
index 2b2fb9e224b00..6040286e07a65 100644
--- a/tools/perf/util/symbol_conf.h
+++ b/tools/perf/util/symbol_conf.h
@@ -43,7 +43,8 @@ struct symbol_conf {
 			disable_add2line_warn,
 			buildid_mmap2,
 			guest_code,
-			lazy_load_kernel_maps;
+			lazy_load_kernel_maps,
+			keep_exited_threads;
 	const char	*vmlinux_name,
 			*kallsyms_name,
 			*source_prefix,
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index e79225a0ea46b..0df775b5c1105 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -36,13 +36,22 @@ struct thread_rb_node {
 };
 
 DECLARE_RC_STRUCT(thread) {
+	/** @maps: mmaps associated with this thread. */
 	struct maps		*maps;
 	pid_t			pid_; /* Not all tools update this */
+	/** @tid: thread ID number unique to a machine. */
 	pid_t			tid;
+	/** @ppid: parent process of the process this thread belongs to. */
 	pid_t			ppid;
 	int			cpu;
 	int			guest_cpu; /* For QEMU thread */
 	refcount_t		refcnt;
+	/**
+	 * @exited: Has the thread had an exit event. Such threads are usually
+	 * removed from the machine's threads but some events/tools require
+	 * access to dead threads.
+	 */
+	bool			exited;
 	bool			comm_set;
 	int			comm_len;
 	struct list_head	namespaces_list;
@@ -189,6 +198,11 @@ static inline refcount_t *thread__refcnt(struct thread *thread)
 	return &RC_CHK_ACCESS(thread)->refcnt;
 }
 
+static inline void thread__set_exited(struct thread *thread, bool exited)
+{
+	RC_CHK_ACCESS(thread)->exited = exited;
+}
+
 static inline bool thread__comm_set(const struct thread *thread)
 {
 	return RC_CHK_ACCESS(thread)->comm_set;
-- 
2.43.0



