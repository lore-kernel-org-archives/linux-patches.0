Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011E33B19DE;
	Fri,  9 Oct 2026 14:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556574; cv=none; b=MXv/VLzILTu6XsLfaKip3XuGS04RvWUcxNuB8r0cUfkOH2S3iRGy6DMFIGbbvko5rkc/XO7k7cTI5SbmSG0TKBSr1SiKeVEY3fNi2mUxn8okvT0Pb4HyBJny8v6fF2qCOqEHjmFvuMBf5eVrw476uEduToEWFY73F1g2X82kXNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556574; c=relaxed/simple;
	bh=0xMqId9dgDLCI21eAJo6LZzyrcZaHvaHUZurlcPyaMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bBUBju8AShFiJSz2LpjpTfvwIkbLHLpa+VMAD4f92P4b633Dk9cZeTK4501m+l1/2aCcY5gRei290AEUkpDMLP9nG9/XcWPxDmLKu5tqaVc5tK5IVqS+/8GYb0JiDahA4PG4gqwMGFxJ/VO1uTZAvjQ8LDbXMzCV34TFZm6LUXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hce6VQFL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hce6VQFL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E8AB1F000FF;
	Fri,  9 Oct 2026 14:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556572;
	bh=evm22oyOvxZi0Z9WBWvS5+ohU0qEXMH9y7Gfov3LVsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hce6VQFLntDlYDwqtuvYk14KCQLM8oLBsM6Wl7zqAOAEx8PR7Xa3s2hP2k/yARotJ
	 ZtfCFBfpblfr7MBAcrM36HwmMFFtK3X7cMPjo3WV58DM7kzf/BLzNNCJeTEGJTGDLb
	 02+6KoUDd4uHRtpRilNS7hcJsBr8xm6ujfTBQA6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.18 257/403] KVM: nVMX: Force MSR bitmap refresh if runtime eVMCS controls are modified
Date: Fri,  9 Oct 2026 16:10:18 +0200
Message-ID: <20261009140958.184754500@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

commit 2abb25273c82061dd4670690c81c319c03740bf6 upstream.

Force a refresh of the vmcs02 MSR bitmap during nested VM-Enter if the
runtime eVMCS controls (pin, primary, secondary, etc.) are being updated.
If L1 isn't intercepting TPR writes, runs L2 with TPR virtualization, and
then runs the same L2 with TPR virtualization disabled, KVM will fail to
refresh msr_bitmap02 and leave TPR in passthrough mode even though TPR
virtualization is disabled.  I.e. failure to refresh the bitmap lets L2 (or
L1 by proxy) read and write L0's TPR.

Fixes: 502d2bf5f2fd ("KVM: nVMX: Implement Enlightened MSR Bitmap feature")
Cc: stable@vger.kernel.org
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/nested.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1700,6 +1700,9 @@ static void copy_vmcs12_to_shadow(struct
 static void copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx, u32 hv_clean_fields)
 {
 #ifdef CONFIG_KVM_HYPERV
+	const u64 runtime_controls = HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_GRP1 |
+				     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_GRP2 |
+				     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_PROC;
 	struct vmcs12 *vmcs12 = vmx->nested.cached_vmcs12;
 	struct hv_enlightened_vmcs *evmcs = nested_vmx_evmcs(vmx);
 	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(&vmx->vcpu);
@@ -1708,6 +1711,9 @@ static void copy_enlightened_to_vmcs12(s
 	vmcs12->tpr_threshold = evmcs->tpr_threshold;
 	vmcs12->guest_rip = evmcs->guest_rip;
 
+	if ((hv_clean_fields & runtime_controls) != runtime_controls)
+		vmx->nested.force_msr_bitmap_recalc = true;
+
 	if (unlikely(!(hv_clean_fields &
 		       HV_VMX_ENLIGHTENED_CLEAN_FIELD_ENLIGHTENMENTSCONTROL))) {
 		hv_vcpu->nested.pa_page_gpa = evmcs->partition_assist_page;


