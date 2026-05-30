Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA6833F590;
	Sat, 30 May 2026 16:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159457; cv=none; b=ImzGRiWtPKzEFqrweJVXCcByMQDHb1rLBerQ0p9mT2QUYS2JceQmnnaqTZ5/C1R48YWAQXphs/dgZiLodTPWoFtca/3ZuRzNiK43zFlSHezatl8KSgWRwfqkmdC8tiihmnp4Xv3ohDWVyRve5gWo4qEFNwieZMGedaioK+8E6Rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159457; c=relaxed/simple;
	bh=+OTss+Z9JkGgb4+q+4RvNWDHgMc0ltysZv9vgX+byxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i50MjYZ2LE9fKAB9AcSlkom+i/tSIQa/hFYYAQXUSeAwcucT9qfTq0WHGp1Fh1awQbaNzYsli6Gtn6/JSuIxZ1qhHHjaHavyAirMbvG9nUoaQDVfLhQ9PFZEVXAqPU5qJzSgZpPspoKyv3cxVVdSopzw1cCJlAW+sa4c8YvCNbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b3S+Ko7M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b3S+Ko7M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D01601F00893;
	Sat, 30 May 2026 16:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780159456;
	bh=5bubg609n7Xee2awU+wsX9EcoMcuof/0mKD/1yoSepM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b3S+Ko7Mr1qpF1Qvd8lzaxd19FXQDFHuv+jiFhM+5QUItfOw6vhsvsoq1Ehco0SQw
	 CGMXaFYj6gavdVeq/605ILWrU/1n+14N2Bu9MlQLgNCCWY6nz4zzbdR/rMWi4qIITN
	 DX7gH0E234pfW4dpNlanYVaZrpGiQEH79R/hTOng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yashu Zhang <zhangjiaji1@huawei.com>,
	Tom Lendacky <thomas.lendacky@gmail.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.1 098/969] KVM: x86: Use scratch field in MMIO fragment to hold small write values
Date: Sat, 30 May 2026 17:53:42 +0200
Message-ID: <20260530160303.035303804@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

commit 0b16e69d17d8c35c5c9d5918bf596c75a44655d3 upstream.

When exiting to userspace to service an emulated MMIO write, copy the
to-be-written value to a scratch field in the MMIO fragment if the size
of the data payload is 8 bytes or less, i.e. can fit in a single chunk,
instead of pointing the fragment directly at the source value.

This fixes a class of use-after-free bugs that occur when the emulator
initiates a write using an on-stack, local variable as the source, the
write splits a page boundary, *and* both pages are MMIO pages.  Because
KVM's ABI only allows for physically contiguous MMIO requests, accesses
that split MMIO pages are separated into two fragments, and are sent to
userspace one at a time.  When KVM attempts to complete userspace MMIO in
response to KVM_RUN after the first fragment, KVM will detect the second
fragment and generate a second userspace exit, and reference the on-stack
variable.

The issue is most visible if the second KVM_RUN is performed by a separate
task, in which case the stack of the initiating task can show up as truly
freed data.

  ==================================================================
  BUG: KASAN: use-after-free in complete_emulated_mmio+0x305/0x420
  Read of size 1 at addr ffff888009c378d1 by task syz-executor417/984

  CPU: 1 PID: 984 Comm: syz-executor417 Not tainted 5.10.0-182.0.0.95.h2627.eulerosv2r13.x86_64 #3
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.15.0-0-g2dd4b9b3f840-prebuilt.qemu.org 04/01/2014 Call Trace:
  dump_stack+0xbe/0xfd
  print_address_description.constprop.0+0x19/0x170
  __kasan_report.cold+0x6c/0x84
  kasan_report+0x3a/0x50
  check_memory_region+0xfd/0x1f0
  memcpy+0x20/0x60
  complete_emulated_mmio+0x305/0x420
  kvm_arch_vcpu_ioctl_run+0x63f/0x6d0
  kvm_vcpu_ioctl+0x413/0xb20
  __se_sys_ioctl+0x111/0x160
  do_syscall_64+0x30/0x40
  entry_SYSCALL_64_after_hwframe+0x67/0xd1
  RIP: 0033:0x42477d
  Code: <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
  RSP: 002b:00007faa8e6890e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
  RAX: ffffffffffffffda RBX: 00000000004d7338 RCX: 000000000042477d
  RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000005
  RBP: 00000000004d7330 R08: 00007fff28d546df R09: 0000000000000000
  R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004d733c
  R13: 0000000000000000 R14: 000000000040a200 R15: 00007fff28d54720

  The buggy address belongs to the page:
  page:0000000029f6a428 refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x9c37
  flags: 0xfffffc0000000(node=0|zone=1|lastcpupid=0x1fffff)
  raw: 000fffffc0000000 0000000000000000 ffffea0000270dc8 0000000000000000
  raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000 page dumped because: kasan: bad access detected

  Memory state around the buggy address:
  ffff888009c37780: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
  ffff888009c37800: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
  >ffff888009c37880: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                                                   ^
  ffff888009c37900: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
  ffff888009c37980: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
  ==================================================================

