Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D93D196C8E;
	Thu,  6 Jun 2024 14:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682967; cv=none; b=ePF4z+dlrtqo88tFoIyo5iWgLn0/KRXsTO4yd1dxV1kh4hcUthvdXV8WZkW1gzlRNWnko9I+RKPcDg2GbFOQyzN2n+HGckVNX6WjuurOswZ41aPfp2TD7sC2izeU35sqmq64bJ3UmJ0HDB4TiL86eYjK7t+R1ziDMha4GAZ/xm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682967; c=relaxed/simple;
	bh=Vypf+tbrfwUXguPS2YyEDYrDDlzbhOiRvZ1A3FgGc10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nqJxf/XUJaz30iQUvT9cqTaCWokathDPfSVkWIW63GS2bySJSUTDUc6zHMo8wD5BzFGKZf6GFwAbKXW8Jkt5Eo2s68ug+ui3bXKRDWRC3N4POeLMO3qvsesVgbObRjMaU58aXXt3NnbsZcPC2yd7qh/GT8MZkcv6orz65H7Pch4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ORVdkNwB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ORVdkNwB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCCB9C2BD10;
	Thu,  6 Jun 2024 14:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682967;
	bh=Vypf+tbrfwUXguPS2YyEDYrDDlzbhOiRvZ1A3FgGc10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ORVdkNwBOd8rV65dqrhhKwqPG+duXMnpNuJLd5S3V8J6zFT5t9n7zjBjHRqlWihs/
	 Bda75hzoPf8pq8DKyycf/KzVVXsuDtw3FyBOWR1OOx2SxZEK+xi0GprpSkN9h3OH8Q
	 TNy9SrUvKbE0Zy1chYNRkkY7hLjlxpYpZ1ryP+VM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Remus <jremus@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 135/374] s390/stackstrace: Detect vdso stack frames
Date: Thu,  6 Jun 2024 16:01:54 +0200
Message-ID: <20240606131656.427041820@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 62b672c4ba90e726cc39b5c3d6dffd1ca817e143 ]

Clear the backchain of the extra stack frame added by the vdso user wrapper
code. This allows the user stack walker to detect and skip the non-standard
stack frame. Without this an incorrect instruction pointer would be added
to stack traces, and stack frame walking would be continued with a more or
less random back chain.

Fixes: aa44433ac4ee ("s390: add USER_STACKTRACE support")
Reviewed-by: Jens Remus <jremus@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/processor.h           |  1 +
 arch/s390/kernel/asm-offsets.c              |  1 +
 arch/s390/kernel/stacktrace.c               | 28 ++++++++++++++++++---
 arch/s390/kernel/vdso.c                     | 13 +++++++---
 arch/s390/kernel/vdso64/vdso_user_wrapper.S |  1 +
 5 files changed, 36 insertions(+), 8 deletions(-)

diff --git a/arch/s390/include/asm/processor.h b/arch/s390/include/asm/processor.h
index db9982f0e8cd0..bbbdc5abe2b2c 100644
--- a/arch/s390/include/asm/processor.h
+++ b/arch/s390/include/asm/processor.h
@@ -98,6 +98,7 @@ void cpu_detect_mhz_feature(void);
 
 extern const struct seq_operations cpuinfo_op;
 extern void execve_tail(void);
