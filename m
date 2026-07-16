Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A203195EF;
	Thu, 16 Jul 2026 14:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211431; cv=none; b=PRBpyWoo8FC2lP4XyzsotxfgXA8/oAIjUiCLMXXbG143OaAf90sFaos+WLt+BKYUOIQs69pbRkSusztduSpB0tYvIFDpP7b4FbYmhEn+hDtTGaWMVelTvtNzqDweGaHvza9QO2wyYGL8wIE2V9iivP78LRY6rfpdfHReS4T/pj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211431; c=relaxed/simple;
	bh=Kk93+fOFuQKET7wzjOQw3JeO4HFKVdQcqU5b8K8w9lA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nmctx4d7PPkUr7Vka86NoCABoQ5HFagWIChf1GzMxpITEzBbyyD0azbOtC/Nbmv39EDK4IDv3iW3MLTE7Ge5D79yygXRQB6J5HF0f2ySro6eX7qBT2zVMJc34Syn2fF4aqBOXVKdLgwNfJLs4plLzQw9UTK9gLYFt0V8Jsh//7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mljnFry/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mljnFry/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CEB91F000E9;
	Thu, 16 Jul 2026 14:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211430;
	bh=ADp13zNW6bysNMmJHs0URSimy5GoeWdl68mEchxI1zY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mljnFry/IF7otjP+zMRr8oGjirapTM738Vdb1p15zSYdmD2EwMZKeZQ1ZOv11ZvT3
	 UD6+HY747mXnJt1peCwSoXGvvRuVk2No+ta/sHz+OhIjdFlRjvF2k3mEpNNovU9XIF
	 EDsIVjqFZXijl0W5AZoRdWYhxFveP4FYAqLqpNts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuanqing Shi <1356292400@qq.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 426/480] KVM: VMX: Handle bad values on proxied writes to LBR MSRs
Date: Thu, 16 Jul 2026 15:32:53 +0200
Message-ID: <20260716133054.030564444@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Xuanqing Shi <1356292400@qq.com>

commit ca674df13b195eb6d124ab059799d4e03fa40624 upstream.

Use the "safe" WRMSR API when writing LBRs on behalf of the guest (or host
userspace), and propagate any errors back to the instigator, as the value
being written is untrusted.  E.g. if the guest (or host userspace) attempts
to set reserved bits in LBR_SELECT, then KVM needs to return an error, and
not WARN on the bad value.

Continue using the "unsafe" version of RDMSR, as it should be impossible to
reach the helper with a completely bogus MSR, i.e. WARNing on RDMSR failure
is very desirable, e.g. to make KVM bugs more visible.

  unchecked MSR access error: WRMSR to 0x1c8 (tried to write 0x0000000000004000)
  Call Trace:
   intel_pmu_set_msr+0x4e0/0x7f0 [kvm_intel]
   kvm_pmu_set_msr+0x17e/0x1c0 [kvm]
   kvm_set_msr_common+0xc76/0x1440 [kvm]
   vmx_set_msr+0x5e6/0x1570 [kvm_intel]
   kvm_emulate_wrmsr+0x54/0x1d0 [kvm]
   vmx_handle_exit+0x7fc/0x970 [kvm_intel]

Fixes: 1b5ac3226a1a ("KVM: vmx/pmu: Pass-through LBR msrs when the guest LBR event is ACTIVE")
Cc: stable@vger.kernel.org
Signed-off-by: Xuanqing Shi <1356292400@qq.com>
[sean: rework changelog, only modify WRMSR path, tag for stable@]
Link: https://patch.msgid.link/20260527022617.3973884-1-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/pmu_intel.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -320,13 +320,15 @@ static bool intel_pmu_handle_lbr_msrs_ac
 	 */
 	local_irq_disable();
 	if (lbr_desc->event->state == PERF_EVENT_STATE_ACTIVE) {
+		int err = 0;
+
 		if (read)
 			rdmsrq(index, msr_info->data);
 		else
-			wrmsrq(index, msr_info->data);
+			err = wrmsrq_safe(index, msr_info->data);
 		__set_bit(INTEL_PMC_IDX_FIXED_VLBR, vcpu_to_pmu(vcpu)->pmc_in_use);
 		local_irq_enable();
-		return true;
+		return !err;
 	}
 	clear_bit(INTEL_PMC_IDX_FIXED_VLBR, vcpu_to_pmu(vcpu)->pmc_in_use);
 	local_irq_enable();


