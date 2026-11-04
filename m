Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829216;
	b=yHFQv7z69CJuo92jJeWw8Y/9rUMk0crA7+a6EkbRx6ibmUCejrD2WoS/NFgWiL1dDGxi
	 y/aUKEJ+xvjAI3yEG9RxnjIHTu6NpvZ+Vsktc2nQKziuroxB14WKtvLgevJtXiJlCc1TS
	 a6zk8JKx73I70kgypMRo4ZnzwI1atKgO0OlbOxYJjvfRnBm/doUHNeMrfPJuu9cvhhwb5
	 Ch7GgVmckV/mVJb7skBjzz9URkDMpd37WMFRr0ibM/7E2/sas4z4Y9VjlzU91MyGAPVWG
	 vjOydU+/zjl/XtMN0GpajF28jRxVw+od6kGdJf1IU4pd59uYOLYf08XvwHgV3Hq0Qbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829216;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dlFgcRgRBqBeHByj51RbtdySKPUtNoJ40vu3mosPVy8=;
	b=0OMVTfjYAN4mY1SMTqSYMs57Y3ho8X7FTBwhh5WaQVTvKy5GI7Lv/xrQHpTiBQIPG+81
	 J7TQZXUK4e5QK7SBimeKA14I3d8XltolipaG8PmXZppyWZESvmD+jpK4REsQTvLbba106
	 0S7gDaG2PoLvG842Nwf8MIAHMeMQTTLH4fLZ08viqJ2VkLa5pGfcKYjg6MfnlA6ZKNTm2
	 kDn0ne4n26Ii/PB1HWF5kbv8bl72IsvpCdjsb/0Lc8rdBM8iT14WnW/x5jv+0kq1R/QJ+
	 fuTujvtwmtxhuFldvZjfAEuBLJK8ToI/VXpnLn7DlRvrg6gnzaQaxe/U2oB1g2V9yHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IFr64U8N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A40736070A88;
	Wed,  4 Nov 2026 21:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IFr64U8N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26AE11F00A18;
	Wed,  4 Nov 2026 21:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829215;
	bh=dlFgcRgRBqBeHByj51RbtdySKPUtNoJ40vu3mosPVy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IFr64U8NASNmNEvky62mfwiERLXVcQ10D5dIbxp4fMEbIzk/o+Vz/n3oODM+/61xr
	 Knu7yOlNVXqNLB4zbhVfSdp8ceKmpEcTNtc9c7CQ3nulUAs2x++3CVco1OCbx42YfG
	 bDMA4RmwAeXAx+lp8va0uzmHa/KZvVAvfJPxlfs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Machhiwal <amachhiw@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 7.3 481/547] KVM: PPC: Book3S HV: Add preempt_disable() around virtual-mode HPTE bit-lock users
Date: Wed,  4 Nov 2026 16:11:05 -0500
Message-ID: <20261104211052.041001178@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amit Machhiwal <amachhiw@linux.ibm.com>

commit abbbe5ff83e7c9ed3a4d61b73011f1df7bf87907 upstream.

kvmppc_hv_find_lock_hpte() requires virtual-mode callers to run with
preemption disabled, because it can return with HPTE_V_HVLOCK still held
until the caller later unlocks the HPTE.  Existing virtual-mode callers
in book3s_64_mmu_hv.c already follow that rule.

Two virtual-mode call paths do not:

1. kvmppc_handle_exit_hv() calls kvmppc_hpte_hv_fault() for hash-mode
   data-side and instruction-side faults after guest exit, with
   preemption already enabled.  kvmppc_hpte_hv_fault() calls
   kvmppc_hv_find_lock_hpte() directly.

2. kvmppc_pseries_do_hcall() executes virtual-mode handlers for HPT
   hcalls via kvmppc_pseries_do_hpt_hcall() with preemption enabled.
   The handlers for H_ENTER, H_REMOVE, H_READ, H_CLEAR_MOD, H_CLEAR_REF,
   H_PROTECT, and H_BULK_REMOVE spin on try_lock_hpte() or lock_rmap(),
   and H_ENTER also reaches kvmppc_do_h_enter(), which uses
   arch_spin_lock() on kvm->mmu_lock.  That raw lock choice is
   intentional because kvmppc_do_h_enter() is also used by real-mode
   callers, so the correct fix is to establish the proper preemption
   context at the virtual-mode caller boundary.

If a vCPU thread is preempted while holding HPTE_V_HVLOCK, any other
thread on the same CPU trying to acquire the same bit-lock can spin
indefinitely.  The same applies to lock_rmap() users and to the H_ENTER
path while holding the raw mmu_lock.

Fix this by adding preempt_disable()/preempt_enable() pairs around the
two kvmppc_hpte_hv_fault() call sites in kvmppc_handle_exit_hv(), and
around the kvmppc_pseries_do_hpt_hcall() invocation in
kvmppc_pseries_do_hcall().  Targeting only the HPT hcall helper avoids
wrapping non-HPT hcalls (such as H_RTAS, H_CONFER, H_REGISTER_VPA) that
perform page faults, blocking memory allocations, or context switches.

Fixes: 6165d5dd99db ("KVM: PPC: Book3S HV: add virtual mode handlers for HPT hcalls and page faults")
Cc: stable@vger.kernel.org # v5.14+
Signed-off-by: Amit Machhiwal <amachhiw@linux.ibm.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260928122837.8782-3-amachhiw@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kvm/book3s_hv.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -1212,9 +1212,11 @@ int kvmppc_pseries_do_hcall(struct kvm_v
 	case H_CLEAR_REF:
 	case H_PROTECT:
 	case H_BULK_REMOVE:
+		preempt_disable();
 		idx = srcu_read_lock(&kvm->srcu);
 		ret = kvmppc_pseries_do_hpt_hcall(vcpu, req);
 		srcu_read_unlock(&kvm->srcu, idx);
+		preempt_enable();
 		if (ret == H_TOO_HARD)
 			return RESUME_HOST;
 		break;
@@ -1834,8 +1836,10 @@ static int kvmppc_handle_exit_hv(struct
 		else
 			vsid = vcpu->arch.fault_gpa;
 
+		preempt_disable();
 		err = kvmppc_hpte_hv_fault(vcpu, vcpu->arch.fault_dar,
 				vsid, vcpu->arch.fault_dsisr, true);
+		preempt_enable();
 		if (err == 0) {
 			r = RESUME_GUEST;
 		} else if (err == -1 || err == -2) {
@@ -1881,8 +1885,10 @@ static int kvmppc_handle_exit_hv(struct
 		else
 			vsid = vcpu->arch.fault_gpa;
 
+		preempt_disable();
 		err = kvmppc_hpte_hv_fault(vcpu, vcpu->arch.fault_dar,
 				vsid, vcpu->arch.fault_dsisr, false);
+		preempt_enable();
 		if (err == 0) {
 			r = RESUME_GUEST;
 		} else if (err == -1) {


