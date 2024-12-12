Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE7021766D;
	Thu, 12 Dec 2024 17:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023616; cv=none; b=mjznVK6bgPrH+Q9SY6mlwl1V3k36OMcDnQ3vR5nqEULGc+gQqOa3v5PUQ/JKKXY0ctaOYp89lptRQs6V239KJjTDsb+SY1Lcw2v+OE6lvKB2HBAtKgpvd6fqdoR1NA/XgVZPPDmD07mX+LYHNBOs+g/w0C3ewqfQ/egps88ZV74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023616; c=relaxed/simple;
	bh=vsSh4lF4dQS0I6+i62LIxC9qaq2yK6GONrrO0OlgXlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jU+PHyKg9wDH+Wt0sk0hJdZ0aZVEu/f1t/gWN/8hN3LSJQimGpbvJu3cdg44oqfyLJlXv9LYYKWNxtnVx3r+0wSghDC8ODFNeBQ8KS5GxzVo8c1vt+c6/8Pz0oLVmpMzomCKti9/x8NqbbOFSFYqKIzbFO9wkSgH9Ks/mKpL0Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k+wh4c3t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k+wh4c3t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CCC1C4CECE;
	Thu, 12 Dec 2024 17:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023615;
	bh=vsSh4lF4dQS0I6+i62LIxC9qaq2yK6GONrrO0OlgXlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k+wh4c3t72uS4cfIs4Gb/d4pEoHJ2ahmjhnzuVwEQV2kb39YASAao6YGbJW3xD0Dt
	 oREJjwA1FzKVEToMVGr4f6rE1LtNGz/khidhyZk5v5fzKKOxez+upx5hcN6dtr8xUM
	 g9U5bsZMyxp7t+G9azSQzrWNj0v15VO1YjkQS69U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	guoweikang <guoweikang.kernel@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.10 009/459] ftrace: Fix regression with module command in stack_trace_filter
Date: Thu, 12 Dec 2024 15:55:47 +0100
Message-ID: <20241212144253.895789317@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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
@@ -4311,6 +4311,9 @@ ftrace_mod_callback(struct trace_array *
 	char *func;
 	int ret;
 
+	if (!tr)
+		return -ENODEV;
+
 	/* match_records() modifies func, and we need the original */
 	func = kstrdup(func_orig, GFP_KERNEL);
 	if (!func)


