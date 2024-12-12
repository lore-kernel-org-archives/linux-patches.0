Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E5D52153DD;
	Thu, 12 Dec 2024 16:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020465; cv=none; b=d+zcXGm3kBS1xEOPLmYw8Nh7z+yb0+xpAQ3kBLWFJSCEKxTRo1PqRSmf/lgoU2HF6QZsASgShSx1kY36EEY7Un7lhwW3oUQN0DDind6BN4dQmK4NDdFYbBxFrfvpZSV/McOua3ccV1fUNrTSNArhCgeZfPMV5HO11EOJObQxO/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020465; c=relaxed/simple;
	bh=0rm0N9ywkcWyTNEDhf+1oALhQep5dvhN1Pc7BdBFLG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IUcfmFqdema86yYHQ/wfJb5p2GARWaKxfUZiSWfT0UUMNVqNvtmDzjGLhWRku8rGk+Tpe8AdzI1vRoQPjmYs6Oveh/a89sVIdcJ/LVUH5kaSybmI5ZDaz93UvH+dXovkw9Cdr0aJXfdXPxztcoVqCs6G1gCCChIM67O0HnhA3lI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rA7OTewX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rA7OTewX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A257FC4CED0;
	Thu, 12 Dec 2024 16:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020465;
	bh=0rm0N9ywkcWyTNEDhf+1oALhQep5dvhN1Pc7BdBFLG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rA7OTewXN35b70uehwN/XAaDDPiK+rmfOg5oSPO5r8bwz+iocCZKgxD43lo688+0/
	 nEPj3ruJvqB5W8YN+LPSeSYdYvyEHekile/LzEe18n9N1Pi2JgVpkfdLs4Ehn5O3qb
	 t1HNKKgk9khrb94qsS+/qCLslbhFrcRyUVZo4UOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	guoweikang <guoweikang.kernel@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.1 473/772] ftrace: Fix regression with module command in stack_trace_filter
Date: Thu, 12 Dec 2024 15:56:58 +0100
Message-ID: <20241212144409.477614647@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4437,6 +4437,9 @@ ftrace_mod_callback(struct trace_array *
 	char *func;
 	int ret;
 
+	if (!tr)
+		return -ENODEV;
+
 	/* match_records() modifies func, and we need the original */
 	func = kstrdup(func_orig, GFP_KERNEL);
 	if (!func)


