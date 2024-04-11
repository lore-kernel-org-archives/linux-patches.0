Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C06D0144D34;
	Thu, 11 Apr 2024 10:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830231; cv=none; b=kRHesa32Dho6dD7PTRVl1s4DS2CA+g41HW0NYCKlwfhuNi9++xE9Ti8EjKehTvMytmRhQJ4ghDmrCIqEiga3qlqzGy30C0vVenbAktxhbT6bPVc+mEcwnJAW/Vg6vQA11GPrUHGDZIHH+5wQRpnvqSdMpSFuhn0bWasdp4eMSso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830231; c=relaxed/simple;
	bh=la6xAYIMM2eTAQd4v44zRDD0woJA7ENMWwl/Dw2oPZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bDIZB4I5K+I82qcYCzYMOb0tvKxHgmk5KuhigBUU6W8y3zIQf2MZIUow+CN6oxAqHeYrNR/Xa1h5gO/oTAinrefX+n7vZCT/p6UdtakfedpAhyKtpRyYltSw7u8J7hYZwGkhOcsFIQ96KYchpSRwkiosWMz/gYDfsKDk1GXMGpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gfopb2KZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gfopb2KZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D11C433F1;
	Thu, 11 Apr 2024 10:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830231;
	bh=la6xAYIMM2eTAQd4v44zRDD0woJA7ENMWwl/Dw2oPZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gfopb2KZlkrSxXcpW0SVPUqj3jhlBR4DxvY+Mt3P+ewGCEQMXoF3FhCWLhOSKve7a
	 XKupKEtvJ6foV+u00mqf257fl7Sp3Mo+ZoOjuJ2SOyE+MYR2XFQLLzho138oLHp6n4
	 qMjbKnxLYgR3BZC06JqDqP7yroRpzz25JT4q4p04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 079/143] x86/vdso: Fix rethunk patching for vdso-image-{32,64}.o
Date: Thu, 11 Apr 2024 11:55:47 +0200
Message-ID: <20240411095423.291849264@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit b388e57d4628eb22782bdad4cd5b83ca87a1b7c9 ]

For CONFIG_RETHUNK kernels, objtool annotates all the function return
sites so they can be patched during boot.  By design, after
apply_returns() is called, all tail-calls to the compiler-generated
default return thunk (__x86_return_thunk) should be patched out and
replaced with whatever's needed for any mitigations (or lack thereof).

The commit

  4461438a8405 ("x86/retpoline: Ensure default return thunk isn't used at runtime")

adds a runtime check and a WARN_ONCE() if the default return thunk ever
gets executed after alternatives have been applied.  This warning is
a sanity check to make sure objtool and apply_returns() are doing their
job.

As Nathan reported, that check found something:

  Unpatched return thunk in use. This should not happen!
  WARNING: CPU: 0 PID: 1 at arch/x86/kernel/cpu/bugs.c:2856 __warn_thunk+0x27/0x40
  RIP: 0010:__warn_thunk+0x27/0x40
  Call Trace:
   <TASK>
   ? show_regs
   ? __warn
   ? __warn_thunk
   ? report_bug
   ? console_unlock
   ? handle_bug
   ? exc_invalid_op
   ? asm_exc_invalid_op
   ? ia32_binfmt_init
   ? __warn_thunk
   warn_thunk_thunk
   do_one_initcall
   kernel_init_freeable
   ? __pfx_kernel_init
   kernel_init
   ret_from_fork
   ? __pfx_kernel_init
   ret_from_fork_asm
   </TASK>

Boris debugged to find that the unpatched return site was in
init_vdso_image_64(), and its translation unit wasn't being analyzed by
objtool, so it never got annotated.  So it got ignored by
apply_returns().

This is only a minor issue, as this function is only called during boot.
Still, objtool needs full visibility to the kernel.  Fix it by enabling
objtool on vdso-image-{32,64}.o.

Note this problem can only be seen with !CONFIG_X86_KERNEL_IBT, as that
requires objtool to run individually on all translation units rather on
vmlinux.o.

  [ bp: Massage commit message. ]

Reported-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20240215032049.GA3944823@dev-arch.thelio-3990X
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/entry/vdso/Makefile | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/entry/vdso/Makefile b/arch/x86/entry/vdso/Makefile
index b1b8dd1608f7e..4ee59121b9053 100644
--- a/arch/x86/entry/vdso/Makefile
+++ b/arch/x86/entry/vdso/Makefile
@@ -34,8 +34,12 @@ obj-y					+= vma.o extable.o
 KASAN_SANITIZE_vma.o			:= y
 UBSAN_SANITIZE_vma.o			:= y
 KCSAN_SANITIZE_vma.o			:= y
-OBJECT_FILES_NON_STANDARD_vma.o		:= n
-OBJECT_FILES_NON_STANDARD_extable.o	:= n
+
+OBJECT_FILES_NON_STANDARD_extable.o		:= n
+OBJECT_FILES_NON_STANDARD_vdso-image-32.o 	:= n
+OBJECT_FILES_NON_STANDARD_vdso-image-64.o 	:= n
+OBJECT_FILES_NON_STANDARD_vdso32-setup.o	:= n
+OBJECT_FILES_NON_STANDARD_vma.o			:= n
 
 # vDSO images to build
 vdso_img-$(VDSO64-y)		+= 64
@@ -43,7 +47,6 @@ vdso_img-$(VDSOX32-y)		+= x32
 vdso_img-$(VDSO32-y)		+= 32
 
 obj-$(VDSO32-y)				 += vdso32-setup.o
-OBJECT_FILES_NON_STANDARD_vdso32-setup.o := n
 
 vobjs := $(foreach F,$(vobjs-y),$(obj)/$F)
 vobjs32 := $(foreach F,$(vobjs32-y),$(obj)/$F)
-- 
2.43.0



