Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45327A94A;
	Tue,  8 Apr 2025 11:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112980; cv=none; b=l43raIv38YpKyIG5HkBgvzHPLRRRj15J32TQ00TWejbqK8E8C3bB+HF6aIdPfiNmwxmR8sZaDYjjnMf1sFSEH10zw+g6h+rWpNojdrdnCDoeJdcGVPRyML34Ygb1Cnolj6gp6ha9zipP3ayHBV5JzXNcWGdXO03CBlUAJORLizY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112980; c=relaxed/simple;
	bh=/fl5ruZVe8rlvwSCib5YveFXhaoFEF0uWmOLH9JKT8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mh7WCHv5/XJjEBtL2KAcQB+evAe6nYp66SRkWVnoW7pnJEBemZdYVwFfJzn76LK0pLN92FdOjG6LwaN/BM2Uz4hTa4pfEmbNcgsqeuYjfOsuGn7k6cyw/p6XesFsIZlVHylTyS5+3v7nBQgZvEmB0Hj00V9r54r8M/skQ5SEt4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UEzMay0J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UEzMay0J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7810C4CEE5;
	Tue,  8 Apr 2025 11:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112980;
	bh=/fl5ruZVe8rlvwSCib5YveFXhaoFEF0uWmOLH9JKT8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UEzMay0Jovs+xBH+u+yzo//svqXDV3/d1GRbxJPupLUVtb9jpJwg5xKCh0S3k2Hio
	 APvg96zJoi6LfyUwvqpX6owpLgGVnp210XWNB6wIExHz4zS1Ql37JB0VqO1Ta12id7
	 6fl6JRwwr99V6TJCS7kZwQIgSHNWX1zcbEy/q9hM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Douglas Raillard <douglas.raillard@arm.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.15 269/279] tracing: Ensure module defining synth event cannot be unloaded while tracing
Date: Tue,  8 Apr 2025 12:50:52 +0200
Message-ID: <20250408104833.654534397@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 kernel/trace/trace_events_synth.c |   31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace_events_synth.c
+++ b/kernel/trace/trace_events_synth.c
@@ -856,6 +856,35 @@ static struct trace_event_fields synth_e
 	{}
 };
 
+static int synth_event_reg(struct trace_event_call *call,
+		    enum trace_reg type, void *data)
+{
+	struct synth_event *event = container_of(call, struct synth_event, call);
+	int ret;
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
+	ret = trace_event_reg(call, type, data);
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
@@ -885,7 +914,7 @@ static int register_synth_event(struct s
 		goto out;
 	}
 	call->flags = TRACE_EVENT_FL_TRACEPOINT;
-	call->class->reg = trace_event_reg;
+	call->class->reg = synth_event_reg;
 	call->class->probe = trace_event_raw_event_synth;
 	call->data = event;
 	call->tp = event->tp;


