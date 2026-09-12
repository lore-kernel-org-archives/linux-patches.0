Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 597DB3783B0;
	Sat, 12 Sep 2026 16:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231499; cv=none; b=sqpnwDbGtI4mf3tx5cy6O844yqxHkahl7HsAx04gHozNznRIsk2KLpS9Q/zWezTTbCjUp6IcpY16Rw1sBxc7ZjYiGQ2wIS8MimXGdN/vkaxgCF/H2eKGXMHDkoB/EE/n4HVU/kd5GrF/v4q86ekDooEytqcyMKEU2gg0J9y6tBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231499; c=relaxed/simple;
	bh=AhGXG0Hsn2BtcYEuJKntJSN3r6HjR8eeAgYJ26JH7qA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vGli2rZ/XHiWmzdnlhKvPSdbmK38oYBoFhWwurJnI40mLvEvw1IlCjD4GJhOJzwboKKlMEk7ZhNFmMdaKQlJWvG81efqpphuYeYekKAQzd4Te2Iyne0iefwOASJfErjWQMPQd04kptHIxHCMjdMBnqipbboImLrUO0KNpdFL/ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=opeBuj6f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="opeBuj6f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B031F000FF;
	Sat, 12 Sep 2026 16:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231498;
	bh=kPZeMTCc6WxOerFq9hfnkcq7am9rlkSyfuX37QT9H80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=opeBuj6fo7UkO+O5Dv0eOWKc5gVtbZ7cDbfJ7e4Ze9jGwny5+5CLTU5fWOO8hs4yL
	 ghbudT0Gtkh0jOxNemYDj2Yv7udnR/q4HDZcE9PyiD3rZMBRgJizz3YRFkQI4/Lhrd
	 Shy4jMTlaYv2Sr8x3qlzgRDqwt0aXcgVFObVYVnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1009/1191] tracing: Remove "__attribute__()" from the type field of event format
Date: Sat, 12 Sep 2026 09:02:17 +0200
Message-ID: <20260912065610.857841687@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit 1a967e92bf47cf5170336b88d748117c700edc47 ]

With CONFIG_DEBUG_INFO_BTF=y and PAHOLE_HAS_BTF_TAG=y, `__user` is
converted to `__attribute__((btf_type_tag("user")))`. In this case,
some syscall events have it for __user data, like below;

/sys/kernel/tracing # cat events/syscalls/sys_enter_openat/format
name: sys_enter_openat
ID: 720
format:
        field:unsigned short common_type;       offset:0;       size:2; signed:0;
        field:unsigned char common_flags;       offset:2;       size:1; signed:0;
        field:unsigned char common_preempt_count;       offset:3;       size:1; signed:0;
        field:int common_pid;   offset:4;       size:4; signed:1;

        field:int __syscall_nr; offset:8;       size:4; signed:1;
        field:int dfd;  offset:16;      size:8; signed:0;
        field:const char __attribute__((btf_type_tag("user"))) * filename;      offset:24;      size:8; signed:0;
        field:int flags;        offset:32;      size:8; signed:0;
        field:umode_t mode;     offset:40;      size:8; signed:0;

Then the trace event filter fails to set the string acceptable flag
(FILTER_PTR_STRING) to the field and rejects setting string filter;

 # echo 'filename.ustring ~ "*ftracetest-dir.wbx24v*"' \
    >> events/syscalls/sys_enter_openat/filter
 sh: write error: Invalid argument
 # cat error_log
 [  723.743637] event filter parse error: error: Expecting numeric field
   Command: filename.ustring ~ "*ftracetest-dir.wbx24v*"

Since this __attribute__ makes format parsing complicated and not
needed, remove the __attribute__(.*) from the type string.

Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Link: https://lore.kernel.org/175376583493.1688759.12333973498014733551.stgit@mhiramat.tok.corp.google.com
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Stable-dep-of: ae70b04ab9c7 ("tracing: Have trace_event_update_all() only handle module that is loading")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace.c        |  28 +++++---
 kernel/trace/trace.h        |   4 +-
 kernel/trace/trace_events.c | 128 ++++++++++++++++++++++++++++++------
 3 files changed, 127 insertions(+), 33 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 5ef1c79dc5c9e..a5f9f666a49f5 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -6192,17 +6192,27 @@ static inline void trace_insert_eval_map_file(struct module *mod,
 			      struct trace_eval_map **start, int len) { }
 #endif /* !CONFIG_TRACE_EVAL_MAP_FILE */
 
