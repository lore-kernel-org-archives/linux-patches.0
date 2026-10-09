Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44FD74EA36F;
	Fri,  9 Oct 2026 14:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557301; cv=none; b=RUJP7HV5jbcKkIdVk9GqQxeW9xXPtP9y6Xi8iRDledSQxjYQZAUWLAKmAv9kqpRaIXmnY8EkqpALlyYT2BG3i3Rit6jn4hrU+lYKHezw89T9ky/QreistpVBpakdjtegLEbl0CKFs7uMBAv5y2mTnwgQFBhDtc26TiVTq4+j8KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557301; c=relaxed/simple;
	bh=qlmZ5DAJR7brrzfFoQGSqID6h6Pr1RUBCSVqoDi2ISY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p/yHABS95viWmQU5DwAcyz4EmYlodBZc2vgh4vQAhhsvUzakdorNqiqMQRWz2cgkYv6UHCDOyUj5TLvBJEFG9wfQG9+FRBFj135VxAd+h31zTjVPv5Z8PsOICJZqtCZqVraiycIh/hgnYh/eA4ckKyHrvWrxeBS9gZqVpn/cyuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kpg0eZIJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kpg0eZIJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E2C91F000FF;
	Fri,  9 Oct 2026 14:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557300;
	bh=f2gR41s/dNLWadtsWxp/A+7Bz11tfpmzGxRaSWEkozw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kpg0eZIJ3OvndqJEVQ3ziWiWk2VNjaj/jaKvyFejtumnhbs4AWeMa+gbvlKQP3qCc
	 nPw4sogMc0qIln5/6YCYPRyAgG9dvdDJVBwjn6Q5jqUs+ellPECnMwOzJPC3ekiMy4
	 uHBllV0etSKjAuVw+KXeWogNDNvNWqfIEtMfWpkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 7.2 311/428] KVM: nVMX: Force MSR bitmap refresh if runtime eVMCS controls are modified
Date: Fri,  9 Oct 2026 16:10:48 +0200
Message-ID: <20261009140952.953799579@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1758,6 +1758,9 @@ static void copy_vmcs12_to_shadow(struct
 static void copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx, u32 hv_clean_fields)
 {
 #ifdef CONFIG_KVM_HYPERV
+	const u64 runtime_controls = HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_GRP1 |
+				     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_GRP2 |
+				     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_PROC;
 	struct vmcs12 *vmcs12 = vmx->nested.cached_vmcs12;
 	struct hv_enlightened_vmcs *evmcs = nested_vmx_evmcs(vmx);
 	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(&vmx->vcpu);
@@ -1766,6 +1769,9 @@ static void copy_enlightened_to_vmcs12(s
 	vmcs12->tpr_threshold = evmcs->tpr_threshold;
 	vmcs12->guest_rip = evmcs->guest_rip;
 
+	if ((hv_clean_fields & runtime_controls) != runtime_controls)
+		vmx->nested.force_msr_bitmap_recalc = true;
+
 	if (unlikely(!(hv_clean_fields &
 		       HV_VMX_ENLIGHTENED_CLEAN_FIELD_ENLIGHTENMENTSCONTROL))) {
 		hv_vcpu->nested.pa_page_gpa = evmcs->partition_assist_page;


