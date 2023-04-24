Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BD777C
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:31:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94F4AC4339B;
	Mon, 24 Apr 2023 13:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682343111;
	bh=IVKEMJJd8BBDFuG8UMI5H7FrwA616yd8Zt08N5eJnRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OYp/jf+ACHfCSqpQcC4vLDnPVQxFCUFEaYYqZeblo5CViDjROYx1tEdhP8b8wVu87
	 v+LLfMcWKRP/1anFOM/XyGOaYm5u1UqScdg+gi7MNlfwXhy9h14lxXL4i5l9Asj4Ln
	 m3lCas6ocYQIqVdKTXzZ2r10O5tUNDBwCX3JrfqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.2 064/110] LoongArch: Check unwind_error() in arch_stack_walk()
Date: Mon, 24 Apr 2023 15:17:26 +0200
Message-Id: <20230424131138.737749391@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tiezhu Yang <yangtiezhu@loongson.cn>

commit 370a3b8f58743eceb97c5256538d6048c26d2d03 upstream.

We can see the following messages with CONFIG_PROVE_LOCKING=y on
LoongArch:

  BUG: MAX_STACK_TRACE_ENTRIES too low!
  turning off the locking correctness validator.

This is because stack_trace_save() returns a big value after call
arch_stack_walk(), here is the call trace:

  save_trace()
    stack_trace_save()
      arch_stack_walk()
        stack_trace_consume_entry()

arch_stack_walk() should return immediately if unwind_next_frame()
failed, no need to do the useless loops to increase the value of c->len
in stack_trace_consume_entry(), then we can fix the above problem.

Cc: stable@vger.kernel.org
Reported-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/all/8a44ad71-68d2-4926-892f-72bfc7a67e2a@roeck-us.net/
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/stacktrace.c      |    2 +-
 arch/loongarch/kernel/unwind.c          |    1 +
 arch/loongarch/kernel/unwind_prologue.c |    4 +++-
 3 files changed, 5 insertions(+), 2 deletions(-)

--- a/arch/loongarch/kernel/stacktrace.c
+++ b/arch/loongarch/kernel/stacktrace.c
@@ -30,7 +30,7 @@ void arch_stack_walk(stack_trace_consume
 
 	regs->regs[1] = 0;
 	for (unwind_start(&state, task, regs);
-	      !unwind_done(&state); unwind_next_frame(&state)) {
+	     !unwind_done(&state) && !unwind_error(&state); unwind_next_frame(&state)) {
 		addr = unwind_get_return_address(&state);
 		if (!addr || !consume_entry(cookie, addr))
 			break;
--- a/arch/loongarch/kernel/unwind.c
+++ b/arch/loongarch/kernel/unwind.c
@@ -28,5 +28,6 @@ bool default_next_frame(struct unwind_st
 
 	} while (!get_stack_info(state->sp, state->task, info));
 
+	state->error = true;
 	return false;
 }
--- a/arch/loongarch/kernel/unwind_prologue.c
+++ b/arch/loongarch/kernel/unwind_prologue.c
@@ -211,7 +211,7 @@ static bool next_frame(struct unwind_sta
 			pc = regs->csr_era;
 
 			if (user_mode(regs) || !__kernel_text_address(pc))
-				return false;
+				goto out;
 
 			state->first = true;
 			state->pc = pc;
@@ -226,6 +226,8 @@ static bool next_frame(struct unwind_sta
 
 	} while (!get_stack_info(state->sp, state->task, info));
 
+out:
+	state->error = true;
 	return false;
 }
 


