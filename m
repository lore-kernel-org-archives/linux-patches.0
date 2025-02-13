Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C241DE4C1;
	Thu, 13 Feb 2025 15:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739461030; cv=none; b=SbqCWXCobKmUUj3i+DoAVslX5fmwapLtfw08jI5zrfovnAcCG1zZ/pmKUg8fyZpAgItGVFr9ad0tPdbVlQwtG1DZMNNeeWyMus3TchHzqw6yPIdWwhZT2RqOvkyWkqPYb4/aS4k6icVT7+8b/7/4z88JG8mZM4/dTzIQon8Rb4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739461030; c=relaxed/simple;
	bh=3SHyI0jLYWWbAAkdAuAxZzuaDVJktjD68MJgj4w9Mds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WRJ5Rlp9yYdT9J6krHEAiiK1Fr3mZwp6qoZpOJ/qgWPVPQFriqnx+qk6NyGkFaHoV66MInPQ3Le6zdyeJPVvpO6NWVQSM1LcYzTwzAKK8qBbdVzbnzZ3EWOKeJKTzgReYl1CeYCkZ0QOIAompD0NwvgSqfXWkfQ3ywYN/OO/0IE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UzehsnUO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UzehsnUO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5DBBC4CED1;
	Thu, 13 Feb 2025 15:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739461029;
	bh=3SHyI0jLYWWbAAkdAuAxZzuaDVJktjD68MJgj4w9Mds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UzehsnUOO6kPNKsjsWQCaFyAWeCD3NsE7pHpGpucSV3BVTra3gk8EKxOPrbdIvH30
	 NIipjcGAqGnrZQ6KPmHnmhapMYPikN+YUIOVZxExfh66BYgdvxyuR1NdtXVyIyDf6y
	 pNV7T0O+2hK92NX9IUDNyZO8+3mb/SNs6VNPD7P8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Luczaj <mhal@rbox.co>,
	Haoyu Wu <haoyuwu254@gmail.com>,
	syzbot+545f1326f405db4e1c3e@syzkaller.appspotmail.com,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	James Houghton <jthoughton@google.com>
Subject: [PATCH 6.6 272/273] KVM: x86: Make x2APIC ID 100% readonly
Date: Thu, 13 Feb 2025 15:30:44 +0100
Message-ID: <20250213142418.172267554@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 4b7c3f6d04bd53f2e5b228b6821fb8f5d1ba3071 upstream.

