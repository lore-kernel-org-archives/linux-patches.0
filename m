Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E1714A4C1;
	Thu, 23 May 2024 13:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470093; cv=none; b=SLD2JdaVBKOzxx4czdRqX5J/j+DGT06nfazZ7MJ/esXLqObb2VIISlfHtkqEl40Fy6rLrfRk2G7unv8XHrNG9HygK+pd+yz+xex4rDJ3TkrAsdTPJxg+5dKeOxfDWYNJwyQo26ZU4kTr4TuaqCZzyV/sbi9W9UJrfJ4M0MNxHWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470093; c=relaxed/simple;
	bh=bBv6J+R/cklU7zu0XqHCLE4PYmLw/kivHsJ4cZAcO0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R4zAtMdXWbdzTrhIHf9wZ10NSpESU1cRicdrYsUvldEJUAkmBrcAEF5yy2QaEBrygMtzn5d8+PXskOTPJyiOBBCGWm/um6VOrZ382BAYu0OS8F8HHzMyjU6iI+6DioMtf/nMY30GSIh9oY7o6fY8kb5gutMS8r/jiQNmBw7/rfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mSdcw1LA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mSdcw1LA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C7C8C3277B;
	Thu, 23 May 2024 13:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470093;
	bh=bBv6J+R/cklU7zu0XqHCLE4PYmLw/kivHsJ4cZAcO0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mSdcw1LAKIBOdC5Jilj4xbMZz9/RBKXEq9fZRWilw27ZXoXh90PKDCkgveZyS1CCw
	 5df3Uw3O14j1oB3OaeWRlWlwymDs23uShBarO4aOdCk4/UtQAeGcOt1ZRe6dFU0R39
	 nk2fyJEFQFCHhbExsDb7OGuNgK7EvqrIpha5P96o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"stable@vger.kernel.org, George Guo" <guodongtai@kylinos.cn>,
	Tom Zanussi <tom.zanussi@linux.intel.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	"Steven Rostedt (VMware)" <rostedt@goodmis.org>,
	George Guo <guodongtai@kylinos.cn>
Subject: [PATCH 4.19 05/18] tracing: Add unified dynamic event framework
Date: Thu, 23 May 2024 15:12:28 +0200
Message-ID: <20240523130325.936734519@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130325.727602650@linuxfoundation.org>
References: <20240523130325.727602650@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu <mhiramat@kernel.org>

commit 5448d44c38557fc15d1c53b608a9c9f0e1ca8f86 upstream.

Add unified dynamic event framework for ftrace kprobes, uprobes
and synthetic events. Those dynamic events can be co-exist on
same file because those syntax doesn't overlap.

This introduces a framework part which provides a unified tracefs
interface and operations.

Link: http://lkml.kernel.org/r/154140852824.17322.12250362185969352095.stgit@devbox

Reviewed-by: Tom Zanussi <tom.zanussi@linux.intel.com>
Tested-by: Tom Zanussi <tom.zanussi@linux.intel.com>
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: George Guo <guodongtai@kylinos.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/Kconfig          |    3 
 kernel/trace/Makefile         |    1 
 kernel/trace/trace.c          |    4 
 kernel/trace/trace_dynevent.c |  210 ++++++++++++++++++++++++++++++++++++++++++
 kernel/trace/trace_dynevent.h |  119 +++++++++++++++++++++++
 5 files changed, 337 insertions(+)
 create mode 100644 kernel/trace/trace_dynevent.c
 create mode 100644 kernel/trace/trace_dynevent.h

--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -518,6 +518,9 @@ config BPF_EVENTS
 	help
 	  This allows the user to attach BPF programs to kprobe events.
 
+config DYNAMIC_EVENTS
+	def_bool n
+
 config PROBE_EVENTS
 	def_bool n
 
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -78,6 +78,7 @@ endif
 ifeq ($(CONFIG_TRACING),y)
 obj-$(CONFIG_KGDB_KDB) += trace_kdb.o
 endif
+obj-$(CONFIG_DYNAMIC_EVENTS) += trace_dynevent.o
 obj-$(CONFIG_PROBE_EVENTS) += trace_probe.o
 obj-$(CONFIG_UPROBE_EVENTS) += trace_uprobe.o
 
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4665,6 +4665,10 @@ static const char readme_msg[] =
 	"\t\t\t  traces\n"
 #endif
 #endif /* CONFIG_STACK_TRACER */
+#ifdef CONFIG_DYNAMIC_EVENTS
+	"  dynamic_events\t\t- Add/remove/show the generic dynamic events\n"
+	"\t\t\t  Write into this file to define/undefine new trace events.\n"
+#endif
 #ifdef CONFIG_KPROBE_EVENTS
 	"  kprobe_events\t\t- Add/remove/show the kernel dynamic events\n"
 	"\t\t\t  Write into this file to define/undefine new trace events.\n"
