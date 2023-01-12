Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE782746A
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 13:57:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69EBEC433D2;
	Thu, 12 Jan 2023 13:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673531837;
	bh=I27d5YDz+gwxAll49MWFYLb08TMklxJt4E0zjTcc6pM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0r8vLirJ3Ku0+xSl9tIrq6vhHCKmdBciFjhf5i7H3wgzdpqPjE2V/fRPx/+i1qkO6
	 cNfy+qFV+B2ljicqx9VgTvV8dz1Djp+DaPr+qNs/osh/1XRO3j/fdQXIw7SUo+zt12
	 mDohPO2//QarbZdAn9SGy1k3OwiJLcffswG1oePw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Huey <me@kylehuey.com>,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH 5.15 02/10] x86/fpu: Take task_struct* in copy_sigframe_from_user_to_xstate()
Date: Thu, 12 Jan 2023 14:56:39 +0100
Message-Id: <20230112135326.771928687@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135326.689857506@linuxfoundation.org>
References: <20230112135326.689857506@linuxfoundation.org>
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

commit 6a877d2450ace4f27c012519e5a1ae818f931983 upstream

This will allow copy_sigframe_from_user_to_xstate() to grab the address of
thread_struct's pkru value in a later patch.

Signed-off-by: Kyle Huey <me@kylehuey.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://lore.kernel.org/all/20221115230932.7126-2-khuey%40kylehuey.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/fpu/xstate.h |    2 +-
 arch/x86/kernel/fpu/signal.c      |    2 +-
 arch/x86/kernel/fpu/xstate.c      |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

--- a/arch/x86/include/asm/fpu/xstate.h
+++ b/arch/x86/include/asm/fpu/xstate.h
@@ -137,7 +137,7 @@ extern void __init update_regset_xstate_
 void *get_xsave_addr(struct xregs_state *xsave, int xfeature_nr);
 int xfeature_size(int xfeature_nr);
 int copy_uabi_from_kernel_to_xstate(struct xregs_state *xsave, const void *kbuf);
-int copy_sigframe_from_user_to_xstate(struct xregs_state *xsave, const void __user *ubuf);
+int copy_sigframe_from_user_to_xstate(struct task_struct *tsk, const void __user *ubuf);
 
 void xsaves(struct xregs_state *xsave, u64 mask);
 void xrstors(struct xregs_state *xsave, u64 mask);
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -370,7 +370,7 @@ static int __fpu_restore_sig(void __user
 	fpregs_unlock();
 
 	if (use_xsave() && !fx_only) {
-		ret = copy_sigframe_from_user_to_xstate(&fpu->state.xsave, buf_fx);
+		ret = copy_sigframe_from_user_to_xstate(tsk, buf_fx);
 		if (ret)
 			return ret;
 	} else {
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1169,10 +1169,10 @@ int copy_uabi_from_kernel_to_xstate(stru
  * XSAVE[S] format and copy to the target thread. This is called from the
  * sigreturn() and rt_sigreturn() system calls.
  */
-int copy_sigframe_from_user_to_xstate(struct xregs_state *xsave,
+int copy_sigframe_from_user_to_xstate(struct task_struct *tsk,
 				      const void __user *ubuf)
 {
-	return copy_uabi_to_xstate(xsave, NULL, ubuf);
+	return copy_uabi_to_xstate(&tsk->thread.fpu.state.xsave, NULL, ubuf);
 }
 
 static bool validate_xsaves_xrstors(u64 mask)


