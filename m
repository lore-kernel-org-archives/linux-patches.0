Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81259432E6E;
	Thu, 30 Jul 2026 14:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422206; cv=none; b=RZ7V82iYkBR17vHIuxW5BfDoQmunxJ6CH7M/JA68XgMdrD5n5arP9yAnclbucfn/2tMEWPW5soXPkMLXTHEi7Iduxm9YnyveQH9oLcX5A20g6v1NSy09s9PS9232HatqKDPwGw9VgwPNau8FIpK4E5KJrLLWsfskF577m3tSgLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422206; c=relaxed/simple;
	bh=32m55Ru7fstbwgONuKx0AB6olQRgS2GQax7ragUJV8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jJ+YA6JECHUWVeoFhqvt/gfjBTYc9IUiESYy/z5m814CC4XnIm6YzTGn6c8ZhiSMJDsRx0k6geJ+mAZr6iZ25aLZ4G1N5H02L/GbG/llBdPE1a1E6niPql8icWUeLonR9YoBV42hQAYT4BSE62BcxtQahHIJet90z3j49FdYnkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2gYrkPhQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2gYrkPhQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C81BD1F000E9;
	Thu, 30 Jul 2026 14:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422205;
	bh=H7/nVeYaKP+bgIINK7N0iH58RtY+Wh7axr6g0Ab/1hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2gYrkPhQUUyC84uHdo8y5oPf6IpIhkiVoIgbtF+HWeLduHNOffQe2WpKBEt30bO6q
	 CuIeWM02aLdhC0DPFLEugfzHUu9R8WIQdT2d5wY16bpCw9XCrW+C501rZI82zNEq4e
	 keSuPzjYsEL2zIUfTY72u3iQ8Y6nwkTcjo9CSzS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	David Carlier <devnexen@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 358/744] tracing: Fix use-after-free freeing trigger private data
Date: Thu, 30 Jul 2026 16:10:31 +0200
Message-ID: <20260730141451.893812703@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Carlier <devnexen@gmail.com>

[ Upstream commit 79097812153b826fc156a2930ec8a90ed9edf4a2 ]

Commit 61d445af0a7c ("tracing: Add bulk garbage collection of freeing
event_trigger_data") moved the kfree() of event_trigger_data to a kthread
that runs tracepoint_synchronize_unregister() before freeing. That removed
the synchronization the trigger .free callbacks used to get implicitly and
inline from trigger_data_free().

event_hist_trigger_free(), event_hist_trigger_named_free() and
event_enable_trigger_free() free their satellite data (hist_data, cmd_ops,
enable_data) right after trigger_data_free() returns. With the
synchronization now deferred to the kthread, a concurrent tracepoint
handler can still reach that data through the list_del_rcu()'d trigger,
causing a use-after-free.

The histogram teardown must stay synchronous: remove_hist_vars() and
unregister_field_var_hists() have to detach a synthetic event from the
histogram before the trigger-removal write returns, otherwise a following
command races in and the synthetic-event removal fails with -EBUSY, as the
trigger-synthetic-eprobe.tc selftest catches. Make those callbacks wait
with the correct barrier - tracepoint_synchronize_unregister(), matching
the free kthread - before freeing.

The enable trigger has no such synchronous requirement, and a blocking
synchronize there would re-serialize the path that commit deliberately
deferred. Give it an optional private_data_free() callback that the free
kthread runs after its grace period, and free enable_data from there.

Link: https://patch.msgid.link/20260724030523.19081-1-devnexen@gmail.com
Suggested-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Fixes: 61d445af0a7c ("tracing: Add bulk garbage collection of freeing event_trigger_data")
Signed-off-by: David Carlier <devnexen@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace.h                |  1 +
 kernel/trace/trace_events_hist.c    |  2 ++
 kernel/trace/trace_events_trigger.c | 18 +++++++++++++++---
 3 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 80fe152af1dd84..bf77331f56a4dd 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -1941,6 +1941,7 @@ struct event_trigger_data {
 	struct list_head		named_list;
 	struct event_trigger_data	*named_data;
 	struct llist_node		llist;
+	void				(*private_data_free)(struct event_trigger_data *data);
 };
 
 /* Avoid typos */
diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index 9701650c89b2f2..e287dad25fc39f 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -6358,6 +6358,7 @@ static void event_hist_trigger_free(struct event_trigger_data *data)
 
 		trigger_data_free(data);
 
+		tracepoint_synchronize_unregister();
 		remove_hist_vars(hist_data);
 
 		unregister_field_var_hists(hist_data);
@@ -6397,6 +6398,7 @@ static void event_hist_trigger_named_free(struct event_trigger_data *data)
 
 		del_named_trigger(data);
 		trigger_data_free(data);
+		tracepoint_synchronize_unregister();
 		kfree(cmd_ops);
 	}
 }
diff --git a/kernel/trace/trace_events_trigger.c b/kernel/trace/trace_events_trigger.c
index 655db2e8251349..46e60b70a4bbc4 100644
--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -38,6 +38,13 @@ static void trigger_create_kthread_locked(void)
 	}
 }
 
+static void trigger_data_free_one(struct event_trigger_data *data)
+{
+	if (data->private_data_free)
+		data->private_data_free(data);
+	kfree(data);
+}
+
 static void trigger_data_free_queued_locked(void)
 {
 	struct event_trigger_data *data, *tmp;
@@ -52,7 +59,7 @@ static void trigger_data_free_queued_locked(void)
 	tracepoint_synchronize_unregister();
 
 	llist_for_each_entry_safe(data, tmp, llnodes, llist)
-		kfree(data);
+		trigger_data_free_one(data);
 }
 
 /* Bulk garbage collection of event_trigger_data elements */
@@ -75,7 +82,7 @@ static int trigger_kthread_fn(void *ignore)
 		tracepoint_synchronize_unregister();
 
 		llist_for_each_entry_safe(data, tmp, llnodes, llist)
-			kfree(data);
+			trigger_data_free_one(data);
 	}
 
 	return 0;
@@ -1717,6 +1724,11 @@ int event_enable_trigger_print(struct seq_file *m,
 	return 0;
 }
 
+static void enable_trigger_private_data_free(struct event_trigger_data *data)
+{
+	kfree(data->private_data);
+}
+
 void event_enable_trigger_free(struct event_trigger_data *data)
 {
 	struct enable_trigger_data *enable_data = data->private_data;
@@ -1728,9 +1740,9 @@ void event_enable_trigger_free(struct event_trigger_data *data)
 	if (!data->ref) {
 		/* Remove the SOFT_MODE flag */
 		trace_event_enable_disable(enable_data->file, 0, 1);
+		data->private_data_free = enable_trigger_private_data_free;
 		trace_event_put_ref(enable_data->file->event_call);
 		trigger_data_free(data);
-		kfree(enable_data);
 	}
 }
 
-- 
2.53.0



