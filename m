Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B838319858;
	Tue, 26 Aug 2025 11:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208791; cv=none; b=Ba5xOfzGsJns9MaidEdba+OCKOu6zGA44EfTJ5hmqWCNcBEXFRgWU/NRxgyGeBa57tubyNd64wiJ/kbUQ6OOBXm6ua5rz3396o+QzmzieNsXMRiz7LWjBmYXBcPOPQLqOj4ZiVqj+VU7kLgvOJ46h/IbcQFom8W6s/No5W9BxgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208791; c=relaxed/simple;
	bh=EdlS1CpFaehbFnZLTMCV4zAqBXAZa8WPXE1xnsCeMZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BL9ru3aO8sjES15nMq7zB56v4ea+eFPv5Z1x65JZ31b2j2Prz2GaaV4vWkmR1GObFC3TpyCJjYQdYT6MVgnv3Ja0jfADdhs7MBrIL/XqiieZFeQGF0wwcCrVUIB0ROsTqRly6c10pKjkmDoRrwso1AqTu+nhhLbXN5+OEuhjrK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yzt64rO8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yzt64rO8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9534DC4CEF1;
	Tue, 26 Aug 2025 11:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208790;
	bh=EdlS1CpFaehbFnZLTMCV4zAqBXAZa8WPXE1xnsCeMZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yzt64rO8zDxXSW5gL0+GKneSq+3k8RabN2/LJgjvg2XufHCyyK8JP3J/XW7YBbE++
	 /ca9gDG3iO7EwhXxWtpEhQgT70Be+hfowj2KRB7S7vSSQGf6YcYxeQHdKy9MjLrcDL
	 8tdjtDu7Wjv2UrvRwcfAcCjEcjvGZZOle5Pr975o=
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
Subject: [PATCH 6.12 239/322] tracing: Remove unneeded goto out logic
Date: Tue, 26 Aug 2025 13:10:54 +0200
Message-ID: <20250826110921.810973929@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit c89504a703fb779052213add0e8ed642f4a4f1c8 ]

Several places in the trace.c file there's a goto out where the out is
simply a return. There's no reason to jump to the out label if it's not
doing any more logic but simply returning from the function.

Replace the goto outs with a return and remove the out labels.

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: https://lore.kernel.org/20250801203857.538726745@kernel.org
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Stable-dep-of: 6a909ea83f22 ("tracing: Limit access to parser->buffer when trace_get_user failed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |   38 +++++++++++++++-----------------------
 1 file changed, 15 insertions(+), 23 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1754,7 +1754,7 @@ int trace_get_user(struct trace_parser *
 
 	ret = get_user(ch, ubuf++);
 	if (ret)
-		goto out;
+		return ret;
 
 	read++;
 	cnt--;
@@ -1768,7 +1768,7 @@ int trace_get_user(struct trace_parser *
 		while (cnt && isspace(ch)) {
 			ret = get_user(ch, ubuf++);
 			if (ret)
-				goto out;
+				return ret;
 			read++;
 			cnt--;
 		}
@@ -1778,8 +1778,7 @@ int trace_get_user(struct trace_parser *
 		/* only spaces were written */
 		if (isspace(ch) || !ch) {
 			*ppos += read;
-			ret = read;
-			goto out;
+			return read;
 		}
 	}
 
@@ -1787,13 +1786,12 @@ int trace_get_user(struct trace_parser *
 	while (cnt && !isspace(ch) && ch) {
 		if (parser->idx < parser->size - 1)
 			parser->buffer[parser->idx++] = ch;
-		else {
-			ret = -EINVAL;
-			goto out;
-		}
+		else
+			return -EINVAL;
+
 		ret = get_user(ch, ubuf++);
 		if (ret)
-			goto out;
+			return ret;
 		read++;
 		cnt--;
 	}
@@ -1808,15 +1806,11 @@ int trace_get_user(struct trace_parser *
 		/* Make sure the parsed string always terminates with '\0'. */
 		parser->buffer[parser->idx] = 0;
 	} else {
-		ret = -EINVAL;
-		goto out;
+		return -EINVAL;
 	}
 
 	*ppos += read;
-	ret = read;
-
-out:
-	return ret;
+	return read;
 }
 
 /* TODO add a seq_buf_to_buffer() */
@@ -2318,10 +2312,10 @@ int __init register_tracer(struct tracer
 	mutex_unlock(&trace_types_lock);
 
 	if (ret || !default_bootup_tracer)
-		goto out_unlock;
+		return ret;
 
 	if (strncmp(default_bootup_tracer, type->name, MAX_TRACER_SIZE))
-		goto out_unlock;
+		return 0;
 
 	printk(KERN_INFO "Starting tracer '%s'\n", type->name);
 	/* Do we want this tracer to start on bootup? */
@@ -2333,8 +2327,7 @@ int __init register_tracer(struct tracer
 	/* disable other selftests, since this will break it. */
 	disable_tracing_selftest("running a tracer");
 
- out_unlock:
-	return ret;
+	return 0;
 }
 
 static void tracing_reset_cpu(struct array_buffer *buf, int cpu)
@@ -8563,12 +8556,12 @@ ftrace_trace_snapshot_callback(struct tr
  out_reg:
 	ret = tracing_arm_snapshot(tr);
 	if (ret < 0)
-		goto out;
+		return ret;
 
 	ret = register_ftrace_function_probe(glob, tr, ops, count);
 	if (ret < 0)
 		tracing_disarm_snapshot(tr);
- out:
+
 	return ret < 0 ? ret : 0;
 }
 
@@ -10469,7 +10462,7 @@ __init static int tracer_alloc_buffers(v
 	BUILD_BUG_ON(TRACE_ITER_LAST_BIT > TRACE_FLAGS_MAX_SIZE);
 
 	if (!alloc_cpumask_var(&tracing_buffer_mask, GFP_KERNEL))
-		goto out;
+		return -ENOMEM;
 
 	if (!alloc_cpumask_var(&global_trace.tracing_cpumask, GFP_KERNEL))
 		goto out_free_buffer_mask;
@@ -10582,7 +10575,6 @@ out_free_cpumask:
 	free_cpumask_var(global_trace.tracing_cpumask);
 out_free_buffer_mask:
 	free_cpumask_var(tracing_buffer_mask);
-out:
 	return ret;
 }
 


