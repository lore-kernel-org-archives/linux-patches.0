Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB5A13C816;
	Thu, 25 Jul 2024 14:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721919220; cv=none; b=Pks1ASIoYNlA29ALhEO11+spP07gYskmrNP840LK+IWqUmW07GQ3klSxUjh//BKQGklKe9nxFEOEBs8sIFngLiBFc4H1t4KMrj/tJCv09+4HgxD4DH5k9Dy6g39RXRQjDqGJ1JshTPriguEjin85Iupuu+ipOaD1HKZHkdLKL6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721919220; c=relaxed/simple;
	bh=0J3EDs+f+rPWs+fqDBe1saRCBEf44flkgP/ApMG6P+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BwLLhmtk5khMDm7/7Tz5vECQky5PyEJCKne5OLGz6HUtF1ny8qyE+s+WGaA0SNC9wtEnA0RabJ/PMzB6VsB5jX6/Vzw3wQgsP6Tm4xdZqgGAjhh5ZpUd5LJEvjACjmS0c2N1duTYll9t4DQduqcG/+xnIL2dtctRobvaQMI7nqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FA2he2yN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FA2he2yN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED43C116B1;
	Thu, 25 Jul 2024 14:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721919220;
	bh=0J3EDs+f+rPWs+fqDBe1saRCBEf44flkgP/ApMG6P+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FA2he2yN/yVl+JG7pAwz4WA1nAP7EiuPLCQZKflz9KmuMbfWjVUBnySDzQG+5xpPE
	 tQPjZ9mXlid/AECrkekEhxA2B5PYj1q3Yk4/KzLzrV/PxRkAuMI7lFcYt//VBsk0ri
	 7yO+lO/P9Hf/lxPLNMiZbsIX6r/7+zLAbj4fuAB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Puranjay Mohan <puranjay@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 59/87] riscv: stacktrace: fix usage of ftrace_graph_ret_addr()
Date: Thu, 25 Jul 2024 16:37:32 +0200
Message-ID: <20240725142740.654847188@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142738.422724252@linuxfoundation.org>
References: <20240725142738.422724252@linuxfoundation.org>
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

From: Puranjay Mohan <puranjay@kernel.org>

[ Upstream commit 393da6cbb2ff89aadc47683a85269f913aa1c139 ]

ftrace_graph_ret_addr() takes an `idx` integer pointer that is used to
optimize the stack unwinding. Pass it a valid pointer to utilize the
optimizations that might be available in the future.

The commit is making riscv's usage of ftrace_graph_ret_addr() match
x86_64.

Signed-off-by: Puranjay Mohan <puranjay@kernel.org>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Link: https://lore.kernel.org/r/20240618145820.62112-1-puranjay@kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/stacktrace.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/stacktrace.c b/arch/riscv/kernel/stacktrace.c
index 94721c484d638..95b4ad1b6708c 100644
--- a/arch/riscv/kernel/stacktrace.c
+++ b/arch/riscv/kernel/stacktrace.c
@@ -34,6 +34,7 @@ void notrace walk_stackframe(struct task_struct *task, struct pt_regs *regs,
 			     bool (*fn)(void *, unsigned long), void *arg)
 {
 	unsigned long fp, sp, pc;
+	int graph_idx = 0;
 	int level = 0;
 
 	if (regs) {
@@ -70,7 +71,7 @@ void notrace walk_stackframe(struct task_struct *task, struct pt_regs *regs,
 			pc = regs->ra;
 		} else {
 			fp = frame->fp;
-			pc = ftrace_graph_ret_addr(current, NULL, frame->ra,
+			pc = ftrace_graph_ret_addr(current, &graph_idx, frame->ra,
 						   &frame->ra);
 			if (pc == (unsigned long)ret_from_exception) {
 				if (unlikely(!__kernel_text_address(pc) || !fn(arg, pc)))
-- 
2.43.0