Ignore the userspace provided x2APIC ID when fixing up APIC state for
KVM_SET_LAPIC, i.e. make the x2APIC fully readonly in KVM.  Commit
a92e2543d6a8 ("KVM: x86: use hardware-compatible format for APIC ID
register"), which added the fixup, didn't intend to allow userspace to
modify the x2APIC ID.  In fact, that commit is when KVM first started
treating the x2APIC ID as readonly, apparently to fix some race:

 static inline u32 kvm_apic_id(struct kvm_lapic *apic)
 {
-       return (kvm_lapic_get_reg(apic, APIC_ID) >> 24) & 0xff;
+       /* To avoid a race between apic_base and following APIC_ID update when
+        * switching to x2apic_mode, the x2apic mode returns initial x2apic id.
+        */
+       if (apic_x2apic_mode(apic))
+               return apic->vcpu->vcpu_id;
+
+       return kvm_lapic_get_reg(apic, APIC_ID) >> 24;
 }

Furthermore, KVM doesn't support delivering interrupts to vCPUs with a
modified x2APIC ID, but KVM *does* return the modified value on a guest
RDMSR and for KVM_GET_LAPIC.  I.e. no remotely sane setup can actually
work with a modified x2APIC ID.

Making the x2APIC ID fully readonly fixes a WARN in KVM's optimized map
calculation, which expects the LDR to align with the x2APIC ID.

  WARNING: CPU: 2 PID: 958 at arch/x86/kvm/lapic.c:331 kvm_recalculate_apic_map+0x609/0xa00 [kvm]
  CPU: 2 PID: 958 Comm: recalc_apic_map Not tainted 6.4.0-rc3-vanilla+ #35
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Arch Linux 1.16.2-1-1 04/01/2014
  RIP: 0010:kvm_recalculate_apic_map+0x609/0xa00 [kvm]
  Call Trace:
   <TASK>
   kvm_apic_set_state+0x1cf/0x5b0 [kvm]
   kvm_arch_vcpu_ioctl+0x1806/0x2100 [kvm]
   kvm_vcpu_ioctl+0x663/0x8a0 [kvm]
   __x64_sys_ioctl+0xb8/0xf0
   do_syscall_64+0x56/0x80
   entry_SYSCALL_64_after_hwframe+0x46/0xb0
  RIP: 0033:0x7fade8b9dd6f

Unfortunately, the WARN can still trigger for other CPUs than the current
one by racing against KVM_SET_LAPIC, so remove it completely.

Reported-by: Michal Luczaj <mhal@rbox.co>
Closes: https://lore.kernel.org/all/814baa0c-1eaa-4503-129f-059917365e80@rbox.co
Reported-by: Haoyu Wu <haoyuwu254@gmail.com>
Closes: https://lore.kernel.org/all/20240126161633.62529-1-haoyuwu254@gmail.com
Reported-by: syzbot+545f1326f405db4e1c3e@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/000000000000c2a6b9061cbca3c3@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20240802202941.344889-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: James Houghton <jthoughton@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/lapic.c |   22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -338,10 +338,8 @@ static void kvm_recalculate_logical_map(
 	 * reversing the LDR calculation to get cluster of APICs, i.e. no
 	 * additional work is required.
 	 */
-	if (apic_x2apic_mode(apic)) {
-		WARN_ON_ONCE(ldr != kvm_apic_calc_x2apic_ldr(kvm_x2apic_id(apic)));
+	if (apic_x2apic_mode(apic))
 		return;
-	}
 
 	if (WARN_ON_ONCE(!kvm_apic_map_get_logical_dest(new, ldr,
 							&cluster, &mask))) {
@@ -2964,18 +2962,28 @@ static int kvm_apic_state_fixup(struct k
 		struct kvm_lapic_state *s, bool set)
 {
 	if (apic_x2apic_mode(vcpu->arch.apic)) {
+		u32 x2apic_id = kvm_x2apic_id(vcpu->arch.apic);
 		u32 *id = (u32 *)(s->regs + APIC_ID);
 		u32 *ldr = (u32 *)(s->regs + APIC_LDR);
 		u64 icr;
 
 		if (vcpu->kvm->arch.x2apic_format) {
-			if (*id != vcpu->vcpu_id)
+			if (*id != x2apic_id)
 				return -EINVAL;
 		} else {
+			/*
+			 * Ignore the userspace value when setting APIC state.
+			 * KVM's model is that the x2APIC ID is readonly, e.g.
+			 * KVM only supports delivering interrupts to KVM's
+			 * version of the x2APIC ID.  However, for backwards
+			 * compatibility, don't reject attempts to set a
+			 * mismatched ID for userspace that hasn't opted into
+			 * x2apic_format.
+			 */
 			if (set)
-				*id >>= 24;
+				*id = x2apic_id;
 			else
-				*id <<= 24;
+				*id = x2apic_id << 24;
 		}
 
 		/*
@@ -2984,7 +2992,7 @@ static int kvm_apic_state_fixup(struct k
 		 * split to ICR+ICR2 in userspace for backwards compatibility.
 		 */
 		if (set) {
-			*ldr = kvm_apic_calc_x2apic_ldr(*id);
+			*ldr = kvm_apic_calc_x2apic_ldr(x2apic_id);
 
 			icr = __kvm_lapic_get_reg(s->regs, APIC_ICR) |
 			      (u64)__kvm_lapic_get_reg(s->regs, APIC_ICR2) << 32;


