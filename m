Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 064BE18C034;
	Thu, 17 Apr 2025 18:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912968; cv=none; b=LaqiS64i3Vsu6blyrAbLeMY4sy691ofVI6toRBTvFGqNDRw4qYpnBPuvSKiXh+nr2uRP6A9P51g9h0doTfkuce+ib1OLBpReERvkpWrcN0SQZuUuB41BUWFWFejnrQXCgI7RiqpR7gQl8s7HZl3bQw6fyYewwX9M8z7OVqakeDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912968; c=relaxed/simple;
	bh=P9W7aem89bSQg5zgo/+Nfaa+dzQZCvTi+ONypoSdMZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=si3PL6UskwgL3UAPbkrCo9g0u7lVQ3TYlsMdG7qZTXkqCo61Hbta8ceNtIi0rEhkcOJzMMPyXzw+KYLgHOBLGLkoQjutoCP9pmetY1zJ1yRSLDxVNBbTTWoYxlrsr72le72FlvVf0btpz9d2mHgXTAkuyDSHas6BqC7DyXZ8IRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xocjLCpt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xocjLCpt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32C59C4CEE4;
	Thu, 17 Apr 2025 18:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912967;
	bh=P9W7aem89bSQg5zgo/+Nfaa+dzQZCvTi+ONypoSdMZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xocjLCptAG8G1HKD46nvprWBQmRphvxSKVS+q+0Kt0Jq+CfHy0b/uTdTKTkMoJa1X
	 Xv/Kve+pw5P2xsIXauIeaXTZQCbzvuwJFqcVhTaTzhWFIVAXA2+rvgj0u3pvLx8cRi
	 VwOCf70MH3N9m2DULXXDOhXdFem6PFTVeLinMeSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 183/449] tracing: probe-events: Log error for exceeding the number of arguments
Date: Thu, 17 Apr 2025 19:47:51 +0200
Message-ID: <20250417175125.341526856@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit 57faaa04804ccbf16582f7fc7a6b986fd0c0e78c ]

Add error message when the number of arguments exceeds the limitation.

Link: https://lore.kernel.org/all/174055075075.4079315.10916648136898316476.stgit@mhiramat.tok.corp.google.com/

Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_eprobe.c | 2 ++
 kernel/trace/trace_fprobe.c | 5 ++++-
 kernel/trace/trace_kprobe.c | 5 ++++-
 kernel/trace/trace_probe.h  | 1 +
 kernel/trace/trace_uprobe.c | 9 +++++++--
 5 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_eprobe.c b/kernel/trace/trace_eprobe.c
index 82fd637cfc19e..af9fa0632b574 100644
--- a/kernel/trace/trace_eprobe.c
+++ b/kernel/trace/trace_eprobe.c
@@ -913,6 +913,8 @@ static int __trace_eprobe_create(int argc, const char *argv[])
 	}
 
 	if (argc - 2 > MAX_TRACE_ARGS) {
+		trace_probe_log_set_index(2);
+		trace_probe_log_err(0, TOO_MANY_ARGS);
 		ret = -E2BIG;
 		goto error;
 	}
diff --git a/kernel/trace/trace_fprobe.c b/kernel/trace/trace_fprobe.c
index 985ff98272da8..5d7ca80173ea2 100644
--- a/kernel/trace/trace_fprobe.c
+++ b/kernel/trace/trace_fprobe.c
@@ -1199,8 +1199,11 @@ static int trace_fprobe_create_internal(int argc, const char *argv[],
 		argc = new_argc;
 		argv = new_argv;
 	}
-	if (argc > MAX_TRACE_ARGS)
+	if (argc > MAX_TRACE_ARGS) {
+		trace_probe_log_set_index(2);
+		trace_probe_log_err(0, TOO_MANY_ARGS);
 		return -E2BIG;
+	}
 
 	ret = traceprobe_expand_dentry_args(argc, argv, &dbuf);
 	if (ret)
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index d8d5f18a141ad..8287b175667f3 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1007,8 +1007,11 @@ static int trace_kprobe_create_internal(int argc, const char *argv[],
 		argc = new_argc;
 		argv = new_argv;
 	}
-	if (argc > MAX_TRACE_ARGS)
+	if (argc > MAX_TRACE_ARGS) {
+		trace_probe_log_set_index(2);
+		trace_probe_log_err(0, TOO_MANY_ARGS);
 		return -E2BIG;
+	}
 
 	ret = traceprobe_expand_dentry_args(argc, argv, &dbuf);
 	if (ret)
diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
index 96792bc4b0924..854e5668f5ee5 100644
--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -545,6 +545,7 @@ extern int traceprobe_define_arg_fields(struct trace_event_call *event_call,
 	C(BAD_BTF_TID,		"Failed to get BTF type info."),\
 	C(BAD_TYPE4STR,		"This type does not fit for string."),\
 	C(NEED_STRING_TYPE,	"$comm and immediate-string only accepts string type"),\
+	C(TOO_MANY_ARGS,	"Too many arguments are specified"),	\
 	C(TOO_MANY_EARGS,	"Too many entry arguments specified"),
 
 #undef C
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index ccc762fbb69cd..3386439ec9f67 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -562,8 +562,14 @@ static int __trace_uprobe_create(int argc, const char **argv)
 
 	if (argc < 2)
 		return -ECANCELED;
-	if (argc - 2 > MAX_TRACE_ARGS)
+
+	trace_probe_log_init("trace_uprobe", argc, argv);
+
+	if (argc - 2 > MAX_TRACE_ARGS) {
+		trace_probe_log_set_index(2);
+		trace_probe_log_err(0, TOO_MANY_ARGS);
 		return -E2BIG;
+	}
 
 	if (argv[0][1] == ':')
 		event = &argv[0][2];
@@ -582,7 +588,6 @@ static int __trace_uprobe_create(int argc, const char **argv)
 		return -ECANCELED;
 	}
 
-	trace_probe_log_init("trace_uprobe", argc, argv);
 	trace_probe_log_set_index(1);	/* filename is the 2nd argument */
 
 	*arg++ = '\0';
-- 
2.39.5



