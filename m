Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD4D13D53B;
	Wed, 30 Jul 2025 09:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868953; cv=none; b=BQpUuwpe9HbBjBaVA5o/Evdk9j/5/S37csDHd7XjJFRVck1LV7bd/+kr4547eHU5Qgvbtjo5iUf8sloYfe49gJQCJvla/Nf+Ntj68HLmp41Jhb7evsVWx5gbH5tfu2FWc12N2CRYpBP+/i4xX7xDAtGSfv+EaGa3KMAIuiiMH+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868953; c=relaxed/simple;
	bh=kr+qoyFHenjK7TIhWZtPHbJND6VKiQPaCtwvfuJ6eNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CTXCasAYK7EXvPZTQPZ/WURS37Ya4+nu4tgwQBVLWYESaX/bIyFUuLD4y/ubKVUQ1FcXAywb4KWeMTV0sRtOE72uObF7uscvOh/HvzNWGBFLVrhY3EbB/eBOpSX1OBEaTnnw/k4xEzo0f2sTXhV3DZjyYQeO+vs85BMT7vxOJ3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hp58H0gq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hp58H0gq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE32BC4CEF5;
	Wed, 30 Jul 2025 09:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868953;
	bh=kr+qoyFHenjK7TIhWZtPHbJND6VKiQPaCtwvfuJ6eNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hp58H0gqKTOmVpyYoZTLyhXtDfzinmyigIXiLtn8Q3rRJ8pNXU9lMSTbpPlyIjShW
	 xy3qINPS3mKlbvBUJc0LGU6u0AVWQWhb0VANHIIn4tafhCQyLLYPfYNK8CT+o8zXLU
	 VBcbqV69673e2KLHrAHgRRDwLGtjSovLFj274Ktg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Lewis <aaronlewis@google.com>,
	Jim Mattson <jmattson@google.com>,
	Yan Zhao <yan.y.zhao@intel.com>,
	Rick P Edgecombe <rick.p.edgecombe@intel.com>,
	Kai Huang <kai.huang@intel.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Kevin Cheng <chengkev@google.com>
Subject: [PATCH 6.12 116/117] KVM: x86: Free vCPUs before freeing VM state
Date: Wed, 30 Jul 2025 11:36:25 +0200
Message-ID: <20250730093238.323882107@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
References: <20250730093233.592541778@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 17bcd714426386fda741a4bccd96a2870179344b upstream.

Free vCPUs before freeing any VM state, as both SVM and VMX may access
VM state when "freeing" a vCPU that is currently "in" L2, i.e. that needs
to be kicked out of nested guest mode.

Commit 6fcee03df6a1 ("KVM: x86: avoid loading a vCPU after .vm_destroy was
called") partially fixed the issue, but for unknown reasons only moved the
MMU unloading before VM destruction.  Complete the change, and free all
vCPU state prior to destroying VM state, as nVMX accesses even more state
than nSVM.

In addition to the AVIC, KVM can hit a use-after-free on MSR filters:

  kvm_msr_allowed+0x4c/0xd0
  __kvm_set_msr+0x12d/0x1e0
  kvm_set_msr+0x19/0x40
  load_vmcs12_host_state+0x2d8/0x6e0 [kvm_intel]
  nested_vmx_vmexit+0x715/0xbd0 [kvm_intel]
  nested_vmx_free_vcpu+0x33/0x50 [kvm_intel]
  vmx_free_vcpu+0x54/0xc0 [kvm_intel]
  kvm_arch_vcpu_destroy+0x28/0xf0
  kvm_vcpu_destroy+0x12/0x50
  kvm_arch_destroy_vm+0x12c/0x1c0
  kvm_put_kvm+0x263/0x3c0
  kvm_vm_release+0x21/0x30

and an upcoming fix to process injectable interrupts on nested VM-Exit
will access the PIC:

  BUG: kernel NULL pointer dereference, address: 0000000000000090
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  CPU: 23 UID: 1000 PID: 2658 Comm: kvm-nx-lpage-re
  RIP: 0010:kvm_cpu_has_extint+0x2f/0x60 [kvm]
  Call Trace:
   <TASK>
   kvm_cpu_has_injectable_intr+0xe/0x60 [kvm]
   nested_vmx_vmexit+0x2d7/0xdf0 [kvm_intel]
   nested_vmx_free_vcpu+0x40/0x50 [kvm_intel]
   vmx_vcpu_free+0x2d/0x80 [kvm_intel]
   kvm_arch_vcpu_destroy+0x2d/0x130 [kvm]
   kvm_destroy_vcpus+0x8a/0x100 [kvm]
   kvm_arch_destroy_vm+0xa7/0x1d0 [kvm]
   kvm_destroy_vm+0x172/0x300 [kvm]
   kvm_vcpu_release+0x31/0x50 [kvm]

Inarguably, both nSVM and nVMX need to be fixed, but punt on those
cleanups for the moment.  Conceptually, vCPUs should be freed before VM
state.  Assets like the I/O APIC and PIC _must_ be allocated before vCPUs
are created, so it stands to reason that they must be freed _after_ vCPUs
are destroyed.

Reported-by: Aaron Lewis <aaronlewis@google.com>
Closes: https://lore.kernel.org/all/20240703175618.2304869-2-aaronlewis@google.com
Cc: Jim Mattson <jmattson@google.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: Kai Huang <kai.huang@intel.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20250224235542.2562848-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Kevin Cheng <chengkev@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12895,11 +12895,11 @@ void kvm_arch_destroy_vm(struct kvm *kvm
 		mutex_unlock(&kvm->slots_lock);
 	}
 	kvm_unload_vcpu_mmus(kvm);
+	kvm_destroy_vcpus(kvm);
 	kvm_x86_call(vm_destroy)(kvm);
 	kvm_free_msr_filter(srcu_dereference_check(kvm->arch.msr_filter, &kvm->srcu, 1));
 	kvm_pic_destroy(kvm);
 	kvm_ioapic_destroy(kvm);
-	kvm_destroy_vcpus(kvm);
 	kvfree(rcu_dereference_check(kvm->arch.apic_map, 1));
 	kfree(srcu_dereference_check(kvm->arch.pmu_event_filter, &kvm->srcu, 1));
 	kvm_mmu_uninit_vm(kvm);


