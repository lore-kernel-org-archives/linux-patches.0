Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9FA222837C;
	Thu, 12 Dec 2024 16:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021606; cv=none; b=K5pmPihzY9ag7LPy1Hrd8jWKrA71D8hDh1vC4S9yeX6hko/PoyfO0m2u9KU+GCQKKLGfPBP9CD/Ap2tV/NoKfUu5e3Rr2W/VKwssJjxHoUVBGGWyWrZPhBHsVMeQ0JDzO/uwPli136/lk3lE3xWhs5Tw6lkpOMXSrW8+MWuG31I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021606; c=relaxed/simple;
	bh=Y/KPRL5Osx0n1geYMXZG1VSX0fBLt0wXgQ2/lJoDqqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tCuw0acK00qRp9OES9muPpnOsPn8O6RTbvhcUo7yCK6XVfdSPQQvTRA5wpeuL3ZK9qUlDZXouWV2dJezRSpQntnyZXA5yVeMaqO67N9zgppfVmyzSoZ9jIlQwbiRQb/zV0uFFdYXj3gy2m4hRbmhSwI2geLMV/lU/PwUlr+Tacw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lXzFgras; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lXzFgras"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0352BC4CECE;
	Thu, 12 Dec 2024 16:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021605;
	bh=Y/KPRL5Osx0n1geYMXZG1VSX0fBLt0wXgQ2/lJoDqqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lXzFgrasofGf4OIH1bZlx4W3ertYt2/VhNsAqPPaBeJd//2TputSiAqDiYVnfP/h8
	 wkeH7p92ZuNq8FXMTiKmxTxoLx2YmdyaHN989kcbRbcHmsrLPgGFak5m5R0M9mfk9k
	 KPi5Rm3HkIAr+WvyCuiSKXzIswFKEk3dm3IqAxZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	guoweikang <guoweikang.kernel@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.15 012/565] ftrace: Fix regression with module command in stack_trace_filter
Date: Thu, 12 Dec 2024 15:53:27 +0100
Message-ID: <20241212144311.938599675@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4305,6 +4305,9 @@ ftrace_mod_callback(struct trace_array *
 	char *func;
 	int ret;
 
+	if (!tr)
+		return -ENODEV;
+
 	/* match_records() modifies func, and we need the original */
 	func = kstrdup(func_orig, GFP_KERNEL);
 	if (!func)