-static void trace_insert_eval_map(struct module *mod,
-				  struct trace_eval_map **start, int len)
+static void
+trace_event_update_with_eval_map(struct module *mod,
+				 struct trace_eval_map **start,
+				 int len)
 {
 	struct trace_eval_map **map;
 
-	if (len <= 0)
-		return;
+	/* Always run sanitizer only if btf_type_tag attr exists. */
+	if (len <= 0) {
+		if (!(IS_ENABLED(CONFIG_DEBUG_INFO_BTF) &&
+		      IS_ENABLED(CONFIG_PAHOLE_HAS_BTF_TAG) &&
+		      __has_attribute(btf_type_tag)))
+			return;
+	}
 
 	map = start;
 
-	trace_event_eval_update(map, len);
+	trace_event_update_all(map, len);
+
+	if (len <= 0)
+		return;
 
 	trace_insert_eval_map_file(mod, start, len);
 }
@@ -9835,7 +9845,7 @@ static void __init eval_map_work_func(struct work_struct *work)
 	int len;
 
 	len = __stop_ftrace_eval_maps - __start_ftrace_eval_maps;
-	trace_insert_eval_map(NULL, __start_ftrace_eval_maps, len);
+	trace_event_update_with_eval_map(NULL, __start_ftrace_eval_maps, len);
 }
 
 static int __init trace_eval_init(void)
@@ -9870,9 +9880,6 @@ late_initcall_sync(trace_eval_sync);
 #ifdef CONFIG_MODULES
 static void trace_module_add_evals(struct module *mod)
 {
-	if (!mod->num_trace_evals)
-		return;
-
 	/*
 	 * Modules with bad taint do not have events created, do
 	 * not bother with enums either.
@@ -9880,7 +9887,8 @@ static void trace_module_add_evals(struct module *mod)
 	if (trace_module_has_bad_taint(mod))
 		return;
 
-	trace_insert_eval_map(mod, mod->trace_evals, mod->num_trace_evals);
+	/* Even if no trace_evals, this need to sanitize field types. */
+	trace_event_update_with_eval_map(mod, mod->trace_evals, mod->num_trace_evals);
 }
 
 #ifdef CONFIG_TRACE_EVAL_MAP_FILE
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 494207311934e..7058234433359 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -1930,13 +1930,13 @@ static inline const char *get_syscall_name(int syscall)
 
 #ifdef CONFIG_EVENT_TRACING
 void trace_event_init(void);
-void trace_event_eval_update(struct trace_eval_map **map, int len);
+void trace_event_update_all(struct trace_eval_map **map, int len);
 /* Used from boot time tracer */
 extern int ftrace_set_clr_event(struct trace_array *tr, char *buf, int set);
 extern int trigger_process_regex(struct trace_event_file *file, char *buff);
 #else
 static inline void __init trace_event_init(void) { }
-static inline void trace_event_eval_update(struct trace_eval_map **map, int len) { }
+static inline void trace_event_update_all(struct trace_eval_map **map, int len) { }
 #endif
 
 #ifdef CONFIG_TRACER_SNAPSHOT
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 5b8f6de6e7ef6..367b34814ab8e 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -2847,43 +2847,120 @@ static void add_str_to_module(struct module *module, char *str)
 	list_add(&modstr->next, &module_strings);
 }
 
