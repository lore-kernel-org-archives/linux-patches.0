Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2620314A81
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f4kIBMdL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94951C433C8;
	Mon, 23 Oct 2023 11:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698058966;
	bh=LQw+RHH/Gnbd2NVlFvIPDwZ8PTYQIMQr1ldgy+KGrn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f4kIBMdLWDLJN6P2PbFT92TcVABgnYkFpLeIMFo2muq1P8/oHw6ncFuJYwHivMFj1
	 ghu039QpU3yZzACXOW87/BnHvlzY+F3A1i/B7EVkkSSZPYjH/NO+9mEAn7PlsuwO2l
	 aLqF/XR/U0la0jag34rz/RwuG76gQnRFDj/QpBk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.5 019/241] x86/fpu: Allow caller to constrain xfeatures when copying to uabi buffer
Date: Mon, 23 Oct 2023 12:53:25 +0200
Message-ID: <20231023104834.396293937@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

commit 18164f66e6c59fda15c198b371fa008431efdb22 upstream.

Plumb an xfeatures mask into __copy_xstate_to_uabi_buf() so that KVM can
constrain which xfeatures are saved into the userspace buffer without
having to modify the user_xfeatures field in KVM's guest_fpu state.

KVM's ABI for KVM_GET_XSAVE{2} is that features that are not exposed to
guest must not show up in the effective xstate_bv field of the buffer.
Saving only the guest-supported xfeatures allows userspace to load the
saved state on a different host with a fewer xfeatures, so long as the
target host supports the xfeatures that are exposed to the guest.

KVM currently sets user_xfeatures directly to restrict KVM_GET_XSAVE{2} to
the set of guest-supported xfeatures, but doing so broke KVM's historical
ABI for KVM_SET_XSAVE, which allows userspace to load any xfeatures that
are supported by the *host*.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20230928001956.924301-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/fpu/api.h |    3 ++-
 arch/x86/kernel/fpu/core.c     |    5 +++--
 arch/x86/kernel/fpu/xstate.c   |    7 +++++--
 arch/x86/kernel/fpu/xstate.h   |    3 ++-
 arch/x86/kvm/x86.c             |   21 +++++++++------------
 5 files changed, 21 insertions(+), 18 deletions(-)

