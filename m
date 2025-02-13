Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A8F26B0BD;
	Thu, 13 Feb 2025 15:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460562; cv=none; b=rLT1h+MpoTjxua8EqcVo5T5TwM91wJySXMgXEE+voh+xyzpxCofnH0cAnU6jmPKQJ1ozbxko03LH0id/EEVFKJzWYZM9gT/y5znbJkhLpOJeI0J7ClOLd47FZGLbbrbsb6eXUWbhPE89Pd1wQSD0L/wRSpKIuS6LJ7OgoDOlkQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460562; c=relaxed/simple;
	bh=TIfIZ104s7aNs3MVRdxz6iesee+wUrURjTf6j2IV9zE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=irhstxPeZOywuuNSFJJuaOewxvrinQBQdyjBGCoXPwWTgoRirscMnwMYLhq2okaKQcown/etQeFKpr+9wLq6u3vfHnERaXNmpsu6+Z46S0O0388vSFfSx7Y2EBkto/s3elXXfYCGvsNxJrRGclfbmH83dk8V6wp7iw4B6Dqv/dE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jrKo5dbm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jrKo5dbm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D725BC4CED1;
	Thu, 13 Feb 2025 15:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460562;
	bh=TIfIZ104s7aNs3MVRdxz6iesee+wUrURjTf6j2IV9zE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jrKo5dbmqV+xmpzC19wYWbtE2gO+ydnNaYSwcccQEoDjOUq66EX+hYR/iZH3pYYWO
	 UxtH3akj85CP4vWR7RibUaimbT4Pj13UZnqxbDStDksFVXFNsqZKwb62R2ehWWE624
	 qH2m0CTj+gzjaQHZ8X/ajRXsILRrc68HPkt3q/Sw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WANG Xuerui <git@xen0n.name>,
	Xi Ruoyao <xry111@xry111.site>,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 148/273] LoongArch: Extend the maximum number of watchpoints
Date: Thu, 13 Feb 2025 15:28:40 +0100
Message-ID: <20250213142413.186346779@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiezhu Yang <yangtiezhu@loongson.cn>

commit 531936dee53e471a3ec668de3c94ca357f54b7e8 upstream.

The maximum number of load/store watchpoints and fetch instruction
watchpoints is 14 each according to LoongArch Reference Manual, so
extend the maximum number of watchpoints from 8 to 14 for ptrace.

By the way, just simply change 8 to 14 for the definition in struct
user_watch_state at the beginning, but it may corrupt uapi, then add
a new struct user_watch_state_v2 directly.

As far as I can tell, the only users for this struct in the userspace
are GDB and LLDB, there are no any problems of software compatibility
between the application and kernel according to the analysis.

The compatibility problem has been considered while developing and
testing. When the applications in the userspace get watchpoint state,
the length will be specified which is no bigger than the sizeof struct
user_watch_state or user_watch_state_v2, the actual length is assigned
as the minimal value of the application and kernel in the generic code
of ptrace:

kernel/ptrace.c: ptrace_regset():

	kiov->iov_len = min(kiov->iov_len,
			   (__kernel_size_t) (regset->n * regset->size));

	if (req == PTRACE_GETREGSET)
		return copy_regset_to_user(task, view, regset_no, 0,
					  kiov->iov_len, kiov->iov_base);
	else
		return copy_regset_from_user(task, view, regset_no, 0,
					  kiov->iov_len, kiov->iov_base);

For example, there are four kind of combinations, all of them work well.

(1) "older kernel + older gdb", the actual length is 8+(8+8+4+4)*8=200;
(2) "newer kernel + newer gdb", the actual length is 8+(8+8+4+4)*14=344;
(3) "older kernel + newer gdb", the actual length is 8+(8+8+4+4)*8=200;
(4) "newer kernel + older gdb", the actual length is 8+(8+8+4+4)*8=200.

Link: https://loongson.github.io/LoongArch-Documentation/LoongArch-Vol1-EN.html#control-and-status-registers-related-to-watchpoints
Cc: stable@vger.kernel.org
Fixes: 1a69f7a161a7 ("LoongArch: ptrace: Expose hardware breakpoints to debuggers")
Reviewed-by: WANG Xuerui <git@xen0n.name>
Reviewed-by: Xi Ruoyao <xry111@xry111.site>
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/include/uapi/asm/ptrace.h | 10 ++++++++++
 arch/loongarch/kernel/ptrace.c           |  6 +++---
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/loongarch/include/uapi/asm/ptrace.h b/arch/loongarch/include/uapi/asm/ptrace.h
index ac915f841650..aafb3cd9e943 100644
--- a/arch/loongarch/include/uapi/asm/ptrace.h
+++ b/arch/loongarch/include/uapi/asm/ptrace.h
@@ -72,6 +72,16 @@ struct user_watch_state {
 	} dbg_regs[8];
 };
 
+struct user_watch_state_v2 {
+	uint64_t dbg_info;
+	struct {
+		uint64_t    addr;
+		uint64_t    mask;
+		uint32_t    ctrl;
+		uint32_t    pad;
+	} dbg_regs[14];
+};
+
 #define PTRACE_SYSEMU			0x1f
 #define PTRACE_SYSEMU_SINGLESTEP	0x20
 
diff --git a/arch/loongarch/kernel/ptrace.c b/arch/loongarch/kernel/ptrace.c
index 19dc6eff45cc..5e2402cfcab0 100644
--- a/arch/loongarch/kernel/ptrace.c
+++ b/arch/loongarch/kernel/ptrace.c
@@ -720,7 +720,7 @@ static int hw_break_set(struct task_struct *target,
 	unsigned int note_type = regset->core_note_type;
 
 	/* Resource info */
-	offset = offsetof(struct user_watch_state, dbg_regs);
+	offset = offsetof(struct user_watch_state_v2, dbg_regs);
 	user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf, 0, offset);
 
 	/* (address, mask, ctrl) registers */
@@ -920,7 +920,7 @@ static const struct user_regset loongarch64_regsets[] = {
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
 	[REGSET_HW_BREAK] = {
 		.core_note_type = NT_LOONGARCH_HW_BREAK,
-		.n = sizeof(struct user_watch_state) / sizeof(u32),
+		.n = sizeof(struct user_watch_state_v2) / sizeof(u32),
 		.size = sizeof(u32),
 		.align = sizeof(u32),
 		.regset_get = hw_break_get,
@@ -928,7 +928,7 @@ static const struct user_regset loongarch64_regsets[] = {
 	},
 	[REGSET_HW_WATCH] = {
 		.core_note_type = NT_LOONGARCH_HW_WATCH,
-		.n = sizeof(struct user_watch_state) / sizeof(u32),
+		.n = sizeof(struct user_watch_state_v2) / sizeof(u32),
 		.size = sizeof(u32),
 		.align = sizeof(u32),
 		.regset_get = hw_break_get,
-- 
2.48.1



