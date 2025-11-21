Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5B5026CE33;
	Fri, 21 Nov 2025 13:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731547; cv=none; b=NBGQxIRIVN90m24FocStwnn8ovVow7VHgK6uPkTiQ5cT0eZXjLdip7fKJ6YPfs+0xxxub7omiOI0SWwz1khvHM/EFjmS4ZaTQwr/mVqz7qzgMv58v2h7cl8RTxk4B8nFl3fka40vaeO8qp9L2eLG/Ssw54yQoxG2xI7skiM5ymk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731547; c=relaxed/simple;
	bh=riBUUv50CNB3VKebqEbQ5S7zEb+twqNwbdqIsFHtus4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=My1PgsYjEcxN1woHIcY/sekSuq9gWdTnvo8+3fi53FlZ3+QkAuvGUEz0PMm1farT0WGjfqP2t6s/MvpAEfyy2LzVYN8K7Pm+wvc6VRitKWebTg3cgVaseEpnThxPG9TzQCmOjJ3gffUIx/FxbBgXjC9yeuPXhi3W6VDGEgCYbVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IvbXeWkI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IvbXeWkI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E90E7C4CEF1;
	Fri, 21 Nov 2025 13:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731546;
	bh=riBUUv50CNB3VKebqEbQ5S7zEb+twqNwbdqIsFHtus4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IvbXeWkI1DeoaWSXhVCISbka8nCTmK/gQLHijOOi3v1nMDk+3Y3RlmtGoXxOkwrpD
	 gH6GxKEj3d9seLIb1KQOuBDHJ9Bl8BOpj1oHJT2ZICjCzb5YF8MBbeOLicYv8U9C/r
	 CEYZZztrX62VEBE56D0LsI3dG8suP+Lf2YoMnInI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai Huang <kai.huang@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 245/247] KVM: VMX: Inject #UD if guest tries to execute SEAMCALL or TDCALL
Date: Fri, 21 Nov 2025 14:13:12 +0100
Message-ID: <20251121130203.534520650@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 9d7dfb95da2cb5c1287df2f3468bcb70d8b31087 ]

Add VMX exit handlers for SEAMCALL and TDCALL to inject a #UD if a non-TD
guest attempts to execute SEAMCALL or TDCALL.  Neither SEAMCALL nor TDCALL
is gated by any software enablement other than VMXON, and so will generate
a VM-Exit instead of e.g. a native #UD when executed from the guest kernel.

Note!  No unprivileged DoS of the L1 kernel is possible as TDCALL and
SEAMCALL #GP at CPL > 0, and the CPL check is performed prior to the VMX
non-root (VM-Exit) check, i.e. userspace can't crash the VM. And for a
nested guest, KVM forwards unknown exits to L1, i.e. an L2 kernel can
crash itself, but not L1.

Note #2!  The Intel® Trust Domain CPU Architectural Extensions spec's
pseudocode shows the CPL > 0 check for SEAMCALL coming _after_ the VM-Exit,
but that appears to be a documentation bug (likely because the CPL > 0
check was incorrectly bundled with other lower-priority #GP checks).
Testing on SPR and EMR shows that the CPL > 0 check is performed before
the VMX non-root check, i.e. SEAMCALL #GPs when executed in usermode.

Note #3!  The aforementioned Trust Domain spec uses confusing pseudocode
that says that SEAMCALL will #UD if executed "inSEAM", but "inSEAM"
specifically means in SEAM Root Mode, i.e. in the TDX-Module.  The long-
form description explicitly states that SEAMCALL generates an exit when
executed in "SEAM VMX non-root operation".  But that's a moot point as the
TDX-Module injects #UD if the guest attempts to execute SEAMCALL, as
documented in the "Unconditionally Blocked Instructions" section of the
TDX-Module base specification.

Cc: stable@vger.kernel.org
Cc: Kai Huang <kai.huang@intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Link: https://lore.kernel.org/r/20251016182148.69085-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/uapi/asm/vmx.h |    1 +
 arch/x86/kvm/vmx/nested.c       |    8 ++++++++
 arch/x86/kvm/vmx/vmx.c          |    8 ++++++++
 3 files changed, 17 insertions(+)

--- a/arch/x86/include/uapi/asm/vmx.h
+++ b/arch/x86/include/uapi/asm/vmx.h
@@ -93,6 +93,7 @@
 #define EXIT_REASON_TPAUSE              68
 #define EXIT_REASON_BUS_LOCK            74
 #define EXIT_REASON_NOTIFY              75
+#define EXIT_REASON_SEAMCALL            76
 #define EXIT_REASON_TDCALL              77
 #define EXIT_REASON_MSR_READ_IMM        84
 #define EXIT_REASON_MSR_WRITE_IMM       85
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6587,6 +6587,14 @@ static bool nested_vmx_l1_wants_exit(str
 	case EXIT_REASON_NOTIFY:
 		/* Notify VM exit is not exposed to L1 */
 		return false;
+	case EXIT_REASON_SEAMCALL:
+	case EXIT_REASON_TDCALL:
+		/*
+		 * SEAMCALL and TDCALL unconditionally VM-Exit, but aren't
+		 * virtualized by KVM for L1 hypervisors, i.e. L1 should
+		 * never want or expect such an exit.
+		 */
+		return false;
 	default:
 		return true;
 	}
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5953,6 +5953,12 @@ static int handle_vmx_instruction(struct
 	return 1;
 }
 
+static int handle_tdx_instruction(struct kvm_vcpu *vcpu)
+{
+	kvm_queue_exception(vcpu, UD_VECTOR);
+	return 1;
+}
+
 #ifndef CONFIG_X86_SGX_KVM
 static int handle_encls(struct kvm_vcpu *vcpu)
 {
@@ -6078,6 +6084,8 @@ static int (*kvm_vmx_exit_handlers[])(st
 	[EXIT_REASON_ENCLS]		      = handle_encls,
 	[EXIT_REASON_BUS_LOCK]                = handle_bus_lock_vmexit,
 	[EXIT_REASON_NOTIFY]		      = handle_notify,
+	[EXIT_REASON_SEAMCALL]		      = handle_tdx_instruction,
+	[EXIT_REASON_TDCALL]		      = handle_tdx_instruction,
 	[EXIT_REASON_MSR_READ_IMM]            = handle_rdmsr_imm,
 	[EXIT_REASON_MSR_WRITE_IMM]           = handle_wrmsr_imm,
 };


