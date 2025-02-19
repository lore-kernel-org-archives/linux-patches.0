Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 880091BD9D3;
	Wed, 19 Feb 2025 09:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957192; cv=none; b=Zc7ZhF3TW7px4uuU/aZpOFm+X57OgqBxuoAnFAC3LJ/f5z1F81IM+xCUcvDXxJBL+aY95NElaXC3V7t+y5GZEyZtDJpa3FcLNS5eTP/9oQbz4pEC2um2ZX6OeyGlUow8AggrplaC/wuoWxgk2LFO7FkkaeNYDtFE+lzEtmGVYTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957192; c=relaxed/simple;
	bh=O3HmKxv21leycROBYMk++KHQnKb1Ww0IpE2YVWVvizo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b0Pn1OMUORv2vRxS7kvjHQAouxnf48Qx/x8C3oQsbgBjFbHuJyE6gJZrHfojSGGH5C4XLoUml+2/LpA7L7vbW8lrBDszcLBY5qZFsr4jb1kipV5LiKeLcnQwtRR5SWhUofNiD9KVIS9o11iRdymz6eAkA2qKnRCJ6XsuRIqeyas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RKLWC578; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RKLWC578"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11AD4C4CED1;
	Wed, 19 Feb 2025 09:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957192;
	bh=O3HmKxv21leycROBYMk++KHQnKb1Ww0IpE2YVWVvizo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RKLWC578Q2IezJU9XUlCD9iUgP4oGkWc/ki64CAf95PK94TZoofL+fAU3EhYEzglu
	 ksnzvHSIRYI0VfTzN/LCK5B8xO7owGXyQiDAbAPl5ftfxy+Rr0wxnoOrasL62kH7Y2
	 DaM+4+hL1I1MeqhBVqAnuUaTthKcfTKWj+0W3848=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Kacur <jkacur@redhat.com>,
	Luis Goncalves <lgoncalv@redhat.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Tomas Glozar <tglozar@redhat.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.1 440/578] rtla: Add trace_instance_stop
Date: Wed, 19 Feb 2025 09:27:24 +0100
Message-ID: <20250219082710.314606724@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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


