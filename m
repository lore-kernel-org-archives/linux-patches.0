Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FD441474A9;
	Fri,  6 Dec 2024 14:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496222; cv=none; b=o1ztHfbDeQi4qOBsHJKRjFyGYPc53+wAz0azIBrvTqgKV0HFci/u2TwGHkiLT0gRVFdORUlJWYo9aC+rLeNM/WDmUhoh26DzmSmIJU3iDFwrCiJLR3dwNfI5hs/BmHUvl2B8P/jhpcOx8FnU0RW+5BfWUhMaNpWOQdizhqB3I8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496222; c=relaxed/simple;
	bh=G1xcFN6aO07EPwGhHwiHrsed6bE205Y4pV+rJzFEpvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LoCSrq26odBBoj4c7U+eXgYhc/+9k98k8QneVUTYryHCDx1wBKEGWscxTvVhQqYb0+GbOnqhuddBo13sOLaP4HIgnMRfy/rY2JGC+UOPmjSYnskE3Gf2agUm7ByEpzLxFEaqSAveBMSydHWxHkqIgtjVSD4cyE2kOUpr/162yQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QpJWB6AX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QpJWB6AX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7552BC4CED1;
	Fri,  6 Dec 2024 14:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496221;
	bh=G1xcFN6aO07EPwGhHwiHrsed6bE205Y4pV+rJzFEpvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QpJWB6AXjS1xVRWvsqavY4rEg20rtK69YLPPhyJhnJJipwQ+Rhph34JYCQZJ/BZVc
	 4LliSlp4OJwYXQylF3FVle5+N8sYMG6bujmUXrCE3yk/fHrzoh8GSf+EfR/GYqzxvU
	 7wnnLW4pOepJxWofLpI2GzLVFD07/TwViD5Rsnn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	guoweikang <guoweikang.kernel@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.12 045/146] ftrace: Fix regression with module command in stack_trace_filter
Date: Fri,  6 Dec 2024 15:36:16 +0100
Message-ID: <20241206143529.399823075@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: guoweikang <guoweikang.kernel@gmail.com>

commit 45af52e7d3b8560f21d139b3759735eead8b1653 upstream.

When executing the following command:

    # echo "write*:mod:ext3" > /sys/kernel/tracing/stack_trace_filter

The current mod command causes a null pointer dereference. While commit
0f17976568b3f ("ftrace: Fix regression with module command in stack_trace_filter")
has addressed part of the issue, it left a corner case unhandled, which still
results in a kernel crash.

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Link: https://lore.kernel.org/20241120052750.275463-1-guoweikang.kernel@gmail.com
Fixes: 04ec7bb642b77 ("tracing: Have the trace_array hold the list of registered func probes");
Signed-off-by: guoweikang <guoweikang.kernel@gmail.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ftrace.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -5080,6 +5080,9 @@ ftrace_mod_callback(struct trace_array *
 	char *func;
 	int ret;
 
+	if (!tr)
+		return -ENODEV;
+
 	/* match_records() modifies func, and we need the original */
 	func = kstrdup(func_orig, GFP_KERNEL);
 	if (!func)


