Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC2FB26B0BF;
	Thu, 13 Feb 2025 15:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459982; cv=none; b=D/nC3pSuCgX337AT75QhjiRKoRUmnm7jxMZs/Q0rVhFX82Sl55ZhzabREntzcNLW+RVRK2sNSa0Pizks9l8CrqRxvRzkKHi6aFpZK51h/dTr7sTOr+3fDzCxPLHH/5I0Gt7lI1o0Tu03vZU0ba9ZChNQI5un/7riUdeBIdLBOTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459982; c=relaxed/simple;
	bh=Rkw+nfsJrRM7i9cCWOGfgGYzbjZ7YFiBUUPqZhWd0YA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OcTwCqaJ75ohsQzmRBkmCH6RGwNjLLUhUpzycvUcqX6IQ1ZarcMbIVFpzs3eg633G4lSNKi0nbhbdPK9Lo7z/pgo2vENNXnTX+vEaxIV3T8cRy42XA2PycX5Yxa7W+yhqVtRfI7h2pMbgS3zChAuXIldjzsLpp4qfJMB+btPoAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nke2R15n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nke2R15n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A43FC4CED1;
	Thu, 13 Feb 2025 15:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459981;
	bh=Rkw+nfsJrRM7i9cCWOGfgGYzbjZ7YFiBUUPqZhWd0YA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nke2R15ny6SNzVshre78Za/K7Aqj5HaAJ8izTTBVjEKVoEylKhcAxPUSOTD/bioO3
	 6b1/CLlSrKU6iDv1z7vz3jSXK+FLX0ykj9WwvlqRTj92DyeiTFbyvD3I9FxYJVSPyG
	 4kiqPgbdvhnDi/WuuPgAgse2I/d5v66LkEltwKc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Kacur <jkacur@redhat.com>,
	Luis Goncalves <lgoncalv@redhat.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Tomas Glozar <tglozar@redhat.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.13 423/443] rtla: Add trace_instance_stop
Date: Thu, 13 Feb 2025 15:29:48 +0100
Message-ID: <20250213142456.944869694@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

From: Tomas Glozar <tglozar@redhat.com>

commit e879b5dcf8d044f3865a32d95cc5b213f314c54f upstream.

Support not only turning trace on for the timerlat tracer, but also
turning it off.

This will be used in subsequent patches to stop the timerlat tracer
without also wiping the trace buffer.

Cc: stable@vger.kernel.org
Cc: John Kacur <jkacur@redhat.com>
Cc: Luis Goncalves <lgoncalv@redhat.com>
Cc: Gabriele Monaco <gmonaco@redhat.com>
Link: https://lore.kernel.org/20250116144931.649593-2-tglozar@redhat.com
Signed-off-by: Tomas Glozar <tglozar@redhat.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/tracing/rtla/src/trace.c |    8 ++++++++
 tools/tracing/rtla/src/trace.h |    1 +
 2 files changed, 9 insertions(+)

--- a/tools/tracing/rtla/src/trace.c
+++ b/tools/tracing/rtla/src/trace.c
@@ -197,6 +197,14 @@ int trace_instance_start(struct trace_in
 }
 
 /*
+ * trace_instance_stop - stop tracing a given rtla instance
+ */
+int trace_instance_stop(struct trace_instance *trace)
+{
+	return tracefs_trace_off(trace->inst);
+}
+
+/*
  * trace_events_free - free a list of trace events
  */
 static void trace_events_free(struct trace_events *events)
--- a/tools/tracing/rtla/src/trace.h
+++ b/tools/tracing/rtla/src/trace.h
@@ -21,6 +21,7 @@ struct trace_instance {
 
 int trace_instance_init(struct trace_instance *trace, char *tool_name);
 int trace_instance_start(struct trace_instance *trace);
+int trace_instance_stop(struct trace_instance *trace);
 void trace_instance_destroy(struct trace_instance *trace);
 
 struct trace_seq *get_trace_seq(void);


