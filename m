Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7EDFBE1;
	Mon, 11 Dec 2023 18:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bDaLSs6D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F39ECC433C8;
	Mon, 11 Dec 2023 18:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319779;
	bh=Ibf14BlzmqR6ginzJtsRRFzdOdoY7qWxenIxQgDreqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bDaLSs6Dc8vzW7HZB7vbQtVXmmIXJd0dmWlj0ghVDgCZnBk87qb8SulAKdkJSjM7i
	 DYTEgdwVMGPJx5gK4VRBj+c4QA9STOJpM265+edOnlB7dqr49W6HycrCtCd7KH51gx
	 4zUWoJ2+gplw9zFTNGZuK5WS2ZdlkAuvZU9MWT6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurelien Jarno <aurel32@debian.org>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.6 230/244] MIPS: kernel: Clear FPU states when setting up kernel threads
Date: Mon, 11 Dec 2023 19:22:03 +0100
Message-ID: <20231211182056.341834152@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

commit a58a173444a68412bb08849bd81c679395f20ca0 upstream.

io_uring sets up the io worker kernel thread via a syscall out of an
user space prrocess. This process might have used FPU and since
copy_thread() didn't clear FPU states for kernel threads a BUG()
is triggered for using FPU inside kernel. Move code around
to always clear FPU state for user and kernel threads.

Cc: stable@vger.kernel.org
Reported-by: Aurelien Jarno <aurel32@debian.org>
Closes: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1055021
Suggested-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/kernel/process.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

--- a/arch/mips/kernel/process.c
+++ b/arch/mips/kernel/process.c
@@ -121,6 +121,19 @@ int copy_thread(struct task_struct *p, c
 	/*  Put the stack after the struct pt_regs.  */
 	childksp = (unsigned long) childregs;
 	p->thread.cp0_status = (read_c0_status() & ~(ST0_CU2|ST0_CU1)) | ST0_KERNEL_CUMASK;
+
+	/*
+	 * New tasks lose permission to use the fpu. This accelerates context
+	 * switching for most programs since they don't use the fpu.
+	 */
+	clear_tsk_thread_flag(p, TIF_USEDFPU);
+	clear_tsk_thread_flag(p, TIF_USEDMSA);
+	clear_tsk_thread_flag(p, TIF_MSA_CTX_LIVE);
+
+#ifdef CONFIG_MIPS_MT_FPAFF
+	clear_tsk_thread_flag(p, TIF_FPUBOUND);
+#endif /* CONFIG_MIPS_MT_FPAFF */
+
 	if (unlikely(args->fn)) {
 		/* kernel thread */
 		unsigned long status = p->thread.cp0_status;
@@ -149,20 +162,8 @@ int copy_thread(struct task_struct *p, c
 	p->thread.reg29 = (unsigned long) childregs;
 	p->thread.reg31 = (unsigned long) ret_from_fork;
 
-	/*
-	 * New tasks lose permission to use the fpu. This accelerates context
-	 * switching for most programs since they don't use the fpu.
-	 */
 	childregs->cp0_status &= ~(ST0_CU2|ST0_CU1);
 
-	clear_tsk_thread_flag(p, TIF_USEDFPU);
-	clear_tsk_thread_flag(p, TIF_USEDMSA);
-	clear_tsk_thread_flag(p, TIF_MSA_CTX_LIVE);
-
-#ifdef CONFIG_MIPS_MT_FPAFF
-	clear_tsk_thread_flag(p, TIF_FPUBOUND);
-#endif /* CONFIG_MIPS_MT_FPAFF */
-
 #ifdef CONFIG_MIPS_FP_SUPPORT
 	atomic_set(&p->thread.bd_emu_frame, BD_EMUFRAME_NONE);
 #endif


