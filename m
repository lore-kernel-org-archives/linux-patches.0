Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F850345EA7;
	Sat, 12 Sep 2026 15:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228270; cv=none; b=UOFl75cO0aGfqbJOd9742SkgtdI7drQa8sg63egN0Hcp9jsAPfjCpN60C63MHXZftGquv9N/6ZoaDGTVupSR1ZOUoRGSUcgUge+2A5jadXkt7W2uWg0+XaJK7+Y5EhGmuRu0wAzl0MYhpkylTAVin4pGvwohpq95l9YqemxC0gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228270; c=relaxed/simple;
	bh=Pmef6oYuqi74sXfs/QmkAkEvl/Oj1p+1TQU6omNIazo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KwvwiI3EfEMJ9OL/fP8KzTwRqukVtoZLPeYMrDJ0iaOSxxNe07Y3IuGl08Ia24Qy0E5JqT7yHNN6D2Mglpz26ghhgRSyuxepIbAjnifVSopj2TyxT8TJnNN3m65lOJK35sdBzScvG3aMXOsBFjyL5A5vf9XjCLAqSu+yRlwRdf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yUkkPPkd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yUkkPPkd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F9D1F00898;
	Sat, 12 Sep 2026 15:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228269;
	bh=ay+1/CDiJQqqkB7Z/jG8EGd4HwsLi361Zr9i/9OrXMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yUkkPPkdmAC1a5jPzNbDAbsJdpNm9sEjp9C89WJtk/9qVRbc5P7YQ1wS4klZTKajf
	 Ss+QQYp/u2MbdCNdAN+z0UYjD7pbR7ryWYSj4rhin9hHLgrkV6MIZRPSw10LyZdv1O
	 bsWRy/mURFpuXoHFKg7t6x9ydsJMZysRGrwbAaIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH 6.1 0351/1191] KVM: nVMX: Service local TLB flushes on failed nested VM-Enter
Date: Sat, 12 Sep 2026 08:51:19 +0200
Message-ID: <20260912065556.113104967@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3527,6 +3527,14 @@ enum nvmx_vmentry_status nested_vmx_ente
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


