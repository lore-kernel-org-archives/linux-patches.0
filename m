Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5154C97;
	Tue, 11 Nov 2025 00:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822285; cv=none; b=gfJGufmC/uurH/lexjGMeG99v2rl2nBDVj554Tekn8gEG3NWqA9PiASIu8Gt0ohtqACXH3SKf20wAcFUSQz99WFYgS16YSh9Ct4N5lPK0OU+hNI1KcZWtIhVqRDCvK1hKLoTSqdoPl4eZs5rRuvgvNn87nz6rPhZpQpHn5ZSUrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822285; c=relaxed/simple;
	bh=pYM4L3L/gbcj5bZBKy9crzhCwbnNgL/zgp+xwqlsjzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cftaqta54V+uFkllW26BzNNk2Q5AWR4rMoxuyK10NFUcH6Ib1ePzqQ3+i43/hE9dprhwRpVnrI8jJDFQcVl43KXQofehX8XFVQq4VERBs8qsltrqpw7dM+vUZS96+P9HMQ9bqI4J+Gi2iJjLHWG27jpOVTRpF3SToXHobgGDepM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ROyDwMh8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ROyDwMh8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30709C19425;
	Tue, 11 Nov 2025 00:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822285;
	bh=pYM4L3L/gbcj5bZBKy9crzhCwbnNgL/zgp+xwqlsjzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ROyDwMh8H7yO0gtOnJTk/CSrH9Y4n+LwmaTkJ+UnnV4GOxfwzhGl255E7yIMAAdGx
	 0d4TXEKyQQG2xxXXuljkZEj5LmPYOMa7++BdjJe2IJZyNsnINGlz5/TMeo73wRcaGE
	 EGoy4O0e+MmZaDq2r7Qune4N3/jw5z0vYwMmLOAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	"Chang S. Bae" <chang.seok.bae@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Chao Gao <chao.gao@intel.com>
Subject: [PATCH 6.12 018/565] x86/fpu: Ensure XFD state on signal delivery
Date: Tue, 11 Nov 2025 09:37:54 +0900
Message-ID: <20251111004527.279512668@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Chang S. Bae <chang.seok.bae@intel.com>

commit 388eff894d6bc5f921e9bfff0e4b0ab2684a96e9 upstream.

Sean reported [1] the following splat when running KVM tests:

   WARNING: CPU: 232 PID: 15391 at xfd_validate_state+0x65/0x70
   Call Trace:
    <TASK>
    fpu__clear_user_states+0x9c/0x100
    arch_do_signal_or_restart+0x142/0x210
    exit_to_user_mode_loop+0x55/0x100
    do_syscall_64+0x205/0x2c0
    entry_SYSCALL_64_after_hwframe+0x4b/0x53

Chao further identified [2] a reproducible scenario involving signal
delivery: a non-AMX task is preempted by an AMX-enabled task which
modifies the XFD MSR.

When the non-AMX task resumes and reloads XSTATE with init values,
a warning is triggered due to a mismatch between fpstate::xfd and the
CPU's current XFD state. fpu__clear_user_states() does not currently
re-synchronize the XFD state after such preemption.

Invoke xfd_update_state() which detects and corrects the mismatch if
there is a dynamic feature.

This also benefits the sigreturn path, as fpu__restore_sig() may call
fpu__clear_user_states() when the sigframe is inaccessible.

[ dhansen: minor changelog munging ]

Closes: https://lore.kernel.org/lkml/aDCo_SczQOUaB2rS@google.com [1]
Fixes: 672365477ae8a ("x86/fpu: Update XFD state where required")
Reported-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
Tested-by: Chao Gao <chao.gao@intel.com>
Link: https://lore.kernel.org/all/aDWbctO%2FRfTGiCg3@intel.com [2]
Cc:stable@vger.kernel.org
Link: https://patch.msgid.link/20250610001700.4097-1-chang.seok.bae%40intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/fpu/core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -757,6 +757,9 @@ void fpu__clear_user_states(struct fpu *
 	    !fpregs_state_valid(fpu, smp_processor_id()))
 		os_xrstor_supervisor(fpu->fpstate);
 
+	/* Ensure XFD state is in sync before reloading XSTATE */
+	xfd_update_state(fpu->fpstate);
+
 	/* Reset user states in registers. */
 	restore_fpregs_from_init_fpstate(XFEATURE_MASK_USER_RESTORE);
 


