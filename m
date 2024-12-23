Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7148F186E58;
	Mon, 23 Dec 2024 16:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970022; cv=none; b=aypo7mNKZJoFwfDvasJAFAHIGwlm8vSNCnW/niA16eVhoKb5dGlWPFdAVFUqlrLXHtXqIrCtF4FMAFE4curCHg1cUHbRRCg8hIt1aud+zzPLkdznQb+OpcnkNi79pZb+LDsFy28/pM5rk4FnTjz9RwGBhG9OJH00gq5Vf+PjcEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970022; c=relaxed/simple;
	bh=jqQjrR8W4zFLrLTytzvFhv7DWm1jnFDKYXsZpVym5JI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eRwKPFiTXQA7+WYczJ/RhfVfW8irSYqvdafQ9uS5lSO5uxjFV6BllfwucrDTEcNxxdlpW2HJ33VNGfuXn3GUqghzKjl29Y4DH6rR8DQBOHmMGxtkjzkk1P3DE3Lqqe8z3UpXZaKfs2z+wpe/Q0wVmm4mRwpBl++yX4BRmnXuGoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I2Xylgni; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I2Xylgni"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B6FC4CED4;
	Mon, 23 Dec 2024 16:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970022;
	bh=jqQjrR8W4zFLrLTytzvFhv7DWm1jnFDKYXsZpVym5JI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I2Xylgni9/T0iBmrgk5yIq940AneOjrFYzVjiBWf1bQpY1MWZjDKkEyjoh/UFu1pQ
	 Gb8Gckby4gu7ujkizkV1fYBmKsXuDixbpmuRKmf3IJH2xiRJ8CO49lIUg8VWbL5rgG
	 OYusdPqKb8jYPxyUmJ8YXHey+xsWH9dYzwKTPlds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.12 122/160] fgraph: Still initialize idle shadow stacks when starting
Date: Mon, 23 Dec 2024 16:58:53 +0100
Message-ID: <20241223155413.478957830@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

From: Steven Rostedt <rostedt@goodmis.org>

commit cc252bb592638e0f7aea40d580186c36d89526b8 upstream.

A bug was discovered where the idle shadow stacks were not initialized
for offline CPUs when starting function graph tracer, and when they came
online they were not traced due to the missing shadow stack. To fix
this, the idle task shadow stack initialization was moved to using the
CPU hotplug callbacks. But it removed the initialization when the
function graph was enabled. The problem here is that the hotplug
callbacks are called when the CPUs come online, but the idle shadow
stack initialization only happens if function graph is currently
active. This caused the online CPUs to not get their shadow stack
initialized.

The idle shadow stack initialization still needs to be done when the
function graph is registered, as they will not be allocated if function
graph is not registered.

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Link: https://lore.kernel.org/20241211135335.094ba282@batman.local.home
Fixes: 2c02f7375e65 ("fgraph: Use CPU hotplug mechanism to initialize idle shadow stacks")
Reported-by: Linus Walleij <linus.walleij@linaro.org>
Tested-by: Linus Walleij <linus.walleij@linaro.org>
Closes: https://lore.kernel.org/all/CACRpkdaTBrHwRbbrphVy-=SeDz6MSsXhTKypOtLrTQ+DgGAOcQ@mail.gmail.com/
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/fgraph.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/kernel/trace/fgraph.c
+++ b/kernel/trace/fgraph.c
@@ -1160,7 +1160,7 @@ void fgraph_update_pid_func(void)
 static int start_graph_tracing(void)
 {
 	unsigned long **ret_stack_list;
-	int ret;
+	int ret, cpu;
 
 	ret_stack_list = kcalloc(FTRACE_RETSTACK_ALLOC_SIZE,
 				 sizeof(*ret_stack_list), GFP_KERNEL);
@@ -1168,6 +1168,12 @@ static int start_graph_tracing(void)
 	if (!ret_stack_list)
 		return -ENOMEM;
 
+	/* The cpu_boot init_task->ret_stack will never be freed */
+	for_each_online_cpu(cpu) {
+		if (!idle_task(cpu)->ret_stack)
+			ftrace_graph_init_idle_task(idle_task(cpu), cpu);
+	}
+
 	do {
 		ret = alloc_retstack_tasklist(ret_stack_list);
 	} while (ret == -EAGAIN);


