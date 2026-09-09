Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A6A58125F;
	Wed,  9 Sep 2026 14:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963884; cv=none; b=Q/h5TH8xafpkNEKFN5UmwAAk8TCXDYPs5twfCWS+nCk+4Mvusc3Yyeu46Crvjedfq1+IGCSvrOyXl4PQ6UgswqCaMNi2FQu+MPmwbhkxCL44BnoVkleq859YjBGJTw7J+0Hb0p/RfgQoKn8MsYoO8/dToxbknp6cjBaEz1HqVPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963884; c=relaxed/simple;
	bh=/Rw3Hpbii3258l19vr0icrqUOZAlAgh/rrW4XXnwB2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c5e87SfUeAOMb+Uokd+9UN63GCBbyvCe+otWKW6EI9kFtSxsNmJBFzaGXj1E3HM9OcDSfZAwT6uvnAQ7Jxp8xOHo2kKu0D6tbawx4kI5b9Dm3+0ar9/pXlrJ6rC/hKLjU7X7iucwvT3MQ5iVjoVip7z02rVuuQN+06Ec1+ohQig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZZM3SXfn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZZM3SXfn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D65141F00A3A;
	Wed,  9 Sep 2026 14:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963883;
	bh=ay/9o6Tg2VFq5JBNRokqGqnzgdMr4lgNNGrxKfoFwT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZZM3SXfnLw+d0yiQN1Yw1gxq5Arj8J6y6dECEJ8VOYDprjNEzVhi00aNSiozqV8GJ
	 73Ab5invXIHQuRzXx6KTTJwUpYq2l0GUq/XUAfQdrtohuVZfu/X1E/bVwRosSiFq4e
	 M31GXd/+epWlZy86TAjwBrmzzSrPSHFhoeVhembI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH 6.18 233/583] KVM: nVMX: Service local TLB flushes on failed nested VM-Enter
Date: Wed,  9 Sep 2026 15:38:38 +0200
Message-ID: <20260909134246.226241266@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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
@@ -3801,6 +3801,14 @@ enum nvmx_vmentry_status nested_vmx_ente
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


