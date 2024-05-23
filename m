Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A1B414A4DD;
	Thu, 23 May 2024 13:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470099; cv=none; b=qajYxjpHy41J5LhpOy8IWARLlZVDqusw2D3Ndy/1fOFTnkhBggM1/eVG2GEv+ZdMump03xE37KYd7jbUVsi/dzD5VEI/6F0U9UZEBHSA91ynv9oZBUhGP4+lGwH+xyVJKrQ9rj9oyPGUi3TvcyTxJ7mgHEUvVaGWSHWKn6Hmtw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470099; c=relaxed/simple;
	bh=btyAJ8OhvRhm8ATKPEqka6YoDX3JYxi3Yk3IgnQ+ZFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CuR0vMf9zYO38OxP5uSIrOsSfAzlVlVwZB578GwN+aFAtWaCCg07b3553cXk5e+EwM891PrQLbjzutDV0p2RpQ5djxwwQ+2pOnYlz2oWGq+tN4auckvvj+/zrDtIX0H/7txCCV+Hvg+gIHEvCDaWcZxIGSAPV//du0CNBlh5fw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FvR2h82h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FvR2h82h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D1D3C3277B;
	Thu, 23 May 2024 13:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470099;
	bh=btyAJ8OhvRhm8ATKPEqka6YoDX3JYxi3Yk3IgnQ+ZFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FvR2h82ha8sYduqWn6VX7YSVG2sh8zxeotPS3HoJKZ/aQmEzN3M2ln1g1al3//rIl
	 Gtr5XAmRgnHYH6/pWdt5WJ9c0qgPly5VNLEF/IIRnotGp0X/1N2/oUP3MxY2O+CqCw
	 uMNnt+MBg5q4paBOpBzx2E6jpkBN09SVfEhpFiAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"stable@vger.kernel.org, George Guo" <guodongtai@kylinos.cn>,
	Tom Zanussi <tom.zanussi@linux.intel.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	"Steven Rostedt (VMware)" <rostedt@goodmis.org>,
	George Guo <guodongtai@kylinos.cn>
Subject: [PATCH 4.19 07/18] tracing: Remove unneeded synth_event_mutex
Date: Thu, 23 May 2024 15:12:30 +0200
Message-ID: <20240523130326.011328258@linuxfoundation.org>
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

commit 0e2b81f7b52a1c1a8c46986f9ca01eb7b3c421f8 upstream.

Rmove unneeded synth_event_mutex. This mutex protects the reference
count in synth_event, however, those operational points are already
protected by event_mutex.

1. In __create_synth_event() and create_or_delete_synth_event(),
 those synth_event_mutex clearly obtained right after event_mutex.

2. event_hist_trigger_func() is trigger_hist_cmd.func() which is
 called by trigger_process_regex(), which is a part of
 event_trigger_regex_write() and this function takes event_mutex.

3. hist_unreg_all() is trigger_hist_cmd.unreg_all() which is called
 by event_trigger_regex_open() and it takes event_mutex.

4. onmatch_destroy() and onmatch_create() have long call tree,
 but both are finally invoked from event_trigger_regex_write()
 and event_trace_del_tracer(), former takes event_mutex, and latter
 ensures called under event_mutex locked.

Finally, I ensured there is no resource conflict. For safety,
I added lockdep_assert_held(&event_mutex) for each function.

Link: http://lkml.kernel.org/r/154140864134.17322.4796059721306031894.stgit@devbox

Reviewed-by: Tom Zanussi <tom.zanussi@linux.intel.com>
Tested-by: Tom Zanussi <tom.zanussi@linux.intel.com>
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: George Guo <guodongtai@kylinos.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_hist.c |   30 +++++++-----------------------
 1 file changed, 7 insertions(+), 23 deletions(-)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -443,8 +443,6 @@ static bool have_hist_err(void)
 	return false;
 }
 
