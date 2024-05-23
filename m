Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD21613D2BD;
	Thu, 23 May 2024 13:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470079; cv=none; b=OiWKzrStocOBY9PUrlAaD8ZZhAlXMBp93ukAoQk8OpCKYkNmlsQ80zXtaGBrLBovWtrade16ChZRr4LPzDJwOA9O6MXLL2zqc6P/SEC4JTGqz/uFynZjwTHAHfLLalolqmbW1rMfAx8VkotWlouzimSS3pBeK4nsDhuVLTUOEHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470079; c=relaxed/simple;
	bh=QeAtZRpzUezzeBXa+nHqCP6K1jNaItu3E71TVXhC34c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n8gCKYe41/LFFyB6aTRfsDAmShbJbQsuTJ2IwbAjiOubs50ilKN6TjF/GyI9zauYOIVsUyGMLW2aIxKDRCYcys9vxs+QhtEgt+IUeQeJ6blkh+dHAT72vudb3HPF+Rg1c94QPPxl2C1nqUkCb/ETs3euJa0PKSdhaTPV4w5ORWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H+I/+CIc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H+I/+CIc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3F19C2BD10;
	Thu, 23 May 2024 13:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470079;
	bh=QeAtZRpzUezzeBXa+nHqCP6K1jNaItu3E71TVXhC34c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H+I/+CIcUBETEDn7PWgndbzwaVWign0zW5y8TxQE90ohvmTT+6D4Yl5p1ZQt23tul
	 Eh96D9/SRsb8IvM8bTl3E2lkCEfnbiVtqm8FhBbPOq3tFjv1T8PQna5AXnsPIKVkeC
	 GAagVSqH0RtU2UMmxxL01hOm3Sw2QZ7lxb+2Z+mA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"stable@vger.kernel.org, George Guo" <guodongtai@kylinos.cn>,
	Tom Zanussi <tom.zanussi@linux.intel.com>,
	"Steven Rostedt (VMware)" <rostedt@goodmis.org>,
	George Guo <guodongtai@kylinos.cn>
Subject: [PATCH 4.19 14/18] tracing: Split up onmatch action data
Date: Thu, 23 May 2024 15:12:37 +0200
Message-ID: <20240523130326.280788792@linuxfoundation.org>
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

From: Tom Zanussi <tom.zanussi@linux.intel.com>

commit c3e49506a0f426a850675e39419879214060ca8b upstream.

Currently, the onmatch action data binds the onmatch action to data
related to synthetic event generation.  Since we want to allow the
onmatch handler to potentially invoke a different action, and because
we expect other handlers to generate synthetic events, we need to
separate the data related to these two functions.

Also rename the onmatch data to something more descriptive, and create
and use common action data destroy function.

Link: http://lkml.kernel.org/r/b9abbf9aae69fe3920cdc8ddbcaad544dd258d78.1550100284.git.tom.zanussi@linux.intel.com

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: George Guo <guodongtai@kylinos.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c             |   12 ++++
 kernel/trace/trace_events_hist.c |   95 +++++++++++++++++++++------------------
 2 files changed, 63 insertions(+), 44 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4754,6 +4754,7 @@ static const char readme_msg[] =
 	"\t            [:size=#entries]\n"
 	"\t            [:pause][:continue][:clear]\n"
 	"\t            [:name=histname1]\n"
+	"\t            [:<handler>.<action>]\n"
 	"\t            [if <filter>]\n\n"
 	"\t    Note, special fields can be used as well:\n"
 	"\t            common_timestamp - to record current timestamp\n"
@@ -4799,7 +4800,16 @@ static const char readme_msg[] =
 	"\t    The enable_hist and disable_hist triggers can be used to\n"
 	"\t    have one event conditionally start and stop another event's\n"
 	"\t    already-attached hist trigger.  The syntax is analagous to\n"