--- /dev/null
+++ b/kernel/trace/trace_dynevent.c
@@ -0,0 +1,210 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Generic dynamic event control interface
+ *
+ * Copyright (C) 2018 Masami Hiramatsu <mhiramat@kernel.org>
+ */
+
+#include <linux/debugfs.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/mm.h>
+#include <linux/mutex.h>
+#include <linux/tracefs.h>
+
+#include "trace.h"
+#include "trace_dynevent.h"
+
+static DEFINE_MUTEX(dyn_event_ops_mutex);
+static LIST_HEAD(dyn_event_ops_list);
+
+int dyn_event_register(struct dyn_event_operations *ops)
+{
+	if (!ops || !ops->create || !ops->show || !ops->is_busy ||
+	    !ops->free || !ops->match)
+		return -EINVAL;
+
+	INIT_LIST_HEAD(&ops->list);
+	mutex_lock(&dyn_event_ops_mutex);
+	list_add_tail(&ops->list, &dyn_event_ops_list);
+	mutex_unlock(&dyn_event_ops_mutex);
+	return 0;
+}
+
+int dyn_event_release(int argc, char **argv, struct dyn_event_operations *type)
+{
+	struct dyn_event *pos, *n;
+	char *system = NULL, *event, *p;
+	int ret = -ENOENT;
+
+	if (argv[0][1] != ':')
+		return -EINVAL;
+
+	event = &argv[0][2];
+	p = strchr(event, '/');
+	if (p) {
+		system = event;
+		event = p + 1;
+		*p = '\0';
+	}
+	if (event[0] == '\0')
+		return -EINVAL;
+
+	mutex_lock(&event_mutex);
+	for_each_dyn_event_safe(pos, n) {
+		if (type && type != pos->ops)
+			continue;
+		if (pos->ops->match(system, event, pos)) {
+			ret = pos->ops->free(pos);
+			break;
+		}
+	}
+	mutex_unlock(&event_mutex);
+
+	return ret;
+}
+
+static int create_dyn_event(int argc, char **argv)
+{
+	struct dyn_event_operations *ops;
+	int ret;
+
+	if (argv[0][0] == '-')
+		return dyn_event_release(argc, argv, NULL);
+
+	mutex_lock(&dyn_event_ops_mutex);
+	list_for_each_entry(ops, &dyn_event_ops_list, list) {
+		ret = ops->create(argc, (const char **)argv);
+		if (!ret || ret != -ECANCELED)
+			break;
+	}
+	mutex_unlock(&dyn_event_ops_mutex);
+	if (ret == -ECANCELED)
+		ret = -EINVAL;
+
+	return ret;
+}
+
+/* Protected by event_mutex */
+LIST_HEAD(dyn_event_list);
+
+void *dyn_event_seq_start(struct seq_file *m, loff_t *pos)
+{
+	mutex_lock(&event_mutex);
+	return seq_list_start(&dyn_event_list, *pos);
+}
+
+void *dyn_event_seq_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	return seq_list_next(v, &dyn_event_list, pos);
+}
+
+void dyn_event_seq_stop(struct seq_file *m, void *v)
+{
+	mutex_unlock(&event_mutex);
+}
+
+static int dyn_event_seq_show(struct seq_file *m, void *v)
+{
+	struct dyn_event *ev = v;
+
+	if (ev && ev->ops)
+		return ev->ops->show(m, ev);
+
+	return 0;
+}
+
+static const struct seq_operations dyn_event_seq_op = {
+	.start	= dyn_event_seq_start,
+	.next	= dyn_event_seq_next,
+	.stop	= dyn_event_seq_stop,
+	.show	= dyn_event_seq_show
+};
+
+/*
+ * dyn_events_release_all - Release all specific events
+ * @type:	the dyn_event_operations * which filters releasing events
+ *
+ * This releases all events which ->ops matches @type. If @type is NULL,
+ * all events are released.
+ * Return -EBUSY if any of them are in use, and return other errors when
+ * it failed to free the given event. Except for -EBUSY, event releasing
+ * process will be aborted at that point and there may be some other
+ * releasable events on the list.
+ */
+int dyn_events_release_all(struct dyn_event_operations *type)
+{
+	struct dyn_event *ev, *tmp;
+	int ret = 0;
+
+	mutex_lock(&event_mutex);
+	for_each_dyn_event(ev) {
+		if (type && ev->ops != type)
+			continue;
+		if (ev->ops->is_busy(ev)) {
+			ret = -EBUSY;
+			goto out;
+		}
+	}
+	for_each_dyn_event_safe(ev, tmp) {
+		if (type && ev->ops != type)
+			continue;
+		ret = ev->ops->free(ev);
+		if (ret)
+			break;
+	}
+out:
+	mutex_unlock(&event_mutex);
+
+	return ret;
+}
+
+static int dyn_event_open(struct inode *inode, struct file *file)
+{
+	int ret;
+
+	if ((file->f_mode & FMODE_WRITE) && (file->f_flags & O_TRUNC)) {
+		ret = dyn_events_release_all(NULL);
+		if (ret < 0)
+			return ret;
+	}
+
+	return seq_open(file, &dyn_event_seq_op);
+}
+
+static ssize_t dyn_event_write(struct file *file, const char __user *buffer,
+				size_t count, loff_t *ppos)
+{
+	return trace_parse_run_command(file, buffer, count, ppos,
+				       create_dyn_event);
+}
+
+static const struct file_operations dynamic_events_ops = {
+	.owner          = THIS_MODULE,
+	.open           = dyn_event_open,
+	.read           = seq_read,
+	.llseek         = seq_lseek,
+	.release        = seq_release,
+	.write		= dyn_event_write,
+};
+
+/* Make a tracefs interface for controlling dynamic events */
+static __init int init_dynamic_event(void)
+{
+	struct dentry *d_tracer;
+	struct dentry *entry;
+
+	d_tracer = tracing_init_dentry();
+	if (IS_ERR(d_tracer))
+		return 0;
+
+	entry = tracefs_create_file("dynamic_events", 0644, d_tracer,
+				    NULL, &dynamic_events_ops);
+
+	/* Event list interface */
+	if (!entry)
+		pr_warn("Could not create tracefs 'dynamic_events' entry\n");
+
+	return 0;
+}
+fs_initcall(init_dynamic_event);
--- /dev/null
+++ b/kernel/trace/trace_dynevent.h
@@ -0,0 +1,119 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Common header file for generic dynamic events.
+ */
+
+#ifndef _TRACE_DYNEVENT_H
+#define _TRACE_DYNEVENT_H
+
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/seq_file.h>
+
+#include "trace.h"
+
+struct dyn_event;
+
+/**
+ * struct dyn_event_operations - Methods for each type of dynamic events
+ *
+ * These methods must be set for each type, since there is no default method.
+ * Before using this for dyn_event_init(), it must be registered by
+ * dyn_event_register().
+ *
+ * @create: Parse and create event method. This is invoked when user passes
+ *  a event definition to dynamic_events interface. This must not destruct
+ *  the arguments and return -ECANCELED if given arguments doesn't match its
+ *  command prefix.
+ * @show: Showing method. This is invoked when user reads the event definitions
+ *  via dynamic_events interface.
+ * @is_busy: Check whether given event is busy so that it can not be deleted.
+ *  Return true if it is busy, otherwides false.
+ * @free: Delete the given event. Return 0 if success, otherwides error.
+ * @match: Check whether given event and system name match this event.
+ *  Return true if it matches, otherwides false.
+ *
+ * Except for @create, these methods are called under holding event_mutex.
+ */
+struct dyn_event_operations {
+	struct list_head	list;
+	int (*create)(int argc, const char *argv[]);
+	int (*show)(struct seq_file *m, struct dyn_event *ev);
+	bool (*is_busy)(struct dyn_event *ev);
+	int (*free)(struct dyn_event *ev);
+	bool (*match)(const char *system, const char *event,
+			struct dyn_event *ev);
+};
+
+/* Register new dyn_event type -- must be called at first */
+int dyn_event_register(struct dyn_event_operations *ops);
+
+/**
+ * struct dyn_event - Dynamic event list header
+ *
+ * The dyn_event structure encapsulates a list and a pointer to the operators
+ * for making a global list of dynamic events.
+ * User must includes this in each event structure, so that those events can
+ * be added/removed via dynamic_events interface.
+ */
+struct dyn_event {
+	struct list_head		list;
+	struct dyn_event_operations	*ops;
+};
+
+extern struct list_head dyn_event_list;
+
+static inline
+int dyn_event_init(struct dyn_event *ev, struct dyn_event_operations *ops)
+{
+	if (!ev || !ops)
+		return -EINVAL;
+
+	INIT_LIST_HEAD(&ev->list);
+	ev->ops = ops;
+	return 0;
+}
+
+static inline int dyn_event_add(struct dyn_event *ev)
+{
+	lockdep_assert_held(&event_mutex);
+
+	if (!ev || !ev->ops)
+		return -EINVAL;
+
+	list_add_tail(&ev->list, &dyn_event_list);
+	return 0;
+}
+
+static inline void dyn_event_remove(struct dyn_event *ev)
+{
+	lockdep_assert_held(&event_mutex);
+	list_del_init(&ev->list);
+}
+
+void *dyn_event_seq_start(struct seq_file *m, loff_t *pos);
+void *dyn_event_seq_next(struct seq_file *m, void *v, loff_t *pos);
+void dyn_event_seq_stop(struct seq_file *m, void *v);
+int dyn_events_release_all(struct dyn_event_operations *type);
+int dyn_event_release(int argc, char **argv, struct dyn_event_operations *type);
+
+/*
+ * for_each_dyn_event	-	iterate over the dyn_event list
+ * @pos:	the struct dyn_event * to use as a loop cursor
+ *
+ * This is just a basement of for_each macro. Wrap this for
+ * each actual event structure with ops filtering.
+ */
+#define for_each_dyn_event(pos)	\
+	list_for_each_entry(pos, &dyn_event_list, list)
+
+/*
+ * for_each_dyn_event	-	iterate over the dyn_event list safely
+ * @pos:	the struct dyn_event * to use as a loop cursor
+ * @n:		the struct dyn_event * to use as temporary storage
+ */
+#define for_each_dyn_event_safe(pos, n)	\
+	list_for_each_entry_safe(pos, n, &dyn_event_list, list)
+
+#endif