-static DEFINE_MUTEX(synth_event_mutex);
-
 struct synth_trace_event {
 	struct trace_entry	ent;
 	u64			fields[];
@@ -1097,7 +1095,6 @@ static int __create_synth_event(int argc
 		return -EINVAL;
 
 	mutex_lock(&event_mutex);
-	mutex_lock(&synth_event_mutex);
 
 	event = find_synth_event(name);
 	if (event) {
@@ -1139,7 +1136,6 @@ static int __create_synth_event(int argc
 	else
 		free_synth_event(event);
  out:
-	mutex_unlock(&synth_event_mutex);
 	mutex_unlock(&event_mutex);
 
 	return ret;
@@ -1159,7 +1155,6 @@ static int create_or_delete_synth_event(
 	/* trace_run_command() ensures argc != 0 */
 	if (name[0] == '!') {
 		mutex_lock(&event_mutex);
-		mutex_lock(&synth_event_mutex);
 		event = find_synth_event(name + 1);
 		if (event) {
 			if (event->ref)
@@ -1173,7 +1168,6 @@ static int create_or_delete_synth_event(
 			}
 		} else
 			ret = -ENOENT;
-		mutex_unlock(&synth_event_mutex);
 		mutex_unlock(&event_mutex);
 		return ret;
 	}
@@ -3660,7 +3654,7 @@ static void onmatch_destroy(struct actio
 {
 	unsigned int i;
 
-	mutex_lock(&synth_event_mutex);
+	lockdep_assert_held(&event_mutex);
 
 	kfree(data->onmatch.match_event);
 	kfree(data->onmatch.match_event_system);
@@ -3673,8 +3667,6 @@ static void onmatch_destroy(struct actio
 		data->onmatch.synth_event->ref--;
 
 	kfree(data);
-
-	mutex_unlock(&synth_event_mutex);
 }
 
 static void destroy_field_var(struct field_var *field_var)
@@ -3810,15 +3802,14 @@ static int onmatch_create(struct hist_tr
 	struct synth_event *event;
 	int ret = 0;
 
-	mutex_lock(&synth_event_mutex);
+	lockdep_assert_held(&event_mutex);
+
 	event = find_synth_event(data->onmatch.synth_event_name);
 	if (!event) {
 		hist_err("onmatch: Couldn't find synthetic event: ", data->onmatch.synth_event_name);
-		mutex_unlock(&synth_event_mutex);
 		return -EINVAL;
 	}
 	event->ref++;
-	mutex_unlock(&synth_event_mutex);
 
 	var_ref_idx = hist_data->n_var_refs;
 
@@ -3892,9 +3883,7 @@ static int onmatch_create(struct hist_tr
  out:
 	return ret;
  err:
-	mutex_lock(&synth_event_mutex);
 	event->ref--;
-	mutex_unlock(&synth_event_mutex);
 
 	goto out;
 }
@@ -5611,6 +5600,8 @@ static void hist_unreg_all(struct trace_
 	struct synth_event *se;
 	const char *se_name;
 
+	lockdep_assert_held(&event_mutex);
+
 	if (hist_file_check_refs(file))
 		return;
 
@@ -5620,12 +5611,10 @@ static void hist_unreg_all(struct trace_
 			list_del_rcu(&test->list);
 			trace_event_trigger_enable_disable(file, 0);
 
-			mutex_lock(&synth_event_mutex);
 			se_name = trace_event_name(file->event_call);
 			se = find_synth_event(se_name);
 			if (se)
 				se->ref--;
-			mutex_unlock(&synth_event_mutex);
 
 			update_cond_flag(file);
 			if (hist_data->enable_timestamps)
@@ -5651,6 +5640,8 @@ static int event_hist_trigger_func(struc
 	char *trigger, *p;
 	int ret = 0;
 
+	lockdep_assert_held(&event_mutex);
+
 	if (glob && strlen(glob)) {
 		last_cmd_set(param);
 		hist_err_clear();
@@ -5741,14 +5732,10 @@ static int event_hist_trigger_func(struc
 		}
 
 		cmd_ops->unreg(glob+1, trigger_ops, trigger_data, file);
-
-		mutex_lock(&synth_event_mutex);
 		se_name = trace_event_name(file->event_call);
 		se = find_synth_event(se_name);
 		if (se)
 			se->ref--;
-		mutex_unlock(&synth_event_mutex);
-
 		ret = 0;
 		goto out_free;
 	}
@@ -5787,13 +5774,10 @@ enable:
 	if (ret)
 		goto out_unreg;
 
-	mutex_lock(&synth_event_mutex);
 	se_name = trace_event_name(file->event_call);
 	se = find_synth_event(se_name);
 	if (se)
 		se->ref++;
-	mutex_unlock(&synth_event_mutex);
-
 	/* Just return zero, not the number of registered triggers */
 	ret = 0;
  out:


