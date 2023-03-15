Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9194431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:31:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDC51C4339B;
	Wed, 15 Mar 2023 12:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678883460;
	bh=UFax8ChcHz89KEeLFaoHTzZWrkyBpqimqMVr5v6hN3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YXt6FPF6Q09wD/ULFWJtxuCx1vUZ7pL31Ti0Ip8ht2uex6IeNGGz+J52kwjw/d4V4
	 uV6J2bCUH5BXVwho/toGOxCel+olpoxoCaDUpegw0PyGf/vq9agPrj6PMtYhcjHxrh
	 S00hN+MLUJt/DodKBHiY2y/W5Nk95vzKqXxD1LUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Alexandru Matei <alexandru.matei@uipath.com>
Subject: [PATCH 5.15 145/145] KVM: VMX: Fix crash due to uninitialized current_vmcs
Date: Wed, 15 Mar 2023 13:13:31 +0100
Message-Id: <20230315115743.681328887@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexandru Matei <alexandru.matei@uipath.com>

commit 93827a0a36396f2fd6368a54a020f420c8916e9b upstream.

KVM enables 'Enlightened VMCS' and 'Enlightened MSR Bitmap' when running as
a nested hypervisor on top of Hyper-V. When MSR bitmap is updated,
evmcs_touch_msr_bitmap function uses current_vmcs per-cpu variable to mark
that the msr bitmap was changed.

vmx_vcpu_create() modifies the msr bitmap via vmx_disable_intercept_for_msr
-> vmx_msr_bitmap_l01_changed which in the end calls this function. The
function checks for current_vmcs if it is null but the check is
insufficient because current_vmcs is not initialized. Because of this, the
code might incorrectly write to the structure pointed by current_vmcs value
left by another task. Preemption is not disabled, the current task can be
preempted and moved to another CPU while current_vmcs is accessed multiple
times from evmcs_touch_msr_bitmap() which leads to crash.

The manipulation of MSR bitmaps by callers happens only for vmcs01 so the
solution is to use vmx->vmcs01.vmcs instead of current_vmcs.

  BUG: kernel NULL pointer dereference, address: 0000000000000338
  PGD 4e1775067 P4D 0
  Oops: 0002 [#1] PREEMPT SMP NOPTI
  ...
  RIP: 0010:vmx_msr_bitmap_l01_changed+0x39/0x50 [kvm_intel]
  ...
  Call Trace:
   vmx_disable_intercept_for_msr+0x36/0x260 [kvm_intel]
   vmx_vcpu_create+0xe6/0x540 [kvm_intel]
   kvm_arch_vcpu_create+0x1d1/0x2e0 [kvm]
   kvm_vm_ioctl_create_vcpu+0x178/0x430 [kvm]
   kvm_vm_ioctl+0x53f/0x790 [kvm]
   __x64_sys_ioctl+0x8a/0xc0
   do_syscall_64+0x5c/0x90
   entry_SYSCALL_64_after_hwframe+0x63/0xcd

Fixes: ceef7d10dfb6 ("KVM: x86: VMX: hyper-v: Enlightened MSR-Bitmap support")
Cc: stable@vger.kernel.org
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Alexandru Matei <alexandru.matei@uipath.com>
Link: https://lore.kernel.org/r/20230123221208.4964-1-alexandru.matei@uipath.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
[manual backport: evmcs.h got renamed to hyperv.h in a later
version, modified in evmcs.h instead]
Signed-off-by: Alexandru Matei <alexandru.matei@uipath.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/evmcs.h |   11 -----------
 arch/x86/kvm/vmx/vmx.c   |    9 +++++++--
 2 files changed, 7 insertions(+), 13 deletions(-)

--- a/arch/x86/kvm/vmx/evmcs.h
+++ b/arch/x86/kvm/vmx/evmcs.h
@@ -162,16 +162,6 @@ static inline u16 evmcs_read16(unsigned
 	return *(u16 *)((char *)current_evmcs + offset);
 }
 
-static inline void evmcs_touch_msr_bitmap(void)
-{
-	if (unlikely(!current_evmcs))
-		return;
-
-	if (current_evmcs->hv_enlightenments_control.msr_bitmap)
-		current_evmcs->hv_clean_fields &=
-			~HV_VMX_ENLIGHTENED_CLEAN_FIELD_MSR_BITMAP;
-}
-
 static inline void evmcs_load(u64 phys_addr)
 {
 	struct hv_vp_assist_page *vp_ap =
@@ -192,7 +182,6 @@ static inline u64 evmcs_read64(unsigned
 static inline u32 evmcs_read32(unsigned long field) { return 0; }
 static inline u16 evmcs_read16(unsigned long field) { return 0; }
 static inline void evmcs_load(u64 phys_addr) {}
-static inline void evmcs_touch_msr_bitmap(void) {}
 #endif /* IS_ENABLED(CONFIG_HYPERV) */
 
 #define EVMPTR_INVALID (-1ULL)
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3779,8 +3779,13 @@ static void vmx_msr_bitmap_l01_changed(s
 	 * 'Enlightened MSR Bitmap' feature L0 needs to know that MSR
 	 * bitmap has changed.
 	 */
-	if (static_branch_unlikely(&enable_evmcs))
-		evmcs_touch_msr_bitmap();
+	if (IS_ENABLED(CONFIG_HYPERV) && static_branch_unlikely(&enable_evmcs)) {
+		struct hv_enlightened_vmcs *evmcs = (void *)vmx->vmcs01.vmcs;
+
+		if (evmcs->hv_enlightenments_control.msr_bitmap)
+			evmcs->hv_clean_fields &=
+				~HV_VMX_ENLIGHTENED_CLEAN_FIELD_MSR_BITMAP;
+	}
 }
 
 void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)


