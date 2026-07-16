Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58ED31717E;
	Thu, 16 Jul 2026 13:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210154; cv=none; b=CO16rUnn2MhAxAY5UYuZzgK7MB6I+Ve5KDmq1F1tKmLYrHYcvgckBY1THTHezF+AaB5ZaG51hLntJXZ3Fw2uxSwLcVS57jNA/gLBhOhGYs7x1JZ8wyhlnisL9h/AwzmFKz5UG0hLRvTGRhPPOHaGDV4NmfZX7F/EANF0srn1OXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210154; c=relaxed/simple;
	bh=s7er9HRLPRBZFMGQCXfUuxR+zrg7nU6O+6AwDF/rDNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BGHVqanhqzRjR1xUqRV4IwNlZV+KO4vgT+PoI+lJsfKpYGPh1pwx7oXLq6Ua0Ec7JJcVFRKQ5ma1Hs5SV+0aip7dhlbnOXcF/q8rKOMQF/iTCnquhyx7NVuUD/EINd4gmEdLQKXRxgKuv1yWO4ESZCZ8EzzIYNPvanX1Q3xcuic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X21vloIS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X21vloIS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 244FE1F000E9;
	Thu, 16 Jul 2026 13:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210153;
	bh=L4AIPHe0S32rIJOA9MwJX0XHjyuAjnOqSC5vF6+wiRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X21vloIS6IMbxjI2NjAghEq0iIqHjAd1vigTi/sn6FWUlgKJZZ53BWDRnR/U5dyfo
	 92s7d67mlH6IBABL4e9Q6yIUBWYUE42v3uzT2MUQRmQpQpUePgN29Xwbq2+c10rfAu
	 gmYVe/RtBp2GZts8Uu2aMrSq4xWIJwT1sh+xJNwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuanqing Shi <1356292400@qq.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 7.1 459/518] KVM: VMX: Handle bad values on proxied writes to LBR MSRs
Date: Thu, 16 Jul 2026 15:32:07 +0200
Message-ID: <20260716133057.885116704@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -308,13 +308,15 @@ static bool intel_pmu_handle_lbr_msrs_ac
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


