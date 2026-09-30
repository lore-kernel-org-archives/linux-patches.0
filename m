Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D174B33A6F1;
	Wed, 30 Sep 2026 19:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795170; cv=none; b=U05Ymk03LInSy8tugK/kDNWyp/hDzZcpa1CVRwxrgflolS/LJW6Q74JqQ35doc8Buz8VIfkdAVUi59j3L/j0llfsP0NjyKt5YrjeNu0M2gikXyULO1+txQAgWC3jLUjf3IQDzWFqIFhKLbgiZ2B37kmKOXNi4kIJJdD9cKXUltU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795170; c=relaxed/simple;
	bh=kKS3WBfGLmgQqJhi8lCnQegW/V29vh2sOIXRr3didHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c+FQYcx0IeOOggZs0RCq5AaoW5p83Qk7sHhIbf0r1z1jsPGXVwxBbaT6v8K9dD3BqCymKfVo3th0lnrPGTWC4tFo8SeYNRTzPS8Z0LIZPC0moNsVq9kcHmWHl4nYw1VPctgb9gkZhmw1T5XldptdBM7nIvcWZuiuSZsis26YOv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q3oFy3R+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q3oFy3R+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E80531F000FF;
	Wed, 30 Sep 2026 19:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795168;
	bh=kqS5dAMudtEYm6EWcpRfP2jPIq+UqUqTMYAXXHHNF84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q3oFy3R+3YpZZO7L+0bue5B38MM/uzdOg5CQxpwEa9OrdfItsfzx7wSc3Un5NRo6c
	 pK43pGjpn2NcmGkPOFpFGdScgkMgrAo+IuqNfXWWJ81TJctjnZ+uJ8NJ/G/t2t2YfY
	 8fxJJB/u+YhlQzXi08cH+oYL7jMUAjXvIj4LRMgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0465/1193] tracing/probes: Fix use-after-free on field name/type of events with multiple probes
Date: Wed, 30 Sep 2026 17:19:09 +0200
Message-ID: <20260930152444.503630649@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henry Martin <bsdhenrymartin@gmail.com>

[ Upstream commit 86b7a239ec6b14a7544200ede85474c6f5526049 ]

The fields of a probe-based dynamic event (kprobe, uprobe, eprobe and
fprobe events) are created in traceprobe_define_arg_fields() by handing
the probe_arg name/type strings to trace_define_field(), which only
stores the pointers without copying. Those strings are owned by the
trace_probe and are freed when that probe is removed.

An event can have several probes attached. The field list is defined
only once, by the first probe that registers the event, but it is kept
alive by any surviving sibling probe. Deleting just that first probe by
symbol -

  # primary A: fields are defined from A's args
  echo 'p:kprobes/ev vfs_read  a1=$arg1' >  kprobe_events
  # append B: shares A's event call
  echo 'p:kprobes/ev vfs_write a1=$arg1' >> kprobe_events
  # delete only A (matched by symbol), B survives
  echo '-:kprobes/ev vfs_read'           >> kprobe_events

frees A's args (trace_probe_cleanup() -> traceprobe_free_probe_arg()),
but trace_probe_unlink() keeps the trace_probe_event because the probe
list is not empty. The event call stays registered via B while its
fields now reference freed memory. Any field lookup then reads it, e.g.

  echo 'a1 == 1' > events/kprobes/ev/filter

  BUG: KASAN: slab-use-after-free in strcmp+0xa7/0xb0
  Call Trace:
   strcmp
   trace_find_event_field
   parse_pred
   process_preds
   create_filter
   apply_event_filter
   event_filter_write