+#define ATTRIBUTE_STR "__attribute__("
+#define ATTRIBUTE_STR_LEN (sizeof(ATTRIBUTE_STR) - 1)
+
+/* Remove all __attribute__() from @type. Return allocated string or @type. */
+static char *sanitize_field_type(const char *type)
+{
+	char *attr, *tmp, *next, *ret = (char *)type;
+	int depth;
+
+	next = (char *)type;
+	while ((attr = strstr(next, ATTRIBUTE_STR))) {
+		/* Retry if "__attribute__(" is a part of another word. */
+		if (attr != next && !isspace(attr[-1])) {
+			next = attr + ATTRIBUTE_STR_LEN;
+			continue;
+		}
+
+		if (ret == type) {
+			ret = kstrdup(type, GFP_KERNEL);
+			if (WARN_ON_ONCE(!ret))
+				return NULL;
+			attr = ret + (attr - type);
+		}
+
+		/* the ATTRIBUTE_STR already has the first '(' */
+		depth = 1;
+		next = attr + ATTRIBUTE_STR_LEN;
+		do {
+			tmp = strpbrk(next, "()");
+			/* There is unbalanced parentheses */
+			if (WARN_ON_ONCE(!tmp)) {
+				kfree(ret);
+				return (char *)type;
+			}
+
+			if (*tmp == '(')
+				depth++;
+			else
+				depth--;
+			next = tmp + 1;
+		} while (depth > 0);
+		next = skip_spaces(next);
+		strcpy(attr, next);
+		next = attr;
+	}
+	return ret;
+}
+
+static char *find_replacable_eval(const char *type, const char *eval_string,
+				  int len)
+{
+	char *ptr;
+
+	if (!eval_string)
+		return NULL;
+
+	ptr = strchr(type, '[');
+	if (!ptr)
+		return NULL;
+	ptr++;
+
+	if (!isalpha(*ptr) && *ptr != '_')
+		return NULL;
+
+	if (strncmp(eval_string, ptr, len) != 0)
+		return NULL;
+
+	return ptr;
+}
+
 static void update_event_fields(struct trace_event_call *call,
 				struct trace_eval_map *map)
 {
 	struct ftrace_event_field *field;
+	const char *eval_string = NULL;
 	struct list_head *head;
+	int len = 0;
 	char *ptr;
 	char *str;
-	int len = strlen(map->eval_string);
 
 	/* Dynamic events should never have field maps */
-	if (WARN_ON_ONCE(call->flags & TRACE_EVENT_FL_DYNAMIC))
+	if (call->flags & TRACE_EVENT_FL_DYNAMIC)
 		return;
 
+	if (map) {
+		eval_string = map->eval_string;
+		len = strlen(map->eval_string);
+	}
+
 	head = trace_get_fields(call);
 	list_for_each_entry(field, head, link) {
-		ptr = strchr(field->type, '[');
-		if (!ptr)
-			continue;
-		ptr++;
-
-		if (!isalpha(*ptr) && *ptr != '_')
-			continue;
+		str = sanitize_field_type(field->type);
+		if (!str)
+			return;
 
-		if (strncmp(map->eval_string, ptr, len) != 0)
-			continue;
+		ptr = find_replacable_eval(str, eval_string, len);
+		if (ptr) {
+			if (str == field->type) {
+				str = kstrdup(field->type, GFP_KERNEL);
+				if (WARN_ON_ONCE(!str))
+					return;
+				ptr = str + (ptr - field->type);
+			}
 
-		str = kstrdup(field->type, GFP_KERNEL);
-		if (WARN_ON_ONCE(!str))
-			return;
-		ptr = str + (ptr - field->type);
-		ptr = eval_replace(ptr, map, len);
-		/* enum/sizeof string smaller than value */
-		if (WARN_ON_ONCE(!ptr)) {
-			kfree(str);
-			continue;
+			ptr = eval_replace(ptr, map, len);
+			/* enum/sizeof string smaller than value */
+			if (WARN_ON_ONCE(!ptr)) {
+				kfree(str);
+				continue;
+			}
 		}
 
+		if (str == field->type)
+			continue;
 		/*
 		 * If the event is part of a module, then we need to free the string
 		 * when the module is removed. Otherwise, it will stay allocated
@@ -2893,14 +2970,18 @@ static void update_event_fields(struct trace_event_call *call,
 			add_str_to_module(call->module, str);
 
 		field->type = str;
+		if (field->filter_type == FILTER_OTHER)
+			field->filter_type = filter_assign_type(field->type);
 	}
 }
 
-void trace_event_eval_update(struct trace_eval_map **map, int len)
+/* Update all events for replacing eval and sanitizing */
+void trace_event_update_all(struct trace_eval_map **map, int len)
 {
 	struct trace_event_call *call, *p;
 	const char *last_system = NULL;
 	bool first = false;
+	bool updated;
 	int last_i;
 	int i;
 
@@ -2914,6 +2995,7 @@ void trace_event_eval_update(struct trace_eval_map **map, int len)
 			last_system = call->class->system;
 		}
 
+		updated = false;
 		/*
 		 * Since calls are grouped by systems, the likelihood that the
 		 * next call in the iteration belongs to the same system as the
@@ -2933,8 +3015,12 @@ void trace_event_eval_update(struct trace_eval_map **map, int len)
 				}
 				update_event_printk(call, map[i]);
 				update_event_fields(call, map[i]);
+				updated = true;
 			}
 		}
+		/* If not updated yet, update field for sanitizing. */
+		if (!updated)
+			update_event_fields(call, NULL);
 		cond_resched();
 	}
 	up_write(&trace_event_sem);
-- 
2.53.0



