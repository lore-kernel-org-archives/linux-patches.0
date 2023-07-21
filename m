Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF941F941
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:17:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AECD7C433CA;
	Fri, 21 Jul 2023 16:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956224;
	bh=nYXZSMhhnu5iA7+z3PlljJX3Hm5IHfppWYM4tc1QtCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UqBT9JtnYRngPnLoMKxZM3F0Ms5UNGNoUcWMZ6ph/F2QgH+9SuIdrNzwsoSy8jI1H
	 i+tyxLVac8fDeJfkZgD6aVdBcmbBcScUUhz7DlLGdmVAeCoc5FxMKGL7cFjM5XG4Ol
	 kAlmBIYlV+iXSESvufTYUDPJbt+lhecx+ulP+WOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 6.4 144/292] powerpc/64s: Fix native_hpte_remove() to be irq-safe
Date: Fri, 21 Jul 2023 18:04:13 +0200
Message-ID: <20230721160535.074958891@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michael Ellerman <mpe@ellerman.id.au>

commit 8bbe9fee5848371d4af101be445303cac8d880c5 upstream.

Lockdep warns that the use of the hpte_lock in native_hpte_remove() is
not safe against an IRQ coming in:

  ================================
  WARNING: inconsistent lock state
  6.4.0-rc2-g0c54f4d30ecc #1 Not tainted
  --------------------------------
  inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W} usage.
  qemu-system-ppc/93865 [HC0[0]:SC0[0]:HE1:SE1] takes:
  c0000000021f5180 (hpte_lock){+.?.}-{0:0}, at: native_lock_hpte+0x8/0xd0
  {IN-SOFTIRQ-W} state was registered at:
    lock_acquire+0x134/0x3f0
    native_lock_hpte+0x44/0xd0
    native_hpte_insert+0xd4/0x2a0
    __hash_page_64K+0x218/0x4f0
    hash_page_mm+0x464/0x840
    do_hash_fault+0x11c/0x260
    data_access_common_virt+0x210/0x220
    __ip_select_ident+0x140/0x150
    ...
    net_rx_action+0x3bc/0x440
    __do_softirq+0x180/0x534
    ...
    sys_sendmmsg+0x34/0x50
    system_call_exception+0x128/0x320
    system_call_common+0x160/0x2e4
  ...
   Possible unsafe locking scenario:

         CPU0
         ----
    lock(hpte_lock);
    <Interrupt>
      lock(hpte_lock);

   *** DEADLOCK ***
  ...
  Call Trace:
    dump_stack_lvl+0x98/0xe0 (unreliable)
    print_usage_bug.part.0+0x250/0x278
    mark_lock+0xc9c/0xd30
    __lock_acquire+0x440/0x1ca0
    lock_acquire+0x134/0x3f0
    native_lock_hpte+0x44/0xd0
    native_hpte_remove+0xb0/0x190
    kvmppc_mmu_map_page+0x650/0x698 [kvm_pr]
    kvmppc_handle_pagefault+0x534/0x6e8 [kvm_pr]
    kvmppc_handle_exit_pr+0x6d8/0xe90 [kvm_pr]
    after_sprg3_load+0x80/0x90 [kvm_pr]
    kvmppc_vcpu_run_pr+0x108/0x270 [kvm_pr]
    kvmppc_vcpu_run+0x34/0x48 [kvm]
    kvm_arch_vcpu_ioctl_run+0x340/0x470 [kvm]
    kvm_vcpu_ioctl+0x338/0x8b8 [kvm]
    sys_ioctl+0x7c4/0x13e0
    system_call_exception+0x128/0x320
    system_call_common+0x160/0x2e4

I suspect kvm_pr is the only caller that doesn't already have IRQs
disabled, which is why this hasn't been reported previously.

Fix it by disabling IRQs in native_hpte_remove().

Fixes: 35159b5717fa ("powerpc/64s: make HPTE lock and native_tlbie_lock irq-safe")
Cc: stable@vger.kernel.org # v6.1+
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20230517123033.18430-1-mpe@ellerman.id.au
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/mm/book3s64/hash_native.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/arch/powerpc/mm/book3s64/hash_native.c
+++ b/arch/powerpc/mm/book3s64/hash_native.c
@@ -328,10 +328,12 @@ static long native_hpte_insert(unsigned
 
 static long native_hpte_remove(unsigned long hpte_group)
 {
+	unsigned long hpte_v, flags;
 	struct hash_pte *hptep;
 	int i;
 	int slot_offset;
-	unsigned long hpte_v;
+
+	local_irq_save(flags);
 
 	DBG_LOW("    remove(group=%lx)\n", hpte_group);
 
@@ -356,13 +358,16 @@ static long native_hpte_remove(unsigned
 		slot_offset &= 0x7;
 	}
 
-	if (i == HPTES_PER_GROUP)
-		return -1;
+	if (i == HPTES_PER_GROUP) {
+		i = -1;
+		goto out;
+	}
 
 	/* Invalidate the hpte. NOTE: this also unlocks it */
 	release_hpte_lock();
 	hptep->v = 0;
-
+out:
+	local_irq_restore(flags);
 	return i;
 }
 


