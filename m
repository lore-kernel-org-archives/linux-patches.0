Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1DF3DA7E1;
	Tue, 16 Jun 2026 18:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634763; cv=none; b=S1OpfxdxUQX0R5/djLS6sHyUIGbJRNeXEOXZL8385BRmuqU9FXP3QzUt+DicPnZmDIGdMuuBUUKa2v4hy+c1tUjTR+KeJs3gLre9IPmKCpN3o3usWITws4EUJfZXgyamIJMeNngHp5bfxs+KXeuby1MJMQMlbtaW5NXZraCu6n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634763; c=relaxed/simple;
	bh=YgU5QmY8nNjDmUvwqJGfPyahBwcVsSLjp8A2s89CIMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CBe4rM6oEowedjPVl62uehlHwZunfzReyVOY2t/NayZPxTV8Pe+qvETa0q1BhEtZscaW90QqrX4vpNy6DsGl/kVWLmP9Rx/9h3H22C2qVxfNyFqfjYUHt5xkcR5LFwHAj0DfMThcTIdz9HTnRDTFH1R6TutPA7RVkdWLNwee6xE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U5ttypm3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U5ttypm3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF9791F000E9;
	Tue, 16 Jun 2026 18:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634762;
	bh=SsyRFvVessaoVBQmvn1UixiCYo41Gmtr6haKgD7ZQM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U5ttypm3t5qwwLC+tnZhBvgloevD69cizL/QewSGhxszwBsjaYcjk8g0o1aht9FzZ
	 9iwaJ8UF1Ze5M3u470mVxTf90XDIt9GQ/ke0zVQFwTS/GPBVfEmONMKUvE4YsDoze4
	 KvhG9L9WAuLTYaPRlR8C6rB/cJ4q+DFRh7SLC6hk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 325/411] tracing/probes: Limit size of event probe to 3K
Date: Tue, 16 Jun 2026 20:29:23 +0530
Message-ID: <20260616145118.427843398@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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
[ adjusted context for missing later-kernel infrastructure and used `goto out` instead of `goto fail` ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_probe.c |    6 ++++++
 kernel/trace/trace_probe.h |    4 +++-
 2 files changed, 9 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -647,6 +647,12 @@ static int traceprobe_parse_probe_arg_bo
 	parg->offset = *size;
 	*size += parg->type->size * (parg->count ?: 1);
 
+	if (*size > MAX_PROBE_EVENT_SIZE) {
+		ret = -E2BIG;
+		trace_probe_log_err(offset, EVENT_TOO_BIG);
+		goto out;
+	}
+
 	ret = -ENOMEM;
 	if (parg->count) {
 		len = strlen(parg->type->fmttype) + 6;
--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -33,6 +33,7 @@
 #define MAX_ARRAY_LEN		64
 #define MAX_ARG_NAME_LEN	32
 #define MAX_STRING_SIZE		PATH_MAX
+#define MAX_PROBE_EVENT_SIZE	3072
 
 /* Reserved field names */
 #define FIELD_STRING_IP		"__probe_ip"
@@ -455,7 +456,8 @@ extern int traceprobe_define_arg_fields(
 	C(FAIL_REG_PROBE,	"Failed to register probe event"),\
 	C(DIFF_PROBE_TYPE,	"Probe type is different from existing probe"),\
 	C(DIFF_ARG_TYPE,	"Argument type or name is different from existing probe"),\
-	C(SAME_PROBE,		"There is already the exact same probe event"),
+	C(SAME_PROBE,		"There is already the exact same probe event"),\
+	C(EVENT_TOO_BIG,	"Event too big (too many fields?)"),
 
 #undef C
 #define C(a, b)		TP_ERR_##a


