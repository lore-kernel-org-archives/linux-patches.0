Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD685248BA1;
	Wed, 15 Jan 2025 10:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938301; cv=none; b=jUICEQRprLpB/fuFAwMXB78KqV5zxqr4t63mF/zxDcINRtHP2yDK0cfbR+vj5SQnB38P9UufshIRx3q5QYHX+uxiwVvVeRPEUDCmE19KDUiK7TK4TD8rwk8l378H+JZwkn5KTxGzr3wE69x8/VVroMuIJGejMxCGyCjq4V6Qh0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938301; c=relaxed/simple;
	bh=I8m0bA3yxk2KTuXBaz/TckW3lchdEuHeUEgAzcbpMKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XQ6E3/GWN0n4EVWSITIQOLKtvUm9irupED+fvUEdLUAXzCU8taS/vGHPEjVZoC2NqgpT52Y90p9rbJCcJX9hvUyLuyJQIBg4YWHaLfSa6q6fwP/qOe/mahR2D3NtR6uvJhzYTjUo2MO3xJdsHhcX+rWHEVriSnax5pWhCS/Fjtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OZds1HM0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OZds1HM0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EED7C4CEDF;
	Wed, 15 Jan 2025 10:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938301;
	bh=I8m0bA3yxk2KTuXBaz/TckW3lchdEuHeUEgAzcbpMKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OZds1HM0jMzAsxKXvIkUXYOqd8j8h2ZJW747lWKKxDrJwvp5D7g3d/rrncCrMK2hg
	 Bm94bRCnAFCK36dqeU49ZOJ/uD4VMBDo6rW41/I0Yk631/1vsJxNF3I9EquFEvNPTn
	 HYIYz4Mj5QuxlfSjm0ks2otvSqkhdm544jxFvk/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christina Schimpe <christina.schimpe@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH 6.12 143/189] x86/fpu: Ensure shadow stack is active before "getting" registers
Date: Wed, 15 Jan 2025 11:37:19 +0100
Message-ID: <20250115103612.128642344@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rick Edgecombe <rick.p.edgecombe@intel.com>

commit a9d9c33132d49329ada647e4514d210d15e31d81 upstream.

The x86 shadow stack support has its own set of registers. Those registers
are XSAVE-managed, but they are "supervisor state components" which means
that userspace can not touch them with XSAVE/XRSTOR.  It also means that
they are not accessible from the existing ptrace ABI for XSAVE state.
Thus, there is a new ptrace get/set interface for it.

The regset code that ptrace uses provides an ->active() handler in
addition to the get/set ones. For shadow stack this ->active() handler
verifies that shadow stack is enabled via the ARCH_SHSTK_SHSTK bit in the
thread struct. The ->active() handler is checked from some call sites of
the regset get/set handlers, but not the ptrace ones. This was not
understood when shadow stack support was put in place.

As a result, both the set/get handlers can be called with
XFEATURE_CET_USER in its init state, which would cause get_xsave_addr() to
return NULL and trigger a WARN_ON(). The ssp_set() handler luckily has an
ssp_active() check to avoid surprising the kernel with shadow stack
behavior when the kernel is not ready for it (ARCH_SHSTK_SHSTK==0). That
check just happened to avoid the warning.

But the ->get() side wasn't so lucky. It can be called with shadow stacks
disabled, triggering the warning in practice, as reported by Christina
Schimpe:

WARNING: CPU: 5 PID: 1773 at arch/x86/kernel/fpu/regset.c:198 ssp_get+0x89/0xa0
[...]
Call Trace:
<TASK>
? show_regs+0x6e/0x80
? ssp_get+0x89/0xa0
? __warn+0x91/0x150
? ssp_get+0x89/0xa0
? report_bug+0x19d/0x1b0
? handle_bug+0x46/0x80
? exc_invalid_op+0x1d/0x80
? asm_exc_invalid_op+0x1f/0x30
? __pfx_ssp_get+0x10/0x10
? ssp_get+0x89/0xa0
? ssp_get+0x52/0xa0
__regset_get+0xad/0xf0
copy_regset_to_user+0x52/0xc0
ptrace_regset+0x119/0x140
ptrace_request+0x13c/0x850
? wait_task_inactive+0x142/0x1d0
? do_syscall_64+0x6d/0x90
arch_ptrace+0x102/0x300
[...]

Ensure that shadow stacks are active in a thread before looking them up
in the XSAVE buffer. Since ARCH_SHSTK_SHSTK and user_ssp[SHSTK_EN] are
set at the same time, the active check ensures that there will be
something to find in the XSAVE buffer.

[ dhansen: changelog/subject tweaks ]

Fixes: 2fab02b25ae7 ("x86: Add PTRACE interface for shadow stack")
Reported-by: Christina Schimpe <christina.schimpe@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Tested-by: Christina Schimpe <christina.schimpe@intel.com>
Cc:stable@vger.kernel.org
Link: https://lore.kernel.org/all/20250107233056.235536-1-rick.p.edgecombe%40intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/fpu/regset.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/fpu/regset.c
+++ b/arch/x86/kernel/fpu/regset.c
@@ -190,7 +190,8 @@ int ssp_get(struct task_struct *target,
 	struct fpu *fpu = &target->thread.fpu;
 	struct cet_user_state *cetregs;
 
-	if (!cpu_feature_enabled(X86_FEATURE_USER_SHSTK))
+	if (!cpu_feature_enabled(X86_FEATURE_USER_SHSTK) ||
+	    !ssp_active(target, regset))
 		return -ENODEV;
 
 	sync_fpstate(fpu);


