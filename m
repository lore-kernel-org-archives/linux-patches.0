Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACD5B47884E;
	Fri,  7 Aug 2026 15:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117166; cv=none; b=IsDCWxWd+T9aRVYYHT4TypKb09s1yUiWkYChnjMM3QEb473mB9+vQyUmHg6WjSgkRZ/nQSHXw9f6dCX69LSWY6MzajpkRckcvUlqmUG8GGKCKgEMR+471XPPAydbFDKUJxpVuXTYJcIcRLaEUFUhtT4/oCPHtUuAHADmFAOLvpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117166; c=relaxed/simple;
	bh=ScsEFBRLeewzaGRCKernRfVWbFb4W7gWIHEm2eb9cMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bPKBGI/RoyDypHJG1/5FR4jCs1/wqeuJEPG3d0zE4P9G7QaOBovtR8nLz32v3owVyaT2tcWMgIof2aFcJTBdyfr7jKJwcEejTLIvQOoNGlA6By5tHxmEHpvUh0+QoyAg+vjktaDUBJnb/wmXVHP+7tPgCQdH10xCEq4ACwZDvho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dx+UiOKE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dx+UiOKE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8C511F000E9;
	Fri,  7 Aug 2026 15:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117165;
	bh=YJ/uLKeuVEPalQYMvpPdZ55LpmD0E5kncZagAD3h4ws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dx+UiOKE1vMIQeqrjya9oR9FAk3x4nEejDeQV3Ob6RpukBEapMwbU1EBF7pFWX6yZ
	 rnFzZsiruImn1IlWO+agSBPSqXwRGybCE2lEfAKyZqLF68uoXCI9Ilv6O1k5anciaj
	 gNarZYoFY7wMrwWoefMBEs4bhLqVeIcuZHHHOdVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zdi-disclosures@trendmicro.com,
	Zhong Wang <wangzhong.c0ss4ck@bytedance.com>,
	Xuanqing Shi <shixuanqing.11@bytedance.com>,
	Weiming Shi <bestswngs@gmail.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 7.1 224/438] KVM: x86: Cancel delayed I/O APIC EOI handling before destroying vCPUs
Date: Fri,  7 Aug 2026 16:37:00 +0200
Message-ID: <20260807143432.780466571@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weiming Shi <bestswngs@gmail.com>

commit 9910e835580fef3bef53b70241dd00c4bffad693 upstream.

Cancel (and flush) the I/O APIC's delayed EOI handling work during the
"pre VM destroy" phase, before vCPUs are destroyed, as processing the EOI
broadcast will inject another IRQ if the line is asserted, i.e. will try
to deliver an IRQ to the target vCPU(s).  Canceling the work after vCPUs
are destroyed leads to UAF if the delayed work is processed after vCPUs are
destroyed.

  BUG: KASAN: slab-use-after-free in __kvm_irq_delivery_to_apic_fast+0x9bf/0xa20 arch/x86/kvm/lapic.c:1250
  Read of size 8 at addr ffff8880499abea0 by task kworker/1:2/1218

  CPU: 1 UID: 0 PID: 1218 Comm: kworker/1:2 Not tainted 7.1.0-rc7 #5 PREEMPT(lazy)
  Hardware name: QEMU Ubuntu 25.10 PC v2 (i440FX + PIIX, + 10.1 machine, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
  Workqueue: events kvm_ioapic_eoi_inject_work
  Call Trace:
   <TASK>
   __dump_stack lib/dump_stack.c:94
   dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
   print_address_description mm/kasan/report.c:378
   print_report+0x139/0x4ad mm/kasan/report.c:482
   kasan_report+0xe4/0x1d0 mm/kasan/report.c:595
   __kvm_irq_delivery_to_apic_fast+0x9bf/0xa20 arch/x86/kvm/lapic.c:1250
   __kvm_irq_delivery_to_apic+0xd8/0xbf0 arch/x86/kvm/lapic.c:1345
   kvm_irq_delivery_to_apic arch/x86/kvm/lapic.h:129
   ioapic_service+0x308/0x590 arch/x86/kvm/ioapic.c:492
   kvm_ioapic_eoi_inject_work+0x13c/0x190 arch/x86/kvm/ioapic.c:532
   process_one_work+0xa59/0x19a0 kernel/workqueue.c:3314
   process_scheduled_works kernel/workqueue.c:3397
   worker_thread+0x5eb/0xe50 kernel/workqueue.c:3478
   kthread+0x370/0x450 kernel/kthread.c:436
   ret_from_fork+0x72b/0xd30 arch/x86/kernel/process.c:158
   ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
   </TASK>

Note, the VM is unreachable once kvm_destroy_vm() starts, and scheduling
new work via kvm_ioapic_send_eoi() can only be done via KVM_RUN, i.e.
requires a live vCPU.

Alternatively, KVM could simply destroy the I/O APIC during the "pre" phase
of VM destruction, but that gets more than a bit sketchy as KVM expects the
I/O APIC to exist if ioapic_in_kernel() is true, and nested virtualization
in particular has a bad habit of touching VM-scope state during vCPU
destruction.  E.g. attempting to free the PIC during the pre phase would
lead to a NULL pointer dereference in kvm_cpu_has_extint(), and it's not
hard to imagine the I/O APIC having a similar flaw.

Fixes: 17bcd7144263 ("KVM: x86: Free vCPUs before freeing VM state")
Reported-by: <zdi-disclosures@trendmicro.com>
Reported-by: Zhong Wang <wangzhong.c0ss4ck@bytedance.com>
Reported-by: Xuanqing Shi <shixuanqing.11@bytedance.com>
Cc: stable@vger.kernel.org
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20260727171718.543491-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13460,9 +13460,15 @@ void kvm_arch_pre_destroy_vm(struct kvm
 	 * iterating over vCPUs in a different task while vCPUs are being freed
 	 * is unsafe, i.e. will lead to use-after-free.  The PIT also needs to
 	 * be stopped before IRQ routing is freed.
+	 *
+	 * Do NOT free the in-kernel PIC or I/O APIC here (but as above, make
+	 * sure to flush any background work), as KVM expects interrupt routing
+	 * structures to be valid until vCPUs are destroyed.
 	 */
 #ifdef CONFIG_KVM_IOAPIC
 	kvm_free_pit(kvm);
+	if (kvm->arch.vioapic)
+		cancel_delayed_work_sync(&kvm->arch.vioapic->eoi_inject);
 #endif
 
 	kvm_mmu_pre_destroy_vm(kvm);


