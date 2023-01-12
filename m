Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E96746A
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 13:57:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA307C433EF;
	Thu, 12 Jan 2023 13:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673531875;
	bh=/JlfAO5F8GQUXx9ZbY192XkACLPf3EhZ0v7/USpRT0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ecMl0QZ/fg15byoKm4SSbpIB+qIvWO6itWvHelD3Fu98y3bcLSY1hS4vpMitG7tTL
	 r+iuiglvKPm10L19Zn0LBVcXNZlRc+0n1EGF5E9NqZXi/BXQsjrENxkCOFXKahzXSJ
	 DR7FBjFkjtdtgW0IgZslg7jpSGTFBia2+G0CC1/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Huey <me@kylehuey.com>,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH 5.15 03/10] x86/fpu: Add a pkru argument to copy_uabi_from_kernel_to_xstate().
Date: Thu, 12 Jan 2023 14:56:40 +0100
Message-Id: <20230112135326.807828831@linuxfoundation.org>
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

commit 1c813ce0305571e1b2e4cc4acca451da9e6ad18f upstream

ptrace (through PTRACE_SETREGSET with NT_X86_XSTATE) ultimately calls
copy_uabi_from_kernel_to_xstate(). In preparation for eventually handling
PKRU in copy_uabi_to_xstate, pass in a pointer to the PKRU location.

Signed-off-by: Kyle Huey <me@kylehuey.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://lore.kernel.org/all/20221115230932.7126-3-khuey%40kylehuey.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/fpu/xstate.h |    2 +-
 arch/x86/kernel/fpu/regset.c      |    2 +-
 arch/x86/kernel/fpu/xstate.c      |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/include/asm/fpu/xstate.h
+++ b/arch/x86/include/asm/fpu/xstate.h
@@ -136,7 +136,7 @@ extern void __init update_regset_xstate_
 
 void *get_xsave_addr(struct xregs_state *xsave, int xfeature_nr);
 int xfeature_size(int xfeature_nr);
-int copy_uabi_from_kernel_to_xstate(struct xregs_state *xsave, const void *kbuf);
+int copy_uabi_from_kernel_to_xstate(struct xregs_state *xsave, const void *kbuf, u32 *pkru);
 int copy_sigframe_from_user_to_xstate(struct task_struct *tsk, const void __user *ubuf);
 
 void xsaves(struct xregs_state *xsave, u64 mask);
--- a/arch/x86/kernel/fpu/regset.c
+++ b/arch/x86/kernel/fpu/regset.c
@@ -163,7 +163,7 @@ int xstateregs_set(struct task_struct *t
 	}
 
 	fpu_force_restore(fpu);
-	ret = copy_uabi_from_kernel_to_xstate(&fpu->state.xsave, kbuf ?: tmpbuf);
+	ret = copy_uabi_from_kernel_to_xstate(&fpu->state.xsave, kbuf ?: tmpbuf, &target->thread.pkru);
 
 out:
 	vfree(tmpbuf);
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1159,7 +1159,7 @@ static int copy_uabi_to_xstate(struct xr
  * format and copy to the target thread. This is called from
  * xstateregs_set().
  */
-int copy_uabi_from_kernel_to_xstate(struct xregs_state *xsave, const void *kbuf)
+int copy_uabi_from_kernel_to_xstate(struct xregs_state *xsave, const void *kbuf, u32 *pkru)
 {
 	return copy_uabi_to_xstate(xsave, kbuf, NULL);
 }


