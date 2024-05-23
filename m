Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9028013D2BD;
	Thu, 23 May 2024 13:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470082; cv=none; b=Gbn+M0NwfJq2xUcFuKLO3YI0hBtQi5q0KlUb+hnuJB5zcg93cZnC6qATb4Jme+7Pc5ans5GK0KRWO5Fv3zKGYydQ/E+kZNJOAIY89umu0+RBCndyxFtrLWWfUu5v5DGVihy0yS+bnmx5/GePztENNtwX7dY9g+HKheVu4CLX2ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470082; c=relaxed/simple;
	bh=d2uqPx7sAf6BqnLd6KV0kH/XBsMtIU1DAxsrul5/SLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ooOQkpDc7L4Rqt/T1KURGUJDjq2QI2jPOfXDdDsSx39NL3MlZ1PZf4NS3qmjzXnN0I3UfycpEh0C/xyXqbMQ+8f0u0cL9XY0ga3WRS2cHzLn1Oigu+CuQdSpsvw7+OMDcLzEzPkZzsIL3rkwPrK+dLUDlNyMDLKQrIMT1dwVJmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UjNQIIoG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UjNQIIoG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B773DC2BD10;
	Thu, 23 May 2024 13:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470082;
	bh=d2uqPx7sAf6BqnLd6KV0kH/XBsMtIU1DAxsrul5/SLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UjNQIIoGFL2c8RQY5y498Vyexe258fkC9vhpIOR0soxqNMOumHgE2zqyrjD+fK0jn
	 QOGBEx23oD8YEKTcM7KRYMvoTYRVyVyhKDKAtSfz4B/LOy7QG4FRlLTbrUV6hH/q5X
	 tyR/n7UAEsbs0fV/O16ySZGE1z4hRdV48oFAD0ZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"stable@vger.kernel.org, George Guo" <guodongtai@kylinos.cn>,
	Tom Zanussi <tom.zanussi@linux.intel.com>,
	"Steven Rostedt (VMware)" <rostedt@goodmis.org>,
	George Guo <guodongtai@kylinos.cn>
Subject: [PATCH 4.19 15/18] tracing: Generalize hist trigger onmax and save action
Date: Thu, 23 May 2024 15:12:38 +0200
Message-ID: <20240523130326.318437290@linuxfoundation.org>
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

commit 466f4528fbc692ea56deca278fa6aeb79e6e8b21 upstream.

The action refactor code allowed actions and handlers to be separated,
but the existing onmax handler and save action code is still not
flexible enough to handle arbitrary coupling.  This change generalizes
them and in the process makes additional handlers and actions easier
to implement.

The onmax action can be broken up and thought of as two separate
components - a variable to be tracked (the parameter given to the
onmax($var_to_track) function) and an invisible variable created to
save the ongoing result of doing something with that variable, such as
saving the max value of that variable so far seen.

Separating it out like this and renaming it appropriately allows us to
use the same code for similar tracking functions such as
onchange($var_to_track), which would just track the last value seen
rather than the max seen so far, which is useful in some situations.

Additionally, because different handlers and actions may want to save
and access data differently e.g. save and retrieve tracking values as
local variables vs something more global, save_val() and get_val()
interface functions are introduced and max-specific implementations
are used instead.

The same goes for the code that checks whether a maximum has been hit
- a generic check_val() interface and max-checking implementation is
used instead, which allows future patches to make use of he same code
using their own implemetations of similar functionality.

Link: http://lkml.kernel.org/r/980ea73dd8e3f36db3d646f99652f8fed42b77d4.1550100284.git.tom.zanussi@linux.intel.com

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: George Guo <guodongtai@kylinos.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_hist.c |  242 ++++++++++++++++++++++++++-------------
 1 file changed, 163 insertions(+), 79 deletions(-)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -360,6 +360,8 @@ typedef void (*action_fn_t) (struct hist
 			     struct ring_buffer_event *rbe, void *key,
 			     struct action_data *data, u64 *var_ref_vals);
 
+typedef bool (*check_track_val_fn_t) (u64 track_val, u64 var_val);
+
 enum handler_id {
 	HANDLER_ONMATCH = 1,
 	HANDLER_ONMAX,
@@ -397,15 +399,35 @@ struct action_data {
 		} match_data;
 
 		struct {
+			/*
+			 * var_str contains the $-unstripped variable
+			 * name referenced by var_ref, and used when
+			 * printing the action.  Because var_ref
+			 * creation is deferred to create_actions(),
+			 * we need a per-action way to save it until
+			 * then, thus var_str.
+			 */
 			char			*var_str;
-			unsigned int		max_var_ref_idx;
-			struct hist_field	*max_var;
-			struct hist_field	*var;
-		} onmax;
+
+			/*
+			 * var_ref refers to the variable being
+			 * tracked e.g onmax($var).
+			 */
+			struct hist_field	*var_ref;
+
+			/*
+			 * track_var contains the 'invisible' tracking
+			 * variable created to keep the current
+			 * e.g. max value.
+			 */
+			struct hist_field	*track_var;
+
+			check_track_val_fn_t	check_val;
+			action_fn_t		save_data;
+		} track_data;
 	};
 };
 
