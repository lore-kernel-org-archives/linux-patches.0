Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 927C3241103;
	Tue, 20 May 2025 13:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749176; cv=none; b=MyB8yaUx1LCjUelwyn1aYHqPMw1IMW+7R6T5cbU6Hevts4AU1p2PJHfefWqfvg6OLMZ4r97zowCcqCOR/oPlpdZjeWexC7c44AxkKub7ZuAYgbAQq7Hh6uIDKSag16JuyWvIs31t/9abYibKIk5+31pN+jOZ+s6dYYay247UnYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749176; c=relaxed/simple;
	bh=2cGgVZ8GGDJX55T20NdeHJUHqUmhJnJnokvOYBxf3fA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bO0wphfy17hSARtn2CMZZ4M1PpiJC+AnQkNDCXyapO+HrE4Ag28kyiykLWWMYsYJ0c7MnU6U0EfQ0ALUDJpFDsGMM3tq5MAWJMJ/GrV0jEPxAaDK7d8GahdekvxPm4nOe7al4/UjN3zffl9lOoykCvCoZEW4oGNnAfK6GehaMaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dxbkHQdP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dxbkHQdP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 326BCC4CEE9;
	Tue, 20 May 2025 13:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749176;
	bh=2cGgVZ8GGDJX55T20NdeHJUHqUmhJnJnokvOYBxf3fA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dxbkHQdPLzhMy8teq3BZWnKT5lte7qffdW1X14S/CjSq1kD2FiRCbul6BPO/FE0bd
	 Aiea/jT/9rUp6bFf2Ycy0XFUrFEJzvUDVDlxkK4s0XUnbfLy6vmf7F3s3Lu+ulqaFj
	 HuIYIEMPb7M4G/A31hmh45RVAa6o5+LuWPisROiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Cacheux <paulcacheux@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 02/59] tracing: probes: Fix a possible race in trace_probe_log APIs
Date: Tue, 20 May 2025 15:49:53 +0200
Message-ID: <20250520125753.936384265@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125753.836407405@linuxfoundation.org>
References: <20250520125753.836407405@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d4f7137233234..6d0e9f869ad68 100644
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
index 3a1c54c9918b4..e062f4efec8d0 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -971,7 +971,7 @@ static int create_or_delete_trace_kprobe(const char *raw_command)
 	if (raw_command[0] == '-')
 		return dyn_event_release(raw_command, &trace_kprobe_ops);
 
-	ret = trace_kprobe_create(raw_command);
+	ret = dyn_event_create(raw_command, &trace_kprobe_ops);
 	return ret == -ECANCELED ? -EINVAL : ret;
 }
 
diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index d2a1b7f030685..38fa6cc118daf 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -143,9 +143,12 @@ static const struct fetch_type *find_fetch_type(const char *type)
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
@@ -154,11 +157,15 @@ void trace_probe_log_init(const char *subsystem, int argc, const char **argv)
 
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
 
@@ -167,6 +174,8 @@ void __trace_probe_log_err(int offset, int err_type)
 	char *command, *p;
 	int i, len = 0, pos = 0;
 
+	lockdep_assert_held(&dyn_event_ops_mutex);
+
 	if (!trace_probe_log.argv)
 		return;
 
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 720b46b34ab94..322d56661d04a 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -729,7 +729,7 @@ static int create_or_delete_trace_uprobe(const char *raw_command)
 	if (raw_command[0] == '-')
 		return dyn_event_release(raw_command, &trace_uprobe_ops);
 
-	ret = trace_uprobe_create(raw_command);
+	ret = dyn_event_create(raw_command, &trace_uprobe_ops);
 	return ret == -ECANCELED ? -EINVAL : ret;
 }
 
-- 
2.39.5