-	"\t    the enable_event and disable_event triggers.\n"
+	"\t    the enable_event and disable_event triggers.\n\n"
+	"\t    Hist trigger handlers and actions are executed whenever a\n"
+	"\t    a histogram entry is added or updated.  They take the form:\n\n"
+	"\t        <handler>.<action>\n\n"
+	"\t    The available handlers are:\n\n"
+	"\t        onmatch(matching.event)  - invoke on addition or update\n"
+	"\t        onmax(var)               - invoke if var exceeds current max\n\n"
+	"\t    The available actions are:\n\n"
+	"\t        <synthetic_event>(param list)        - generate synthetic event\n"
+	"\t        save(field,...)                      - save current event fields\n"
 #endif
 ;
 
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -379,13 +379,22 @@ struct action_data {
 	unsigned int		n_params;
 	char			*params[SYNTH_FIELDS_MAX];
 
+	/*
+	 * When a histogram trigger is hit, the values of any
+	 * references to variables, including variables being passed
+	 * as parameters to synthetic events, are collected into a
+	 * var_ref_vals array.  This var_ref_idx is the index of the
+	 * first param in the array to be passed to the synthetic
+	 * event invocation.
+	 */
+	unsigned int		var_ref_idx;
+	struct synth_event	*synth_event;
+
 	union {
 		struct {
-			unsigned int		var_ref_idx;
-			char			*match_event;
-			char			*match_event_system;
-			struct synth_event	*synth_event;
-		} onmatch;
+			char			*event;
+			char			*event_system;
+		} match_data;
 
 		struct {
 			char			*var_str;
@@ -1080,9 +1089,9 @@ static void action_trace(struct hist_tri
 			 struct ring_buffer_event *rbe, void *key,
 			 struct action_data *data, u64 *var_ref_vals)
 {
-	struct synth_event *event = data->onmatch.synth_event;
+	struct synth_event *event = data->synth_event;
 
-	trace_synth(event, var_ref_vals, data->onmatch.var_ref_idx);
+	trace_synth(event, var_ref_vals, data->var_ref_idx);
 }
 
 struct hist_var_data {
@@ -1648,8 +1657,8 @@ find_match_var(struct hist_trigger_data
 		struct action_data *data = hist_data->actions[i];
 
 		if (data->handler == HANDLER_ONMATCH) {
-			char *system = data->onmatch.match_event_system;
-			char *event_name = data->onmatch.match_event;
+			char *system = data->match_data.event_system;
+			char *event_name = data->match_data.event;
 
 			file = find_var_file(tr, system, event_name, var_name);
 			if (!file)
@@ -3490,22 +3499,33 @@ static void onmax_save(struct hist_trigg
 	update_max_vars(hist_data, elt, rbe, rec);
 }
 
-static void onmax_destroy(struct action_data *data)
+static void action_data_destroy(struct action_data *data)
 {
 	unsigned int i;
 
-	destroy_hist_field(data->onmax.max_var, 0);
-	destroy_hist_field(data->onmax.var, 0);
+	lockdep_assert_held(&event_mutex);
 
-	kfree(data->onmax.var_str);
 	kfree(data->action_name);
 
 	for (i = 0; i < data->n_params; i++)
 		kfree(data->params[i]);
 
+	if (data->synth_event)
+		data->synth_event->ref--;
+
 	kfree(data);
 }
 
+static void onmax_destroy(struct action_data *data)
+{
+	destroy_hist_field(data->onmax.max_var, 0);
+	destroy_hist_field(data->onmax.var, 0);
+
+	kfree(data->onmax.var_str);
+
+	action_data_destroy(data);
+}
+
 static int action_create(struct hist_trigger_data *hist_data,
 			 struct action_data *data);
 
@@ -3685,21 +3705,10 @@ static struct action_data *onmax_parse(c
 
 static void onmatch_destroy(struct action_data *data)
 {
-	unsigned int i;
-
-	lockdep_assert_held(&event_mutex);
+	kfree(data->match_data.event);
+	kfree(data->match_data.event_system);
 
-	kfree(data->onmatch.match_event);
-	kfree(data->onmatch.match_event_system);
-	kfree(data->action_name);
-
-	for (i = 0; i < data->n_params; i++)
-		kfree(data->params[i]);
-
-	if (data->onmatch.synth_event)
-		data->onmatch.synth_event->ref--;
-
-	kfree(data);
+	action_data_destroy(data);
 }
 
 static void destroy_field_var(struct field_var *field_var)
@@ -3760,8 +3769,8 @@ trace_action_find_var(struct hist_trigge
 	hist_field = find_target_event_var(hist_data, system, event, var);
 	if (!hist_field) {
 		if (!system && data->handler == HANDLER_ONMATCH) {
-			system = data->onmatch.match_event_system;
-			event = data->onmatch.match_event;
+			system = data->match_data.event_system;
+			event = data->match_data.event;
 		}
 
 		hist_field = find_event_var(hist_data, system, event, var);
@@ -3800,8 +3809,8 @@ trace_action_create_field_var(struct his
 		 * event.
 		 */
 		if (!system && data->handler == HANDLER_ONMATCH) {
-			system = data->onmatch.match_event_system;
-			event = data->onmatch.match_event;
+			system = data->match_data.event_system;
+			event = data->match_data.event;
 		}
 
 		if (!event)
@@ -3913,8 +3922,8 @@ static int trace_action_create(struct hi
 		goto err;
 	}
 
-	data->onmatch.synth_event = event;
-	data->onmatch.var_ref_idx = var_ref_idx;
+	data->synth_event = event;
+	data->var_ref_idx = var_ref_idx;
  out:
 	return ret;
  err:
@@ -4000,14 +4009,14 @@ static struct action_data *onmatch_parse
 		goto free;
 	}
 
-	data->onmatch.match_event = kstrdup(match_event, GFP_KERNEL);
-	if (!data->onmatch.match_event) {
+	data->match_data.event = kstrdup(match_event, GFP_KERNEL);
+	if (!data->match_data.event) {
 		ret = -ENOMEM;
 		goto free;
 	}
 
-	data->onmatch.match_event_system = kstrdup(match_event_system, GFP_KERNEL);
-	if (!data->onmatch.match_event_system) {
+	data->match_data.event_system = kstrdup(match_event_system, GFP_KERNEL);
+	if (!data->match_data.event_system) {
 		ret = -ENOMEM;
 		goto free;
 	}
@@ -4579,8 +4588,8 @@ static void print_onmatch_spec(struct se
 			       struct hist_trigger_data *hist_data,
 			       struct action_data *data)
 {
-	seq_printf(m, ":onmatch(%s.%s).", data->onmatch.match_event_system,
-		   data->onmatch.match_event);
+	seq_printf(m, ":onmatch(%s.%s).", data->match_data.event_system,
+		   data->match_data.event);
 
 	seq_printf(m, "%s(", data->action_name);
 
@@ -4618,11 +4627,11 @@ static bool actions_match(struct hist_tr
 			return false;
 
 		if (data->handler == HANDLER_ONMATCH) {
-			if (strcmp(data->onmatch.match_event_system,
-				   data_test->onmatch.match_event_system) != 0)
+			if (strcmp(data->match_data.event_system,
+				   data_test->match_data.event_system) != 0)
 				return false;
-			if (strcmp(data->onmatch.match_event,
-				   data_test->onmatch.match_event) != 0)
+			if (strcmp(data->match_data.event,
+				   data_test->match_data.event) != 0)
 				return false;
 		} else if (data->handler == HANDLER_ONMAX) {
 			if (strcmp(data->onmax.var_str,


