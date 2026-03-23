Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2CBB3B8BC3;
	Mon, 23 Mar 2026 15:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278668; cv=none; b=UcVM/RX4J56fAtLZwqdKKyAMZk//ycYExHktOhVm11lm+imPwxQq3pro07/ddV6XHTRAmEYiG+vNZlr6HVGq5C4fdITR0tEqWDBOAA+571q40X2b2FkDMYf8Kkt254xRzbu6oG91a/5YgdrJM5euS7q0Zvk1IaU7WHr/Zr0nO/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278668; c=relaxed/simple;
	bh=l8b1RXM7h/nv3Btt4PeCpSZ9av5yqUcBmjhXvxw3nNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ntwwUOAp4ArxIDz5SBaQQuxebdkJrIrSdeW1F52j7RLU812afoic7Z/Zdj9KOOGje0eUR+CyJrnalDTGKaNpcBfi/ON3mihu3Cys99bOY+DEb/4yFAwjFc6ov8+t9JgrUJyw+5qxMeS3VAOnvoj5I9/YvRkIgaSXfmdUltNIuyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ck6tTR1w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ck6tTR1w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55248C2BC9E;
	Mon, 23 Mar 2026 15:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278668;
	bh=l8b1RXM7h/nv3Btt4PeCpSZ9av5yqUcBmjhXvxw3nNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ck6tTR1wxXQYYtKQz0qbcM5C8uSWYgxGapd7/AuWFEYC5wDwVa2Jhhl7kGs7hGuzz
	 HSFuuXTv0LUwYn7+H5zpEz5dP5sgE+Fi2ppkFxFiRPtwGU1W+lDZLL6OpCsDr3YnQA
	 tUNj6dVw0ppi/Ei52hoZ3kkgLkXXqLP438644MP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Naveen N Rao (AMD)" <naveen@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 382/567] KVM: SVM: Limit AVIC physical max index based on configured max_vcpu_ids
Date: Mon, 23 Mar 2026 14:45:02 +0100
Message-ID: <20260323134543.292862869@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naveen N Rao <naveen@kernel.org>

[ Upstream commit 574ef752d4aea04134bc121294d717f4422c2755 ]

KVM allows VMMs to specify the maximum possible APIC ID for a virtual
machine through KVM_CAP_MAX_VCPU_ID capability so as to limit data
structures related to APIC/x2APIC. Utilize the same to set the AVIC
physical max index in the VMCB, similar to VMX. This helps hardware
limit the number of entries to be scanned in the physical APIC ID table
speeding up IPI broadcasts for virtual machines with smaller number of
vCPUs.

Unlike VMX, SVM AVIC requires a single page to be allocated for the
Physical APIC ID table and the Logical APIC ID table, so retain the
existing approach of allocating those during VM init.

Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
Link: https://lore.kernel.org/r/adb07ccdb3394cd79cb372ba6bcc69a4e4d4ef54.1757009416.git.naveen@kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Stable-dep-of: 87d0f901a9bd ("KVM: SVM: Set/clear CR8 write interception when AVIC is (de)activated")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/avic.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -85,6 +85,7 @@ struct amd_svm_iommu_ir {
 static void avic_activate_vmcb(struct vcpu_svm *svm)
 {
 	struct vmcb *vmcb = svm->vmcb01.ptr;
+	struct kvm *kvm = svm->vcpu.kvm;
 
 	vmcb->control.int_ctl &= ~(AVIC_ENABLE_MASK | X2APIC_MODE_MASK);
 	vmcb->control.avic_physical_id &= ~AVIC_PHYSICAL_MAX_INDEX_MASK;
@@ -100,7 +101,8 @@ static void avic_activate_vmcb(struct vc
 	 */
 	if (x2avic_enabled && apic_x2apic_mode(svm->vcpu.arch.apic)) {
 		vmcb->control.int_ctl |= X2APIC_MODE_MASK;
-		vmcb->control.avic_physical_id |= X2AVIC_MAX_PHYSICAL_ID;
+		vmcb->control.avic_physical_id |= min(kvm->arch.max_vcpu_ids - 1,
+						      X2AVIC_MAX_PHYSICAL_ID);
 		/* Disabling MSR intercept for x2APIC registers */
 		svm_set_x2apic_msr_interception(svm, false);
 	} else {
@@ -111,7 +113,8 @@ static void avic_activate_vmcb(struct vc
 		kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, &svm->vcpu);
 
 		/* For xAVIC and hybrid-xAVIC modes */
-		vmcb->control.avic_physical_id |= AVIC_MAX_PHYSICAL_ID;
+		vmcb->control.avic_physical_id |= min(kvm->arch.max_vcpu_ids - 1,
+						      AVIC_MAX_PHYSICAL_ID);
 		/* Enabling MSR intercept for x2APIC registers */
 		svm_set_x2apic_msr_interception(svm, true);
 	}


