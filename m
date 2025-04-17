Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3341264A78;
	Thu, 17 Apr 2025 18:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914899; cv=none; b=ZnEBGnwOTMG3iRItSqIt9ztamVLoeNphzstKi1dblxb350x43MyCL7LdeEefBbVWuPV3eAKLhJqmC0tHvmbxBMCdKXvaUlwFBywPirbE6tG3q6YBg6zY/r8CRN38TsAGPQE4sXMNyEUOAwIF3DNAenvl1ciJz9YkHVU/gBWEZtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914899; c=relaxed/simple;
	bh=FH1aiKPsmFck4ZLAplkZlnNwoc5EJfb1jtvG4WxJ388=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VDn/Ny7OiyIDeLK3XFDYlIONppYySSe42DvGoS2No6UoZuagSW7lEbzH1bMVeLGIVCuV/jooPR1V0PlDx5vWU+njZvRezJ7hVdo7PFaeu/YFLSQvsMc+o5JjgYzaW5Ex8YdOENQkuEI31ArDgHa16H2w9Eb2KVZk7TtJAV0DTQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WNP7B4cq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WNP7B4cq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 349B7C4CEE4;
	Thu, 17 Apr 2025 18:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914899;
	bh=FH1aiKPsmFck4ZLAplkZlnNwoc5EJfb1jtvG4WxJ388=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WNP7B4cqRqhNQrFuHj0dqKsDc0tb22uM6rwd5Bvvhx0QUKog0drul1f+nlrdMg+t2
	 Pn7wdcRTxQoNVHTVmjWWhk0RVZAKHtBmW7+z1g5BpzXf4TsLrDzKF0Mhiua+SV3EVO
	 2KXtvoiGn5nUhek1i5CqgfKZMxzZuT06Seb/z0LQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.13 367/414] KVM: x86: Acquire SRCU in KVM_GET_MP_STATE to protect guest memory accesses
Date: Thu, 17 Apr 2025 19:52:05 +0200
Message-ID: <20250417175126.225466969@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -11765,6 +11765,8 @@ int kvm_arch_vcpu_ioctl_get_mpstate(stru
 	if (kvm_mpx_supported())
 		kvm_load_guest_fpu(vcpu);
 
+	kvm_vcpu_srcu_read_lock(vcpu);
+
 	r = kvm_apic_accept_events(vcpu);
 	if (r < 0)
 		goto out;
@@ -11778,6 +11780,8 @@ int kvm_arch_vcpu_ioctl_get_mpstate(stru
 		mp_state->mp_state = vcpu->arch.mp_state;
 
 out:
+	kvm_vcpu_srcu_read_unlock(vcpu);
+
 	if (kvm_mpx_supported())
 		kvm_put_guest_fpu(vcpu);
 	vcpu_put(vcpu);


