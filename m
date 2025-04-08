Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E36920330;
	Tue,  8 Apr 2025 12:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116032; cv=none; b=V7BBesYJU5q35Zi4J3pQptXjZIl3TpoNbq3x982HcB/VnccF3DEI3zKklURkgp1HB1GRQnjGPVgA+lpYZIxk9Dpn9bxMWVv7CtfgA0ap/Y4kfm0G0YnBqQGX75N2W7M0TWFbZkIdDJG0xsUp+SOj6Bv/Pv2iCI2gyAUrmFfbOGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116032; c=relaxed/simple;
	bh=xXaQdKQsMIBdX/IjeYBTXS9aT8im45KKEntwFlW6zeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rDNBPQb1QU0DUpgCwvePmaZzljRQciD5xcqoHVr+qa+h4zMcMswOh3rlIFyb8twr3pKtuobTzUupp+zfpSNjyGQRmhX+SE0u9o7C4BJkN1elFjRUO8oIVZ2pVOo4rbta84OQFRpyakQ/4pWPA9F3Vnn9TJJlvsnZpxxCuBdZpgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PfQVPfHm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PfQVPfHm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E774C4CEE5;
	Tue,  8 Apr 2025 12:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116031;
	bh=xXaQdKQsMIBdX/IjeYBTXS9aT8im45KKEntwFlW6zeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PfQVPfHmKZWPM+UbdBo0a6Ubg4e71+KMTufOFHFFVE4WzAjR2QJHbfUBRkaRiWcI8
	 HJp+Tlu1rbEYejc4ppj0dbpRHT80VLYFKVGomjY+xxMYBA1A+05VHxAz6pY++yOeT1
	 SGe1sG9tS6t+2+wFsS51F4MYPgAcZRizcUaco+p0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Douglas Raillard <douglas.raillard@arm.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.1 194/204] tracing: Ensure module defining synth event cannot be unloaded while tracing
Date: Tue,  8 Apr 2025 12:52:04 +0200
Message-ID: <20250408104826.004761317@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Raillard <douglas.raillard@arm.com>

commit 21581dd4e7ff6c07d0ab577e3c32b13a74b31522 upstream.

Currently, using synth_event_delete() will fail if the event is being
used (tracing in progress), but that is normally done in the module exit
function. At that stage, failing is problematic as returning a non-zero
status means the module will become locked (impossible to unload or
reload again).

Instead, ensure the module exit function does not get called in the
first place by increasing the module refcnt when the event is enabled.

Cc: stable@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Fixes: 35ca5207c2d11 ("tracing: Add synthetic event command generation functions")
Link: https://lore.kernel.org/20250318180906.226841-1-douglas.raillard@arm.com
Signed-off-by: Douglas Raillard <douglas.raillard@arm.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_synth.c |   30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace_events_synth.c
+++ b/kernel/trace/trace_events_synth.c
@@ -875,6 +875,34 @@ static struct trace_event_fields synth_e
 	{}
 };
 
+static int synth_event_reg(struct trace_event_call *call,
+		    enum trace_reg type, void *data)
+{
+	struct synth_event *event = container_of(call, struct synth_event, call);
+
+	switch (type) {
+	case TRACE_REG_REGISTER:
+	case TRACE_REG_PERF_REGISTER:
+		if (!try_module_get(event->mod))
+			return -EBUSY;
+		break;
+	default:
+		break;
+	}
+
+	int ret = trace_event_reg(call, type, data);
+
+	switch (type) {
+	case TRACE_REG_UNREGISTER:
+	case TRACE_REG_PERF_UNREGISTER:
+		module_put(event->mod);
+		break;
+	default:
+		break;
+	}
+	return ret;
+}
+
 static int register_synth_event(struct synth_event *event)
 {
 	struct trace_event_call *call = &event->call;
@@ -904,7 +932,7 @@ static int register_synth_event(struct s
 		goto out;
 	}
 	call->flags = TRACE_EVENT_FL_TRACEPOINT;
-	call->class->reg = trace_event_reg;
+	call->class->reg = synth_event_reg;
 	call->class->probe = trace_event_raw_event_synth;
 	call->data = event;
 	call->tp = event->tp;