+unsigned long vdso_text_size(void);
 unsigned long vdso_size(void);
 
 /*
diff --git a/arch/s390/kernel/asm-offsets.c b/arch/s390/kernel/asm-offsets.c
index 28017c418442b..2f65bca2f3f1c 100644
--- a/arch/s390/kernel/asm-offsets.c
+++ b/arch/s390/kernel/asm-offsets.c
@@ -66,6 +66,7 @@ int main(void)
 	OFFSET(__SF_SIE_CONTROL_PHYS, stack_frame, sie_control_block_phys);
 	DEFINE(STACK_FRAME_OVERHEAD, sizeof(struct stack_frame));
 	BLANK();
+	OFFSET(__SFUSER_BACKCHAIN, stack_frame_user, back_chain);
 	DEFINE(STACK_FRAME_USER_OVERHEAD, sizeof(struct stack_frame_user));
 	OFFSET(__SFVDSO_RETURN_ADDRESS, stack_frame_vdso_wrapper, return_address);
 	DEFINE(STACK_FRAME_VDSO_OVERHEAD, sizeof(struct stack_frame_vdso_wrapper));
diff --git a/arch/s390/kernel/stacktrace.c b/arch/s390/kernel/stacktrace.c
index b4485b0c7f06b..640363b2a1059 100644
--- a/arch/s390/kernel/stacktrace.c
+++ b/arch/s390/kernel/stacktrace.c
@@ -92,10 +92,16 @@ static inline bool ip_invalid(unsigned long ip)
 	return false;
 }
 
+static inline bool ip_within_vdso(unsigned long ip)
+{
+	return in_range(ip, current->mm->context.vdso_base, vdso_text_size());
+}
+
 void arch_stack_walk_user_common(stack_trace_consume_fn consume_entry, void *cookie,
 				 struct perf_callchain_entry_ctx *entry,
 				 const struct pt_regs *regs, bool perf)
 {
+	struct stack_frame_vdso_wrapper __user *sf_vdso;
 	struct stack_frame_user __user *sf;
 	unsigned long ip, sp;
 	bool first = true;
@@ -112,11 +118,25 @@ void arch_stack_walk_user_common(stack_trace_consume_fn consume_entry, void *coo
 	while (1) {
 		if (__get_user(sp, &sf->back_chain))
 			break;
+		/*
+		 * VDSO entry code has a non-standard stack frame layout.
+		 * See VDSO user wrapper code for details.
+		 */
+		if (!sp && ip_within_vdso(ip)) {
+			sf_vdso = (void __user *)sf;
+			if (__get_user(ip, &sf_vdso->return_address))
+				break;
+			sp = (unsigned long)sf + STACK_FRAME_VDSO_OVERHEAD;
+			sf = (void __user *)sp;
+			if (__get_user(sp, &sf->back_chain))
+				break;
+		} else {
+			sf = (void __user *)sp;
+			if (__get_user(ip, &sf->gprs[8]))
+				break;
+		}
 		/* Sanity check: ABI requires SP to be 8 byte aligned. */
-		if (!sp || sp & 0x7)
-			break;
-		sf = (void __user *)sp;
-		if (__get_user(ip, &sf->gprs[8]))
+		if (sp & 0x7)
 			break;
 		if (ip_invalid(ip)) {
 			/*
diff --git a/arch/s390/kernel/vdso.c b/arch/s390/kernel/vdso.c
index a45b3a4c91db0..2f967ac2b8e3e 100644
--- a/arch/s390/kernel/vdso.c
+++ b/arch/s390/kernel/vdso.c
@@ -210,17 +210,22 @@ static unsigned long vdso_addr(unsigned long start, unsigned long len)
 	return addr;
 }
 
-unsigned long vdso_size(void)
+unsigned long vdso_text_size(void)
 {
-	unsigned long size = VVAR_NR_PAGES * PAGE_SIZE;
+	unsigned long size;
 
 	if (is_compat_task())
-		size += vdso32_end - vdso32_start;
+		size = vdso32_end - vdso32_start;
 	else
-		size += vdso64_end - vdso64_start;
+		size = vdso64_end - vdso64_start;
 	return PAGE_ALIGN(size);
 }
 
+unsigned long vdso_size(void)
+{
+	return vdso_text_size() + VVAR_NR_PAGES * PAGE_SIZE;
+}
+
 int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 {
 	unsigned long addr = VDSO_BASE;
diff --git a/arch/s390/kernel/vdso64/vdso_user_wrapper.S b/arch/s390/kernel/vdso64/vdso_user_wrapper.S
index deee8ca9cdbf0..e26e68675c08d 100644
--- a/arch/s390/kernel/vdso64/vdso_user_wrapper.S
+++ b/arch/s390/kernel/vdso64/vdso_user_wrapper.S
@@ -23,6 +23,7 @@ __kernel_\func:
 	CFI_VAL_OFFSET 15,-STACK_FRAME_USER_OVERHEAD
 	stg	%r14,__SFVDSO_RETURN_ADDRESS(%r15)
 	CFI_REL_OFFSET 14,__SFVDSO_RETURN_ADDRESS
+	xc	__SFUSER_BACKCHAIN(8,%r15),__SFUSER_BACKCHAIN(%r15)
 	brasl	%r14,__s390_vdso_\func
 	lg	%r14,__SFVDSO_RETURN_ADDRESS(%r15)
 	CFI_RESTORE 14
-- 
2.43.0



