Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A894D256C6D;
	Thu, 17 Apr 2025 18:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913636; cv=none; b=hrxtQnAvsfOFP2Ab8h1HWrdyPZ/CCxM1QEtpqhxp5gqnLlLtHBNxVLRWjIdF1x/o464Wc3WuIuL/AQfbtIShAKVo5eUOJJGmCdIWObLDP2JI2kNyFAUPOSMwcPqxm17tVOhZnxEYmWE1T+l3jrdguqz+96Q8RLWhp+43EeErTRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913636; c=relaxed/simple;
	bh=BFfIWSSJVhBFNRNlbGvBV0Nt6hmlrA6noDpmQ34Yr7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DbXkE2lNG9tcpSWzWa/TrEJUizhej7l3b6iR/jH+0bnzzTXZbRDR/naHEpb2Y6KthqUPE3iw9bc5pMyZv+Tf1S7wQCnwXBxgBgXfTQmDuWcqVIHnF7bb8cDI4yQ5E6uwLaLrnBvf7BcMoIidrkeZtfrZaSO9FCRvSlnztjXrD/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ciN65E4x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ciN65E4x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30478C4CEE4;
	Thu, 17 Apr 2025 18:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913636;
	bh=BFfIWSSJVhBFNRNlbGvBV0Nt6hmlrA6noDpmQ34Yr7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ciN65E4xoBPGxo4iWAGP1GUiolWP7mtGadEw+ylcbrPOAWvHgM/7AyRgm2vfneAgb
	 FIH4nRl0gciel2x2PpLzunX1jmDjaAcMk4mfIg5os1VcEOFW6cc7zl7giTj2C36NM2
	 7Pjd6m5/KCW4SotqaWUwNfUoLaA0JFwqdQhf5Rus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.14 404/449] KVM: x86: Acquire SRCU in KVM_GET_MP_STATE to protect guest memory accesses
Date: Thu, 17 Apr 2025 19:51:32 +0200
Message-ID: <20250417175134.528964318@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit ef01cac401f18647d62720cf773d7bb0541827da upstream.

Acquire a lock on kvm->srcu when userspace is getting MP state to handle a
rather extreme edge case where "accepting" APIC events, i.e. processing
pending INIT or SIPI, can trigger accesses to guest memory.  If the vCPU
is in L2 with INIT *and* a TRIPLE_FAULT request pending, then getting MP
state will trigger a nested VM-Exit by way of ->check_nested_events(), and
emuating the nested VM-Exit can access guest memory.

The splat was originally hit by syzkaller on a Google-internal kernel, and
reproduced on an upstream kernel by hacking the triple_fault_event_test
selftest to stuff a pending INIT, store an MSR on VM-Exit (to generate a
memory access on VMX), and do vcpu_mp_state_get() to trigger the scenario.

  =============================
  WARNING: suspicious RCU usage
  6.14.0-rc3-b112d356288b-vmx/pi_lockdep_false_pos-lock #3 Not tainted
  -----------------------------
  include/linux/kvm_host.h:1058 suspicious rcu_dereference_check() usage!

  other info that might help us debug this:

  rcu_scheduler_active = 2, debug_locks = 1
  1 lock held by triple_fault_ev/1256:
   #0: ffff88810df5a330 (&vcpu->mutex){+.+.}-{4:4}, at: kvm_vcpu_ioctl+0x8b/0x9a0 [kvm]

  stack backtrace:
  CPU: 11 UID: 1000 PID: 1256 Comm: triple_fault_ev Not tainted 6.14.0-rc3-b112d356288b-vmx #3
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  Call Trace:
   <TASK>
   dump_stack_lvl+0x7f/0x90
   lockdep_rcu_suspicious+0x144/0x190
   kvm_vcpu_gfn_to_memslot+0x156/0x180 [kvm]
   kvm_vcpu_read_guest+0x3e/0x90 [kvm]
   read_and_check_msr_entry+0x2e/0x180 [kvm_intel]
   __nested_vmx_vmexit+0x550/0xde0 [kvm_intel]
   kvm_check_nested_events+0x1b/0x30 [kvm]
   kvm_apic_accept_events+0x33/0x100 [kvm]
   kvm_arch_vcpu_ioctl_get_mpstate+0x30/0x1d0 [kvm]
   kvm_vcpu_ioctl+0x33e/0x9a0 [kvm]
   __x64_sys_ioctl+0x8b/0xb0
   do_syscall_64+0x6c/0x170
   entry_SYSCALL_64_after_hwframe+0x4b/0x53
   </TASK>

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20250401150504.829812-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11773,6 +11773,8 @@ int kvm_arch_vcpu_ioctl_get_mpstate(stru
 	if (kvm_mpx_supported())
 		kvm_load_guest_fpu(vcpu);
 
+	kvm_vcpu_srcu_read_lock(vcpu);
+
 	r = kvm_apic_accept_events(vcpu);
 	if (r < 0)
 		goto out;
@@ -11786,6 +11788,8 @@ int kvm_arch_vcpu_ioctl_get_mpstate(stru
 		mp_state->mp_state = vcpu->arch.mp_state;
 
 out:
+	kvm_vcpu_srcu_read_unlock(vcpu);
+
 	if (kvm_mpx_supported())
 		kvm_put_guest_fpu(vcpu);
 	vcpu_put(vcpu);


