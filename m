Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 167A23FD956;
	Sat, 12 Sep 2026 15:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227860; cv=none; b=HqrW+cqh3kKLm9DyJw1HWZkX+l54NrKnts+ZEe3/3HFrzu7BpYd39UaxVn2fXUaQV71J8PTd2D6vDS0NbxJqDad6qh4GMNs87W55ELu7Az3ylT74FfUlD7BrjX6lEQdLc0ujaWJ1Igs/AjRNL1bred+/IInWH3aZdu1LNKm1PQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227860; c=relaxed/simple;
	bh=UYVP4g/MNJorJpyiZ9cTKq+4dtKERQqN4yubz2eXVCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=djRLed38lYasyAQj8eiPkZ7EI5IjqmEcAUsBiRod8hWz5KcckyBoWYk3ijIBXS727t4j1BYZdwXNu8prCqDFNp2fZ3/JZDzct0LEHLz58M5vcBJ7H8ULGDGJPxDEP4pxX3JzZgaaeduAne0bm5/GaLq+ZzW2FlHF/3ZcYJaAChw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lZqGi623; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lZqGi623"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48BBF1F000FF;
	Sat, 12 Sep 2026 15:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227856;
	bh=pFl6qpnz98+wWlFUBWpxsNTbszYh9ecb9ddKYBFKZlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lZqGi623zDspdmHzHdE8VXZu8KGTVbufQMoa2ko1ZO+Nkv7p8B64Fqg+evhgxf0Td
	 H1qYny3F5rw0w0687SAXjcIc1KSH5n0WQ93QG9RDk5KHeVapvNCZtOhoR5Ddg4sZ2t
	 CXL/q+DobJY7oQlZ2NwbQR5XFg5WCJkDVr8aXSWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Alexander Martyniuk <alexevgmart@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0266/1191] tracing/mmiotrace: Add NULL check for mmio_trace_array in logging functions
Date: Sat, 12 Sep 2026 08:49:54 +0200
Message-ID: <20260912065554.196536560@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit 12b80cdbc54cf615b4717a4e8180063408091ea2 upstream.

mmio_trace_rw() and mmio_trace_mapping() retrieve mmio_trace_array into
tr and pass it to __trace_mmiotrace_rw() and __trace_mmiotrace_map().
If these functions are invoked while mmio_trace_array is NULL (e.g. before
initialization or after disabled), accessing tr->array_buffer.buffer will
result in a NULL pointer dereference crash.

Fix this by adding an explicit NULL check for tr at the beginning of
__trace_mmiotrace_rw() and __trace_mmiotrace_map().

Link: https://patch.msgid.link/178524300062.56416.8362487250709962380.stgit@devnote2
Fixes: f984b51e0779 ("ftrace: add mmiotrace plugin")
Assisted-by: Antigravity:gemini-3.6-flash
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Alexander Martyniuk <alexevgmart@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_mmiotrace.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
index 74f378fca5187..f4ebf7d9cc25a 100644
--- a/kernel/trace/trace_mmiotrace.c
+++ b/kernel/trace/trace_mmiotrace.c
@@ -295,11 +295,15 @@ static void __trace_mmiotrace_rw(struct trace_array *tr,
 				struct mmiotrace_rw *rw)
 {
 	struct trace_event_call *call = &event_mmiotrace_rw;
-	struct trace_buffer *buffer = tr->array_buffer.buffer;
+	struct trace_buffer *buffer;
 	struct ring_buffer_event *event;
 	struct trace_mmiotrace_rw *entry;
 	unsigned int trace_ctx;
 
+	if (!tr)
+		return;
+
+	buffer = tr->array_buffer.buffer;
 	trace_ctx = tracing_gen_ctx_flags(0);
 	event = trace_buffer_lock_reserve(buffer, TRACE_MMIO_RW,
 					  sizeof(*entry), trace_ctx);
@@ -324,11 +328,15 @@ static void __trace_mmiotrace_map(struct trace_array *tr,
 				struct mmiotrace_map *map)
 {
 	struct trace_event_call *call = &event_mmiotrace_map;
-	struct trace_buffer *buffer = tr->array_buffer.buffer;
+	struct trace_buffer *buffer;
 	struct ring_buffer_event *event;
 	struct trace_mmiotrace_map *entry;
 	unsigned int trace_ctx;
 
+	if (!tr)
+		return;
+
+	buffer = tr->array_buffer.buffer;
 	trace_ctx = tracing_gen_ctx_flags(0);
 	event = trace_buffer_lock_reserve(buffer, TRACE_MMIO_MAP,
 					  sizeof(*entry), trace_ctx);
-- 
2.53.0



