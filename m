Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7331926982A;
	Tue,  8 Apr 2025 11:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112085; cv=none; b=gQD3NoP2g1fM5dGeuVJnz5yw7ikmdSlIuJc7i4avDG40P5tKL3qpbwog1ncXznApIRrTjv3qVRtWna0n93BRqnRw5WhdnfYga1CSz3pH3mql2O19l08LBT8TOj99Ns0X4oyLm++gNRfu4R71FIUEXzabAMOaP52TwgQ3Ombzuf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112085; c=relaxed/simple;
	bh=y0qEaZIsmadFfVJayRUl6zzPVf0k/YUoG7020iMCH/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fJXrZ+RkeQdIwNEZm/9FfpU9SadHR+5KCzd6HslQgXtBYchKofsZWqmxSXEpH37izCKSS+gblWTRmQevYFHsgZVMpZ8y0yAfABD/C727uR0r9pOTSTvPnCDN+DhHukPiTODPC/QwCR5vacBE8EXKrgl9ae9IEQM6MxVYlqE9nds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e9k3hwtb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e9k3hwtb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02B51C4CEEF;
	Tue,  8 Apr 2025 11:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112085;
	bh=y0qEaZIsmadFfVJayRUl6zzPVf0k/YUoG7020iMCH/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e9k3hwtbE9HCPuvXuN+XPO5P6fRaxDq3vkOKsan7SyG5CuTXo4QDVgA4Xuo31sKAM
	 wf3XaBJDR198HG2Q+Uk2nXoYGm4/iaVUXWsxQkgCPIeHpmSHO2OGiBaJ7/G/+x+Poy
	 fZrCxZuV//Qr0GDOurc3mqaDXq8MMAhIzvOdEmJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>
Subject: [PATCH 6.14 669/731] KVM: x86: block KVM_CAP_SYNC_REGS if guest state is protected
Date: Tue,  8 Apr 2025 12:49:26 +0200
Message-ID: <20250408104929.827098218@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Bonzini <pbonzini@redhat.com>

commit 74c1807f6c4feddb3c3cb1056c54531d4adbaea6 upstream.

KVM_CAP_SYNC_REGS does not make sense for VMs with protected guest state,
since the register values cannot actually be written.  Return 0
when using the VM-level KVM_CHECK_EXTENSION ioctl, and accordingly
return -EINVAL from KVM_RUN if the valid/dirty fields are nonzero.

However, on exit from KVM_RUN userspace could have placed a nonzero
value into kvm_run->kvm_valid_regs, so check guest_state_protected
again and skip store_regs() in that case.

Cc: stable@vger.kernel.org
Fixes: 517987e3fb19 ("KVM: x86: add fields to struct kvm_arch for CoCo features")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <20250306202923.646075-1-pbonzini@redhat.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4573,6 +4573,11 @@ static bool kvm_is_vm_type_supported(uns
 	return type < 32 && (kvm_caps.supported_vm_types & BIT(type));
 }
 
+static inline u32 kvm_sync_valid_fields(struct kvm *kvm)
+{
+	return kvm && kvm->arch.has_protected_state ? 0 : KVM_SYNC_X86_VALID_FIELDS;
+}
+
 int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 {
 	int r = 0;
@@ -4681,7 +4686,7 @@ int kvm_vm_ioctl_check_extension(struct
 		break;
 #endif
 	case KVM_CAP_SYNC_REGS:
-		r = KVM_SYNC_X86_VALID_FIELDS;
+		r = kvm_sync_valid_fields(kvm);
 		break;
 	case KVM_CAP_ADJUST_CLOCK:
 		r = KVM_CLOCK_VALID_FLAGS;
@@ -11474,6 +11479,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_v
 {
 	struct kvm_queued_exception *ex = &vcpu->arch.exception;
 	struct kvm_run *kvm_run = vcpu->run;
+	u32 sync_valid_fields;
 	int r;
 
 	r = kvm_mmu_post_init_vm(vcpu->kvm);
@@ -11519,8 +11525,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_v
 		goto out;
 	}
 
-	if ((kvm_run->kvm_valid_regs & ~KVM_SYNC_X86_VALID_FIELDS) ||
-	    (kvm_run->kvm_dirty_regs & ~KVM_SYNC_X86_VALID_FIELDS)) {
+	sync_valid_fields = kvm_sync_valid_fields(vcpu->kvm);
+	if ((kvm_run->kvm_valid_regs & ~sync_valid_fields) ||
+	    (kvm_run->kvm_dirty_regs & ~sync_valid_fields)) {
 		r = -EINVAL;
 		goto out;
 	}
@@ -11578,7 +11585,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_v
 
 out:
 	kvm_put_guest_fpu(vcpu);
-	if (kvm_run->kvm_valid_regs)
+	if (kvm_run->kvm_valid_regs && likely(!vcpu->arch.guest_state_protected))
 		store_regs(vcpu);
 	post_kvm_run_save(vcpu);
 	kvm_vcpu_srcu_read_unlock(vcpu);


