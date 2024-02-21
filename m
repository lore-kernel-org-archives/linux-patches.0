Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5BEE7C6E9;
	Wed, 21 Feb 2024 14:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524613; cv=none; b=GI7wiyRN3NcZztqqVGrO5UvysN0N8xEic+h+6SH9PQHL7cIwBp7OCiZ0FswkZ/2XK6pS/1ZojqugQvoYh+jjwh9UMn6bO4t59Fuk/koykhXjMAM2BTH8TTZCNX/Xr2JaIJ5y7anUdmz9FeolDkTWltxPS9ZKc2BRCWGZH4QFhIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524613; c=relaxed/simple;
	bh=zEp8fSqwa243mLx6WXsk1liS4uIfFHbBH60ggIhO0pU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L8hkVCsbjo6Qot1mx+7VQpE2MpAgtKfNg/pnXozMBhEFQy6tgHWZ8IySdxWJkwsiwmI6Tw4dH0bL7GXtbnIj2PyUIqjuWc232/++z/fgPbiGLjwXyi6zjlkkIw0ZPNIFOgGmh9Qp7p0oJFo+3/2lkIT13EvfKLhTCziRHqa+C0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uYxhL/MT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uYxhL/MT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D072C433F1;
	Wed, 21 Feb 2024 14:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524613;
	bh=zEp8fSqwa243mLx6WXsk1liS4uIfFHbBH60ggIhO0pU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uYxhL/MTWg/pKnICK0MzEOCUsknyyNcP8UFt5aZjuVzSj1JS2LqzCuqzHI5509X9h
	 VEE0ZOhacclT7dECtPVoyhZ4dd9ou3NJ6h4OxLMNzrpA31a5tgBrlZqCc7KuA+WjGE
	 K4osesZQ+tSn5lU90HyhbvBblTAXKC3WZPAkB0q0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.10 297/379] tracing/trigger: Fix to return error if failed to alloc snapshot
Date: Wed, 21 Feb 2024 14:07:56 +0100
Message-ID: <20240221130003.710270739@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit 0958b33ef5a04ed91f61cef4760ac412080c4e08 upstream.

Fix register_snapshot_trigger() to return error code if it failed to
allocate a snapshot instead of 0 (success). Unless that, it will register
snapshot trigger without an error.

Link: https://lore.kernel.org/linux-trace-kernel/170622977792.270660.2789298642759362200.stgit@devnote2

Fixes: 0bbe7f719985 ("tracing: Fix the race between registering 'snapshot' event trigger and triggering 'snapshot' operation")
Cc: stable@vger.kernel.org
Cc: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_trigger.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -1140,8 +1140,10 @@ register_snapshot_trigger(char *glob, st
 			  struct event_trigger_data *data,
 			  struct trace_event_file *file)
 {
-	if (tracing_alloc_snapshot_instance(file->tr) != 0)
-		return 0;
+	int ret = tracing_alloc_snapshot_instance(file->tr);
+
+	if (ret < 0)
+		return ret;
 
 	return register_trigger(glob, ops, data, file);
 }


