Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 682A82690D6;
	Tue,  8 Apr 2025 12:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115282; cv=none; b=ldY3JKTGuTE7ltnCeJ2io6TANMzIpxGXoLx/03i/GW1k5OiK427+xeRCbRnOGB7F9M2dPm/3adq8vIqtsx5AN/kTE4prpPSZysGTMUrfQ8+18HoPhmNykwKtPhZRzfIZnNA32hTFAU9/e2sJe0Iym10JbYgSi8l2PUF8JTnfd7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115282; c=relaxed/simple;
	bh=HmWO8BCrJCKOLIbRtn5qXn6NXCry7NAa7wYvr70eOvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z0dSNBiNs9OfOFiDgAfaipRrh8qGpPLlFnb6Xe4E+MGD7YMZjdfU58S0zlzWy9RfkVRcycAx2wdqV/AmZh14IaWGIQ22LOF2aeS0m1uYsDcIlZUhV/5f6mlwJhm31H4qX0heniyWS7PIItqiPqDm4fHJStFKzXGAUS7OOALFQuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yTPuFgxZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yTPuFgxZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 857C3C4CEE5;
	Tue,  8 Apr 2025 12:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115281;
	bh=HmWO8BCrJCKOLIbRtn5qXn6NXCry7NAa7wYvr70eOvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yTPuFgxZ7E5SWecQdXovdyUIkzjCx3CItofaMrWIMOA7nD2DV5G37NW4itqlNqsJf
	 chdh6X2WTVLvCeoW08l4EeTowPGWOTVgqd/BnV+aBbuurdtLyVQMEKMPQVi0xMqtay
	 f4opAlHe0DI72H9Hg1kkNF1zi3AkMsLwAWWgxJDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuah Khan <shuah@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Tom Zanussi <zanussi@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 415/499] tracing/hist: Support POLLPRI event for poll on histogram
Date: Tue,  8 Apr 2025 12:50:27 +0200
Message-ID: <20250408104901.576292199@linuxfoundation.org>
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

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit 66fc6f521a0b91051ce6968a216a30bc52267bf8 ]

Since POLLIN will not be flushed until the hist file is read, the user
needs to repeatedly read() and poll() on the hist file for monitoring the
event continuously. But the read() is somewhat redundant when the user is
only monitoring for event updates.

Add POLLPRI poll event on the hist file so the event returns when a
histogram is updated after open(), poll() or read(). Thus it is possible
to wait for the next event without having to issue a read().

Cc: Shuah Khan <shuah@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Link: https://lore.kernel.org/173527248770.464571.2536902137325258133.stgit@devnote2
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Tom Zanussi <zanussi@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Stable-dep-of: 0b4ffbe4888a ("tracing: Correct the refcount if the hist/hist_debug file fails to open")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_hist.c | 29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index a98753475a3fe..ad7419e240556 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -5595,6 +5595,7 @@ static void hist_trigger_show(struct seq_file *m,
 struct hist_file_data {
 	struct file *file;
 	u64 last_read;
+	u64 last_act;
 };
 
 static u64 get_hist_hit_count(struct trace_event_file *event_file)
@@ -5630,6 +5631,11 @@ static int hist_show(struct seq_file *m, void *v)
 			hist_trigger_show(m, data, n++);
 	}
 	hist_file->last_read = get_hist_hit_count(event_file);
+	/*
+	 * Update last_act too so that poll()/POLLPRI can wait for the next
+	 * event after any syscall on hist file.
+	 */
+	hist_file->last_act = hist_file->last_read;
 
 	return 0;
 }
@@ -5639,6 +5645,8 @@ static __poll_t event_hist_poll(struct file *file, struct poll_table_struct *wai
 	struct trace_event_file *event_file;
 	struct seq_file *m = file->private_data;
 	struct hist_file_data *hist_file = m->private;
+	__poll_t ret = 0;
+	u64 cnt;
 
 	guard(mutex)(&event_mutex);
 
@@ -5648,10 +5656,15 @@ static __poll_t event_hist_poll(struct file *file, struct poll_table_struct *wai
 
 	hist_poll_wait(file, wait);
 
-	if (hist_file->last_read != get_hist_hit_count(event_file))
-		return EPOLLIN | EPOLLRDNORM;
+	cnt = get_hist_hit_count(event_file);
+	if (hist_file->last_read != cnt)
+		ret |= EPOLLIN | EPOLLRDNORM;
+	if (hist_file->last_act != cnt) {
+		hist_file->last_act = cnt;
+		ret |= EPOLLPRI;
+	}
 
-	return 0;
+	return ret;
 }
 
 static int event_hist_release(struct inode *inode, struct file *file)
@@ -5665,6 +5678,7 @@ static int event_hist_release(struct inode *inode, struct file *file)
 
 static int event_hist_open(struct inode *inode, struct file *file)
 {
+	struct trace_event_file *event_file;
 	struct hist_file_data *hist_file;
 	int ret;
 
@@ -5672,16 +5686,25 @@ static int event_hist_open(struct inode *inode, struct file *file)
 	if (ret)
 		return ret;
 
+	guard(mutex)(&event_mutex);
+
+	event_file = event_file_data(file);
+	if (!event_file)
+		return -ENODEV;
+
 	hist_file = kzalloc(sizeof(*hist_file), GFP_KERNEL);
 	if (!hist_file)
 		return -ENOMEM;
+
 	hist_file->file = file;
+	hist_file->last_act = get_hist_hit_count(event_file);
 
 	/* Clear private_data to avoid warning in single_open() */
 	file->private_data = NULL;
 	ret = single_open(file, hist_show, hist_file);
 	if (ret)
 		kfree(hist_file);
+
 	return ret;
 }
 
-- 
2.39.5



