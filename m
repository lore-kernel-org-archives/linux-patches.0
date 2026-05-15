Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A8803B9D84;
	Fri, 15 May 2026 16:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861783; cv=none; b=G1SJWvA+7MLP5jrRcQoVM6kMucvCrkK7twhaS2YT8YX6FVBLwMXDy9tF9YAzGw/sPo52ojWRixwEiBBii8SY78/EJpexuxPV2hNpSBnLvbQ6vNJuBMN8La/AYGtFFDyKqUlGn7zYpGQZUKCAao1bHTUGDsf/gSGduAEjiKXWC/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861783; c=relaxed/simple;
	bh=HJF/OscQ7yJHpLnNHES18tguwPgEhGqDqGFrZXyvzJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P307RGKV1ZvYTU8V90N0xlP8fPLwqFzfc3QxqFAXW5Ad7M1XP9ZXe6tLKB0/9deZrylpDI/yssMXwhCpp6aFsMPWZnTDRfg3zDp+tiyoNPQSyxQq0+tFPHk+9htQAPrLKtXxFEx64eWacPNz0efLOtOJMkodVQWG2SNQEarZMWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0HXwlA6J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0HXwlA6J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC6AFC2BCB0;
	Fri, 15 May 2026 16:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861783;
	bh=HJF/OscQ7yJHpLnNHES18tguwPgEhGqDqGFrZXyvzJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0HXwlA6JQ2sKpOsSWw/Kxp/1h11WtAu7e+JEMtIGBfMe1QMHJHJ4q41Xyfh/8TSgl
	 tQPi74gD3MjUKBXtRTU+KZaiQxB3tExXRIqRZ5OWaxqxa0yjWw+5/JiPjRiqPD9c/J
	 BT/OyCHGecAk8jXEXA2v7MeCAC87BuVHEcuqWXfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 460/474] tracing/probes: Limit size of event probe to 3K
Date: Fri, 15 May 2026 17:49:29 +0200
Message-ID: <20260515154725.053880509@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit b2aa3b4d64e460ac606f386c24e7d8a873ce6f1a ]

There currently isn't a max limit an event probe can be. One could make an
event greater than PAGE_SIZE, which makes the event useless because if
it's bigger than the max event that can be recorded into the ring buffer,
then it will never be recorded.

A event probe should never need to be greater than 3K, so make that the
max size. As long as the max is less than the max that can be recorded
onto the ring buffer, it should be fine.

Cc: stable@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Fixes: 93ccae7a22274 ("tracing/kprobes: Support basic types on dynamic events")
Link: https://patch.msgid.link/20260428122302.706610ba@gandalf.local.home
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[ adjusted context to place MAX_PROBE_EVENT_SIZE near MAX_STRING_SIZE and appended EVENT_TOO_BIG after NEED_STRING_TYPE ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_probe.c | 6 ++++++
 kernel/trace/trace_probe.h | 4 +++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index d46a1033ba5b3..dee9494ed189a 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -1366,6 +1366,12 @@ static int traceprobe_parse_probe_arg_body(const char *argv, ssize_t *size,
 	parg->offset = *size;
 	*size += parg->type->size * (parg->count ?: 1);
 
+	if (*size > MAX_PROBE_EVENT_SIZE) {
+		ret = -E2BIG;
+		trace_probe_log_err(ctx->offset, EVENT_TOO_BIG);
+		goto fail;
+	}
+
 	if (parg->count) {
 		len = strlen(parg->type->fmttype) + 6;
 		parg->fmt = kmalloc(len, GFP_KERNEL);
diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
index c71fa9c2f3815..ce5a0935cd45c 100644
--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -35,6 +35,7 @@
 #define MAX_ARG_NAME_LEN	32
 #define MAX_BTF_ARGS_LEN	128
 #define MAX_STRING_SIZE		PATH_MAX
+#define MAX_PROBE_EVENT_SIZE	3072
 
 /* Reserved field names */
 #define FIELD_STRING_IP		"__probe_ip"
@@ -546,7 +547,8 @@ extern int traceprobe_define_arg_fields(struct trace_event_call *event_call,
 	C(NO_BTF_FIELD,		"This field is not found."),	\
 	C(BAD_BTF_TID,		"Failed to get BTF type info."),\
 	C(BAD_TYPE4STR,		"This type does not fit for string."),\
-	C(NEED_STRING_TYPE,	"$comm and immediate-string only accepts string type"),
+	C(NEED_STRING_TYPE,	"$comm and immediate-string only accepts string type"),\
+	C(EVENT_TOO_BIG,	"Event too big (too many fields?)"),
 
 #undef C
 #define C(a, b)		TP_ERR_##a
-- 
2.53.0



