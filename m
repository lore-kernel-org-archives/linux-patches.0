Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56EDB434409;
	Tue, 21 Jul 2026 21:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669895; cv=none; b=TVUq+5NMVHcroGOd3bOtFqbABHwQbQFOsyyWW+63V3S8ZEmVWo2rz2sfG+UZEDVK3gdy34LC1Z1uS3YE+Jz2c10xb09ucOBhPU7Ot5Cs4jQdjUstT8tu+gXBzRHrHVijkZh7v30Ump9uAsE2AijUHXd9UDjlrmoeZzT4MHQn6GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669895; c=relaxed/simple;
	bh=NAFaJ/iCHqgDm2vgdY7fZ1depxIlSF4dzsfy3czKeic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kz9fUX8Iewccu3EsuijXRTX9+4uHBnK/MQkW8zf+dz1G2SeToQKmZvA+dmNgDkld5Kv3cuoLuNxUscVVuvdwSvPsWh953CMbZq6PwrJx8IqGM4kUR52Fffs6ljfWwJ2x07R9k4AwJFvy7MZLny/Q20VfNuNCHeZphI56LEDv6QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lcBaI6e8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lcBaI6e8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC0801F000E9;
	Tue, 21 Jul 2026 21:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669894;
	bh=eKCOkAUxdObB+WLryeBSDZfREuxrf2LyUB2hqJ0Tqks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lcBaI6e8GBXIMwOiwB9at06wQqQvCtlgoRhBTuru/Q0Z7VuplOsz2XidxMXgICg6d
	 ltF+pgy7QoVBkkoNVFGW5dDDcQhZRTkL/A0XjLIzMX30uk+bffoB1PVhRcW4lRC+xR
	 YICAQsR7x9aG/UwXG3uLE03/UAEydVczd5PjMwIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai Huang <kai.huang@intel.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.1 0727/1067] KVM: x86: Ignore pending PV EOI if the vCPU has since disabled PV EOIs
Date: Tue, 21 Jul 2026 17:22:08 +0200
Message-ID: <20260721152440.851188801@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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
@@ -2913,6 +2913,12 @@ static void apic_sync_pv_eoi_from_guest(
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
@@ -2924,8 +2930,6 @@ static void apic_sync_pv_eoi_from_guest(
 	 * KVM_APIC_PV_EOI_PENDING is set, KVM_PV_EOI_ENABLED is unset:
 	 * 	-> host enabled PV EOI, guest executed EOI.
 	 */
-	BUG_ON(!pv_eoi_enabled(vcpu));
-
 	if (pv_eoi_test_and_clr_pending(vcpu))
 		return;
 	vector = apic_set_eoi(apic);


