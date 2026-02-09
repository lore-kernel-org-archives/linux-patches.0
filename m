Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D7B125B2;
	Mon,  9 Feb 2026 14:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647761; cv=none; b=C3Z7fS2aUVqt0qnhcXFqoG5ijolcnYNwFaUiNNIcrZTTwPyP4qW4KpC+KYxwJ7aoGLsG4uJqMNQv4wWjhEkM1ByyU0OnprYZ0Ns5wcsDzMhQvmltJ6FmS5DBhNYeJA/5KUrTJV/OfLmYmJ/kKxBmklysKRpwSQnby3BTx6KJd6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647761; c=relaxed/simple;
	bh=EQjgOn9aodS8F3suKP3tdZU4ILe1/R3p2t7M5W5YOFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pg3JcU808NSYA7aPpRaPYfPBj9kAJ2e9HQYdK2NhkgsKWocmRI4ZkQs0cfU+Zr1koGo2kUK50QJRd4DVShHTD7h2LD7/yoK1YLGU1BJxNM4jwiwEarauveG227Vn9x9kPddtsC9cvomCNve/7CVAOwzrPbkCgHLd8JYJn5TjDHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y4Y0yJN6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y4Y0yJN6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9DC3C116C6;
	Mon,  9 Feb 2026 14:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647761;
	bh=EQjgOn9aodS8F3suKP3tdZU4ILe1/R3p2t7M5W5YOFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y4Y0yJN6g6XD0FFCkIBiHmrH9WExQsYrdZ0k1Le1oYBXSVDc4oIRIyviPk4i16+6j
	 ztIS+NY/0bdrqIndYlaGzfU94E4Y63zxh2TsUO7g59VMURGtmn1h/NF0RXZzKqKF7g
	 PL511uNYjtpfAM7WM0ZZ8Me3WJ1dU94gQ6LVEUPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.12 020/113] KVM: Dont clobber irqfd routing type when deassigning irqfd
Date: Mon,  9 Feb 2026 15:22:49 +0100
Message-ID: <20260209142310.936877761@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
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

commit b4d37cdb77a0015f51fee083598fa227cc07aaf1 upstream.

When deassigning a KVM_IRQFD, don't clobber the irqfd's copy of the IRQ's
routing entry as doing so breaks kvm_arch_irq_bypass_del_producer() on x86
and arm64, which explicitly look for KVM_IRQ_ROUTING_MSI.  Instead, to
handle a concurrent routing update, verify that the irqfd is still active
before consuming the routing information.  As evidenced by the x86 and
arm64 bugs, and another bug in kvm_arch_update_irqfd_routing() (see below),
clobbering the entry type without notifying arch code is surprising and
error prone.

As a bonus, checking that the irqfd is active provides a convenient
location for documenting _why_ KVM must not consume the routing entry for
an irqfd that is in the process of being deassigned: once the irqfd is
deleted from the list (which happens *before* the eventfd is detached), it
will no longer receive updates via kvm_irq_routing_update(), and so KVM
could deliver an event using stale routing information (relative to
KVM_SET_GSI_ROUTING returning to userspace).

