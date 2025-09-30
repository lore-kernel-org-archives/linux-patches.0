Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEA792236EB;
	Tue, 30 Sep 2025 15:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244783; cv=none; b=FinELvBUnvF3Xm1GoxeZHiye6t8oA7BkB0HV3sU5yHwGakO4BZT+/iKPMCxrFe9osnIhHSAHLw+PdFU6QcEpV6/BABJZyOwzJ06SaLdPBub9DsJoy1qDjPve/8bxyHfN2aCLgvvquACC/yG4lw+0qq7FO6UaJ6BUjg02PpY2zJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244783; c=relaxed/simple;
	bh=ADhR/vhgyLzbBLUNCbUCZ6+FpVc9C4Gt0slLtsZMuR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LhSq7U6fFoxeNqfH8MKFDlxw6WwpZPqncsYM/+ncIL4QSEs9hFtDXL9AuBCXNeQ6QuXSVahxKxOkcbf41iYGLHyb5uhkOiQWL8Gth4cNeqDBccQhiHfZfWZxk4rW+yy9uyneTSTlW81yw2AULjWRKWu8dQNQa8gl4sjs1DJxgUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sYxLYEy3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sYxLYEy3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43506C4CEF0;
	Tue, 30 Sep 2025 15:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244783;
	bh=ADhR/vhgyLzbBLUNCbUCZ6+FpVc9C4Gt0slLtsZMuR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sYxLYEy3DvezKPCSkOS8tzCgOJoqD6UBShTcX4l/QIsVHVDbRcHMp75/eU7eWL2bB
	 qTKonYsAJ5KT1He19iAohXC+Hk96HcnoAizUuEL37Lydjh5Cjy3NLKG0TYLNLvpam0
	 MotBtt3WGw8Wmoi4a94dMHF7Xa0KAPVp/z6dwUKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Menglong Dong <menglong8.dong@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.16 112/143] tracing: fgraph: Protect return handler from recursion loop
Date: Tue, 30 Sep 2025 16:47:16 +0200
Message-ID: <20250930143835.696918822@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit 0db0934e7f9bb624ed98a665890dbe249f65b8fd upstream.

function_graph_enter_regs() prevents itself from recursion by
ftrace_test_recursion_trylock(), but __ftrace_return_to_handler(),
which is called at the exit, does not prevent such recursion.
Therefore, while it can prevent recursive calls from
fgraph_ops::entryfunc(), it is not able to prevent recursive calls
to fgraph from fgraph_ops::retfunc(), resulting in a recursive loop.
This can lead an unexpected recursion bug reported by Menglong.

 is_endbr() is called in __ftrace_return_to_handler -> fprobe_return
  -> kprobe_multi_link_exit_handler -> is_endbr.

To fix this issue, acquire ftrace_test_recursion_trylock() in the
__ftrace_return_to_handler() after unwind the shadow stack to mark
this section must prevent recursive call of fgraph inside user-defined
fgraph_ops::retfunc().

This is essentially a fix to commit 4346ba160409 ("fprobe: Rewrite
fprobe on function-graph tracer"), because before that fgraph was
only used from the function graph tracer. Fprobe allowed user to run
any callbacks from fgraph after that commit.

Reported-by: Menglong Dong <menglong8.dong@gmail.com>
Closes: https://lore.kernel.org/all/20250918120939.1706585-1-dongml2@chinatelecom.cn/
Fixes: 4346ba160409 ("fprobe: Rewrite fprobe on function-graph tracer")
Cc: stable@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/175852292275.307379.9040117316112640553.stgit@devnote2
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Tested-by: Menglong Dong <menglong8.dong@gmail.com>
Acked-by: Menglong Dong <menglong8.dong@gmail.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/fgraph.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/kernel/trace/fgraph.c
+++ b/kernel/trace/fgraph.c
@@ -815,6 +815,7 @@ __ftrace_return_to_handler(struct ftrace
 	unsigned long bitmap;
 	unsigned long ret;
 	int offset;
+	int bit;
 	int i;
 
 	ret_stack = ftrace_pop_return_trace(&trace, &ret, frame_pointer, &offset);
@@ -829,6 +830,15 @@ __ftrace_return_to_handler(struct ftrace
 	if (fregs)
 		ftrace_regs_set_instruction_pointer(fregs, ret);
 
+	bit = ftrace_test_recursion_trylock(trace.func, ret);
+	/*
+	 * This can fail because ftrace_test_recursion_trylock() allows one nest
+	 * call. If we are already in a nested call, then we don't probe this and
+	 * just return the original return address.
+	 */
+	if (unlikely(bit < 0))
+		goto out;
+
 #ifdef CONFIG_FUNCTION_GRAPH_RETVAL
 	trace.retval = ftrace_regs_get_return_value(fregs);
 #endif
@@ -852,6 +862,8 @@ __ftrace_return_to_handler(struct ftrace
 		}
 	}
 
+	ftrace_test_recursion_unlock(bit);
+out:
 	/*
 	 * The ftrace_graph_return() may still access the current
 	 * ret_stack structure, we need to make sure the update of


