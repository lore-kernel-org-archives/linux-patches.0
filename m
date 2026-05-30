Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A32D175A6B;
	Sat, 30 May 2026 18:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164840; cv=none; b=eh1PNtraiXdAPbkjrq1fAK6hc9/kErSz+Mn+ivcalJTlt0I8BPv+oBiy4rt9A9L361Vct9IokISyaEQ9zhxiHsRU3JV3Yb+4h7KVC69Ip8vUFJ4YYskI5P1CTw42aHUJDO3EC3xRUoD6nze+HP5+UzEIrkRNK9kZVOscVtYVgV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164840; c=relaxed/simple;
	bh=llQGFZ8m7hQCYaJZHjoF+brNjeXoOvFzjg7UlYJ6Hzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u5ox0OoxtU/4owQR2pLBERBGHaIVFIJZPFMUXTLJFq/s3oDxyrPDRp2Uy6KrmkjMjEt5k50dIo0I2k1PGNAIEPpkV20K6eveyKU3b7SuokUBikPYK2lSxoDPct0N6F7EN4H1nMnjU6XeZP+dcQqPKbvHypifn5BpKFhMCt3hpL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XRR/2T9t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XRR/2T9t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53F701F00893;
	Sat, 30 May 2026 18:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164838;
	bh=KyAwBUUklYopZTOp6GdBw6rbzoi77B248/0COAReGSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XRR/2T9tzXy+VXG3qW3To5visWDyG/kUbAOfCDtOSgvQ/Z0bWUzz8CDBH4mnw0C16
	 ZvPEyT5yDTgUaAmX2cz/wfNIjXVENQkoYbQFpgiO+hIQb0IMwhDnCyRxx9ovOqIW9t
	 amaZ7XM9txHgsgxxplv1bT00/g8DoJ1WqKLkipsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Rajani Kantha <681739313@139.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 674/776] KVM: x86: Acquire SRCU in KVM_GET_MP_STATE to protect guest memory accesses
Date: Sat, 30 May 2026 18:06:28 +0200
Message-ID: <20260530160257.286652982@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ Based on kernel 5.15 available functions, using srcu_read_lock/srcu_read_unlock instead of
kvm_vcpu_srcu_read_lock/kvm_vcpu_srcu_read_unlock ]
Signed-off-by: Rajani Kantha <681739313@139.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a22cd6c0eb0d4..bbfc8ccf4fcd9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10617,6 +10617,8 @@ int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
 	if (kvm_mpx_supported())
 		kvm_load_guest_fpu(vcpu);
 
+	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
+
 	r = kvm_apic_accept_events(vcpu);
 	if (r < 0)
 		goto out;
@@ -10630,6 +10632,8 @@ int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
 		mp_state->mp_state = vcpu->arch.mp_state;
 
 out:
+	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
+
 	if (kvm_mpx_supported())
 		kvm_put_guest_fpu(vcpu);
 	vcpu_put(vcpu);
-- 
2.53.0



