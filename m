Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7539E18A924;
	Mon, 28 Oct 2024 06:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098178; cv=none; b=mqmOSqgvkM+yrflPFabQLLjZnVmxakwFBB2GDUqoOAl0/wQhZgu7phNwETy6fz+Gz7vw8tV4y3QotnlCSwPegOZ/TSzw3GiCpsyleEhPvUYfD/4g46yZtZEkdsf6UQdOoKWG+7MJBlmD48DpYzMMaC95I/vUczHqj5wCtM5HHQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098178; c=relaxed/simple;
	bh=CIQFlOh5VqV2moGCnCPiwlhAOsqNp1d4GJqGOnmkphQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WqZn4zl50IszYGpMCUMhi+3LXmJEfeNVtIW/KGc6w3AfHwACtTDzZydAgUonxm0UP0a+7rFoTqqoR610sacButjfX9jvSUmo/rcJ2kPgdqU+LdyC9gLQGregKsdNKsW/ySX1PYuk2wXucqlfLIAlASf/e1MvEiW3QzfPeoJvcjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xlRZy3Ik; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xlRZy3Ik"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5378C4CEC3;
	Mon, 28 Oct 2024 06:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098178;
	bh=CIQFlOh5VqV2moGCnCPiwlhAOsqNp1d4GJqGOnmkphQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xlRZy3IkJJpg533PIrbCmTzMwtxLXssxnjKvLCSScjlSV31NqRROgiFIwLpQpd8pZ
	 BwcmpBULYrunP3zZV8/oZ9JpKg0cIfvqrCiYGrkaEyC9NmlXteo6pJPdI2R0/36oKL
	 rGC8gkNyhQqRdqR3XVl8KIlP0k9MNz7mw88RcW+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 112/261] fgraph: Allocate ret_stack_list with proper size
Date: Mon, 28 Oct 2024 07:24:14 +0100
Message-ID: <20241028062314.838100910@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit fae4078c289a2f24229c0de652249948b1cd6bdb ]

The ret_stack_list is an array of ret_stack shadow stacks for the function
graph usage. When the first function graph is enabled, all tasks in the
system get a shadow stack. The ret_stack_list is a 32 element array of
pointers to these shadow stacks. It allocates the shadow stack in batches
(32 stacks at a time), assigns them to running tasks, and continues until
all tasks are covered.

When the function graph shadow stack changed from an array of
ftrace_ret_stack structures to an array of longs, the allocation of
ret_stack_list went from allocating an array of 32 elements to just a
block defined by SHADOW_STACK_SIZE. Luckily, that's defined as PAGE_SIZE
and is much more than enough to hold 32 pointers. But it is way overkill
for the amount needed to allocate.

Change the allocation of ret_stack_list back to a kcalloc() of
FTRACE_RETSTACK_ALLOC_SIZE pointers.

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Link: https://lore.kernel.org/20241018215212.23f13f40@rorschach
Fixes: 42675b723b484 ("function_graph: Convert ret_stack to a series of longs")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/fgraph.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/fgraph.c b/kernel/trace/fgraph.c
index 43f4e3f57438b..41e7a15dcb50c 100644
--- a/kernel/trace/fgraph.c
+++ b/kernel/trace/fgraph.c
@@ -1162,7 +1162,8 @@ static int start_graph_tracing(void)
 	unsigned long **ret_stack_list;
 	int ret;
 
-	ret_stack_list = kmalloc(SHADOW_STACK_SIZE, GFP_KERNEL);
+	ret_stack_list = kcalloc(FTRACE_RETSTACK_ALLOC_SIZE,
+				 sizeof(*ret_stack_list), GFP_KERNEL);
 
 	if (!ret_stack_list)
 		return -ENOMEM;
-- 
2.43.0



