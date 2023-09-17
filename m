Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E33363DE
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:55:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3D40C433C7;
	Sun, 17 Sep 2023 19:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980549;
	bh=QYARrcBXEoggJSNwN8JNKMgKEJSuHc2LumamX8uRB4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IunP0vZL0WLz47TSFHNv4O6+X2vnXmho5rucvbgbVOri8KdMWt84OSwo2aHrU2k7A
	 X9ggpaK1ffq5eJSMv5vqCeMieJPjtj5OGiT/ZxZ6nBkaJ2hfFE6O0ruFf7VYmoh5rw
	 QM4+f5SyZ3I49Lm3L4sGqvezyMhQF/HslYyyMF70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wu Zongyo <wuzongyo@mail.ustc.edu.cn>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.5 224/285] KVM: SVM: Dont inject #UD if KVM attempts to skip SEV guest insn
Date: Sun, 17 Sep 2023 21:13:44 +0200
Message-ID: <20230917191059.238532047@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit cb49631ad111570f1bad37702c11c2ae07fa2e3c upstream.

Don't inject a #UD if KVM attempts to "emulate" to skip an instruction
for an SEV guest, and instead resume the guest and hope that it can make
forward progress.  When commit 04c40f344def ("KVM: SVM: Inject #UD on
attempted emulation for SEV guest w/o insn buffer") added the completely
arbitrary #UD behavior, there were no known scenarios where a well-behaved
guest would induce a VM-Exit that triggered emulation, i.e. it was thought
that injecting #UD would be helpful.

However, now that KVM (correctly) attempts to re-inject INT3/INTO, e.g. if
a #NPF is encountered when attempting to deliver the INT3/INTO, an SEV
guest can trigger emulation without a buffer, through no fault of its own.
Resuming the guest and retrying the INT3/INTO is architecturally wrong,
e.g. the vCPU will incorrectly re-hit code #DBs, but for SEV guests there
is literally no other option that has a chance of making forward progress.

Drop the #UD injection for all "skip" emulation, not just those related to
INT3/INTO, even though that means that the guest will likely end up in an
infinite loop instead of getting a #UD (the vCPU may also crash, e.g. if
KVM emulated everything about an instruction except for advancing RIP).
There's no evidence that suggests that an unexpected #UD is actually
better than hanging the vCPU, e.g. a soft-hung vCPU can still respond to
IRQs and NMIs to generate a backtrace.

Reported-by: Wu Zongyo <wuzongyo@mail.ustc.edu.cn>
Closes: https://lore.kernel.org/all/8eb933fd-2cf3-d7a9-32fe-2a1d82eac42a@mail.ustc.edu.cn
Fixes: 6ef88d6e36c2 ("KVM: SVM: Re-inject INT3/INTO instead of retrying the instruction")
Cc: stable@vger.kernel.org
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Link: https://lore.kernel.org/r/20230825013621.2845700-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.c |   35 +++++++++++++++++++++++++++--------
 1 file changed, 27 insertions(+), 8 deletions(-)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -365,6 +365,8 @@ static void svm_set_interrupt_shadow(str
 		svm->vmcb->control.int_state |= SVM_INTERRUPT_SHADOW_MASK;
 
 }
+static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
+					void *insn, int insn_len);
 
 static int __svm_skip_emulated_instruction(struct kvm_vcpu *vcpu,
 					   bool commit_side_effects)
@@ -385,6 +387,14 @@ static int __svm_skip_emulated_instructi
 	}
 
 	if (!svm->next_rip) {
+		/*
+		 * FIXME: Drop this when kvm_emulate_instruction() does the
+		 * right thing and treats "can't emulate" as outright failure
+		 * for EMULTYPE_SKIP.
+		 */
+		if (!svm_can_emulate_instruction(vcpu, EMULTYPE_SKIP, NULL, 0))
+			return 0;
+
 		if (unlikely(!commit_side_effects))
 			old_rflags = svm->vmcb->save.rflags;
 
@@ -4651,16 +4661,25 @@ static bool svm_can_emulate_instruction(
 	 * and cannot be decrypted by KVM, i.e. KVM would read cyphertext and
 	 * decode garbage.
 	 *
-	 * Inject #UD if KVM reached this point without an instruction buffer.
-	 * In practice, this path should never be hit by a well-behaved guest,
-	 * e.g. KVM doesn't intercept #UD or #GP for SEV guests, but this path
-	 * is still theoretically reachable, e.g. via unaccelerated fault-like
-	 * AVIC access, and needs to be handled by KVM to avoid putting the
-	 * guest into an infinite loop.   Injecting #UD is somewhat arbitrary,
-	 * but its the least awful option given lack of insight into the guest.
+	 * If KVM is NOT trying to simply skip an instruction, inject #UD if
+	 * KVM reached this point without an instruction buffer.  In practice,
+	 * this path should never be hit by a well-behaved guest, e.g. KVM
+	 * doesn't intercept #UD or #GP for SEV guests, but this path is still
+	 * theoretically reachable, e.g. via unaccelerated fault-like AVIC
+	 * access, and needs to be handled by KVM to avoid putting the guest
+	 * into an infinite loop.   Injecting #UD is somewhat arbitrary, but
+	 * its the least awful option given lack of insight into the guest.
+	 *
+	 * If KVM is trying to skip an instruction, simply resume the guest.
+	 * If a #NPF occurs while the guest is vectoring an INT3/INTO, then KVM
+	 * will attempt to re-inject the INT3/INTO and skip the instruction.
+	 * In that scenario, retrying the INT3/INTO and hoping the guest will
+	 * make forward progress is the only option that has a chance of
+	 * success (and in practice it will work the vast majority of the time).
 	 */
 	if (unlikely(!insn)) {
-		kvm_queue_exception(vcpu, UD_VECTOR);
+		if (!(emul_type & EMULTYPE_SKIP))
+			kvm_queue_exception(vcpu, UD_VECTOR);
 		return false;
 	}
 


