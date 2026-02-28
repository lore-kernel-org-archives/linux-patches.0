Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD0FE37314B;
	Sat, 28 Feb 2026 17:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301512; cv=none; b=eoMAl+ZwOSezv7Z4KnRRC5LeZsOlGi9+1fZJeZOOrQeYY4e8cEnJb5ZcRftr3U1MzM91+z19hN6yGzssHhTBXnITfymtk0WHL1nZB7tgv8/0jYrXOZflvw09AGD8vXnjlDYqscYPuWoNeXBEgYDS4SKKCyopY8OLqg7Do3Di5Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301512; c=relaxed/simple;
	bh=XRwiZaNZbQuldDj1VDHUkDd1Y9KjC1P2HuPvJvBYOIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Op0blqbHLwhMYIxE8ZueESS1hNLSnvkO5algVYKQf+3ikFeCkipjLxPeEpsC3OBQDnDrZPBphtLkEaf3Cez8MtCN/kW+OZggln+yM/sOax1N+Ku+WTbcy43h0KNCwez3hzB8C5Lb9exyZjBXMrac+PQ+XfE3/w5Vj6QgLnUr7Xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K82l3ZCl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K82l3ZCl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E428DC116D0;
	Sat, 28 Feb 2026 17:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301512;
	bh=XRwiZaNZbQuldDj1VDHUkDd1Y9KjC1P2HuPvJvBYOIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K82l3ZCl0cFQ8r9Z95KU39H/S47scP/nW+8BpLPKq+5PkBkMqAU7VcPMqCsy5bHOf
	 T7fm49YK8XxaB5iXvPbsWoN0rNCJzhCtU2ZBaLjpiWKbqCBLqxTOoF+aBW984umXeG
	 LRaBFD6+EoQv7z9xvyCTFkN6m7JXpKbwIrU/KkXC8vw/0BEB/4OPOhSGDQHVa0mx89
	 oQcDZ/WswHmJV98g5kVCGI2dtcHEe7b1rM1nZAEspx762TE2L0c2Y4QYvZfW3dLtl/
	 NKXrYh0PgR4YsTtB43TkX+4F9jjcIeMmrq9AB7J+pRc53JIcWEy3mY/tTLIOuLDK0r
	 2NigqZ7xODfNw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	stable@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 698/752] tracing: Reset last_boot_info if ring buffer is reset
Date: Sat, 28 Feb 2026 12:46:49 -0500
Message-ID: <20260228174750.1542406-698-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>

[ Upstream commit 804c4a2209bcf6ed4c45386f033e4d0f7c5bfda5 ]

Commit 32dc0042528d ("tracing: Reset last-boot buffers when reading
out all cpu buffers") resets the last_boot_info when user read out
all data via trace_pipe* files. But it is not reset when user
resets the buffer from other files. (e.g. write `trace` file)

Reset it when the corresponding ring buffer is reset too.

Cc: stable@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Link: https://patch.msgid.link/177071302364.2293046.17895165659153977720.stgit@mhiramat.tok.corp.google.com
Fixes: 32dc0042528d ("tracing: Reset last-boot buffers when reading out all cpu buffers")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index e1d902464e080..d2eabc162205c 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4852,6 +4852,8 @@ static int tracing_single_release_tr(struct inode *inode, struct file *file)
 	return single_release(inode, file);
 }
 
+static bool update_last_data_if_empty(struct trace_array *tr);
+
 static int tracing_open(struct inode *inode, struct file *file)
 {
 	struct trace_array *tr = inode->i_private;
@@ -4876,6 +4878,8 @@ static int tracing_open(struct inode *inode, struct file *file)
 			tracing_reset_online_cpus(trace_buf);
 		else
 			tracing_reset_cpu(trace_buf, cpu);
+
+		update_last_data_if_empty(tr);
 	}
 
 	if (file->f_mode & FMODE_READ) {
@@ -5917,6 +5921,7 @@ tracing_set_trace_read(struct file *filp, char __user *ubuf,
 int tracer_init(struct tracer *t, struct trace_array *tr)
 {
 	tracing_reset_online_cpus(&tr->array_buffer);
+	update_last_data_if_empty(tr);
 	return t->init(tr);
 }
 
@@ -7582,6 +7587,7 @@ int tracing_set_clock(struct trace_array *tr, const char *clockstr)
 		ring_buffer_set_clock(tr->max_buffer.buffer, trace_clocks[i].func);
 	tracing_reset_online_cpus(&tr->max_buffer);
 #endif
+	update_last_data_if_empty(tr);
 
 	if (tr->scratch && !(tr->flags & TRACE_ARRAY_FL_LAST_BOOT)) {
 		struct trace_scratch *tscratch = tr->scratch;
-- 
2.51.0