As an even better bonus, explicitly checking for the irqfd being active
fixes a similar bug to the one the clobbering is trying to prevent: if an
irqfd is deactivated, and then its routing is changed,
kvm_irq_routing_update() won't invoke kvm_arch_update_irqfd_routing()
(because the irqfd isn't in the list).  And so if the irqfd is in bypass
mode, IRQs will continue to be posted using the old routing information.

As for kvm_arch_irq_bypass_del_producer(), clobbering the routing type
results in KVM incorrectly keeping the IRQ in bypass mode, which is
especially problematic on AMD as KVM tracks IRQs that are being posted to
a vCPU in a list whose lifetime is tied to the irqfd.

Without the help of KASAN to detect use-after-free, the most common
sympton on AMD is a NULL pointer deref in amd_iommu_update_ga() due to
the memory for irqfd structure being re-allocated and zeroed, resulting
in irqfd->irq_bypass_data being NULL when read by
avic_update_iommu_vcpu_affinity():

  BUG: kernel NULL pointer dereference, address: 0000000000000018
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 40cf2b9067 P4D 40cf2b9067 PUD 408362a067 PMD 0
  Oops: Oops: 0000 [#1] SMP
  CPU: 6 UID: 0 PID: 40383 Comm: vfio_irq_test
  Tainted: G     U  W  O        6.19.0-smp--5dddc257e6b2-irqfd #31 NONE
  Tainted: [U]=USER, [W]=WARN, [O]=OOT_MODULE
  Hardware name: Google, Inc. Arcadia_IT_80/Arcadia_IT_80, BIOS 34.78.2-0 09/05/2025
  RIP: 0010:amd_iommu_update_ga+0x19/0xe0
  Call Trace:
   <TASK>
   avic_update_iommu_vcpu_affinity+0x3d/0x90 [kvm_amd]
   __avic_vcpu_load+0xf4/0x130 [kvm_amd]
   kvm_arch_vcpu_load+0x89/0x210 [kvm]
   vcpu_load+0x30/0x40 [kvm]
   kvm_arch_vcpu_ioctl_run+0x45/0x620 [kvm]
   kvm_vcpu_ioctl+0x571/0x6a0 [kvm]
   __se_sys_ioctl+0x6d/0xb0
   do_syscall_64+0x6f/0x9d0
   entry_SYSCALL_64_after_hwframe+0x4b/0x53
  RIP: 0033:0x46893b
    </TASK>
  ---[ end trace 0000000000000000 ]---

If AVIC is inhibited when the irfd is deassigned, the bug will manifest as
list corruption, e.g. on the next irqfd assignment.

  list_add corruption. next->prev should be prev (ffff8d474d5cd588),
                       but was 0000000000000000. (next=ffff8d8658f86530).
  ------------[ cut here ]------------
  kernel BUG at lib/list_debug.c:31!
  Oops: invalid opcode: 0000 [#1] SMP
  CPU: 128 UID: 0 PID: 80818 Comm: vfio_irq_test
  Tainted: G     U  W  O        6.19.0-smp--f19dc4d680ba-irqfd #28 NONE
  Tainted: [U]=USER, [W]=WARN, [O]=OOT_MODULE
  Hardware name: Google, Inc. Arcadia_IT_80/Arcadia_IT_80, BIOS 34.78.2-0 09/05/2025
  RIP: 0010:__list_add_valid_or_report+0x97/0xc0
  Call Trace:
   <TASK>
   avic_pi_update_irte+0x28e/0x2b0 [kvm_amd]
   kvm_pi_update_irte+0xbf/0x190 [kvm]
   kvm_arch_irq_bypass_add_producer+0x72/0x90 [kvm]
   irq_bypass_register_consumer+0xcd/0x170 [irqbypass]
   kvm_irqfd+0x4c6/0x540 [kvm]
   kvm_vm_ioctl+0x118/0x5d0 [kvm]
   __se_sys_ioctl+0x6d/0xb0
   do_syscall_64+0x6f/0x9d0
   entry_SYSCALL_64_after_hwframe+0x4b/0x53
   </TASK>
  ---[ end trace 0000000000000000 ]---

On Intel and arm64, the bug is less noisy, as the end result is that the
device keeps posting IRQs to the vCPU even after it's been deassigned.

Note, the worst of the breakage can be traced back to commit cb210737675e
("KVM: Pass new routing entries and irqfd when updating IRTEs"), as before
that commit KVM would pull the routing information from the per-VM routing
table.  But as above, similar bugs have existed since support for IRQ
bypass was added.  E.g. if a routing change finished before irq_shutdown()
invoked kvm_arch_irq_bypass_del_producer(), VMX and SVM would see stale
routing information and potentially leave the irqfd in bypass mode.

Alternatively, x86 could be fixed by explicitly checking irq_bypass_vcpu
instead of irq_entry.type in kvm_arch_irq_bypass_del_producer(), and arm64
could be modified to utilize irq_bypass_vcpu in a similar manner.  But (a)
that wouldn't fix the routing updates bug, and (b) fixing core code doesn't
preclude x86 (or arm64) from adding such code as a sanity check (spoiler
alert).

Fixes: f70c20aaf141 ("KVM: Add an arch specific hooks in 'struct kvm_kernel_irqfd'")
Fixes: cb210737675e ("KVM: Pass new routing entries and irqfd when updating IRTEs")
Fixes: a0d7e2fc61ab ("KVM: arm64: vgic-v4: Only attempt vLPI mapping for actual MSIs")
Cc: stable@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Link: https://patch.msgid.link/20260113174606.104978-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/kvm/eventfd.c |   44 ++++++++++++++++++++++++--------------------
 1 file changed, 24 insertions(+), 20 deletions(-)

--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -157,21 +157,28 @@ irqfd_shutdown(struct work_struct *work)
 }
 
 
-/* assumes kvm->irqfds.lock is held */
-static bool
-irqfd_is_active(struct kvm_kernel_irqfd *irqfd)
+static bool irqfd_is_active(struct kvm_kernel_irqfd *irqfd)
 {
+	/*
+	 * Assert that either irqfds.lock or SRCU is held, as irqfds.lock must
+	 * be held to prevent false positives (on the irqfd being active), and
+	 * while false negatives are impossible as irqfds are never added back
+	 * to the list once they're deactivated, the caller must at least hold
+	 * SRCU to guard against routing changes if the irqfd is deactivated.
+	 */
+	lockdep_assert_once(lockdep_is_held(&irqfd->kvm->irqfds.lock) ||
+			    srcu_read_lock_held(&irqfd->kvm->irq_srcu));
+
 	return list_empty(&irqfd->list) ? false : true;
 }
 
 /*
  * Mark the irqfd as inactive and schedule it for removal
- *
- * assumes kvm->irqfds.lock is held
  */
-static void
-irqfd_deactivate(struct kvm_kernel_irqfd *irqfd)
+static void irqfd_deactivate(struct kvm_kernel_irqfd *irqfd)
 {
+	lockdep_assert_held(&irqfd->kvm->irqfds.lock);
+
 	BUG_ON(!irqfd_is_active(irqfd));
 
 	list_del_init(&irqfd->list);
@@ -212,8 +219,15 @@ irqfd_wakeup(wait_queue_entry_t *wait, u
 			seq = read_seqcount_begin(&irqfd->irq_entry_sc);
 			irq = irqfd->irq_entry;
 		} while (read_seqcount_retry(&irqfd->irq_entry_sc, seq));
-		/* An event has been signaled, inject an interrupt */
-		if (kvm_arch_set_irq_inatomic(&irq, kvm,
+
+		/*
+		 * An event has been signaled, inject an interrupt unless the
+		 * irqfd is being deassigned (isn't active), in which case the
+		 * routing information may be stale (once the irqfd is removed
+		 * from the list, it will stop receiving routing updates).
+		 */
+		if (unlikely(!irqfd_is_active(irqfd)) ||
+		    kvm_arch_set_irq_inatomic(&irq, kvm,
 					      KVM_USERSPACE_IRQ_SOURCE_ID, 1,
 					      false) == -EWOULDBLOCK)
 			schedule_work(&irqfd->inject);
@@ -544,18 +558,8 @@ kvm_irqfd_deassign(struct kvm *kvm, stru
 	spin_lock_irq(&kvm->irqfds.lock);
 
 	list_for_each_entry_safe(irqfd, tmp, &kvm->irqfds.items, list) {
-		if (irqfd->eventfd == eventfd && irqfd->gsi == args->gsi) {
-			/*
-			 * This clearing of irq_entry.type is needed for when
-			 * another thread calls kvm_irq_routing_update before
-			 * we flush workqueue below (we synchronize with
-			 * kvm_irq_routing_update using irqfds.lock).
-			 */
-			write_seqcount_begin(&irqfd->irq_entry_sc);
-			irqfd->irq_entry.type = 0;
-			write_seqcount_end(&irqfd->irq_entry_sc);
+		if (irqfd->eventfd == eventfd && irqfd->gsi == args->gsi)
 			irqfd_deactivate(irqfd);
-		}
 	}
 
 	spin_unlock_irq(&kvm->irqfds.lock);


