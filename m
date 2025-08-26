Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED4231F4C90;
	Tue, 26 Aug 2025 14:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218437; cv=none; b=FgfkeWANS64N6Cg7qC/x98N0JWFGYvcuHRrpT3OQ7XWzmlGslrWs/f8JY6qU2fRGLW64dcrYuZixwIc3VR+oihaCq3WYXwpkMxfI7Sp8lb6Eb2+QyKAT4BK0R2g3Q1F5IUZ3ESn0qpfDnPeRasI1vNV3u76vpYYCg56pUH68O88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218437; c=relaxed/simple;
	bh=w1TuPsVismq2PfJXiGDg2UjZFD9Q7Piyb6ziBjrzvkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DwxFTpJKAfX6R3NIpfd6/VfAVg5EZJnGwBI75c/MRMmXCTQPR+IWPGVYModTRu7lze/B8A8bawaIM3vUkQR0OdPCktOxj/NQb3NQRdk+iM34KAG8ltaMIHgIyxjk/whsvx+NdUYmQApHqMqmbalJKwbRrbea01q7Eurgm9AJuZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O7kmI802; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O7kmI802"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82ED4C4CEF1;
	Tue, 26 Aug 2025 14:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218436;
	bh=w1TuPsVismq2PfJXiGDg2UjZFD9Q7Piyb6ziBjrzvkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O7kmI802RFSsILYXhtA23NJ1gJW2jvYYpHv4Bh4byPcjCGkX1xN+GABKvQPnLCrdL
	 fAJO+8tbIfAmL3gk9Vo2dM5GGR60J/V39RgfS1QBJXwmdsZ0TmvewMxfn+MYFeqKdq
	 WY3LfmhojSBuxCKd0Hju28yWAhsfkeSSzjbe3agc=
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
Subject: [PATCH 5.10 504/523] tracing: Remove unneeded goto out logic
Date: Tue, 26 Aug 2025 13:11:54 +0200
Message-ID: <20250826110936.871533700@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |   37 ++++++++++++++-----------------------
 1 file changed, 14 insertions(+), 23 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1613,7 +1613,7 @@ int trace_get_user(struct trace_parser *
 
 	ret = get_user(ch, ubuf++);
 	if (ret)
-		goto out;
+		return ret;
 
 	read++;
 	cnt--;
@@ -1627,7 +1627,7 @@ int trace_get_user(struct trace_parser *
 		while (cnt && isspace(ch)) {
 			ret = get_user(ch, ubuf++);
 			if (ret)
-				goto out;
+				return ret;
 			read++;
 			cnt--;
 		}
@@ -1637,8 +1637,7 @@ int trace_get_user(struct trace_parser *
 		/* only spaces were written */
 		if (isspace(ch) || !ch) {
 			*ppos += read;
-			ret = read;
-			goto out;
+			return read;
 		}
 	}
 
@@ -1646,13 +1645,12 @@ int trace_get_user(struct trace_parser *
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
@@ -1667,15 +1665,11 @@ int trace_get_user(struct trace_parser *
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
@@ -2139,10 +2133,10 @@ int __init register_tracer(struct tracer
 	mutex_unlock(&trace_types_lock);
 
 	if (ret || !default_bootup_tracer)
-		goto out_unlock;
+		return ret;
 
 	if (strncmp(default_bootup_tracer, type->name, MAX_TRACER_SIZE))
-		goto out_unlock;
+		return 0;
 
 	printk(KERN_INFO "Starting tracer '%s'\n", type->name);
 	/* Do we want this tracer to start on bootup? */
@@ -2154,8 +2148,7 @@ int __init register_tracer(struct tracer
 	/* disable other selftests, since this will break it. */
 	disable_tracing_selftest("running a tracer");
 
- out_unlock:
-	return ret;
+	return 0;
 }
 
 static void tracing_reset_cpu(struct array_buffer *buf, int cpu)
@@ -8240,11 +8233,10 @@ ftrace_trace_snapshot_callback(struct tr
  out_reg:
 	ret = tracing_alloc_snapshot_instance(tr);
 	if (ret < 0)
-		goto out;
+		return ret;
 
 	ret = register_ftrace_function_probe(glob, tr, ops, count);
 
- out:
 	return ret < 0 ? ret : 0;
 }
 
@@ -9746,7 +9738,7 @@ __init static int tracer_alloc_buffers(v
 	BUILD_BUG_ON(TRACE_ITER_LAST_BIT > TRACE_FLAGS_MAX_SIZE);
 
 	if (!alloc_cpumask_var(&tracing_buffer_mask, GFP_KERNEL))
-		goto out;
+		return -ENOMEM;
 
 	if (!alloc_cpumask_var(&global_trace.tracing_cpumask, GFP_KERNEL))
 		goto out_free_buffer_mask;
@@ -9857,7 +9849,6 @@ out_free_cpumask:
 	free_cpumask_var(global_trace.tracing_cpumask);
 out_free_buffer_mask:
 	free_cpumask_var(tracing_buffer_mask);
-out:
 	return ret;
 }
 