The bug can also be reproduced with a targeted KVM-Unit-Test by hacking
KVM to fill a large on-stack variable in complete_emulated_mmio(), i.e. by
overwrite the data value with garbage.

Limit the use of the scratch fields to 8-byte or smaller accesses, and to
just writes, as larger accesses and reads are not affected thanks to
implementation details in the emulator, but add a sanity check to ensure
those details don't change in the future.  Specifically, KVM never uses
on-stack variables for accesses larger that 8 bytes, e.g. uses an operand
in the emulator context, and *all* reads are buffered through the mem_read
cache.

Note!  Using the scratch field for reads is not only unnecessary, it's
also extremely difficult to handle correctly.  As above, KVM buffers all
reads through the mem_read cache, and heavily relies on that behavior when
re-emulating the instruction after a userspace MMIO read exit.  If a read
splits a page, the first page is NOT an MMIO page, and the second page IS
an MMIO page, then the MMIO fragment needs to point at _just_ the second
chunk of the destination, i.e. its position in the mem_read cache.  Taking
the "obvious" approach of copying the fragment value into the destination
when re-emulating the instruction would clobber the first chunk of the
destination, i.e. would clobber the data that was read from guest memory.

Fixes: f78146b0f923 ("KVM: Fix page-crossing MMIO")
Suggested-by: Yashu Zhang <zhangjiaji1@huawei.com>
Reported-by: Yashu Zhang <zhangjiaji1@huawei.com>
Closes: https://lore.kernel.org/all/369eaaa2b3c1425c85e8477066391bc7@huawei.com
Cc: stable@vger.kernel.org
Tested-by: Tom Lendacky <thomas.lendacky@gmail.com>
Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Link: https://patch.msgid.link/20260225012049.920665-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c       |   14 +++++++++++++-
 include/linux/kvm_host.h |    3 ++-
 2 files changed, 15 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7628,7 +7628,13 @@ static int emulator_read_write_onepage(u
 	WARN_ON(vcpu->mmio_nr_fragments >= KVM_MAX_MMIO_FRAGMENTS);
 	frag = &vcpu->mmio_fragments[vcpu->mmio_nr_fragments++];
 	frag->gpa = gpa;
-	frag->data = val;
+	if (write && bytes <= 8u) {
+		frag->val = 0;
+		frag->data = &frag->val;
+		memcpy(&frag->val, val, bytes);
+	} else {
+		frag->data = val;
+	}
 	frag->len = bytes;
 	return X86EMUL_CONTINUE;
 }
@@ -7643,6 +7649,9 @@ static int emulator_read_write(struct x8
 	gpa_t gpa;
 	int rc;
 
+	if (WARN_ON_ONCE((bytes > 8u || !ops->write) && object_is_on_stack(val)))
+		return X86EMUL_UNHANDLEABLE;
+
 	if (ops->read_write_prepare &&
 		  ops->read_write_prepare(vcpu, val, bytes))
 		return X86EMUL_CONTINUE;
@@ -11197,6 +11206,9 @@ static int complete_emulated_mmio(struct
 		frag++;
 		vcpu->mmio_cur_fragment++;
 	} else {
+		if (WARN_ON_ONCE(frag->data == &frag->val))
+			return -EIO;
+
 		/* Go forward to the next mmio piece. */
 		frag->data += len;
 		frag->gpa += len;
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -303,7 +303,8 @@ static inline bool kvm_vcpu_can_poll(kti
 struct kvm_mmio_fragment {
 	gpa_t gpa;
 	void *data;
-	unsigned len;
+	u64 val;
+	unsigned int len;
 };
 
 struct kvm_vcpu {


