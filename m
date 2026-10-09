Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C2623D9DDB;
	Fri,  9 Oct 2026 14:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557191; cv=none; b=c+L3ma9M/izDsur2czGCslMlgq3QYK3FMOwuUswFU2PM9zw//JpOiho2Evb2nsKZTxHznpgTOTUrfTB1u1Tw6aG6uo8CKIKILoV/IkysQeMdNtS4ZrX7di2S0rTJHCxwifzrG9jv6szhxhdwcYVLy046TNTS75Ul9ItXzj0b4Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557191; c=relaxed/simple;
	bh=cMZxHkd7ymW3s4KDaOLclOWVqaLAFXEO8kD6ZFkPPEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BtWnDcMHnJ7fE6nXPaxCOKrAGvgcgWEuz6MHIjselPu2rAPm7+94rVcFIzUFU6VC0xTQiO09zdhPdmc+D+KRrj3GDjsr1EOaONvsPz0zzEwMml+7Ty9gi3LxVYUMAzBnMxgqlONTliHXU0J7i6vx1o19cWXA4R2MdFsfsL414FM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rcIY0/LC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rcIY0/LC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7272A1F000FF;
	Fri,  9 Oct 2026 14:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557189;
	bh=krBcvZlg7duEg40WSKiGqVBa9nndpS17+ZZf2f0vn/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rcIY0/LCVQ9cXCTyAXRZPOq4pUYfSi/OsA6wj9v72Nzk8UwtK40NmOTKiu8nfOItX
	 /b2BYTe5Bz4MiPzm0F87UsCnF1a2x+jn5pTyKxiuCe1sVUMSMxVlQjPD17GhwAe5kB
	 w79hmt5rhcCTQd1ZuJnwCN5UZcP/THg/ZNGEDh2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Teodorescu <fane@google.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Jim Mattson <jmattson@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 7.2 316/428] KVM: SVM: Preserve TLB control (i.e. pending TLB flush) on failed VMRUN
Date: Fri,  9 Oct 2026 16:10:53 +0200
Message-ID: <20261009140953.067951346@linuxfoundation.org>
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

commit 60d93c27859fb3ec5b5a689e24de303f166477d0 upstream.

Don't reset the VMCB's TLB control back to "do nothing" on a failed VMRUN,
as empirical testing shows that the CPU performs the requested TLB flush if
and only if VMRUN is successful, i.e. clearing TLB control on a failed
VMRUN effectively drops a TLB flush.

Explicitly track the need to flush all ASIDs on a per-CPU basis, as the
ASID reuse condition is tied to the pCPU, not to the vCPU.  As a bonus,
this also obviates the need to avoid clobbering FLUSH_ALL_ASID with
TLB_CONTROL_FLUSH_ASID, e.g. in svm_flush_tlb_asid().

Deliberately don't bother saving/restoring the "old" tlb_ctl on failure,
in quotes because it's not exactly the old tlb_ctl, it's the tlb_ctl from
after pre_svm_run(), but before updating tlb_ctl for flush_all_asids.  If
VMRUN fails and TLB_CONTROL_FLUSH_ALL_ASID is forced, then the next
successful run of the VMCB *may* unnecessarily flush all ASIDs, which
strictly speaking could result in noisy neighbor issues.  However, the
fact that new_asid() is already guest-triggerable, because of KVM's flawed
behavior of clearing the ASID on emulated INIT, means that a guest can
already trigger a flush of all ASIDs at roughly the same rate.  And once
KVM stops clobbering the ASID on emulated INIT, *or* assigns a static ASID
to each vCPU, this flaw goes away.

Fixes: 38e5e92fe8c0 ("KVM: SVM: Implement Flush-By-Asid feature")
Cc: stable@vger.kernel.org
Reported-by: Stefan Teodorescu <fane@google.com>
Suggested-by: Yosry Ahmed <yosry@kernel.org>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Jim Mattson <jmattson@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20260904170642.3291466-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.c |   13 ++++++++++---
 arch/x86/kvm/svm/svm.h |    1 +
 2 files changed, 11 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1897,8 +1897,7 @@ static void new_asid(struct vcpu_svm *sv
 	if (sd->next_asid > sd->max_asid) {
 		++sd->asid_generation;
 		sd->next_asid = sd->min_asid;
-		svm->vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ALL_ASID;
-		vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
+		sd->flush_all_asids = true;
 	}
 
 	svm->current_vmcb->asid_generation = sd->asid_generation;
@@ -4518,6 +4517,11 @@ static __no_kcsan fastpath_t svm_vcpu_ru
 		svm->vmcb->control.asid = svm->asid;
 		vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
 	}
+	if (this_cpu_ptr(&svm_data)->flush_all_asids) {
+		svm->vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ALL_ASID;
+		vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
+	}
+
 	svm->vmcb->save.cr2 = vcpu->arch.cr2;
 
 	if (guest_cpu_cap_has(vcpu, X86_FEATURE_ERAPS) &&
@@ -4608,7 +4612,10 @@ static __no_kcsan fastpath_t svm_vcpu_ru
 		vcpu->arch.nested_run_pending = 0;
 	}
 
-	svm->vmcb->control.tlb_ctl = TLB_CONTROL_DO_NOTHING;
+	if (!svm_is_vmrun_failure(svm->vmcb->control.exit_code)) {
+		this_cpu_ptr(&svm_data)->flush_all_asids = false;
+		svm->vmcb->control.tlb_ctl = TLB_CONTROL_DO_NOTHING;
+	}
 
 	/*
 	 * Unconditionally mask off the CLEAR_RAP bit, the AND is just as cheap
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -376,6 +376,7 @@ struct svm_cpu_data {
 	u32 next_asid;
 	u32 min_asid;
 
+	bool flush_all_asids;
 	bool bp_spec_reduce_set;
 
 	struct vmcb *save_area;


