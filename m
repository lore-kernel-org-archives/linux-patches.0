Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F68E2676E1;
	Tue,  8 Apr 2025 12:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114671; cv=none; b=HweZgizDJ64sgGzTyONKouh4ZUPFT3QEXqRdIpqAl8FZdlLH6Q9Ro7ah/cdhdvtF+lc1QXx9NGFZH5nCUiNiMskszxh7ipRSjh81kg8ykTv/Gi2l8ToQDj4hL3RNv1ZN77cpwLwkAGQqSvyUss+gVCca/74L/EtwHYd7ITJe660=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114671; c=relaxed/simple;
	bh=cycGZaeSJXHGuAxx7fV0iWBBGQTpPio9p3ZoWmIj+ps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aQxVWqep0cJzYsJxBjMLakrGmqM3+EchZj3ISXpQQVXlFctWWbsOsaviv6LkEioWItGZYd1Wr7jYUToW6RwP8/RUIVvbshPse70JaLMqkKp8km3nvWHpelGhsXntjap4Se49e0Ced7cYOFsINFqcvSrjKolTw7z6+Uk5waGhZFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JD0904X3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JD0904X3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE0C9C4CEE7;
	Tue,  8 Apr 2025 12:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114671;
	bh=cycGZaeSJXHGuAxx7fV0iWBBGQTpPio9p3ZoWmIj+ps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JD0904X3h33LOGnt2EEwnpdFgAwbz0lIthUEJ76FgwJ1KYRJ4h7FppIB+PrwVetJS
	 9v1dunv+rC7YAQdTRoeE5cCngFkzy/oWMvDCcQHZAaITKjk/6GYCHG4i6vsGyCCZbl
	 kTI2ET/h9QMkJZdDxsS5KM22VvGPfykqge97wesI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 192/499] x86/dumpstack: Fix inaccurate unwinding from exception stacks due to misplaced assignment
Date: Tue,  8 Apr 2025 12:46:44 +0200
Message-ID: <20250408104855.972760549@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

[ Upstream commit 2c118f50d7fd4d9aefc4533a26f83338b2906b7a ]

Commit:

  2e4be0d011f2 ("x86/show_trace_log_lvl: Ensure stack pointer is aligned, again")

was intended to ensure alignment of the stack pointer; but it also moved
the initialization of the "stack" variable down into the loop header.

This was likely intended as a no-op cleanup, since the commit
message does not mention it; however, this caused a behavioral change
because the value of "regs" is different between the two places.

Originally, get_stack_pointer() used the regs provided by the caller; after
that commit, get_stack_pointer() instead uses the regs at the top of the
stack frame the unwinder is looking at. Often, there are no such regs at
all, and "regs" is NULL, causing get_stack_pointer() to fall back to the
task's current stack pointer, which is not what we want here, but probably
happens to mostly work. Other times, the original regs will point to
another regs frame - in that case, the linear guess unwind logic in
show_trace_log_lvl() will start unwinding too far up the stack, causing the
first frame found by the proper unwinder to never be visited, resulting in
a stack trace consisting purely of guess lines.

Fix it by moving the "stack = " assignment back where it belongs.

Fixes: 2e4be0d011f2 ("x86/show_trace_log_lvl: Ensure stack pointer is aligned, again")
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20250325-2025-03-unwind-fixes-v1-2-acd774364768@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/dumpstack.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index a7d562697e50e..b2b118a8c09be 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -195,6 +195,7 @@ static void show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
 	printk("%sCall Trace:\n", log_lvl);
 
 	unwind_start(&state, task, regs, stack);
+	stack = stack ?: get_stack_pointer(task, regs);
 	regs = unwind_get_entry_regs(&state, &partial);
 
 	/*
@@ -213,9 +214,7 @@ static void show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
 	 * - hardirq stack
 	 * - entry stack
 	 */
-	for (stack = stack ?: get_stack_pointer(task, regs);
-	     stack;
-	     stack = stack_info.next_sp) {
+	for (; stack; stack = stack_info.next_sp) {
 		const char *stack_name;
 
 		stack = PTR_ALIGN(stack, sizeof(long));
-- 
2.39.5



