Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 414B0403B1E;
	Sat, 12 Sep 2026 11:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213619; cv=none; b=Fx00EqOlru1UXVerfqg4X8j/DjrO12xowPBofnI8wP/hAGxHbeb4wKOuPMTmT8Ee+fOtYCDoS3XurLTwNCEkF0nz6yr30Z30+82PFjdqUmea81mNLdT8tTxg1lS/ZNNWa45SwN0nUqe/ZZ+D6+B59nMzsvvABY2addToTlHbTjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213619; c=relaxed/simple;
	bh=/L3aupIx7ZjwgSQHg+WhVMOpi5mP2n+WNSymEQCWaUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OJagLa0oZ0zCj4Gn33BXvsdbC3mqZHNoYmaRxmDIOE8juxeUbGYAWAj5mYi1+YlhVKuOclNtTY8jlzjm9oGyTiVJ3ywpjmYNartdoLCokV+wKNwtrqrCemTxiC0L+6UBZt2r+fc/csxbJAfSOoH+3RaV6Lhz1IDQAZtIUHpJqCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TQm/sSyi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TQm/sSyi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F4601F000FF;
	Sat, 12 Sep 2026 11:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213615;
	bh=lGuA33qsWC9gKSZyOj55kBdyhxTJkbUcq8O+6k5cYEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TQm/sSyiuFbOnNzePZMEu3OI4Xo0usIBrC745j4w8LG79mQP57/0U2S2elrp09EYE
	 bieugbtWS8UcfnnET3kOFQdFht5enjObLCtDkWQjVszKh1W9/B95v6ibamv86kFxn/
	 GAK6yirPXkxUrxXyNpg+VWm5UU9y2N17lEWC2rxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH 6.12 0158/1376] KVM: nVMX: Service local TLB flushes on failed nested VM-Enter
Date: Sat, 12 Sep 2026 08:43:04 +0200
Message-ID: <20260912065611.072331389@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Yosry Ahmed <yosry@kernel.org>

commit 05a0b701d1089fb57beeb8982f23c3bbafe0fa8b upstream.

KVM services local TLB flushes on "full" nested VM-Exits (through
__nested_vmx_vmexit()), but not if a nested VM-Enter fails (e.g. due to
failed VMCS checks in nested_vmx_enter_non_root_mode()).

However, it is possible that KVM had queued TLB flushes that need to be
performed, even if the nested VM-Enter was not successful. For example,
if VPID is disabled for L2 (via nested_vmx_transition_tlb_flush(), or if
via the MSR load lists, as the SDM says:

  If any MSR is being loaded in such a way that would architecturally
  require a TLB flush, the TLBs are updated so that, after VM entry, the
  logical processor will not use any translations that were cached before
  the transition.

The SDM is unclear about when the TLB flush should occur, and whether or
not a failed VM entry would flush the TLB, so it is safer to always
do the TLB flush in this case.

More concretely, KVM also updates the last VPID L1 used for L2 in
nested_vmx_transition_tlb_flush() (i.e. last_vpid), even if the VM entry
ultimately fails. With the current code, KVM could miss a TLB flush if
L1 changes L2's VPID, then does a failed VM entry followed by a
successful one, as the failed VM entry would update last_vpid but not
actually flush the TLB. Servicing local TLB flushes on failed VM entries
makes sure that the TLB is always flushed when last_vpid is updated.

Fixes: 5c614b3583e7 ("KVM: nVMX: nested VPID emulation")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org> # Internal review
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
Link: https://patch.msgid.link/20260722230128.1587363-1-yosry@kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/nested.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3670,6 +3670,14 @@ enum nvmx_vmentry_status nested_vmx_ente
 vmentry_fail_vmexit_guest_mode:
 	if (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETTING)
 		vcpu->arch.tsc_offset -= vmcs12->tsc_offset;
+
+	/*
+	 * Handle any TLB flush requests that were queued for L2 if KVM made it
+	 * far enough along to switch to L2 context.  Note, loading host state
+	 * will generate any flushes for L1 required by VM-Exit.
+	 */
+	kvm_service_local_tlb_flush_requests(vcpu);
+
 	leave_guest_mode(vcpu);
 
 vmentry_fail_vmexit:


