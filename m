Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46AFA4078D3;
	Thu, 17 Sep 2026 18:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671457; cv=none; b=g6OvwmPIAaTk1f5m9VLExpOjL0iNRyBAq8ZZTekZ3AH3tLX/dhtecPrquO16BQD2b8U+1rbMrDiCgZXUGuv8ajUhAGE+ix2uHOzmTS4x43zb/MxbgovWa4WxjfpqddAGo3LjORZqxwPRxT92lxb+JbVEIMo6plSJZzuVGwVdAWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671457; c=relaxed/simple;
	bh=5t+MqiwqfwJXXufTNYaheFqBZiQS7O9mwUvBd2ILyng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RJ6T5M3FVjD5ucD1j/FabWv2hm07Ms3SI9R2bq1ByKeNOvYxR4zi9JbgdEiExFqcZd0577ID37/XiuUhn9KFyrbbf4UlT7+hvpIxnolMxAVnS8WKOYhwGNV8B9kRTDNBmacoB2/qbxAmYT2Mxx7m9XYPrMzQ8o26fXadIYMobpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h9uye4FP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h9uye4FP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A4971F000FF;
	Thu, 17 Sep 2026 18:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671456;
	bh=N9ysEX1KINcV4AqmOnZmF3mUFnXA/7soSOPUzO5yXuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h9uye4FPbq7S0zz+l6lgdp27IjqKYyAnhiZTwd6W6AmStRVhq+zQtqT+/aiDRPaXi
	 LkxnreplVl0f4wcx7z0iqGYn0UUxsV8mTM5tz4Fw3GbZpJpyz1lrAolNgKs5xQgpWA
	 vlnblYV6swDjf++dnKIW+lzGNrEJiWNgMFZRRU7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0982/1102] KVM: SEV: Track the GPA of the guest-controlled VMSA used for SNP guests
Date: Thu, 17 Sep 2026 16:15:25 +0100
Message-ID: <20260917151605.357165752@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 42a39ad5d592aec87a70527a4e694f6210694482 ]

Track the GPA of the guest-provided VMSA used after AP_CREATION events when
running SNP guests, instead of simply tracking whether or not the vCPU is
using a guest-provided VMSA.  KVM needs to know the GPA of the VMSA that's
actively being used so that it can react to MMU invalidation events, i.e.
so that KVM can drop the VMSA if its backing guest_memfd page is punched
out of existence.

Opportunistically rename snp_vmsa_gpa to clarify that it tracks the pending
VMSA GPA, whereas snp_guest_vmsa_gpa now tracks the in-use VMSA GPA.

Note!  Take care to track the GPA, not the GFN, as VALID_PAGE() won't
behave correctly if an invalid GFN is converted to a GPA for checking.

Note #2!  Keep snp_has_guest_vmsa so that switching to a guest-provided
VMSA is sticky, even if the guest-provided VMSA becomes invalid.

No functional change intended.

Cc: stable@vger.kernel.org # 6.12.x
Reviewed-by: Michael Roth <michael.roth@amd.com>
Link: https://patch.msgid.link/20260709204948.1988414-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
[ dropped the guest_tsc_protected line since Secure TSC support (a311fce2b6945) is not present in this tree ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |   15 ++++++++++-----
 arch/x86/kvm/svm/svm.h |    3 ++-
 2 files changed, 12 insertions(+), 6 deletions(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3963,6 +3963,7 @@ void sev_snp_init_protected_guest_state(
 
 	/* Clear use of the VMSA */
 	svm->vmcb->control.vmsa_pa = INVALID_PAGE;
+	svm->sev_es.snp_guest_vmsa_gpa = INVALID_PAGE;
 
 	/*
 	 * When replacing the VMSA during SEV-SNP AP creation,
@@ -3970,11 +3971,11 @@ void sev_snp_init_protected_guest_state(
 	 */
 	vmcb_mark_all_dirty(svm->vmcb);
 
-	if (!VALID_PAGE(svm->sev_es.snp_vmsa_gpa))
+	if (!VALID_PAGE(svm->sev_es.snp_pending_vmsa_gpa))
 		return;
 
-	gfn = gpa_to_gfn(svm->sev_es.snp_vmsa_gpa);
-	svm->sev_es.snp_vmsa_gpa = INVALID_PAGE;
+	gfn = gpa_to_gfn(svm->sev_es.snp_pending_vmsa_gpa);
+	svm->sev_es.snp_pending_vmsa_gpa = INVALID_PAGE;
 
 	slot = gfn_to_memslot(vcpu->kvm, gfn);
 	if (!slot)
@@ -3999,6 +4000,7 @@ void sev_snp_init_protected_guest_state(
 	svm->sev_es.snp_has_guest_vmsa = true;
 
 	/* Use the new VMSA */
+	svm->sev_es.snp_guest_vmsa_gpa = gfn_to_gpa(gfn);
 	svm->vmcb->control.vmsa_pa = pfn_to_hpa(pfn);
 
 	/* Mark the vCPU as runnable */
@@ -4089,10 +4091,10 @@ static int sev_snp_ap_creation(struct vc
 			goto out;
 		}
 
-		target_svm->sev_es.snp_vmsa_gpa = svm->vmcb->control.exit_info_2;
+		target_svm->sev_es.snp_pending_vmsa_gpa = svm->vmcb->control.exit_info_2;
 		break;
 	case SVM_VMGEXIT_AP_DESTROY:
-		target_svm->sev_es.snp_vmsa_gpa = INVALID_PAGE;
+		target_svm->sev_es.snp_pending_vmsa_gpa = INVALID_PAGE;
 		break;
 	default:
 		vcpu_unimpl(vcpu, "vmgexit: invalid AP creation request [%#x] from guest\n",
@@ -4689,6 +4691,9 @@ int sev_vcpu_create(struct kvm_vcpu *vcp
 		return -ENOMEM;
 
 	svm->sev_es.vmsa = page_address(vmsa_page);
+	svm->sev_es.snp_pending_vmsa_gpa = INVALID_PAGE;
+	svm->sev_es.snp_guest_vmsa_gpa = INVALID_PAGE;
+
 	return 0;
 }
 
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -240,7 +240,8 @@ struct vcpu_sev_es_state {
 	u64 ghcb_registered_gpa;
 
 	struct mutex snp_vmsa_mutex; /* Used to handle concurrent updates of VMSA. */
-	gpa_t snp_vmsa_gpa;
+	gpa_t snp_pending_vmsa_gpa;
+	gpa_t snp_guest_vmsa_gpa;
 	bool snp_ap_waiting_for_reset;
 	bool snp_has_guest_vmsa;
 };


