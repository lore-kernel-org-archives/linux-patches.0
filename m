Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 292573AFB1A;
	Sat, 12 Sep 2026 18:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237299; cv=none; b=LoeDkOjVj8Mk8vU8kbHxxXK3FZvB9+Ci/5ICmtjcnx/wnE2l0YufJ7VZRbPR1VjjGniV+5SxdsA9Dkjnz5w54onl82HHW2ifrjGCDdQjldMllFddsFas/JSPNcZy7fSkLwkoRbX9BZxAp2EfPEnji8abYTru1xa4xRrrILVrIas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237299; c=relaxed/simple;
	bh=COpSwlTpC7oHAlwakXIj7rYc2seIRVHnx5DZu/Q1ugg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tkoOiATQxKoShWUfGrEcHnVpZDksHeMxS0uXkQUdJB19N0puDuCltdV+H+w+qOBgtIWLvUL0xswZzLGX60xNqrwdx5u5Ivi/QCckzWGJBrsuyuWFFd4qKGwOpyPk13QPQG2BR5ZgUQyhkjzMgavfqWTGwgggb0pW9VUM9J2PwEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tRXAzxuz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tRXAzxuz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E73A91F000FF;
	Sat, 12 Sep 2026 18:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237297;
	bh=0NFLiu0lm0V69TYM4ZF5aBUf380bpwIbNjW/D6ilfo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tRXAzxuzrR449nVkiddCS56jMYm2qEFvRUZAHFEKcGjA9rcPNef8UDOFDf0yQNAIO
	 e2Eo+2BIfWFZ5J9Eb9hzlrK3KXMW31aAZ4U6+BnGQkhQRbpg1Pj6PsbkVmfdvOSu5f
	 MsP8EUnTGo3Jz4HO+e/tmvVJaUNg5N1hJ+26CwZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Alexander Martyniuk <alexevgmart@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 231/935] tracing/mmiotrace: Add NULL check for mmio_trace_array in logging functions
Date: Sat, 12 Sep 2026 08:54:21 +0200
Message-ID: <20260912065532.125560217@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



