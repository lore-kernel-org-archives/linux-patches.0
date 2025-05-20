Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62B511FBE9E;
	Tue, 20 May 2025 14:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750098; cv=none; b=rpGcqNyBexPu4rwQV60tkyNWLIYZ3IYSAxnUPp0juJJnWDfZhuh3sj/Eo6nKrAQQhxPyJ+XZNbQAtBh27OBQqf3/ltY9FsBFuWq1W4sRLjr8ClTI9qa9gi03tfGSU9rvxoxZGy+pC7pkkdnSC1a96h4m5OJpmQkmWIswZ4+BUds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750098; c=relaxed/simple;
	bh=VWFPbXNLOj0Ft9ycqM/MHT6oen2KyZatrUnEZIUws4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tCi5mMKeuHeLWyw/rF9cTvzkKl0ZlXwCrDdh0SdbmCJAOby6nZHwmGW4dt7xuhaWov1WngECUNN8rdpb2D9qTwq5kA2KCGasEuzxjqCeFXjKBucGKpRDNrIGbIpkZ3BRSycbj5WRfJ99an30bJ3dKLHn/9lh0wImyx6rLgsK9Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fexQsWRN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fexQsWRN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C79A7C4CEE9;
	Tue, 20 May 2025 14:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750098;
	bh=VWFPbXNLOj0Ft9ycqM/MHT6oen2KyZatrUnEZIUws4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fexQsWRNfjB0mKPOWLCza2vETcQ8R22ctiBQDETI7VuWVFrnxrEpJLH9nxsav5tef
	 iJJPVwWdGeTojlDV3c+rUlK1RLqDPKpLZB19L77F+JOOQ9U1IG7FfU0mEFw6eFymE8
	 OD5YC5rVlF1ljG6eTgNvA4zNQK6jPk0dd+xDd6XI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Cacheux <paulcacheux@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 011/143] tracing: probes: Fix a possible race in trace_probe_log APIs
Date: Tue, 20 May 2025 15:49:26 +0200
Message-ID: <20250520125810.495227906@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit fd837de3c9cb1a162c69bc1fb1f438467fe7f2f5 ]

Since the shared trace_probe_log variable can be accessed and
modified via probe event create operation of kprobe_events,
uprobe_events, and dynamic_events, it should be protected.
In the dynamic_events, all operations are serialized by
`dyn_event_ops_mutex`. But kprobe_events and uprobe_events
interfaces are not serialized.

To solve this issue, introduces dyn_event_create(), which runs
create() operation under the mutex, for kprobe_events and
uprobe_events. This also uses lockdep to check the mutex is
held when using trace_probe_log* APIs.

Link: https://lore.kernel.org/all/174684868120.551552.3068655787654268804.stgit@devnote2/

Reported-by: Paul Cacheux <paulcacheux@gmail.com>
Closes: https://lore.kernel.org/all/20250510074456.805a16872b591e2971a4d221@kernel.org/
Fixes: ab105a4fb894 ("tracing: Use tracing error_log with probe events")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_dynevent.c | 16 +++++++++++++++-
 kernel/trace/trace_dynevent.h |  1 +
 kernel/trace/trace_kprobe.c   |  2 +-
 kernel/trace/trace_probe.c    |  9 +++++++++
 kernel/trace/trace_uprobe.c   |  2 +-
 5 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace_dynevent.c b/kernel/trace/trace_dynevent.c
index 4376887e0d8aa..c9b0533407ede 100644
--- a/kernel/trace/trace_dynevent.c
+++ b/kernel/trace/trace_dynevent.c
@@ -16,7 +16,7 @@
 #include "trace_output.h"	/* for trace_event_sem */
 #include "trace_dynevent.h"
 
-static DEFINE_MUTEX(dyn_event_ops_mutex);
+DEFINE_MUTEX(dyn_event_ops_mutex);
 static LIST_HEAD(dyn_event_ops_list);
 
 bool trace_event_dyn_try_get_ref(struct trace_event_call *dyn_call)