field->name references parg->name (kstrdup'd, freed with the probe) and,
for array arguments, field->type references parg->fmt (kmalloc'd, freed
with the probe) - the scalar type otherwise points at the static
fmttype rodata, which is safe.

Have traceprobe_define_arg_fields() duplicate the name and type strings
and anchor the copies on the trace_probe_event, which embeds the event
call and outlives every individual probe; trace_probe_event_free()
releases them.

The reproducer above triggers reliably; the field lookup and the delete
both run under event_mutex, so this is a dangling reference after
removal rather than a race.

The issue was found by the autokbug dynamic kernel fuzzer at Tencent
Yunding Lab.

Link: https://lore.kernel.org/all/20260826030009.1855331-1-bsdhenrymartin@gmail.com/

Fixes: ca89bc071d5e4 ("tracing/kprobe: Add multi-probe per event support")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_probe.c | 48 +++++++++++++++++++++++++++++++++++++-
 kernel/trace/trace_probe.h |  2 ++
 2 files changed, 49 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index 2fa7b596f03e1..afae842009d12 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -1876,19 +1876,60 @@ int traceprobe_set_print_fmt(struct trace_probe *tp, enum probe_print_type ptype
 int traceprobe_define_arg_fields(struct trace_event_call *event_call,
 				 size_t offset, struct trace_probe *tp)
 {
+	struct trace_probe_event *tpe = trace_probe_event_from_call(event_call);
 	int ret, i;
 
+	/*
+	 * A field created by trace_define_field() only stores the name and
+	 * type pointers, it does not copy the strings. Here they point into
+	 * the probe_arg of @tp, which is freed when @tp is removed. For an
+	 * event with multiple probes attached, the field list is defined
+	 * once by the first probe but kept alive by the surviving siblings,
+	 * so removing that first probe would leave the fields referencing
+	 * freed memory. Duplicate the strings and anchor the copies on the
+	 * trace_probe_event, which lives as long as the field list itself.
+	 *
+	 * event_define_fields() ignores the return value of this hook, so
+	 * if a previous attempt failed before creating any field, it may
+	 * call here again. Release duplicates left behind by such an
+	 * attempt before starting over.
+	 */
+	for (i = 0; i < tpe->nr_field_strings; i++)
+		kfree(tpe->field_strings[i]);
+	kfree(tpe->field_strings);
+	tpe->field_strings = NULL;
+	tpe->nr_field_strings = 0;
+
+	if (tp->nr_args) {
+		tpe->field_strings = kcalloc(tp->nr_args * 2, sizeof(char *),
+					     GFP_KERNEL);
+		if (!tpe->field_strings)
+			return -ENOMEM;
+	}
+
 	/* Set argument names as fields */
 	for (i = 0; i < tp->nr_args; i++) {
 		struct probe_arg *parg = &tp->args[i];
 		const char *fmt = parg->type->fmttype;
 		int size = parg->type->size;
+		char *name, *type;
 
 		if (parg->fmt)
 			fmt = parg->fmt;
 		if (parg->count)
 			size *= parg->count;
-		ret = trace_define_field(event_call, fmt, parg->name,
+
+		name = kstrdup(parg->name, GFP_KERNEL);
+		type = kstrdup(fmt, GFP_KERNEL);
+		if (!name || !type) {
+			kfree(name);
+			kfree(type);
+			return -ENOMEM;
+		}
+		tpe->field_strings[tpe->nr_field_strings++] = name;
+		tpe->field_strings[tpe->nr_field_strings++] = type;
+
+		ret = trace_define_field(event_call, type, name,
 					 offset + parg->offset, size,
 					 parg->type->is_signed,
 					 FILTER_OTHER);
@@ -1900,6 +1941,11 @@ int traceprobe_define_arg_fields(struct trace_event_call *event_call,
 
 static void trace_probe_event_free(struct trace_probe_event *tpe)
 {
+	int i;
+
+	for (i = 0; i < tpe->nr_field_strings; i++)
+		kfree(tpe->field_strings[i]);
+	kfree(tpe->field_strings);
 	kfree(tpe->class.system);
 	kfree(tpe->call.name);
 	kfree(tpe->call.print_fmt);
diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
index 9fc6b3a39435c..735eb665055a0 100644
--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -252,6 +252,8 @@ struct trace_probe_event {
 	struct trace_event_call		call;
 	struct list_head 		files;
 	struct list_head		probes;
+	char				**field_strings;
+	int				nr_field_strings;
 	struct trace_uprobe_filter	filter[];
 };
 
-- 
2.53.0



