Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D4D3290C7;
	Fri,  7 Aug 2026 14:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114032; cv=none; b=bRtYtRGdqd1+wpBqP+VqKJEe/fdxiPgDb97cTc6BuqemoOwtHhaxBe+Q9W1Gk/WhX70kTmqQ3dDuTuuaBVqaOivzwjDT/TNaVliNsSXSHL3do/PCNwAfgzVEZpnH/BWBacM08A5Izb1T6JvlILj2ZvuoCzgK+ZnfSm9/yVBPfq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114032; c=relaxed/simple;
	bh=zssasMBzQYxaIHYg9zPtwx8nx61ZqWUZfnojSv0pJDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sgG1aKvn3Y3ckHebHnys90muBS/FOANW57TEM9CVR0oWeYzOoTCcGUpA4kpLoWzBKkThRzMvnl2J7gd4zqLscEpVaqx0VIgo+UIaSLYf9V4YPJ8LLKBwyggaOf6ww3BUZYNR9GsyQpm4N1kUyv77jS/qBir9v0MgKCL8I1pUDj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wtZKIA/E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wtZKIA/E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F15231F000E9;
	Fri,  7 Aug 2026 14:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114028;
	bh=23wbqT2c66UBI+YmShP38zlIT3IAqHWaG2WpkrrFv08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wtZKIA/E1VAYa8jNOk8PWCNPOF123imO7X+REUthoXZWhCEOFSzdCivHsgyfwa5FP
	 pczfnTMrnkfmzOoWLjQZKs9nAKTAw+TNaW6IwHGFQS8YFqlha7WQ9twdGzUpnWjzCE
	 dVgtcxCdVYC7f5w2qCx38jmGQup5O/CbhGvLS+gk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 117/337] tracing/mmiotrace: Add NULL check for mmio_trace_array in logging functions
Date: Fri,  7 Aug 2026 16:35:20 +0200
Message-ID: <20260807143421.067366429@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit 12b80cdbc54cf615b4717a4e8180063408091ea2 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_mmiotrace.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
index 6b964471265e1..251ed7051e409 100644
--- a/kernel/trace/trace_mmiotrace.c
+++ b/kernel/trace/trace_mmiotrace.c
@@ -295,11 +295,15 @@ static void __trace_mmiotrace_rw(struct trace_array *tr,
 				struct trace_array_cpu *data,
 				struct mmiotrace_rw *rw)
 {
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
 				struct trace_array_cpu *data,
 				struct mmiotrace_map *map)
 {
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



