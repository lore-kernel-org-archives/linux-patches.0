Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5411F34EEEE;
	Tue,  6 Jan 2026 17:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720460; cv=none; b=Oh3+caHh3pZaK9Re1jVhJ9nGBfIIDdrsOYUtXBdDaHPBgCURiJRH2etgjxbeIBZAHJNUrwg4B3BKSrqiu2zCrsdbP4yw1dzsHM/kWCDLNH5Z2s2N0OZm+Ja3Civbbl8bQQFYtFa8tq32xjSLKiejyfoK9Z9p7eZUl4ncniasPvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720460; c=relaxed/simple;
	bh=kAc/DvJ8ADYHlVvgnTi9GZlJcMTvmqjD21imr2avACg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BiLddZjxhpquoriIVIdsH8JsirkArtU/OktTyApdI3EEnW8v+KxkSKNRFPB2sdFog4XrdrmlvAcl4Z3ttjjbruam4dhcBT2L0myDRGnV6L3tCVCXT2IDnjnSD+U+qkulNB8UjKuuc9B/XEgEYWrrC+22AJLnxSvob1mfZyVOwPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AdyyRSHj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AdyyRSHj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFFBCC16AAE;
	Tue,  6 Jan 2026 17:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720460;
	bh=kAc/DvJ8ADYHlVvgnTi9GZlJcMTvmqjD21imr2avACg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AdyyRSHjlnKfB/LV5gc9+dpdpcyG/miVW7ZIVYZlWbXRMKHGP+TMEUpZf7w+o3A76
	 tAZzBdcEQAiNKYlpEy0Jf+RPoS5PkDRQqwtUWGBook4LtqLYFIt3kT3ibeGJBfXAyz
	 EchLK5BSrLivKEKiOPgKX0tWF/qsIbVZ4vCkub4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Potapenko <glider@google.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.12 211/567] KVM: Disallow toggling KVM_MEM_GUEST_MEMFD on an existing memslot
Date: Tue,  6 Jan 2026 17:59:53 +0100
Message-ID: <20260106170459.127664389@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

commit 9935df5333aa503a18de5071f53762b65c783c4c upstream.

Reject attempts to disable KVM_MEM_GUEST_MEMFD on a memslot that was
initially created with a guest_memfd binding, as KVM doesn't support
toggling KVM_MEM_GUEST_MEMFD on existing memslots.  KVM prevents enabling
KVM_MEM_GUEST_MEMFD, but doesn't prevent clearing the flag.

Failure to reject the new memslot results in a use-after-free due to KVM
not unbinding from the guest_memfd instance.  Unbinding on a FLAGS_ONLY
change is easy enough, and can/will be done as a hardening measure (in
anticipation of KVM supporting dirty logging on guest_memfd at some point),
but fixing the use-after-free would only address the immediate symptom.

  ==================================================================
  BUG: KASAN: slab-use-after-free in kvm_gmem_release+0x362/0x400 [kvm]
  Write of size 8 at addr ffff8881111ae908 by task repro/745

  CPU: 7 UID: 1000 PID: 745 Comm: repro Not tainted 6.18.0-rc6-115d5de2eef3-next-kasan #3 NONE
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  Call Trace:
   <TASK>
   dump_stack_lvl+0x51/0x60
   print_report+0xcb/0x5c0
   kasan_report+0xb4/0xe0
   kvm_gmem_release+0x362/0x400 [kvm]
   __fput+0x2fa/0x9d0
   task_work_run+0x12c/0x200
   do_exit+0x6ae/0x2100
   do_group_exit+0xa8/0x230
   __x64_sys_exit_group+0x3a/0x50
   x64_sys_call+0x737/0x740
   do_syscall_64+0x5b/0x900
   entry_SYSCALL_64_after_hwframe+0x4b/0x53
  RIP: 0033:0x7f581f2eac31
   </TASK>

  Allocated by task 745 on cpu 6 at 9.746971s:
   kasan_save_stack+0x20/0x40
   kasan_save_track+0x13/0x50
   __kasan_kmalloc+0x77/0x90
   kvm_set_memory_region.part.0+0x652/0x1110 [kvm]
   kvm_vm_ioctl+0x14b0/0x3290 [kvm]
   __x64_sys_ioctl+0x129/0x1a0
   do_syscall_64+0x5b/0x900
   entry_SYSCALL_64_after_hwframe+0x4b/0x53

  Freed by task 745 on cpu 6 at 9.747467s:
   kasan_save_stack+0x20/0x40
   kasan_save_track+0x13/0x50
   __kasan_save_free_info+0x37/0x50
   __kasan_slab_free+0x3b/0x60
   kfree+0xf5/0x440
   kvm_set_memslot+0x3c2/0x1160 [kvm]
   kvm_set_memory_region.part.0+0x86a/0x1110 [kvm]
   kvm_vm_ioctl+0x14b0/0x3290 [kvm]
   __x64_sys_ioctl+0x129/0x1a0
   do_syscall_64+0x5b/0x900
   entry_SYSCALL_64_after_hwframe+0x4b/0x53

Reported-by: Alexander Potapenko <glider@google.com>
Fixes: a7800aa80ea4 ("KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for guest-specific backing memory")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20251202020334.1171351-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/kvm/kvm_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2062,7 +2062,7 @@ int __kvm_set_memory_region(struct kvm *
 			return -EINVAL;
 		if ((mem->userspace_addr != old->userspace_addr) ||
 		    (npages != old->npages) ||
-		    ((mem->flags ^ old->flags) & KVM_MEM_READONLY))
+		    ((mem->flags ^ old->flags) & (KVM_MEM_READONLY | KVM_MEM_GUEST_MEMFD)))
 			return -EINVAL;
 
 		if (base_gfn != old->base_gfn)


