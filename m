Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE9C37997D;
	Mon,  9 Feb 2026 14:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647153; cv=none; b=qmOj/0kOm2M5VGynooFeebAPj1iasWyllNssOABZ19ZsXrM9xIkfXAUGlLf7ILfBAdb+KxDmMzaNlxRITCvQkAuGCjycb8BTOJPF284jG47HkAl+4D19c8MSr166yCxdgqillwVbmjJ/F+lrQjKawo3MNa7sqlnI5AzAMhgY1OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647153; c=relaxed/simple;
	bh=IbIZSnEHYZaC3lSKyHeQ1TvRyrllE1WL6NeNkOLkvxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mfJXM24deezA7V8AEMjIrcjXp4ADBq/5FRaOMggn4mLRPo1R8B6dRFwR5OB/CaGlvuyrJjj9A91johz8JASpHXv1Vn1573D71aY9AITvYou+jHaRfdSyu5vD27GQWwFrkhL+SZjQp7ekA8j/oY7El0WmH4KQ6b1jYYw+N0XD4kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=McdVbVZe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="McdVbVZe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58FD9C16AAE;
	Mon,  9 Feb 2026 14:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647152;
	bh=IbIZSnEHYZaC3lSKyHeQ1TvRyrllE1WL6NeNkOLkvxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=McdVbVZehokxqMLwCWSY6gjpCb2CT/jFhsxM6k3VOzgmuziGjFYqlgZ1iCe1b3EIB
	 rnsIjR757glhF3BGwR+3oR6qc+YGBgdL+q5j64Pfcyrdd9jXcZYFQr97ZB4Ob6a/Rj
	 2M2K0TzWzyIGVIQoVQopMLjZoAATASuXnVOLimR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Krause <minipli@grsecurity.net>,
	John Allen <john.allen@amd.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Chao Gao <chao.gao@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 004/175] KVM: x86: Explicitly configure supported XSS from {svm,vmx}_set_cpu_caps()
Date: Mon,  9 Feb 2026 15:21:17 +0100
Message-ID: <20260209142320.637037877@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit f8ade833b733ae0b72e87ac6d2202a1afbe3eb4a upstream.

Explicitly configure KVM's supported XSS as part of each vendor's setup
flow to fix a bug where clearing SHSTK and IBT in kvm_cpu_caps, e.g. due
to lack of CET XFEATURE support, makes kvm-intel.ko unloadable when nested
VMX is enabled, i.e. when nested=1.  The late clearing results in
nested_vmx_setup_{entry,exit}_ctls() clearing VM_{ENTRY,EXIT}_LOAD_CET_STATE
when nested_vmx_setup_ctls_msrs() runs during the CPU compatibility checks,
ultimately leading to a mismatched VMCS config due to the reference config
having the CET bits set, but every CPU's "local" config having the bits
cleared.

Note, kvm_caps.supported_{xcr0,xss} are unconditionally initialized by
kvm_x86_vendor_init(), before calling into vendor code, and not referenced
between ops->hardware_setup() and their current/old location.

Fixes: 69cc3e886582 ("KVM: x86: Add XSS support for CET_KERNEL and CET_USER")
Cc: stable@vger.kernel.org
Cc: Mathias Krause <minipli@grsecurity.net>
Cc: John Allen <john.allen@amd.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Chao Gao <chao.gao@intel.com>
Cc: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Link: https://patch.msgid.link/20260128014310.3255561-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.c |    2 ++
 arch/x86/kvm/vmx/vmx.c |    2 ++
 arch/x86/kvm/x86.c     |   30 +++++++++++++++++-------------
 arch/x86/kvm/x86.h     |    2 ++
 4 files changed, 23 insertions(+), 13 deletions(-)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5285,6 +5285,8 @@ static __init void svm_set_cpu_caps(void
 	 */
 	kvm_cpu_cap_clear(X86_FEATURE_BUS_LOCK_DETECT);
 	kvm_cpu_cap_clear(X86_FEATURE_MSR_IMM);
+
+	kvm_setup_xss_caps();
 }
 
 static __init int svm_hardware_setup(void)
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8021,6 +8021,8 @@ static __init void vmx_set_cpu_caps(void
 		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
 		kvm_cpu_cap_clear(X86_FEATURE_IBT);
 	}
+
+	kvm_setup_xss_caps();
 }
 
 static bool vmx_is_io_intercepted(struct kvm_vcpu *vcpu,
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9954,6 +9954,23 @@ static struct notifier_block pvclock_gto
 };
 #endif
 
+void kvm_setup_xss_caps(void)
+{
+	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
+		kvm_caps.supported_xss = 0;
+
+	if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
+	    !kvm_cpu_cap_has(X86_FEATURE_IBT))
+		kvm_caps.supported_xss &= ~XFEATURE_MASK_CET_ALL;
+
+	if ((kvm_caps.supported_xss & XFEATURE_MASK_CET_ALL) != XFEATURE_MASK_CET_ALL) {
+		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
+		kvm_cpu_cap_clear(X86_FEATURE_IBT);
+		kvm_caps.supported_xss &= ~XFEATURE_MASK_CET_ALL;
+	}
+}
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_setup_xss_caps);
+
 static inline void kvm_ops_update(struct kvm_x86_init_ops *ops)
 {
 	memcpy(&kvm_x86_ops, ops->runtime_ops, sizeof(kvm_x86_ops));
@@ -10132,19 +10149,6 @@ int kvm_x86_vendor_init(struct kvm_x86_i
 	if (!tdp_enabled)
 		kvm_caps.supported_quirks &= ~KVM_X86_QUIRK_IGNORE_GUEST_PAT;
 
-	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
-		kvm_caps.supported_xss = 0;
-
-	if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
-	    !kvm_cpu_cap_has(X86_FEATURE_IBT))
-		kvm_caps.supported_xss &= ~XFEATURE_MASK_CET_ALL;
-
-	if ((kvm_caps.supported_xss & XFEATURE_MASK_CET_ALL) != XFEATURE_MASK_CET_ALL) {
-		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
-		kvm_cpu_cap_clear(X86_FEATURE_IBT);
-		kvm_caps.supported_xss &= ~XFEATURE_MASK_CET_ALL;
-	}
-
 	if (kvm_caps.has_tsc_control) {
 		/*
 		 * Make sure the user can only configure tsc_khz values that
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -457,6 +457,8 @@ extern struct kvm_host_values kvm_host;
 
 extern bool enable_pmu;
 
+void kvm_setup_xss_caps(void);
+
 /*
  * Get a filtered version of KVM's supported XCR0 that strips out dynamic
  * features for which the current process doesn't (yet) have permission to use.


