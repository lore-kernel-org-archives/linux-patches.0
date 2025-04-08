Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8EC526A0E7;
	Tue,  8 Apr 2025 12:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115277; cv=none; b=OIMw541U5tqqMGHshbfPfTozS0zmGmF816RMbP8S9Jk2p93yEr+tsym3hSljwzzL4Vi8RB1rARQ7iwsWoyIGBaZtSCy0LejmEJKg6vEb4FOphRVxHoWbPadb/pl3MIoGBNwFOa1Sg6nq/LO8dRN12fDC7g/VnY1GB6sro5bWXy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115277; c=relaxed/simple;
	bh=0cpMFj1USyUsDy1FDy/EP7swNVeaNBjUIIlK6tl6VI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RpWUZI1dw/lpRwQAOH2b73a0nktFrigJXxvfyu4pC02wHrtvPwmgGQnBtvxQda/7YPMnGS8Rr6e7Le6k4+HyYkxMIdlHdQScwyQ/Q4oUJFewVuduYRqD6DEipJfC5edvsz4fSjcrKWh/vxRp8R/G1YbSI7E6nffXbNaMy/Xs00w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XT/5zuKj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XT/5zuKj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 302DDC4CEE5;
	Tue,  8 Apr 2025 12:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115276;
	bh=0cpMFj1USyUsDy1FDy/EP7swNVeaNBjUIIlK6tl6VI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XT/5zuKj0uz5Rl+Y86IFQ89/ztWZaanIwjjTvtw7uvijJ2/4aZ5kthHWvpBs32FxP
	 tg+90vsLcDLnb4tDQ3PzS6zYK/7qsiVIFVUVarXkVD2OM8Fdw6fTyCaHJINeqdohjd
	 9PKUvDXmm3GIGydcAlovTgIbejScKsoB5EvlPVU4=
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
Subject: [PATCH 6.13 413/499] tracing: Switch trace_events_hist.c code over to use guard()
Date: Tue,  8 Apr 2025 12:50:25 +0200
Message-ID: <20250408104901.524681942@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 89e5bcb915628..dfd568054f41e 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -5594,25 +5594,19 @@ static int hist_show(struct seq_file *m, void *v)
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
@@ -5873,25 +5867,19 @@ static int hist_debug_show(struct seq_file *m, void *v)
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



