Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 375B73382C7;
	Mon, 20 Apr 2026 15:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776699932; cv=none; b=gB4EqYF5x3Cf1+KFqp1owOzZww3/0ZAugfAPHOYvrz0GRIG/MD6/0Gc6Rfr1STxzeyRarqEaKNE9poBTrGIu28wJjcNB/mwrGBKySHd6F1pObN8oXMpJ9grzYnD2Rd6GRc+z5jRI79Ndq7WiXQuWablfrbRW2LbRwKOBpxscTmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776699932; c=relaxed/simple;
	bh=fSNeL+ioRXW45SQ6o6+vHPkyfr5V0Q/bOuvXHg5osRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uru3pRkjWZ+zJQqYmvFMufgmtLLWtiqA3459rkop530Wny4dSOr4sfrcfBJlIUrm+mGBfbidp8chWbXcWX8++BilT9n3aSIIGym++ntegMHd1uGEzfrr3AmePFjxdfyH6lRCAEcPVZm8U2m8seo34By+fnZBQXyA2riFFgvrW7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ft1EWry4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ft1EWry4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C57C19425;
	Mon, 20 Apr 2026 15:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776699932;
	bh=fSNeL+ioRXW45SQ6o6+vHPkyfr5V0Q/bOuvXHg5osRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ft1EWry4/h350y9WHLaT1j+AuDXW/za+v5C8iwRyJpYOs6rnKhDlg77rfLhms0j3P
	 BlN50npi8cphKFM3gXsLsCye+3/RM1DZHSNKd02ygIp5+GC8fx16G/dQFGql6wuMe8
	 az6RACIrkyIcPl18DWO6FTvU1ujHp4GLC4p4+l/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jethro Beekman <jethro@fortanix.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 7.0 53/76] KVM: SEV: Disallow LAUNCH_FINISH if vCPUs are actively being created
Date: Mon, 20 Apr 2026 17:42:04 +0200
Message-ID: <20260420153912.753071910@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153910.810034134@linuxfoundation.org>
References: <20260420153910.810034134@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 624bf3440d7214b62c22d698a0a294323f331d5d upstream.

Reject LAUNCH_FINISH for SEV-ES and SNP VMs if KVM is actively creating
one or more vCPUs, as KVM needs to process and encrypt each vCPU's VMSA.
Letting userspace create vCPUs while LAUNCH_FINISH is in-progress is
"fine", at least in the current code base, as kvm_for_each_vcpu() operates
on online_vcpus, LAUNCH_FINISH (all SEV+ sub-ioctls) holds kvm->mutex, and
fully onlining a vCPU in kvm_vm_ioctl_create_vcpu() is done under
kvm->mutex.  I.e. there's no difference between an in-progress vCPU and a
vCPU that is created entirely after LAUNCH_FINISH.

However, given that concurrent LAUNCH_FINISH and vCPU creation can't
possibly work (for any reasonable definition of "work"), since userspace
can't guarantee whether a particular vCPU will be encrypted or not,
disallow the combination as a hardening measure, to reduce the probability
of introducing bugs in the future, and to avoid having to reason about the
safety of future changes related to LAUNCH_FINISH.

Cc: Jethro Beekman <jethro@fortanix.com>
Closes: https://lore.kernel.org/all/b31f7c6e-2807-4662-bcdd-eea2c1e132fa@fortanix.com
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260310234829.2608037-5-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c   |   10 ++++++++--
 include/linux/kvm_host.h |    7 +++++++
 2 files changed, 15 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1030,6 +1030,9 @@ static int sev_launch_update_vmsa(struct
 	if (!sev_es_guest(kvm))
 		return -ENOTTY;
 
+	if (kvm_is_vcpu_creation_in_progress(kvm))
+		return -EBUSY;
+
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		ret = mutex_lock_killable(&vcpu->mutex);
 		if (ret)
@@ -2050,8 +2053,8 @@ static int sev_check_source_vcpus(struct
 	struct kvm_vcpu *src_vcpu;
 	unsigned long i;
 
-	if (src->created_vcpus != atomic_read(&src->online_vcpus) ||
-	    dst->created_vcpus != atomic_read(&dst->online_vcpus))
+	if (kvm_is_vcpu_creation_in_progress(src) ||
+	    kvm_is_vcpu_creation_in_progress(dst))
 		return -EBUSY;
 
 	if (!sev_es_guest(src))
@@ -2450,6 +2453,9 @@ static int snp_launch_update_vmsa(struct
 	unsigned long i;
 	int ret;
 
+	if (kvm_is_vcpu_creation_in_progress(kvm))
+		return -EBUSY;
+
 	data.gctx_paddr = __psp_pa(sev->snp_context);
 	data.page_type = SNP_PAGE_TYPE_VMSA;
 
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1029,6 +1029,13 @@ static inline struct kvm_vcpu *kvm_get_v
 	return NULL;
 }
 
+static inline bool kvm_is_vcpu_creation_in_progress(struct kvm *kvm)
+{
+	lockdep_assert_held(&kvm->lock);
+
+	return kvm->created_vcpus != atomic_read(&kvm->online_vcpus);
+}
+
 void kvm_destroy_vcpus(struct kvm *kvm);
 
 int kvm_trylock_all_vcpus(struct kvm *kvm);


