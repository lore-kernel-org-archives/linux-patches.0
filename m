Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C407F79C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40C48C433C1;
	Wed, 30 Nov 2022 18:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833614;
	bh=W+ftBqBs/a6ZeUa2bKihIqqf3Llx8kl71TEzsJg7syM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wxfAa11cuZW1HMpVslYUaFHjvDmNE8hDaV5d+YQaKpH6kJmIWK4xao6S0A3hhN//3
	 MfACg7EOHV6p4F29rT/eh2Yf82KMMsjdE+xo8/H4vLwSLPo9yWpJj2SZCq0HCKmr/U
	 5EbeNhGxg5DAONq+18hy2jO1WaNv9zalJ7GPpArI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 159/206] KVM: x86: add kvm_leave_nested
Date: Wed, 30 Nov 2022 19:23:31 +0100
Message-Id: <20221130180537.079772970@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Maxim Levitsky <mlevitsk@redhat.com>

commit f9697df251438b0798780900e8b43bdb12a56d64 upstream.

add kvm_leave_nested which wraps a call to nested_ops->leave_nested
into a function.

Cc: stable@vger.kernel.org
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20221103141351.50662-4-mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/nested.c |    3 ---
 arch/x86/kvm/vmx/nested.c |    3 ---
 arch/x86/kvm/x86.c        |    8 +++++++-
 3 files changed, 7 insertions(+), 7 deletions(-)

--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -940,9 +940,6 @@ void svm_free_nested(struct vcpu_svm *sv
 	svm->nested.initialized = false;
 }
 
-/*
- * Forcibly leave nested mode in order to be able to reset the VCPU later on.
- */
 void svm_leave_nested(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6276,9 +6276,6 @@ out:
 	return kvm_state.size;
 }
 
-/*
- * Forcibly leave nested mode in order to be able to reset the VCPU later on.
- */
 void vmx_leave_nested(struct kvm_vcpu *vcpu)
 {
 	if (is_guest_mode(vcpu)) {
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -608,6 +608,12 @@ void kvm_deliver_exception_payload(struc
 }
 EXPORT_SYMBOL_GPL(kvm_deliver_exception_payload);
 
+/* Forcibly leave the nested mode in cases like a vCPU reset */
+static void kvm_leave_nested(struct kvm_vcpu *vcpu)
+{
+	kvm_x86_ops.nested_ops->leave_nested(vcpu);
+}
+
 static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
 		unsigned nr, bool has_error, u32 error_code,
 	        bool has_payload, unsigned long payload, bool reinject)
@@ -4775,7 +4781,7 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_e
 
 	if (events->flags & KVM_VCPUEVENT_VALID_SMM) {
 		if (!!(vcpu->arch.hflags & HF_SMM_MASK) != events->smi.smm) {
-			kvm_x86_ops.nested_ops->leave_nested(vcpu);
+			kvm_leave_nested(vcpu);
 			kvm_smm_changed(vcpu, events->smi.smm);
 		}
 


