Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40D2746A
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 13:56:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51477C433D2;
	Thu, 12 Jan 2023 13:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673531802;
	bh=a7SFWlwE4RlUkDK4vngE1uAxXvRKn1g6gxNlY6Cn7yE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=13H+CKxXDprXZEfbJcFrWMqh9MOXTxEsVqeudP3exwjb2yicfpQBpSYX153wTc6pD
	 eSomFZ6nKIMyA9fuTEQrHc4srGzvMsTsYl78iUoRBwyv9kGTNDO9cvhkh0MPKLIEU7
	 XDvl+nYxgiX/kOnZ2D5V5qH0rFqPDv1crDPosgzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Huey <me@kylehuey.com>,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH 6.1 02/10] x86/fpu: Take task_struct* in copy_sigframe_from_user_to_xstate()
Date: Thu, 12 Jan 2023 14:56:23 +0100
Message-Id: <20230112135327.076221099@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135326.981869724@linuxfoundation.org>
References: <20230112135326.981869724@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kyle Huey <me@kylehuey.com>

commit 6a877d2450ace4f27c012519e5a1ae818f931983 upstream.

This will allow copy_sigframe_from_user_to_xstate() to grab the address of
thread_struct's pkru value in a later patch.

Signed-off-by: Kyle Huey <me@kylehuey.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://lore.kernel.org/all/20221115230932.7126-2-khuey%40kylehuey.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/fpu/signal.c |    2 +-
 arch/x86/kernel/fpu/xstate.c |    4 ++--
 arch/x86/kernel/fpu/xstate.h |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -396,7 +396,7 @@ static bool __fpu_restore_sig(void __use
 
 	fpregs = &fpu->fpstate->regs;
 	if (use_xsave() && !fx_only) {
-		if (copy_sigframe_from_user_to_xstate(fpu->fpstate, buf_fx))
+		if (copy_sigframe_from_user_to_xstate(tsk, buf_fx))
 			return false;
 	} else {
 		if (__copy_from_user(&fpregs->fxsave, buf_fx,
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1278,10 +1278,10 @@ int copy_uabi_from_kernel_to_xstate(stru
  * XSAVE[S] format and copy to the target thread. This is called from the
  * sigreturn() and rt_sigreturn() system calls.
  */
-int copy_sigframe_from_user_to_xstate(struct fpstate *fpstate,
+int copy_sigframe_from_user_to_xstate(struct task_struct *tsk,
 				      const void __user *ubuf)
 {
-	return copy_uabi_to_xstate(fpstate, NULL, ubuf);
+	return copy_uabi_to_xstate(tsk->thread.fpu.fpstate, NULL, ubuf);
 }
 
 static bool validate_independent_components(u64 mask)
--- a/arch/x86/kernel/fpu/xstate.h
+++ b/arch/x86/kernel/fpu/xstate.h
@@ -47,7 +47,7 @@ extern void __copy_xstate_to_uabi_buf(st
 extern void copy_xstate_to_uabi_buf(struct membuf to, struct task_struct *tsk,
 				    enum xstate_copy_mode mode);
 extern int copy_uabi_from_kernel_to_xstate(struct fpstate *fpstate, const void *kbuf);
-extern int copy_sigframe_from_user_to_xstate(struct fpstate *fpstate, const void __user *ubuf);
+extern int copy_sigframe_from_user_to_xstate(struct task_struct *tsk, const void __user *ubuf);
 
 
 extern void fpu__init_cpu_xstate(void);


