Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2FB44330D;
	Tue, 21 Jul 2026 22:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673102; cv=none; b=KMJhbr2r+QyNHN8IoU2ekMzXDLI4Coet2ECS8cysFWpJjiZPnLm8w4cJ0iuHtTEpG4BQNALbP1fILKHfF4n5YL24OVekjHClDz7JDMZXoQag2j6FDRbd6kG9wq/SOrX0medwzDcGk5IlyIQj+7us9kshvOd/mA60U6fF0Pu+apM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673102; c=relaxed/simple;
	bh=cEgOS1SnXHNBsKuOb8UF3nESORB22sVkv7z971yNmPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T8CyjOByvJH0v+qK7xuheEcVbrEl0UpfOvSXxPnVz8vutWSdBbIbppv8vHFNGjYp28en9O2xXYgQiksWeI41tOxoaXbL7cYLa1yKVDfsm7AMEfC4tAmi52CM0aNd86I5ifNiI9dZzRrf90zL4H39CvuANTVYKh8bqlOBpHI2roY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wDfjVSPC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wDfjVSPC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D4021F000E9;
	Tue, 21 Jul 2026 22:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673100;
	bh=yuqvXYbTR3rgiecLyguYwOhWkJS8a/SePdRaFPz+Z6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wDfjVSPCpRoCgoskm6PHnVH/lAZFZdKMEeRauFxFPtwIZZAplpHwqy8p4571Ln0gq
	 mYCNIXMdFanptA234h522pDCJ78cM1Q1b5Xmnks1s27dCde0c1ZRE2R5IzAqM/UdW2
	 re12yEl4+M9iMXgt50mBvHlDUVM68CcVYVSn6Kf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Darshit Shah <darnshah@amazon.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 009/699] KVM: Replace guest-triggerable BUG_ON() in ioeventfd datamatch with get_unaligned()
Date: Tue, 21 Jul 2026 17:16:08 +0200
Message-ID: <20260721152355.889124723@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit f1edbed787ba67988ed34e0132ca128b052b6ce8 upstream.

Drop a BUG_ON() that has been reachable since it was first added, way back
in 2009, and instead use get_unaligned() to perform potentially-unaligned
accesses.

For a given store, KVM x86's emulator tracks the entire value in the
destination operand, x86_emulate_ctxt.dst.  If the destination is memory,
and the target splits multiple pages and/or is emulated MMIO, then KVM
handles each fragment independently.  E.g. on a page split starting at page
offset 0xffc, KVM writes 4 bytes to the first page, then the remaining
bytes to the second page, using ctxt->dst as the source for both (with
appropriate offsets).

If the destination splits a page *and* hits emulated MMIO on the second
page, then KVM will complete the write to the first page, then emulate the
MMIO access to the second page.  If there is a datamatch-enabled ioeventfd
at offset 0 of the second page, then KVM will process the remainder of the
store as a potential ioeventfd signal.

Putting it all together, if the guest emits a store that splits a page
starting at page offset N, and the second page has a datamatch-enabled
ioeventfd at offset 0, then KVM will check for datamatch using
&dst.valptr[N] as the source.  Due to dst (and thus dst.valptr) being
32-byte aligned, if N is not aligned to @len, the BUG_ON() fires.

E.g. with a 16-byte store at page offset 0xffc, to an ioeventfd of len 8,
all initial checks in ioeventfd_in_range() will succeed, and the BUG_ON()
fires due to @val being 4-byte aligned, but not 8-byte aligned.

  ------------[ cut here ]------------
  kernel BUG at arch/x86/kvm/../../../virt/kvm/eventfd.c:783!
  Oops: invalid opcode: 0000 [#1] SMP
  CPU: 0 UID: 1000 PID: 615 Comm: repro Not tainted 7.1.0-rc2-ff238429d1ea #365 PREEMPT
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  RIP: 0010:ioeventfd_write+0x6c/0x70 [kvm]
  Call Trace:
   <TASK>
   __kvm_io_bus_write+0x85/0xb0 [kvm]
   kvm_io_bus_write+0x53/0x80 [kvm]
   vcpu_mmio_write+0x66/0xf0 [kvm]
   emulator_read_write_onepage+0x12a/0x540 [kvm]
   emulator_read_write+0x109/0x2b0 [kvm]
   x86_emulate_insn+0x4f8/0xfb0 [kvm]
   x86_emulate_instruction+0x181/0x790 [kvm]
   kvm_mmu_page_fault+0x313/0x630 [kvm]
   vmx_handle_exit+0x18a/0x590 [kvm_intel]
   kvm_arch_vcpu_ioctl_run+0xc81/0x1c90 [kvm]
   kvm_vcpu_ioctl+0x2d5/0x970 [kvm]
   __x64_sys_ioctl+0x8a/0xd0
   do_syscall_64+0xb7/0x890
   entry_SYSCALL_64_after_hwframe+0x4b/0x53
  RIP: 0033:0x7f19c931a9bf
   </TASK>
  Modules linked in: kvm_intel kvm irqbypass
  ---[ end trace 0000000000000000 ]---

In a perfect world, the fix would be to simply delete the BUG_ON(), as KVM
x86 doesn't perform alignment checks on "normal" memory accesses at CPL0.
Sadly, C99 ruins all the fun; while the x86 architecture plays nice,
dereferencing an unaligned pointer directly is undefined behavior in C,
e.g. triggers splats when running with CONFIG_UBSAN_ALIGNMENT=y.

Fixes: d34e6b175e61 ("KVM: add ioeventfd support")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20260612225241.678509-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[ Use the old <asm/unaligned.h> header instead ]
Signed-off-by: Darshit Shah <darnshah@amazon.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 virt/kvm/eventfd.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 4702b71aad0831..ff0ef5f7246e93 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -24,6 +24,7 @@
 #include <linux/slab.h>
 #include <linux/seqlock.h>
 #include <linux/irqbypass.h>
+#include <asm/unaligned.h>
 #include <trace/events/kvm.h>
 
 #include <kvm/iodev.h>
@@ -695,21 +696,18 @@ ioeventfd_in_range(struct _ioeventfd *p, gpa_t addr, int len, const void *val)
 		return true;
 
 	/* otherwise, we have to actually compare the data */
-
-	BUG_ON(!IS_ALIGNED((unsigned long)val, len));
-
 	switch (len) {
 	case 1:
-		_val = *(u8 *)val;
+		_val = get_unaligned((u8 *)val);
 		break;
 	case 2:
-		_val = *(u16 *)val;
+		_val = get_unaligned((u16 *)val);
 		break;
 	case 4:
-		_val = *(u32 *)val;
+		_val = get_unaligned((u32 *)val);
 		break;
 	case 8:
-		_val = *(u64 *)val;
+		_val = get_unaligned((u64 *)val);
 		break;
 	default:
 		return false;
-- 
2.53.0



