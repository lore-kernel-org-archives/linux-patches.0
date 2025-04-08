Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C7F93AC1C;
	Tue,  8 Apr 2025 12:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113623; cv=none; b=dOEGHgE0nmJBxz4YNygADl9flEJLeccuDJ/zhKJT2VMfclqkA9Ajz7fWMsQHghfyoNHUEPd7f3U47dQ0nfG3ZsyfGzL2tqyR03yfCEM/HCjh3A/LvsmTN9M1BDosgI60MLNXGLdYwIFDvE8P4qIcGgCyivhlev+X6T4aZS4Xp54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113623; c=relaxed/simple;
	bh=lKcHf/NJ1JBKHQsohFQrhwbBcx2MT9sea6R9kl37gOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fRGAn59Q9749xOQJp5E1+SUJd1OiOgMEJoRVR3W1q6D7dP6V06uXjNb6ZNP6M4njPVLS6wyO+MlVVsFJddml1x4LvxRM0nMmxB9ZC1xE/raXXbFBoQ4HM3V4ZurhH7AUopIcj5yKwCyKucmXY39FIyjnTFyzNh5GYpuLpn7fU+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X03+OOKS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X03+OOKS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C437EC4CEEA;
	Tue,  8 Apr 2025 12:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113623;
	bh=lKcHf/NJ1JBKHQsohFQrhwbBcx2MT9sea6R9kl37gOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X03+OOKSm3W4uOq3RUYUkwgkRk+phuhaAQ9/P6fTUMiSKgviGzUTVORN7RIy0sOhI
	 UGig7CpcGK1Vn3wmOgeWC9hSbXNCsd8VR00hwLlV3l+Ia3oIOegF08LkeujJS0rh1s
	 N67NZKBUAs7g+Cbfji+M/XF/POgkj6BytJfpnYug=
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
Subject: [PATCH 6.6 227/268] tracing/hist: Support POLLPRI event for poll on histogram
Date: Tue,  8 Apr 2025 12:50:38 +0200
Message-ID: <20250408104834.710267575@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 49b7811dec9f8..08cc6405b8837 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -5606,6 +5606,7 @@ static void hist_trigger_show(struct seq_file *m,
 struct hist_file_data {
 	struct file *file;
 	u64 last_read;
+	u64 last_act;
 };
 
 static u64 get_hist_hit_count(struct trace_event_file *event_file)
@@ -5641,6 +5642,11 @@ static int hist_show(struct seq_file *m, void *v)
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
@@ -5650,6 +5656,8 @@ static __poll_t event_hist_poll(struct file *file, struct poll_table_struct *wai
 	struct trace_event_file *event_file;
 	struct seq_file *m = file->private_data;
 	struct hist_file_data *hist_file = m->private;
+	__poll_t ret = 0;
+	u64 cnt;
 
 	guard(mutex)(&event_mutex);
 
@@ -5659,10 +5667,15 @@ static __poll_t event_hist_poll(struct file *file, struct poll_table_struct *wai
 
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
@@ -5676,6 +5689,7 @@ static int event_hist_release(struct inode *inode, struct file *file)
 
 static int event_hist_open(struct inode *inode, struct file *file)
 {
+	struct trace_event_file *event_file;
 	struct hist_file_data *hist_file;
 	int ret;
 
@@ -5683,16 +5697,25 @@ static int event_hist_open(struct inode *inode, struct file *file)
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