-
 static char last_hist_cmd[MAX_FILTER_STR_VAL];
 static char hist_err_str[MAX_FILTER_STR_VAL];
 
@@ -3311,10 +3333,10 @@ static void update_field_vars(struct his
 			    hist_data->n_field_vars, 0);
 }
 
-static void update_max_vars(struct hist_trigger_data *hist_data,
-			    struct tracing_map_elt *elt,
-			    struct ring_buffer_event *rbe,
-			    void *rec)
+static void save_track_data_vars(struct hist_trigger_data *hist_data,
+				 struct tracing_map_elt *elt, void *rec,
+				 struct ring_buffer_event *rbe, void *key,
+				 struct action_data *data, u64 *var_ref_vals)
 {
 	__update_field_vars(elt, rbe, rec, hist_data->save_vars,
 			    hist_data->n_save_vars, hist_data->n_field_var_str);
@@ -3452,14 +3474,67 @@ create_target_field_var(struct hist_trig
 	return create_field_var(target_hist_data, file, var_name);
 }
 
-static void onmax_print(struct seq_file *m,
-			struct hist_trigger_data *hist_data,
-			struct tracing_map_elt *elt,
-			struct action_data *data)
+static bool check_track_val_max(u64 track_val, u64 var_val)
+{
+	if (var_val <= track_val)
+		return false;
+
+	return true;
+}
+
+static u64 get_track_val(struct hist_trigger_data *hist_data,
+			 struct tracing_map_elt *elt,
+			 struct action_data *data)
+{
+	unsigned int track_var_idx = data->track_data.track_var->var.idx;
+	u64 track_val;
+
+	track_val = tracing_map_read_var(elt, track_var_idx);
+
+	return track_val;
+}
+
+static void save_track_val(struct hist_trigger_data *hist_data,
+			   struct tracing_map_elt *elt,
+			   struct action_data *data, u64 var_val)
+{
+	unsigned int track_var_idx = data->track_data.track_var->var.idx;
+
+	tracing_map_set_var(elt, track_var_idx, var_val);
+}
+
+static void save_track_data(struct hist_trigger_data *hist_data,
+			    struct tracing_map_elt *elt, void *rec,
+			    struct ring_buffer_event *rbe, void *key,
+			    struct action_data *data, u64 *var_ref_vals)
+{
+	if (data->track_data.save_data)
+		data->track_data.save_data(hist_data, elt, rec, rbe, key, data, var_ref_vals);
+}
+
+static bool check_track_val(struct tracing_map_elt *elt,
+			    struct action_data *data,
+			    u64 var_val)
 {
-	unsigned int i, save_var_idx, max_idx = data->onmax.max_var->var.idx;
+	struct hist_trigger_data *hist_data;
+	u64 track_val;
+
+	hist_data = data->track_data.track_var->hist_data;
+	track_val = get_track_val(hist_data, elt, data);
+
+	return data->track_data.check_val(track_val, var_val);
+}
+
+static void track_data_print(struct seq_file *m,
+			     struct hist_trigger_data *hist_data,
+			     struct tracing_map_elt *elt,
+			     struct action_data *data)
+{
+	u64 track_val = get_track_val(hist_data, elt, data);
+	unsigned int i, save_var_idx;
 
-	seq_printf(m, "\n\tmax: %10llu", tracing_map_read_var(elt, max_idx));
+	if (data->handler == HANDLER_ONMAX)
+		seq_printf(m, "\n\tmax: %10llu", track_val);
 
 	for (i = 0; i < hist_data->n_save_vars; i++) {
 		struct hist_field *save_val = hist_data->save_vars[i]->val;
@@ -3478,25 +3553,17 @@ static void onmax_print(struct seq_file
 	}
 }
 
-static void onmax_save(struct hist_trigger_data *hist_data,
-		       struct tracing_map_elt *elt, void *rec,
-		       struct ring_buffer_event *rbe, void *key,
-		       struct action_data *data, u64 *var_ref_vals)
-{
-	unsigned int max_idx = data->onmax.max_var->var.idx;
-	unsigned int max_var_ref_idx = data->onmax.max_var_ref_idx;
-
-	u64 var_val, max_val;
-
-	var_val = var_ref_vals[max_var_ref_idx];
-	max_val = tracing_map_read_var(elt, max_idx);
-
-	if (var_val <= max_val)
-		return;
-
-	tracing_map_set_var(elt, max_idx, var_val);
-
-	update_max_vars(hist_data, elt, rbe, rec);
+static void ontrack_action(struct hist_trigger_data *hist_data,
+			   struct tracing_map_elt *elt, void *rec,
+			   struct ring_buffer_event *rbe, void *key,
+			   struct action_data *data, u64 *var_ref_vals)
+{
+	u64 var_val = var_ref_vals[data->track_data.var_ref->var_ref_idx];
+
+	if (check_track_val(elt, data, var_val)) {
+		save_track_val(hist_data, elt, data, var_val);
+		save_track_data(hist_data, elt, rec, rbe, key, data, var_ref_vals);
+	}
 }
 
 static void action_data_destroy(struct action_data *data)
@@ -3516,12 +3583,13 @@ static void action_data_destroy(struct a
 	kfree(data);
 }
 
-static void onmax_destroy(struct action_data *data)
+static void track_data_destroy(struct hist_trigger_data *hist_data,
+			       struct action_data *data)
 {
-	destroy_hist_field(data->onmax.max_var, 0);
-	destroy_hist_field(data->onmax.var, 0);
+	destroy_hist_field(data->track_data.track_var, 0);
+	destroy_hist_field(data->track_data.var_ref, 0);
 
-	kfree(data->onmax.var_str);
+	kfree(data->track_data.var_str);
 
 	action_data_destroy(data);
 }
@@ -3529,25 +3597,24 @@ static void onmax_destroy(struct action_
 static int action_create(struct hist_trigger_data *hist_data,
 			 struct action_data *data);
 
-static int onmax_create(struct hist_trigger_data *hist_data,
-			struct action_data *data)
+static int track_data_create(struct hist_trigger_data *hist_data,
+			     struct action_data *data)
 {
-	struct hist_field *var_field, *ref_field, *max_var = NULL;
+	struct hist_field *var_field, *ref_field, *track_var = NULL;
 	struct trace_event_file *file = hist_data->event_file;
-	unsigned int var_ref_idx = hist_data->n_var_refs;
-	char *onmax_var_str;
+	char *track_data_var_str;
 	int ret = 0;
 
-	onmax_var_str = data->onmax.var_str;
-	if (onmax_var_str[0] != '$') {
-		hist_err("onmax: For onmax(x), x must be a variable: ", onmax_var_str);
+	track_data_var_str = data->track_data.var_str;
+	if (track_data_var_str[0] != '$') {
+		hist_err("For onmax(x), x must be a variable: ", track_data_var_str);
 		return -EINVAL;
 	}
-	onmax_var_str++;
+	track_data_var_str++;
 
-	var_field = find_target_event_var(hist_data, NULL, NULL, onmax_var_str);
+	var_field = find_target_event_var(hist_data, NULL, NULL, track_data_var_str);
 	if (!var_field) {
-		hist_err("onmax: Couldn't find onmax variable: ", onmax_var_str);
+		hist_err("Couldn't find onmax variable: ", track_data_var_str);
 		return -EINVAL;
 	}
 
@@ -3555,17 +3622,16 @@ static int onmax_create(struct hist_trig
 	if (!ref_field)
 		return -ENOMEM;
 
-	data->onmax.var = ref_field;
-
-	data->onmax.max_var_ref_idx = var_ref_idx;
+	data->track_data.var_ref = ref_field;
 
-	max_var = create_var(hist_data, file, "max", sizeof(u64), "u64");
-	if (IS_ERR(max_var)) {
-		hist_err("onmax: Couldn't create onmax variable: ", "max");
-		ret = PTR_ERR(max_var);
+	if (data->handler == HANDLER_ONMAX)
+		track_var = create_var(hist_data, file, "__max", sizeof(u64), "u64");
+	if (IS_ERR(track_var)) {
+		hist_err("Couldn't create onmax variable: ", "__max");
+		ret = PTR_ERR(track_var);
 		goto out;
 	}
-	data->onmax.max_var = max_var;
+	data->track_data.track_var = track_var;
 
 	ret = action_create(hist_data, data);
  out:
@@ -3643,8 +3709,15 @@ static int action_parse(char *str, struc
 			goto out;
 
 		if (handler == HANDLER_ONMAX)
-			data->fn = onmax_save;
+			data->track_data.check_val = check_track_val_max;
+		else {
+			hist_err("action parsing: Handler doesn't support action: ", action_name);
+			ret = -EINVAL;
+			goto out;
+		}
 
+		data->track_data.save_data = save_track_data_vars;
+		data->fn = ontrack_action;
 		data->action = ACTION_SAVE;
 	} else {
 		char *params = strsep(&str, ")");
@@ -3655,7 +3728,15 @@ static int action_parse(char *str, struc
 				goto out;
 		}
 
-		data->fn = action_trace;
+		if (handler == HANDLER_ONMAX)
+			data->track_data.check_val = check_track_val_max;
+
+		if (handler != HANDLER_ONMATCH) {
+			data->track_data.save_data = action_trace;
+			data->fn = ontrack_action;
+		} else
+			data->fn = action_trace;
+
 		data->action = ACTION_TRACE;
 	}
 
@@ -3670,24 +3751,25 @@ static int action_parse(char *str, struc
 	return ret;
 }
 
-static struct action_data *onmax_parse(char *str, enum handler_id handler)
+static struct action_data *track_data_parse(struct hist_trigger_data *hist_data,
+					    char *str, enum handler_id handler)
 {
 	struct action_data *data;
-	char *onmax_var_str;
 	int ret = -EINVAL;
+	char *var_str;
 
 	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)
 		return ERR_PTR(-ENOMEM);
 
-	onmax_var_str = strsep(&str, ")");
-	if (!onmax_var_str || !str) {
+	var_str = strsep(&str, ")");
+	if (!var_str || !str) {
 		ret = -EINVAL;
 		goto free;
 	}
 
-	data->onmax.var_str = kstrdup(onmax_var_str, GFP_KERNEL);
-	if (!data->onmax.var_str) {
+	data->track_data.var_str = kstrdup(var_str, GFP_KERNEL);
+	if (!data->track_data.var_str) {
 		ret = -ENOMEM;
 		goto free;
 	}
@@ -3698,7 +3780,7 @@ static struct action_data *onmax_parse(c
  out:
 	return data;
  free:
-	onmax_destroy(data);
+	track_data_destroy(hist_data, data);
 	data = ERR_PTR(ret);
 	goto out;
 }
@@ -4465,7 +4547,7 @@ static void destroy_actions(struct hist_
 		if (data->handler == HANDLER_ONMATCH)
 			onmatch_destroy(data);
 		else if (data->handler == HANDLER_ONMAX)
-			onmax_destroy(data);
+			track_data_destroy(hist_data, data);
 		else
 			kfree(data);
 	}
@@ -4494,7 +4576,8 @@ static int parse_actions(struct hist_tri
 		} else if ((len = str_has_prefix(str, "onmax("))) {
 			char *action_str = str + len;
 
-			data = onmax_parse(action_str, HANDLER_ONMAX);
+			data = track_data_parse(hist_data, action_str,
+						HANDLER_ONMAX);
 			if (IS_ERR(data)) {
 				ret = PTR_ERR(data);
 				break;
@@ -4524,7 +4607,7 @@ static int create_actions(struct hist_tr
 			if (ret)
 				break;
 		} else if (data->handler == HANDLER_ONMAX) {
-			ret = onmax_create(hist_data, data);
+			ret = track_data_create(hist_data, data);
 			if (ret)
 				break;
 		} else {
@@ -4546,7 +4629,7 @@ static void print_actions(struct seq_fil
 		struct action_data *data = hist_data->actions[i];
 
 		if (data->handler == HANDLER_ONMAX)
-			onmax_print(m, hist_data, elt, data);
+			track_data_print(m, hist_data, elt, data);
 	}
 }
 
@@ -4571,12 +4654,13 @@ static void print_action_spec(struct seq
 	}
 }
 
-static void print_onmax_spec(struct seq_file *m,
-			     struct hist_trigger_data *hist_data,
-			     struct action_data *data)
-{
-	seq_puts(m, ":onmax(");
-	seq_printf(m, "%s", data->onmax.var_str);
+static void print_track_data_spec(struct seq_file *m,
+				  struct hist_trigger_data *hist_data,
+				  struct action_data *data)
+{
+	if (data->handler == HANDLER_ONMAX)
+		seq_puts(m, ":onmax(");
+	seq_printf(m, "%s", data->track_data.var_str);
 	seq_printf(m, ").%s(", data->action_name);
 
 	print_action_spec(m, hist_data, data);
@@ -4634,8 +4718,8 @@ static bool actions_match(struct hist_tr
 				   data_test->match_data.event) != 0)
 				return false;
 		} else if (data->handler == HANDLER_ONMAX) {
-			if (strcmp(data->onmax.var_str,
-				   data_test->onmax.var_str) != 0)
+			if (strcmp(data->track_data.var_str,
+				   data_test->track_data.var_str) != 0)
 				return false;
 		}
 	}
@@ -4655,7 +4739,7 @@ static void print_actions_spec(struct se
 		if (data->handler == HANDLER_ONMATCH)
 			print_onmatch_spec(m, hist_data, data);
 		else if (data->handler == HANDLER_ONMAX)
-			print_onmax_spec(m, hist_data, data);
+			print_track_data_spec(m, hist_data, data);
 	}
 }
 