--- a/arch/x86/include/asm/fpu/api.h
+++ b/arch/x86/include/asm/fpu/api.h
@@ -148,7 +148,8 @@ static inline void fpu_update_guest_xfd(
 static inline void fpu_sync_guest_vmexit_xfd_state(void) { }
 #endif
 
-extern void fpu_copy_guest_fpstate_to_uabi(struct fpu_guest *gfpu, void *buf, unsigned int size, u32 pkru);
+extern void fpu_copy_guest_fpstate_to_uabi(struct fpu_guest *gfpu, void *buf,
+					   unsigned int size, u64 xfeatures, u32 pkru);
 extern int fpu_copy_uabi_to_guest_fpstate(struct fpu_guest *gfpu, const void *buf, u64 xcr0, u32 *vpkru);
 
 static inline void fpstate_set_confidential(struct fpu_guest *gfpu)
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -369,14 +369,15 @@ int fpu_swap_kvm_fpstate(struct fpu_gues
 EXPORT_SYMBOL_GPL(fpu_swap_kvm_fpstate);
 
 void fpu_copy_guest_fpstate_to_uabi(struct fpu_guest *gfpu, void *buf,
-				    unsigned int size, u32 pkru)
+				    unsigned int size, u64 xfeatures, u32 pkru)
 {
 	struct fpstate *kstate = gfpu->fpstate;
 	union fpregs_state *ustate = buf;
 	struct membuf mb = { .p = buf, .left = size };
 
 	if (cpu_feature_enabled(X86_FEATURE_XSAVE)) {
-		__copy_xstate_to_uabi_buf(mb, kstate, pkru, XSTATE_COPY_XSAVE);
+		__copy_xstate_to_uabi_buf(mb, kstate, xfeatures, pkru,
+					  XSTATE_COPY_XSAVE);
 	} else {
 		memcpy(&ustate->fxsave, &kstate->regs.fxsave,
 		       sizeof(ustate->fxsave));
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1053,6 +1053,7 @@ static void copy_feature(bool from_xstat
  * __copy_xstate_to_uabi_buf - Copy kernel saved xstate to a UABI buffer
  * @to:		membuf descriptor
  * @fpstate:	The fpstate buffer from which to copy
+ * @xfeatures:	The mask of xfeatures to save (XSAVE mode only)
  * @pkru_val:	The PKRU value to store in the PKRU component
  * @copy_mode:	The requested copy mode
  *
@@ -1063,7 +1064,8 @@ static void copy_feature(bool from_xstat
  * It supports partial copy but @to.pos always starts from zero.
  */
 void __copy_xstate_to_uabi_buf(struct membuf to, struct fpstate *fpstate,
-			       u32 pkru_val, enum xstate_copy_mode copy_mode)
+			       u64 xfeatures, u32 pkru_val,
+			       enum xstate_copy_mode copy_mode)
 {
 	const unsigned int off_mxcsr = offsetof(struct fxregs_state, mxcsr);
 	struct xregs_state *xinit = &init_fpstate.regs.xsave;
@@ -1087,7 +1089,7 @@ void __copy_xstate_to_uabi_buf(struct me
 		break;
 
 	case XSTATE_COPY_XSAVE:
-		header.xfeatures &= fpstate->user_xfeatures;
+		header.xfeatures &= fpstate->user_xfeatures & xfeatures;
 		break;
 	}
 
@@ -1189,6 +1191,7 @@ void copy_xstate_to_uabi_buf(struct memb
 			     enum xstate_copy_mode copy_mode)
 {
 	__copy_xstate_to_uabi_buf(to, tsk->thread.fpu.fpstate,
+				  tsk->thread.fpu.fpstate->user_xfeatures,
 				  tsk->thread.pkru, copy_mode);
 }
 
--- a/arch/x86/kernel/fpu/xstate.h
+++ b/arch/x86/kernel/fpu/xstate.h
@@ -43,7 +43,8 @@ enum xstate_copy_mode {
 
 struct membuf;
 extern void __copy_xstate_to_uabi_buf(struct membuf to, struct fpstate *fpstate,
-				      u32 pkru_val, enum xstate_copy_mode copy_mode);
+				      u64 xfeatures, u32 pkru_val,
+				      enum xstate_copy_mode copy_mode);
 extern void copy_xstate_to_uabi_buf(struct membuf to, struct task_struct *tsk,
 				    enum xstate_copy_mode mode);
 extern int copy_uabi_from_kernel_to_xstate(struct fpstate *fpstate, const void *kbuf, u32 *pkru);
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5385,26 +5385,23 @@ static int kvm_vcpu_ioctl_x86_set_debugr
 	return 0;
 }
 
-static void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
-					 struct kvm_xsave *guest_xsave)
+
+static void kvm_vcpu_ioctl_x86_get_xsave2(struct kvm_vcpu *vcpu,
+					  u8 *state, unsigned int size)
 {
 	if (fpstate_is_confidential(&vcpu->arch.guest_fpu))
 		return;
 
-	fpu_copy_guest_fpstate_to_uabi(&vcpu->arch.guest_fpu,
-				       guest_xsave->region,
-				       sizeof(guest_xsave->region),
+	fpu_copy_guest_fpstate_to_uabi(&vcpu->arch.guest_fpu, state, size,
+				       vcpu->arch.guest_fpu.fpstate->user_xfeatures,
 				       vcpu->arch.pkru);
 }
 
-static void kvm_vcpu_ioctl_x86_get_xsave2(struct kvm_vcpu *vcpu,
-					  u8 *state, unsigned int size)
+static void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
+					 struct kvm_xsave *guest_xsave)
 {
-	if (fpstate_is_confidential(&vcpu->arch.guest_fpu))
-		return;
-
-	fpu_copy_guest_fpstate_to_uabi(&vcpu->arch.guest_fpu,
-				       state, size, vcpu->arch.pkru);
+	return kvm_vcpu_ioctl_x86_get_xsave2(vcpu, (void *)guest_xsave->region,
+					     sizeof(guest_xsave->region));
 }
 
 static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,