@@ -125,6 +125,20 @@ int dyn_event_release(const char *raw_command, struct dyn_event_operations *type
 	return ret;
 }
 
+/*
+ * Locked version of event creation. The event creation must be protected by
+ * dyn_event_ops_mutex because of protecting trace_probe_log.
+ */
+int dyn_event_create(const char *raw_command, struct dyn_event_operations *type)
+{
+	int ret;
+
+	mutex_lock(&dyn_event_ops_mutex);
+	ret = type->create(raw_command);
+	mutex_unlock(&dyn_event_ops_mutex);
+	return ret;
+}
+
 static int create_dyn_event(const char *raw_command)
 {
 	struct dyn_event_operations *ops;
diff --git a/kernel/trace/trace_dynevent.h b/kernel/trace/trace_dynevent.h
index 936477a111d3e..beee3f8d75444 100644
--- a/kernel/trace/trace_dynevent.h
+++ b/kernel/trace/trace_dynevent.h
@@ -100,6 +100,7 @@ void *dyn_event_seq_next(struct seq_file *m, void *v, loff_t *pos);
 void dyn_event_seq_stop(struct seq_file *m, void *v);
 int dyn_events_release_all(struct dyn_event_operations *type);
 int dyn_event_release(const char *raw_command, struct dyn_event_operations *type);
+int dyn_event_create(const char *raw_command, struct dyn_event_operations *type);
 
 /*
  * for_each_dyn_event	-	iterate over the dyn_event list
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 935a886af40c9..6b9c3f3f870f4 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1090,7 +1090,7 @@ static int create_or_delete_trace_kprobe(const char *raw_command)
 	if (raw_command[0] == '-')
 		return dyn_event_release(raw_command, &trace_kprobe_ops);
 
-	ret = trace_kprobe_create(raw_command);
+	ret = dyn_event_create(raw_command, &trace_kprobe_ops);
 	return ret == -ECANCELED ? -EINVAL : ret;
 }
 
diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index 578919962e5df..ae20ad7f74616 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -154,9 +154,12 @@ static const struct fetch_type *find_fetch_type(const char *type, unsigned long
 }
 
 static struct trace_probe_log trace_probe_log;
+extern struct mutex dyn_event_ops_mutex;
 
 void trace_probe_log_init(const char *subsystem, int argc, const char **argv)
 {
+	lockdep_assert_held(&dyn_event_ops_mutex);
+
 	trace_probe_log.subsystem = subsystem;
 	trace_probe_log.argc = argc;
 	trace_probe_log.argv = argv;
@@ -165,11 +168,15 @@ void trace_probe_log_init(const char *subsystem, int argc, const char **argv)
 
 void trace_probe_log_clear(void)
 {
+	lockdep_assert_held(&dyn_event_ops_mutex);
+
 	memset(&trace_probe_log, 0, sizeof(trace_probe_log));
 }
 
 void trace_probe_log_set_index(int index)
 {
+	lockdep_assert_held(&dyn_event_ops_mutex);
+
 	trace_probe_log.index = index;
 }
 
@@ -178,6 +185,8 @@ void __trace_probe_log_err(int offset, int err_type)
 	char *command, *p;
 	int i, len = 0, pos = 0;
 
+	lockdep_assert_held(&dyn_event_ops_mutex);
+
 	if (!trace_probe_log.argv)
 		return;
 
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index b085a8a164ea0..9916677acf24e 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -739,7 +739,7 @@ static int create_or_delete_trace_uprobe(const char *raw_command)
 	if (raw_command[0] == '-')
 		return dyn_event_release(raw_command, &trace_uprobe_ops);
 
-	ret = trace_uprobe_create(raw_command);
+	ret = dyn_event_create(raw_command, &trace_uprobe_ops);
 	return ret == -ECANCELED ? -EINVAL : ret;
 }
 
-- 
2.39.5



