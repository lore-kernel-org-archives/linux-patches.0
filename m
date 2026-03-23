Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E56263B27EB;
	Mon, 23 Mar 2026 14:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774276948; cv=none; b=u2oIHBr99SRSsYo0ZiRquqOZJ4N4Jr0FMSvwzPh1k2QECVwehHzPIgZbV15RBnpBOO+n0f6ujEG1fcRNYAepYPGpjN2TXvtBkpn66PwiHSzejUECqpgLQwRiKvnnW3u+Hq5X/RwbXV5UgRA9h9AKYg06j2/DzdCX2uC8rwf9T/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774276948; c=relaxed/simple;
	bh=WvIDynjntsXqHLM9V218QIVeQ5zqoWBGPk2EfdMDGk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bwdm8GciYDZd1cefiIu16Q0DBf4DQZXGJFVC+To9blQlFfa/nhqm7FULuNTJKmboGDngXWLIYsuhp1p8B9oO4YGXhp3/1Xz6J1K3W8OxUpTlEo7A1prL0cni/MmbT6ETnUvxHTbYjmJ6PoFQAlkWUuZEHRQwVdUcXFw5WUvQmGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qswCxhiT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qswCxhiT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7484FC4CEF7;
	Mon, 23 Mar 2026 14:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774276947;
	bh=WvIDynjntsXqHLM9V218QIVeQ5zqoWBGPk2EfdMDGk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qswCxhiTKcBex9U55mx0vOMOuGkqGfQARlR/FSvptx770vNNOo1/DOG4M3fc25zUG
	 euJYBh79nx2Xi5ZHgUAjSkJNn6AaAtLWd5M0nC+bcWFYTTN97udrq/ODI3BUoTUt9/
	 3i5vYzr8AcB2ZgXyzfzsntNBikiMjQtTW07tzDXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Krause <minipli@grsecurity.net>,
	John Allen <john.allen@amd.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Chao Gao <chao.gao@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 265/460] KVM: nVMX: Add consistency checks for CR0.WP and CR4.CET
Date: Mon, 23 Mar 2026 14:44:21 +0100
Message-ID: <20260323134532.995801111@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Gao <chao.gao@intel.com>

[ Upstream commit 8060b2bd2dd05a19ad7ec248489d374f2bd2b057 ]

Add consistency checks for CR4.CET and CR0.WP in guest-state or host-state
area in the VMCS12. This ensures that configurations with CR4.CET set and
CR0.WP not set result in VM-entry failure, aligning with architectural
behavior.

Tested-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: John Allen <john.allen@amd.com>
Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Link: https://lore.kernel.org/r/20250919223258.1604852-33-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Stable-dep-of: e2ffe85b6d2b ("KVM: x86: Introduce KVM_X86_QUIRK_VMCS12_ALLOW_FREEZE_IN_SMM")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/nested.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3022,6 +3022,9 @@ static int nested_vmx_check_host_state(s
 	    CC(!kvm_vcpu_is_legal_cr3(vcpu, vmcs12->host_cr3)))
 		return -EINVAL;
 
+	if (CC(vmcs12->host_cr4 & X86_CR4_CET && !(vmcs12->host_cr0 & X86_CR0_WP)))
+		return -EINVAL;
+
 	if (CC(is_noncanonical_msr_address(vmcs12->host_ia32_sysenter_esp, vcpu)) ||
 	    CC(is_noncanonical_msr_address(vmcs12->host_ia32_sysenter_eip, vcpu)))
 		return -EINVAL;
@@ -3136,6 +3139,9 @@ static int nested_vmx_check_guest_state(
 	    CC(!nested_guest_cr4_valid(vcpu, vmcs12->guest_cr4)))
 		return -EINVAL;
 
+	if (CC(vmcs12->guest_cr4 & X86_CR4_CET && !(vmcs12->guest_cr0 & X86_CR0_WP)))
+		return -EINVAL;
+
 	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS) &&
 	    (CC(!kvm_dr7_valid(vmcs12->guest_dr7)) ||
 	     CC(!vmx_is_valid_debugctl(vcpu, vmcs12->guest_ia32_debugctl, false))))


