Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A7B21A01BF;
	Tue, 12 Aug 2025 18:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024444; cv=none; b=E1ClnCfHvhmt9fxc+o3+W0FkM1RItUrvZKc9vYMILeburSp0pxyRbZzjdB9DUuUOoCPTzBVxolmis9rQEnescvN0doeffP4jTcghuZ9Dcoq1gQUJ6IqO4/a0E5rNcOyYT0TAY6V6Izul/AIVdIHpcK45c5SApjFxmfsorpvtZh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024444; c=relaxed/simple;
	bh=jbAQU51pY6nZSFypqKfzsAnW9FA9n8IeMP55/iSizlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G1Gsda5Lnb6G8mdXbphuNnO47pzGRNrdzh0Qzrnih5L37E+bzV+hmiDlLZd329XPcDelHoIv10hYq/Bvg4nBbRjfDlazgV0jLA0pMMh93QrVg7lNAIgf+N6c4LXPMLwyAJrmv2PGOqRu+JROWNSj6ksuukBJEdPGzXEFajklIYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wYkz7EdL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wYkz7EdL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18D90C4CEF0;
	Tue, 12 Aug 2025 18:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024444;
	bh=jbAQU51pY6nZSFypqKfzsAnW9FA9n8IeMP55/iSizlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wYkz7EdL5Zy2V2jLz+IRfx8DsHbu6AwpBFjy14v0DESOLJV0KopJb8lhmRz+Kdfbq
	 oOmyE1BQXlpKi7i9GQIuxkcmGWtUkGHzbENs5fuqYSpaS3BATEYigoENz4+nET+njl
	 RM7fx5fac+3+yGJfM9giV+zKn2X5JjXm3ZVgi5b8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 374/627] tracing: Use queue_rcu_work() to free filters
Date: Tue, 12 Aug 2025 19:31:09 +0200
Message-ID: <20250812173433.529747839@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit 3aceaa539cfe3a2e62bd92e6697d9fae1c20c0be ]

Freeing of filters requires to wait for both an RCU grace period as well as
a RCU task trace wait period after they have been detached from their
lists. The trace task period can be quite large so the freeing of the
filters was moved to use the call_rcu*() routines. The problem with that is
that the callback functions of call_rcu*() is done from a soft irq and can
cause latencies if the callback takes a bit of time.

The filters are freed per event in a system and the syscalls system
contains an event per system call, which can be over 700 events. Freeing 700
filters in a bottom half is undesirable.

Instead, move the freeing to use queue_rcu_work() which is done in task
context.

Link: https://lore.kernel.org/all/9a2f0cd0-1561-4206-8966-f93ccd25927f@paulmck-laptop/

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Link: https://lore.kernel.org/20250609131732.04fd303b@gandalf.local.home
Fixes: a9d0aab5eb33 ("tracing: Fix regression of filter waiting a long time on RCU synchronization")
Suggested-by: "Paul E. McKenney" <paulmck@kernel.org>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_filter.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 3885aadc434d..196c8bf34970 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -1344,13 +1344,14 @@ struct filter_list {
 
 struct filter_head {
 	struct list_head	list;
-	struct rcu_head		rcu;
+	union {
+		struct rcu_head		rcu;
+		struct rcu_work		rwork;
+	};
 };
 
-
-static void free_filter_list(struct rcu_head *rhp)
+static void free_filter_list(struct filter_head *filter_list)
 {
-	struct filter_head *filter_list = container_of(rhp, struct filter_head, rcu);
 	struct filter_list *filter_item, *tmp;
 
 	list_for_each_entry_safe(filter_item, tmp, &filter_list->list, list) {
@@ -1361,9 +1362,20 @@ static void free_filter_list(struct rcu_head *rhp)
 	kfree(filter_list);
 }
 
+static void free_filter_list_work(struct work_struct *work)
+{
+	struct filter_head *filter_list;
+
+	filter_list = container_of(to_rcu_work(work), struct filter_head, rwork);
+	free_filter_list(filter_list);
+}
+
 static void free_filter_list_tasks(struct rcu_head *rhp)
 {
-	call_rcu(rhp, free_filter_list);
+	struct filter_head *filter_list = container_of(rhp, struct filter_head, rcu);
+
+	INIT_RCU_WORK(&filter_list->rwork, free_filter_list_work);
+	queue_rcu_work(system_wq, &filter_list->rwork);
 }
 
 /*
@@ -1460,7 +1472,7 @@ static void filter_free_subsystem_filters(struct trace_subsystem_dir *dir,
 	tracepoint_synchronize_unregister();
 
 	if (head)
-		free_filter_list(&head->rcu);
+		free_filter_list(head);
 
 	list_for_each_entry(file, &tr->events, list) {
 		if (file->system != dir || !file->filter)
@@ -2305,7 +2317,7 @@ static int process_system_preds(struct trace_subsystem_dir *dir,
 	return 0;
  fail:
 	/* No call succeeded */
-	free_filter_list(&filter_list->rcu);
+	free_filter_list(filter_list);
 	parse_error(pe, FILT_ERR_BAD_SUBSYS_FILTER, 0);
 	return -EINVAL;
  fail_mem:
@@ -2315,7 +2327,7 @@ static int process_system_preds(struct trace_subsystem_dir *dir,
 	if (!fail)
 		delay_free_filter(filter_list);
 	else
-		free_filter_list(&filter_list->rcu);
+		free_filter_list(filter_list);
 
 	return -ENOMEM;
 }
-- 
2.39.5



