Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED529375AC8;
	Sat, 28 Feb 2026 18:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301673; cv=none; b=tAC2HtRO3E79mD7w6/vcanYgc6S7tBa+qQGh9nxjqmOw7gNqpT8cpGhpltKEhvNFBnxfY/KTeXpVagYQULWE1THiy4i0lz1Zf8KGgh01skhZnfez4tts5YOcA/+hk3CC4XBv3NaJ8vpLZ+4A6JU6bF5qSQFWCFdgyIV9UcMfH+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301673; c=relaxed/simple;
	bh=0IECMDdzoQ3xxk0IOsGTJyj7NCFQKqRsnQitmx2XL5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dvKwffq0o4dvtfNpD7aYSpE6pzNmfzKdNyY6rM8iWl9IqghYTUiOlTzC9ziZjz7zKrSUi+uKsFJCanmJqYn0c2mcS5+nXy7kyUqNGkxjntH0WUq4kZu5qUBQgckzlThXiZcycydW/gLM7gUzWb5XqWx1SZal9ja/KvxsyTcAqTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wo7FyZAS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wo7FyZAS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0FAEC116D0;
	Sat, 28 Feb 2026 18:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301672;
	bh=0IECMDdzoQ3xxk0IOsGTJyj7NCFQKqRsnQitmx2XL5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wo7FyZASJgL4qznPi5GgoQyXjO74T+VMBHzLJPwhIvSWepC4j+mzEVcaNCVdySUb8
	 4SoKx/cSkCEJCJmuu8RG1PT7tcqAh2Bb2jtmgBjkpDV+ddyMnvtHhI1/fQZTMDfpF6
	 QmetrCsoy/KyeDTCKAYkt48b3BeasR95hmTeMvoMEYMQgNx17B+XjZ5f5vJ7yzms+B
	 axueUW2t919nH2K3rX1RQzSD8oVhgT3KkzX/fWhHUH8zsvAm35IsYS9OBj+/6xJ7FV
	 9m/B4uNuVM8o2+qiYqWIcwu2AZqnNbw3XX1PhQ04RDAla8Y6CJUrXVCol/OA+YT5bA
	 Q6wErjwIIdIfQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	Florent Revest <revest@chromium.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	bpf <bpf@vger.kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Alan Maguire <alan.maguire@oracle.com>,
	Mark Rutland <mark.rutland@arm.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 067/385] ftrace: Use arch_ftrace_regs() for ftrace_regs_*() macros
Date: Sat, 28 Feb 2026 12:54:49 -0500
Message-ID: <20260228180011.1568201-67-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>

[ Upstream commit 0b582611a8f4270fa357a22a546909b2dd5fc5fe ]

Since the arch_ftrace_get_regs(fregs) is only valid when the
FL_SAVE_REGS is set, we need to use `&arch_ftrace_regs()->regs` for
ftrace_regs_*() APIs because those APIs are for ftrace_regs, not
complete pt_regs.

Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Florent Revest <revest@chromium.org>
Cc: Martin KaFai Lau <martin.lau@linux.dev>
Cc: bpf <bpf@vger.kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Alan Maguire <alan.maguire@oracle.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Link: https://lore.kernel.org/172895572290.107311.16057631001860177198.stgit@devnote2
Fixes: e4cf33ca4812 ("ftrace: Consolidate ftrace_regs accessor functions for archs using pt_regs")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Stable-dep-of: aea251799998 ("x86/fgraph,bpf: Switch kprobe_multi program stack unwind to hw_regs path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ftrace_regs.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/ftrace_regs.h b/include/linux/ftrace_regs.h
index dea6a0851b749..b78a0a60515b2 100644
--- a/include/linux/ftrace_regs.h
+++ b/include/linux/ftrace_regs.h
@@ -17,17 +17,17 @@ struct __arch_ftrace_regs {
 struct ftrace_regs;
 
 #define ftrace_regs_get_instruction_pointer(fregs) \
-	instruction_pointer(arch_ftrace_get_regs(fregs))
+	instruction_pointer(&arch_ftrace_regs(fregs)->regs)
 #define ftrace_regs_get_argument(fregs, n) \
-	regs_get_kernel_argument(arch_ftrace_get_regs(fregs), n)
+	regs_get_kernel_argument(&arch_ftrace_regs(fregs)->regs, n)
 #define ftrace_regs_get_stack_pointer(fregs) \
-	kernel_stack_pointer(arch_ftrace_get_regs(fregs))
+	kernel_stack_pointer(&arch_ftrace_regs(fregs)->regs)
 #define ftrace_regs_return_value(fregs) \
-	regs_return_value(arch_ftrace_get_regs(fregs))
+	regs_return_value(&arch_ftrace_regs(fregs)->regs)
 #define ftrace_regs_set_return_value(fregs, ret) \
-	regs_set_return_value(arch_ftrace_get_regs(fregs), ret)
+	regs_set_return_value(&arch_ftrace_regs(fregs)->regs, ret)
 #define ftrace_override_function_with_return(fregs) \
-	override_function_with_return(arch_ftrace_get_regs(fregs))
+	override_function_with_return(&arch_ftrace_regs(fregs)->regs)
 #define ftrace_regs_query_register_offset(name) \
 	regs_query_register_offset(name)
 
-- 
2.51.0

