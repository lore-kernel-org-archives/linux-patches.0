Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C17A9443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:24:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7802C433C8;
	Sun, 13 Aug 2023 21:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691961876;
	bh=MkQSLpQVNE6iWMekQ1nfF/AdrYERUA4pTS2fUZnnfw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xjlMwneBKRwIQfTWBJbZ+QPj7L2iR4E7CqhgjYIDVg9HxQydHjUQKN3ai0tBCDCkG
	 gxDz5sj1Da6c2didcUem+0QmBENVoNMvjRG+AyoYy9fblb+OIwICJNyI9M0jlLXwoc
	 atGGHPFAHgIbSJDxu1pZhzMmmAu1a4F0zwoIOks0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Nguyen <theflow@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.4 008/206] KVM: SEV: only access GHCB fields once
Date: Sun, 13 Aug 2023 23:16:18 +0200
Message-ID: <20230813211725.214125078@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
References: <20230813211724.969019629@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paolo Bonzini <pbonzini@redhat.com>

commit 7588dbcebcbf0193ab5b76987396d0254270b04a upstream.

A KVM guest using SEV-ES or SEV-SNP with multiple vCPUs can trigger
a double fetch race condition vulnerability and invoke the VMGEXIT
handler recursively.

sev_handle_vmgexit() maps the GHCB page using kvm_vcpu_map() and then
fetches the exit code using ghcb_get_sw_exit_code().  Soon after,
sev_es_validate_vmgexit() fetches the exit code again. Since the GHCB
page is shared with the guest, the guest is able to quickly swap the
values with another vCPU and hence bypass the validation. One vmexit code
that can be rejected by sev_es_validate_vmgexit() is SVM_EXIT_VMGEXIT;
if sev_handle_vmgexit() observes it in the second fetch, the call
to svm_invoke_exit_handler() will invoke sev_handle_vmgexit() again
recursively.

To avoid the race, always fetch the GHCB data from the places where
sev_es_sync_from_ghcb stores it.

Exploiting recursions on linux kernel has been proven feasible
in the past, but the impact is mitigated by stack guard pages
(CONFIG_VMAP_STACK).  Still, if an attacker manages to call the handler
multiple times, they can theoretically trigger a stack overflow and
cause a denial-of-service, or potentially guest-to-host escape in kernel
configurations without stack guard pages.

Note that winning the race reliably in every iteration is very tricky
due to the very tight window of the fetches; depending on the compiler
settings, they are often consecutive because of optimization and inlining.

Tested by booting an SEV-ES RHEL9 guest.

Fixes: CVE-2023-4155
Fixes: 291bd20d5d88 ("KVM: SVM: Add initial support for a VMGEXIT VMEXIT")
Cc: stable@vger.kernel.org
Reported-by: Andy Nguyen <theflow@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2442,9 +2442,15 @@ static void sev_es_sync_from_ghcb(struct
 	memset(ghcb->save.valid_bitmap, 0, sizeof(ghcb->save.valid_bitmap));
 }
 
+static u64 kvm_ghcb_get_sw_exit_code(struct vmcb_control_area *control)
+{
+	return (((u64)control->exit_code_hi) << 32) | control->exit_code;
+}
+
 static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 {
-	struct kvm_vcpu *vcpu;
+	struct vmcb_control_area *control = &svm->vmcb->control;
+	struct kvm_vcpu *vcpu = &svm->vcpu;
 	struct ghcb *ghcb;
 	u64 exit_code;
 	u64 reason;
@@ -2455,7 +2461,7 @@ static int sev_es_validate_vmgexit(struc
 	 * Retrieve the exit code now even though it may not be marked valid
 	 * as it could help with debugging.
 	 */
-	exit_code = ghcb_get_sw_exit_code(ghcb);
+	exit_code = kvm_ghcb_get_sw_exit_code(control);
 
 	/* Only GHCB Usage code 0 is supported */
 	if (ghcb->ghcb_usage) {
@@ -2470,7 +2476,7 @@ static int sev_es_validate_vmgexit(struc
 	    !kvm_ghcb_sw_exit_info_2_is_valid(svm))
 		goto vmgexit_err;
 
-	switch (ghcb_get_sw_exit_code(ghcb)) {
+	switch (exit_code) {
 	case SVM_EXIT_READ_DR7:
 		break;
 	case SVM_EXIT_WRITE_DR7:
@@ -2487,18 +2493,18 @@ static int sev_es_validate_vmgexit(struc
 		if (!kvm_ghcb_rax_is_valid(svm) ||
 		    !kvm_ghcb_rcx_is_valid(svm))
 			goto vmgexit_err;
-		if (ghcb_get_rax(ghcb) == 0xd)
+		if (vcpu->arch.regs[VCPU_REGS_RAX] == 0xd)
 			if (!kvm_ghcb_xcr0_is_valid(svm))
 				goto vmgexit_err;
 		break;
 	case SVM_EXIT_INVD:
 		break;
 	case SVM_EXIT_IOIO:
-		if (ghcb_get_sw_exit_info_1(ghcb) & SVM_IOIO_STR_MASK) {
+		if (control->exit_info_1 & SVM_IOIO_STR_MASK) {
 			if (!kvm_ghcb_sw_scratch_is_valid(svm))
 				goto vmgexit_err;
 		} else {
-			if (!(ghcb_get_sw_exit_info_1(ghcb) & SVM_IOIO_TYPE_MASK))
+			if (!(control->exit_info_1 & SVM_IOIO_TYPE_MASK))
 				if (!kvm_ghcb_rax_is_valid(svm))
 					goto vmgexit_err;
 		}
@@ -2506,7 +2512,7 @@ static int sev_es_validate_vmgexit(struc
 	case SVM_EXIT_MSR:
 		if (!kvm_ghcb_rcx_is_valid(svm))
 			goto vmgexit_err;
-		if (ghcb_get_sw_exit_info_1(ghcb)) {
+		if (control->exit_info_1) {
 			if (!kvm_ghcb_rax_is_valid(svm) ||
 			    !kvm_ghcb_rdx_is_valid(svm))
 				goto vmgexit_err;
@@ -2550,8 +2556,6 @@ static int sev_es_validate_vmgexit(struc
 	return 0;
 
 vmgexit_err:
-	vcpu = &svm->vcpu;
-
 	if (reason == GHCB_ERR_INVALID_USAGE) {
 		vcpu_unimpl(vcpu, "vmgexit: ghcb usage %#x is not valid\n",
 			    ghcb->ghcb_usage);
@@ -2849,8 +2853,6 @@ int sev_handle_vmgexit(struct kvm_vcpu *
 
 	trace_kvm_vmgexit_enter(vcpu->vcpu_id, ghcb);
 
-	exit_code = ghcb_get_sw_exit_code(ghcb);
-
 	sev_es_sync_from_ghcb(svm);
 	ret = sev_es_validate_vmgexit(svm);
 	if (ret)
@@ -2859,6 +2861,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *
 	ghcb_set_sw_exit_info_1(ghcb, 0);
 	ghcb_set_sw_exit_info_2(ghcb, 0);
 
+	exit_code = kvm_ghcb_get_sw_exit_code(control);
 	switch (exit_code) {
 	case SVM_VMGEXIT_MMIO_READ:
 		ret = setup_vmgexit_scratch(svm, true, control->exit_info_2);


