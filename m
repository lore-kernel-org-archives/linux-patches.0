Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA671171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:06:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE2AFC433C7;
	Mon, 21 Aug 2023 20:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648399;
	bh=gcpeXCVN4v5KSyPFNjK/zLCOh1Hfq76lAt5te4I//14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s3sFylJa6Q9RegMJaSVuOg8r05YY+cdy3nA8WNTFcA+1sS4l3VTjB3qVRB55Wbc3G
	 gS1BJgYzBQ/XW2bD6u6UzrBLHTm7JZrHwdgtasBJ+pbVdPmIJ+eQT66sPaaECv9jpu
	 G2uKXz3qtqi84LdyN55+D84VsfCBQMT0VjaB9qXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.4 122/234] x86/cpu/kvm: Provide UNTRAIN_RET_VM
Date: Mon, 21 Aug 2023 21:41:25 +0200
Message-ID: <20230821194134.225398028@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peter Zijlstra <peterz@infradead.org>

commit 864bcaa38ee44ec6c0e43f79c2d2997b977e26b2 upstream.

Similar to how it doesn't make sense to have UNTRAIN_RET have two
untrain calls, it also doesn't make sense for VMEXIT to have an extra
IBPB call.

This cures VMEXIT doing potentially unret+IBPB or double IBPB.
Also, the (SEV) VMEXIT case seems to have been overlooked.

Redefine the meaning of the synthetic IBPB flags to:

 - ENTRY_IBPB     -- issue IBPB on entry  (was: entry + VMEXIT)
 - IBPB_ON_VMEXIT -- issue IBPB on VMEXIT

And have 'retbleed=ibpb' set *BOTH* feature flags to ensure it retains
the previous behaviour and issues IBPB on entry+VMEXIT.

The new 'srso=ibpb_vmexit' option only sets IBPB_ON_VMEXIT.

Create UNTRAIN_RET_VM specifically for the VMEXIT case, and have that
check IBPB_ON_VMEXIT.

All this avoids having the VMEXIT case having to check both ENTRY_IBPB
and IBPB_ON_VMEXIT and simplifies the alternatives.

Fixes: fb3bd914b3ec ("x86/srso: Add a Speculative RAS Overflow mitigation")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20230814121149.109557833@infradead.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/nospec-branch.h |   11 +++++++++++
 arch/x86/kernel/cpu/bugs.c           |    1 +
 arch/x86/kvm/svm/vmenter.S           |    7 ++-----
 3 files changed, 14 insertions(+), 5 deletions(-)

--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -295,6 +295,17 @@
 #endif
 .endm
 
+.macro UNTRAIN_RET_VM
+#if defined(CONFIG_CPU_UNRET_ENTRY) || defined(CONFIG_CPU_IBPB_ENTRY) || \
+	defined(CONFIG_CALL_DEPTH_TRACKING) || defined(CONFIG_CPU_SRSO)
+	VALIDATE_UNRET_END
+	ALTERNATIVE_3 "",						\
+		      CALL_UNTRAIN_RET, X86_FEATURE_UNRET,		\
+		      "call entry_ibpb", X86_FEATURE_IBPB_ON_VMEXIT,	\
+		      __stringify(RESET_CALL_DEPTH), X86_FEATURE_CALL_DEPTH
+#endif
+.endm
+
 .macro UNTRAIN_RET_FROM_CALL
 #if defined(CONFIG_CPU_UNRET_ENTRY) || defined(CONFIG_CPU_IBPB_ENTRY) || \
 	defined(CONFIG_CALL_DEPTH_TRACKING)
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1054,6 +1054,7 @@ do_cmd_auto:
 
 	case RETBLEED_MITIGATION_IBPB:
 		setup_force_cpu_cap(X86_FEATURE_ENTRY_IBPB);
+		setup_force_cpu_cap(X86_FEATURE_IBPB_ON_VMEXIT);
 		mitigate_smt = true;
 		break;
 
--- a/arch/x86/kvm/svm/vmenter.S
+++ b/arch/x86/kvm/svm/vmenter.S
@@ -222,10 +222,7 @@ SYM_FUNC_START(__svm_vcpu_run)
 	 * because interrupt handlers won't sanitize 'ret' if the return is
 	 * from the kernel.
 	 */
-	UNTRAIN_RET
-
-	/* SRSO */
-	ALTERNATIVE "", "call entry_ibpb", X86_FEATURE_IBPB_ON_VMEXIT
+	UNTRAIN_RET_VM
 
 	/*
 	 * Clear all general purpose registers except RSP and RAX to prevent
@@ -362,7 +359,7 @@ SYM_FUNC_START(__svm_sev_es_vcpu_run)
 	 * because interrupt handlers won't sanitize RET if the return is
 	 * from the kernel.
 	 */
-	UNTRAIN_RET
+	UNTRAIN_RET_VM
 
 	/* "Pop" @spec_ctrl_intercepted.  */
 	pop %_ASM_BX


