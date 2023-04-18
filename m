Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF22D2566
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:37:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64C10C4339B;
	Tue, 18 Apr 2023 12:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821424;
	bh=zRLMH/4M1S3OWNZU5MIgZLHkKCAM3Htt2XONDBZDETI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1rNuBOmViPjx9FT9Bw+MwyyECTS3ID+XcFB0M0/6eRhzYwiicxg+6Nt/WkzFSUgoG
	 tGtOZeOem6osNFxYBdi67e0sblAaIcr+Cvolp1tGMpSk+01iRxVg/7gEHXCjiUwhjR
	 yawhtO5nxDuTA4bU9ezVC6fH5f3ftlPicILBpq5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathis Salmen <mathis.salmen@matsal.de>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.10 093/124] riscv: add icache flush for nommu sigreturn trampoline
Date: Tue, 18 Apr 2023 14:21:52 +0200
Message-Id: <20230418120313.228546263@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120309.539243408@linuxfoundation.org>
References: <20230418120309.539243408@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mathis Salmen <mathis.salmen@matsal.de>

commit 8d736482749f6d350892ef83a7a11d43cd49981e upstream.

In a NOMMU kernel, sigreturn trampolines are generated on the user
stack by setup_rt_frame. Currently, these trampolines are not instruction
fenced, thus their visibility to ifetch is not guaranteed.

This patch adds a flush_icache_range in setup_rt_frame to fix this
problem.

Signed-off-by: Mathis Salmen <mathis.salmen@matsal.de>
Fixes: 6bd33e1ece52 ("riscv: add nommu support")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230406101130.82304-1-mathis.salmen@matsal.de
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/signal.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/arch/riscv/kernel/signal.c
+++ b/arch/riscv/kernel/signal.c
@@ -16,6 +16,7 @@
 #include <asm/vdso.h>
 #include <asm/switch_to.h>
 #include <asm/csr.h>
+#include <asm/cacheflush.h>
 
 extern u32 __user_rt_sigreturn[2];
 
@@ -178,6 +179,7 @@ static int setup_rt_frame(struct ksignal
 {
 	struct rt_sigframe __user *frame;
 	long err = 0;
+	unsigned long __maybe_unused addr;
 
 	frame = get_sigframe(ksig, regs, sizeof(*frame));
 	if (!access_ok(frame, sizeof(*frame)))
@@ -206,7 +208,12 @@ static int setup_rt_frame(struct ksignal
 	if (copy_to_user(&frame->sigreturn_code, __user_rt_sigreturn,
 			 sizeof(frame->sigreturn_code)))
 		return -EFAULT;
-	regs->ra = (unsigned long)&frame->sigreturn_code;
+
+	addr = (unsigned long)&frame->sigreturn_code;
+	/* Make sure the two instructions are pushed to icache. */
+	flush_icache_range(addr, addr + sizeof(frame->sigreturn_code));
+
+	regs->ra = addr;
 #endif /* CONFIG_MMU */
 
 	/*


