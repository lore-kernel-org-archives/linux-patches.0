Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64213196C8E;
	Thu,  6 Jun 2024 14:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682966; cv=none; b=mpw6Ym5pyTxsSceuGOQgwy+PGBacrd1XDXFhYYbHP9DQaAzbIfGaypZQZYo2+SAN0w1VmHYbFk9WWfScQ04+rwASmRKgqi+OagY7B5Q1HaaXuWOWV0PHsyBhA25SrGVWSv9UFwiqMHK6+To9guIlN/5I1HuCn8JRmRJufxLzuGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682966; c=relaxed/simple;
	bh=Do6fTmO3Zh65AixCc4Qf65soUaHeSzyA+6+YDi1OgNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CpDg5cdJWA4+U6WGX2fqZOQtK0mSDf20tB4ytzWA9kQdgF/0G1PqHzghtJFzYpk2f7XTm2vBSO/ftJrd0x8TfF0o4GYI8hnONev5tXmExDTPLrS7k5vb0MGPk4sGzScS/U4RY2/0hSsulpCgT8WdfejIOXeRuXIYlqINuqwP2ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vclUTwEI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vclUTwEI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B290C32781;
	Thu,  6 Jun 2024 14:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682966;
	bh=Do6fTmO3Zh65AixCc4Qf65soUaHeSzyA+6+YDi1OgNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vclUTwEIU0meQ3pSv3j7RPaVCmJTEBqvjpbAMhauLcnYWBZuoho1P9iRvMFfSfRRh
	 Nk30Mb0XdqoJyUxDbp9trUAag0JEULq1qFt+SnefpKQRuKaWSYkLHtV5FDBEX0lUmB
	 12IbXqni4TZfcDdu6fqhNhUnuWxSnokiNUU5IyFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Remus <jremus@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 134/374] s390/vdso: Introduce and use struct stack_frame_vdso_wrapper
Date: Thu,  6 Jun 2024 16:01:53 +0200
Message-ID: <20240606131656.391083568@linuxfoundation.org>
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

[ Upstream commit be72ea09c1a5273abf8c6c52ef53e36c701cbf6a ]

Introduce and use struct stack_frame_vdso_wrapper within vdso user wrapper
code.  With this structure it is possible to automatically generate an
asm-offset define which can be used to save and restore the return address
of the calling function.

Also use STACK_FRAME_USER_OVERHEAD instead of STACK_FRAME_OVERHEAD to
document that the code works with user space stack frames with the standard
stack frame layout.

Fixes: aa44433ac4ee ("s390: add USER_STACKTRACE support")
Reviewed-by: Jens Remus <jremus@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/stacktrace.h          |  5 +++++
 arch/s390/kernel/asm-offsets.c              |  4 ++++
 arch/s390/kernel/vdso64/vdso_user_wrapper.S | 18 ++++++++----------
 3 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/arch/s390/include/asm/stacktrace.h b/arch/s390/include/asm/stacktrace.h
index 4aefbe32265d8..85b6738b826af 100644
--- a/arch/s390/include/asm/stacktrace.h
+++ b/arch/s390/include/asm/stacktrace.h
@@ -13,6 +13,11 @@ struct stack_frame_user {
 	unsigned long empty2[4];
 };
 
+struct stack_frame_vdso_wrapper {
+	struct stack_frame_user sf;
+	unsigned long return_address;
+};
+
 struct perf_callchain_entry_ctx;
 
 void arch_stack_walk_user_common(stack_trace_consume_fn consume_entry, void *cookie,
diff --git a/arch/s390/kernel/asm-offsets.c b/arch/s390/kernel/asm-offsets.c
index fa5f6885c74aa..28017c418442b 100644
--- a/arch/s390/kernel/asm-offsets.c
+++ b/arch/s390/kernel/asm-offsets.c
@@ -66,6 +66,10 @@ int main(void)
 	OFFSET(__SF_SIE_CONTROL_PHYS, stack_frame, sie_control_block_phys);
 	DEFINE(STACK_FRAME_OVERHEAD, sizeof(struct stack_frame));
 	BLANK();
+	DEFINE(STACK_FRAME_USER_OVERHEAD, sizeof(struct stack_frame_user));
+	OFFSET(__SFVDSO_RETURN_ADDRESS, stack_frame_vdso_wrapper, return_address);
+	DEFINE(STACK_FRAME_VDSO_OVERHEAD, sizeof(struct stack_frame_vdso_wrapper));
+	BLANK();
 	/* idle data offsets */
 	OFFSET(__CLOCK_IDLE_ENTER, s390_idle_data, clock_idle_enter);
 	OFFSET(__TIMER_IDLE_ENTER, s390_idle_data, timer_idle_enter);
diff --git a/arch/s390/kernel/vdso64/vdso_user_wrapper.S b/arch/s390/kernel/vdso64/vdso_user_wrapper.S
index 85247ef5a41b8..deee8ca9cdbf0 100644
--- a/arch/s390/kernel/vdso64/vdso_user_wrapper.S
+++ b/arch/s390/kernel/vdso64/vdso_user_wrapper.S
@@ -6,8 +6,6 @@
 #include <asm/dwarf.h>
 #include <asm/ptrace.h>
 
-#define WRAPPER_FRAME_SIZE (STACK_FRAME_OVERHEAD+8)
-
 /*
  * Older glibc version called vdso without allocating a stackframe. This wrapper
  * is just used to allocate a stackframe. See
@@ -20,16 +18,16 @@
 	__ALIGN
 __kernel_\func:
 	CFI_STARTPROC
-	aghi	%r15,-WRAPPER_FRAME_SIZE
-	CFI_DEF_CFA_OFFSET (STACK_FRAME_OVERHEAD + WRAPPER_FRAME_SIZE)
-	CFI_VAL_OFFSET 15, -STACK_FRAME_OVERHEAD
-	stg	%r14,STACK_FRAME_OVERHEAD(%r15)
-	CFI_REL_OFFSET 14, STACK_FRAME_OVERHEAD
+	aghi	%r15,-STACK_FRAME_VDSO_OVERHEAD
+	CFI_DEF_CFA_OFFSET (STACK_FRAME_USER_OVERHEAD + STACK_FRAME_VDSO_OVERHEAD)
+	CFI_VAL_OFFSET 15,-STACK_FRAME_USER_OVERHEAD
+	stg	%r14,__SFVDSO_RETURN_ADDRESS(%r15)
+	CFI_REL_OFFSET 14,__SFVDSO_RETURN_ADDRESS
 	brasl	%r14,__s390_vdso_\func
-	lg	%r14,STACK_FRAME_OVERHEAD(%r15)
+	lg	%r14,__SFVDSO_RETURN_ADDRESS(%r15)
 	CFI_RESTORE 14
-	aghi	%r15,WRAPPER_FRAME_SIZE
-	CFI_DEF_CFA_OFFSET STACK_FRAME_OVERHEAD
+	aghi	%r15,STACK_FRAME_VDSO_OVERHEAD
+	CFI_DEF_CFA_OFFSET STACK_FRAME_USER_OVERHEAD
 	CFI_RESTORE 15
 	br	%r14
 	CFI_ENDPROC
-- 
2.43.0



