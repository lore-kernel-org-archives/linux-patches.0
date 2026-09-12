Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A607D41D4FE;
	Sat, 12 Sep 2026 09:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205849; cv=none; b=CeOtzS5juerfoPimYBcZRiFxwu6t0r5FjlSrlCRhEayhtZ2ZcDh1lI4GCxhxIQIQwL4H+jMEvvTu4ZPxBhCv4+mupxHYGfmrcvVNzZ63DYV1V2nMnEnbG1MbSj0lF/4Xkwd9AyrUJ+xv0t0Y8cMjaf8p9pBdSddRE3DJhVSW1IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205849; c=relaxed/simple;
	bh=XJCPPOwuRqmmGgpHq4XDZ+HCVUlBnWe0VzQ47DZZarY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fRoOpBNWONpithQX9SkYeIg0vOnL7OOygmKmCeQ1rOzlLIYtLendKW/m5Mu93HGHyb7uht5QrWWNWLUu6R9t17dH4O7CZvEwvbMILogO45EsRyIiC0I8EwnX0iv5DXqikx0vRYKLGAmqh1+JEYqUwU1kFg3Xbc8CoszwRVnBZnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=enK3dp1g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="enK3dp1g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D1B21F00893;
	Sat, 12 Sep 2026 09:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205846;
	bh=c1jhpw+sEGN7fOvQXZKZkk/uHFu8bAATR1/5qN4RWB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=enK3dp1g9KOB4u9ZEpu3XkBYmk7AG0NTQlzDdHvIItUiEQJuPwa+HcaXa3T6QISNV
	 DsWL875/uoGk4+InCIxZTbRf95LEKfdtJSmKwqlcartrU6Bbi8UcQF6xhOMfqucbTB
	 AwqwQDMQlawTspWvcczBVon+4pAypZ1qqBmZHGns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0048/1518] tracing: Make printk_trace global for tracing system
Date: Sat, 12 Sep 2026 08:36:57 +0200
Message-ID: <20260912065624.525629748@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit 1c53d781d42541adc5ba76b4f843a3ff382e01fb ]

The printk_trace is used to determine which trace_array trace_printk()
writes to. By making it a global variable among the tracing subsystem it
will allow the trace_printk functions to be moved out of trace.c and still
have direct access to that variable.

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: https://patch.msgid.link/20260208032450.144525891@kernel.org
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Stable-dep-of: f2951ebd15c3 ("tracing: Take trace_array reference when opening options file")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |    2 +-
 kernel/trace/trace.h |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -537,7 +537,7 @@ static struct trace_array global_trace =
 	.trace_flags = TRACE_DEFAULT_FLAGS,
 };
 
-static struct trace_array *printk_trace = &global_trace;
+struct trace_array *printk_trace = &global_trace;
 
 /* List of trace_arrays interested in the top level trace_marker */
 static LIST_HEAD(marker_copies);
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -479,6 +479,8 @@ extern bool trace_clock_in_ns(struct tra
 
 extern unsigned long trace_adjust_address(struct trace_array *tr, unsigned long addr);
 
+extern struct trace_array *printk_trace;
+
 /*
  * The global tracer (top) should be the first trace array added,
  * but we check the flag anyway.


