Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3814B46A5F7;
	Tue, 21 Jul 2026 19:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663585; cv=none; b=c+Wi3kDyCJunsDYdfaeDKApZ1fwwboTJuHqzNhZZFij7jPTzKfDF0GU0+EQ6bc4iOJR+L2ju/lnINGbiAneB5t3RxXIdYu8i7iHaV+VyyQVhXZdljtZfhrXhrG5h0sqre4AtV8RmDxmOxB0vc32GPU00DHNayw8eqBTyF4TSjlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663585; c=relaxed/simple;
	bh=n7K+2rmjvbzSGg51tqQuodOCgvMH770AYALBxGn7qxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d34lrB1KiRe4jY1kSOdcoZXvf/qCzn2X01Q0kF37IW/FKtuI1lFsEAkiNYzOd8emTyRCWK3FmACw2Jql8T7UejJ514sM3TmObn9/Ejn4c9ggxDRwkLTDCmPWGm4cnpejagnaPI0fk4DyfFT5L5LGcPUI4YYzbhn3mxZ21tYWVsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X5GGIMxs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X5GGIMxs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 922C71F000E9;
	Tue, 21 Jul 2026 19:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663584;
	bh=yrr/s3d7H02Sn9uJd5kXPbPY+UVNVPgarTURsHErCmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X5GGIMxsSfFmwsmXKbNJ02BS99h0/60iouO7jwHgIISpaSzaHeCEMQv2UC1KYjc4H
	 bym02UWOXOo3o1YGTuwaS2jiXas3DjynK9ilcSYDEOOsnniQQSqDNY59R/D8Gd9x5W
	 J6DIwFgGdKILmUCN7n1AqJ1KV0luoCfWDSbhJ5tk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai Huang <kai.huang@intel.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.12 0835/1276] KVM: x86: Ignore pending PV EOI if the vCPU has since disabled PV EOIs
Date: Tue, 21 Jul 2026 17:21:18 +0200
Message-ID: <20260721152504.744326348@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

commit 9285e4070df2c40585c3d7ec9571faa7a2b97e17 upstream.

Ignore KVM's internal "service pending PV EOI" request if the vCPU has
disabled PV EOIs since the request was made.  Asserting that PV EOIs are
enabled can fail if reading guest memory in pv_eoi_get_user() fails, i.e.
if pv_eoi_test_and_clr_pending() bails early, *and* the vCPU also disables
PV EOIs.

  kernel BUG at arch/x86/kvm/lapic.c:3338!
  Oops: invalid opcode: 0000 [#1] SMP
  CPU: 4 UID: 1000 PID: 890 Comm: pv_eoi_test Not tainted 7.0.0-d585aa5894d8-vm #337 PREEMPT
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  RIP: 0010:kvm_lapic_sync_from_vapic+0x12b/0x140 [kvm]
  Call Trace:
   <TASK>
   kvm_arch_vcpu_ioctl_run+0x1075/0x1c30 [kvm]
   kvm_vcpu_ioctl+0x2d5/0x980 [kvm]
   __x64_sys_ioctl+0x8a/0xd0
   do_syscall_64+0xb5/0xb40
   entry_SYSCALL_64_after_hwframe+0x4b/0x53
   </TASK>
  Modules linked in: kvm_intel kvm irqbypass
  ---[ end trace 0000000000000000 ]---

Fixes: ae7a2a3fb6f8 ("KVM: host side for eoi optimization")
Cc: stable@vger.kernel.org
Reviewed-by: Kai Huang <kai.huang@intel.com>
Link: https://patch.msgid.link/20260624220516.3033391-1-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/lapic.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -3169,6 +3169,12 @@ static void apic_sync_pv_eoi_from_guest(
 					struct kvm_lapic *apic)
 {
 	int vector;
+
+	if (unlikely(!pv_eoi_enabled(vcpu))) {
+		__clear_bit(KVM_APIC_PV_EOI_PENDING, &vcpu->arch.apic_attention);
+		return;
+	}
+
 	/*
 	 * PV EOI state is derived from KVM_APIC_PV_EOI_PENDING in host
 	 * and KVM_PV_EOI_ENABLED in guest memory as follows:
@@ -3180,8 +3186,6 @@ static void apic_sync_pv_eoi_from_guest(
 	 * KVM_APIC_PV_EOI_PENDING is set, KVM_PV_EOI_ENABLED is unset:
 	 * 	-> host enabled PV EOI, guest executed EOI.
 	 */
-	BUG_ON(!pv_eoi_enabled(vcpu));
-
 	if (pv_eoi_test_and_clr_pending(vcpu))
 		return;
 	vector = apic_set_eoi(apic);


