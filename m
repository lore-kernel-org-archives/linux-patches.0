Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 251F227CB27;
	Tue,  8 Apr 2025 12:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744117114; cv=none; b=SMfWk9DBHxfbztaULs9RwXMZajXd84gjsCsGV6Mo5Bvlc+FA8i0CR+Jor7msGlbwAKR77Cl4ltlMPmxMxMvm3i05v7GH7rupH2QV7IxXdnDwc7x4RG3CMjr48xDDZJRe2ONlvSvhYBENa7QC3ydErb47ZEyxVY+5rODknmI2Tqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744117114; c=relaxed/simple;
	bh=FFX11LoRt7nBeliucvYMzZ4Hh/TVHBpN5R1JVusrar0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GUhsC/beQOzY6+R6orHHPT5qRLIdgnL/UsI9/2WRTHepdtlDQDFuJQhmGhkH4/elM8Rzi2C8Bd+qIqqiNmZTGG1iPwoi8Vl2xIk3rd5S5ppnvd1UTr4r3cFJF9FhBD4W8VD0i435/pnQ8nw0o75de8fFiGTUPnUpLpWl7mfSztQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p1NMOavV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p1NMOavV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5865C4CEE5;
	Tue,  8 Apr 2025 12:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744117114;
	bh=FFX11LoRt7nBeliucvYMzZ4Hh/TVHBpN5R1JVusrar0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p1NMOavVBvZi218dRyVtth34lUyLTU+R7HyrgdVLkXGfkLx7LHpe6E0+dkk38lPlu
	 ez8qCwxzYD0siGYeJCgFYxSuH97GBFJpNOBuZs7Dydjymb3zb+0Wqh5H/70XWaLB9v
	 8IhavLKZdJbS0IQYmMfC5vcJ8bJXBUXCqWxCUa38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 350/423] tracing: Switch trace_events_hist.c code over to use guard()
Date: Tue,  8 Apr 2025 12:51:16 +0200
Message-ID: <20250408104853.996257190@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit 2b36a97aeeb71b1e4a48bfedc7f21f44aeb1e6fb ]

There are a couple functions in trace_events_hist.c that have "goto out" or
equivalent on error in order to release locks that were taken. This can be
error prone or just simply make the code more complex.

Switch every location that ends with unlocking a mutex on error over to
using the guard(mutex)() infrastructure to let the compiler worry about
releasing locks. This makes the code easier to read and understand.

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/20241219201345.694601480@goodmis.org
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Stable-dep-of: 0b4ffbe4888a ("tracing: Correct the refcount if the hist/hist_debug file fails to open")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_hist.c | 32 ++++++++++----------------------
 1 file changed, 10 insertions(+), 22 deletions(-)

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index 31f5ad322fab0..5d344bc690d99 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -5597,25 +5597,19 @@ static int hist_show(struct seq_file *m, void *v)
 {
 	struct event_trigger_data *data;
 	struct trace_event_file *event_file;
-	int n = 0, ret = 0;
+	int n = 0;
 
-	mutex_lock(&event_mutex);
+	guard(mutex)(&event_mutex);
 
 	event_file = event_file_file(m->private);
-	if (unlikely(!event_file)) {
-		ret = -ENODEV;
-		goto out_unlock;
-	}
+	if (unlikely(!event_file))
+		return -ENODEV;
 
 	list_for_each_entry(data, &event_file->triggers, list) {
 		if (data->cmd_ops->trigger_type == ETT_EVENT_HIST)
 			hist_trigger_show(m, data, n++);
 	}
-
- out_unlock:
-	mutex_unlock(&event_mutex);
-
-	return ret;
+	return 0;
 }
 
 static int event_hist_open(struct inode *inode, struct file *file)
@@ -5876,25 +5870,19 @@ static int hist_debug_show(struct seq_file *m, void *v)
 {
 	struct event_trigger_data *data;
 	struct trace_event_file *event_file;
-	int n = 0, ret = 0;
+	int n = 0;
 
-	mutex_lock(&event_mutex);
+	guard(mutex)(&event_mutex);
 
 	event_file = event_file_file(m->private);
-	if (unlikely(!event_file)) {
-		ret = -ENODEV;
-		goto out_unlock;
-	}
+	if (unlikely(!event_file))
+		return -ENODEV;
 
 	list_for_each_entry(data, &event_file->triggers, list) {
 		if (data->cmd_ops->trigger_type == ETT_EVENT_HIST)
 			hist_trigger_debug_show(m, data, n++);
 	}
-
- out_unlock:
-	mutex_unlock(&event_mutex);
-
-	return ret;
+	return 0;
 }
 
 static int event_hist_debug_open(struct inode *inode, struct file *file)
-- 
2.39.5



