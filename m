Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B73064C6E;
	Mon, 23 Jun 2025 13:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750686236; cv=none; b=C1EQB7LCyy6P9B10Yq2bPAwYkpPzE+v3JQlOwKG0uUM3epa3cGGgy8ye931lL7ocZPvhO3TZ1T7EaLFmOPpWe3ERnHorWwWThngYDU48Rxgl27CQwdq/yCCXkAevwRgAwxf567brfCPe3umCYjlwMKbo0lRXaNez6+kbQ2IScMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750686236; c=relaxed/simple;
	bh=1/LnvRrvpFg6qt/ctwpNJHWg1mE+jxsgefB+CQVOESI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P3AopTkMPxjBdrj5uW0ogVAc+hoD+3g4W5BVlyux67plUy/4JVtbDAg8NYmb7dzGAeOcyZH6a2ghk8J+DwwABm19wTa24wmOXuWgIzciGcW2YxErzx+NNiQVSTHmb6b1PZKJjUBlovPPmYY0HBETsum7WL63Gga/rOvwA4p1RXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jBzJtHyo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jBzJtHyo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1E79C4CEEA;
	Mon, 23 Jun 2025 13:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750686236;
	bh=1/LnvRrvpFg6qt/ctwpNJHWg1mE+jxsgefB+CQVOESI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jBzJtHyoUV0Jd77rajaCpdStlJ6kmbRPDGIb/n8eUDLbImI2v3WlO3nRuwb3WFuZj
	 ovCXBzcKkpIBxjhmBKKP3gUICFwv6CyfoZWfmTKhrm2vuSF59i9XPo/mve7ZqU24+p
	 cDXE82PfkKPbkpz5r3b7rmofahJfs+I0bQZnLrSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Tom Zanussi <zanussi@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 077/508] tracing: Rename event_trigger_alloc() to trigger_data_alloc()
Date: Mon, 23 Jun 2025 15:02:02 +0200
Message-ID: <20250623130647.131154092@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit f2947c4b7d0f235621c5daf78aecfbd6e22c05e5 ]

The function event_trigger_alloc() creates an event_trigger_data
descriptor and states that it needs to be freed via event_trigger_free().
This is incorrect, it needs to be freed by trigger_data_free() as
event_trigger_free() adds ref counting.

Rename event_trigger_alloc() to trigger_data_alloc() and state that it
needs to be freed via trigger_data_free(). This naming convention
was introducing bugs.

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tom Zanussi <zanussi@kernel.org>
Link: https://lore.kernel.org/20250507145455.776436410@goodmis.org
Fixes: 86599dbe2c527 ("tracing: Add helper functions to simplify event_command.parse() callback handling")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace.h                |  8 +++-----
 kernel/trace/trace_events_hist.c    |  2 +-
 kernel/trace/trace_events_trigger.c | 16 ++++++++--------
 3 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 49b297ca7fc72..950782b0ab1cb 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -1586,6 +1586,9 @@ extern int event_enable_register_trigger(char *glob,
 extern void event_enable_unregister_trigger(char *glob,
 					    struct event_trigger_data *test,
 					    struct trace_event_file *file);
+extern struct event_trigger_data *
+trigger_data_alloc(struct event_command *cmd_ops, char *cmd, char *param,
+		   void *private_data);
 extern void trigger_data_free(struct event_trigger_data *data);
 extern int event_trigger_init(struct event_trigger_data *data);
 extern int trace_event_trigger_enable_disable(struct trace_event_file *file,
@@ -1612,11 +1615,6 @@ extern bool event_trigger_check_remove(const char *glob);
 extern bool event_trigger_empty_param(const char *param);
 extern int event_trigger_separate_filter(char *param_and_filter, char **param,
 					 char **filter, bool param_required);
-extern struct event_trigger_data *
-event_trigger_alloc(struct event_command *cmd_ops,
-		    char *cmd,
-		    char *param,
-		    void *private_data);
 extern int event_trigger_parse_num(char *trigger,
 				   struct event_trigger_data *trigger_data);
 extern int event_trigger_set_filter(struct event_command *cmd_ops,
diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index a11392596a365..c53be68bcd111 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -6520,7 +6520,7 @@ static int event_hist_trigger_parse(struct event_command *cmd_ops,
 		return PTR_ERR(hist_data);
 	}
 
-	trigger_data = event_trigger_alloc(cmd_ops, cmd, param, hist_data);
+	trigger_data = trigger_data_alloc(cmd_ops, cmd, param, hist_data);
 	if (!trigger_data) {
 		ret = -ENOMEM;
 		goto out_free;
diff --git a/kernel/trace/trace_events_trigger.c b/kernel/trace/trace_events_trigger.c
index afdbad16d00a6..22bee3eae7cc3 100644
--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -807,7 +807,7 @@ int event_trigger_separate_filter(char *param_and_filter, char **param,
 }
 
 /**
- * event_trigger_alloc - allocate and init event_trigger_data for a trigger
+ * trigger_data_alloc - allocate and init event_trigger_data for a trigger
  * @cmd_ops: The event_command operations for the trigger
  * @cmd: The cmd string
  * @param: The param string
@@ -818,14 +818,14 @@ int event_trigger_separate_filter(char *param_and_filter, char **param,
  * trigger_ops to assign to the event_trigger_data.  @private_data can
  * also be passed in and associated with the event_trigger_data.
  *
- * Use event_trigger_free() to free an event_trigger_data object.
+ * Use trigger_data_free() to free an event_trigger_data object.
  *
  * Return: The trigger_data object success, NULL otherwise
  */
-struct event_trigger_data *event_trigger_alloc(struct event_command *cmd_ops,
-					       char *cmd,
-					       char *param,
-					       void *private_data)
+struct event_trigger_data *trigger_data_alloc(struct event_command *cmd_ops,
+					      char *cmd,
+					      char *param,
+					      void *private_data)
 {
 	struct event_trigger_data *trigger_data;
 	struct event_trigger_ops *trigger_ops;
@@ -992,7 +992,7 @@ event_trigger_parse(struct event_command *cmd_ops,
 		return ret;
 
 	ret = -ENOMEM;
-	trigger_data = event_trigger_alloc(cmd_ops, cmd, param, file);
+	trigger_data = trigger_data_alloc(cmd_ops, cmd, param, file);
 	if (!trigger_data)
 		goto out;
 
@@ -1772,7 +1772,7 @@ int event_enable_trigger_parse(struct event_command *cmd_ops,
 	enable_data->enable = enable;
 	enable_data->file = event_enable_file;
 
-	trigger_data = event_trigger_alloc(cmd_ops, cmd, param, enable_data);
+	trigger_data = trigger_data_alloc(cmd_ops, cmd, param, enable_data);
 	if (!trigger_data) {
 		kfree(enable_data);
 		goto out;
-- 
2.39.5



