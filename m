Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF2C263C76;
	Tue,  8 Apr 2025 12:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744117121; cv=none; b=U1tPc+/oPoYJNOjld4w4oOPf8u1uyWBZokQ3mxcL7bGaOYww0MT6htEdpfPA6yHX2z04ugx3RKZHTqObW761RoMuKI/Kd+qFWFOz3TIC0pXSSqFRzlONlVuhFSnOQmISZpB8Yk+bY2yLkAD7sgPvWOx10HWrCPu8/Jg+PdfI3dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744117121; c=relaxed/simple;
	bh=jl3Ivb7VJz5lrJKt1Za1PP5ZrOVtcyYmWLFXPtunRl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IHKPA9yIJuLp1AzRsi0TuZjcnmWQSwLqC0nGHY8eMQs7agU0KDf23DPdRmcCD/XxHG3dmjlVId+eKGOYMxLkZxgeuTZHFTnY8GgdT12HolVK3VItPrHvUjhYKfRIlvph5Cp0U+47+nJBQtjhZQUjLPrjcDVHAN6cbffm7e4Lobk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kNtnr2WS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kNtnr2WS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ED2EC4CEE7;
	Tue,  8 Apr 2025 12:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744117119;
	bh=jl3Ivb7VJz5lrJKt1Za1PP5ZrOVtcyYmWLFXPtunRl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kNtnr2WSXJ/LrawZ5urhxHn5Cw4MbH9CI1OslktUWc7IAGH0NTea0HaiXNk74Wfww
	 938Fr4nR7odnjCHVlKAv+w7755j+x+eRSuCsXJwXhcZUeRC2oh16H/CBcaA89Zq6ac
	 M78/nbchSyZo26EHFeZ0CEA26GozNQkQ+Vcl0e8Q=
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
Subject: [PATCH 6.12 352/423] tracing/hist: Support POLLPRI event for poll on histogram
Date: Tue,  8 Apr 2025 12:51:18 +0200
Message-ID: <20250408104854.048315424@linuxfoundation.org>
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
index 9e33cd2a73b5c..e07d75adab8e3 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -5598,6 +5598,7 @@ static void hist_trigger_show(struct seq_file *m,
 struct hist_file_data {
 	struct file *file;
 	u64 last_read;
+	u64 last_act;
 };
 
 static u64 get_hist_hit_count(struct trace_event_file *event_file)
@@ -5633,6 +5634,11 @@ static int hist_show(struct seq_file *m, void *v)
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
@@ -5642,6 +5648,8 @@ static __poll_t event_hist_poll(struct file *file, struct poll_table_struct *wai
 	struct trace_event_file *event_file;
 	struct seq_file *m = file->private_data;
 	struct hist_file_data *hist_file = m->private;
+	__poll_t ret = 0;
+	u64 cnt;
 
 	guard(mutex)(&event_mutex);
 
@@ -5651,10 +5659,15 @@ static __poll_t event_hist_poll(struct file *file, struct poll_table_struct *wai
 
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
@@ -5668,6 +5681,7 @@ static int event_hist_release(struct inode *inode, struct file *file)
 
 static int event_hist_open(struct inode *inode, struct file *file)
 {
+	struct trace_event_file *event_file;
 	struct hist_file_data *hist_file;
 	int ret;
 
@@ -5675,16 +5689,25 @@ static int event_hist_open(struct inode *inode, struct file *file)
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



