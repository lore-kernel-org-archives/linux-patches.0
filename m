Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35DCB3C199C;
	Thu, 15 Jan 2026 17:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499519; cv=none; b=Rx1xclvoQ0SoQWeW5zrOt595RkfkX9pUpLewe+Hx6xZXspovUAylTAvyU4Iimb6rM48LcOoZoRzOzSYgIdfciK/nov7Byjhll0/NLk+QkZlLgmHiAWDluBI+9xUHvG15cDkNEnxi0Vd/k1kX9P4SNukCnIbDJAjxRyDhcsKtWTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499519; c=relaxed/simple;
	bh=a8tEJQahGgDvnXQPAXe7JzvFDyo6W92ZyKQbC3ZNHZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PROuHSZcMCa7SfCmDRnw1v3meFBBTDA6wdWq7Y87lZWyHP2xpPMMcObVD98EVUOPK/O66cZBtT9qwYYij+YJffjcjB0AM7Ec1nmUp1SlxOX0hFNUwiNeXFeJEGThAe0sp/VWRFAbSgyHP4A2TDCCUAh2u2HmkoaVWCA6UvkqEa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ll1IhX4+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ll1IhX4+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 819CCC16AAE;
	Thu, 15 Jan 2026 17:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499518;
	bh=a8tEJQahGgDvnXQPAXe7JzvFDyo6W92ZyKQbC3ZNHZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ll1IhX4+agnhrjCMid3JmjfqKxjQXWac+EejPIQ2YCdmOTs/awdx94dXxU3aakSnv
	 y1pozpk0C7MKirQIo1e18CQSlSQ0eqVHueLwqtLnbhm3FTBL4FAUPMndTWQJU+SKpE
	 qQG8kW2DFaq7HilwQ3CkZO8PvNz4+ZZAs12jIEB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	fuqiang wang <fuqiang.wng@gmail.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 5.10 255/451] KVM: x86: Fix VM hard lockup after prolonged inactivity with periodic HV timer
Date: Thu, 15 Jan 2026 17:47:36 +0100
Message-ID: <20260115164240.113390870@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

From: fuqiang wang <fuqiang.wng@gmail.com>

commit 18ab3fc8e880791aa9f7c000261320fc812b5465 upstream.

When advancing the target expiration for the guest's APIC timer in periodic
mode, set the expiration to "now" if the target expiration is in the past
(similar to what is done in update_target_expiration()).  Blindly adding
the period to the previous target expiration can result in KVM generating
a practically unbounded number of hrtimer IRQs due to programming an
expired timer over and over.  In extreme scenarios, e.g. if userspace
pauses/suspends a VM for an extended duration, this can even cause hard
lockups in the host.

Currently, the bug only affects Intel CPUs when using the hypervisor timer
(HV timer), a.k.a. the VMX preemption timer.  Unlike the software timer,
a.k.a. hrtimer, which KVM keeps running even on exits to userspace, the
HV timer only runs while the guest is active.  As a result, if the vCPU
does not run for an extended duration, there will be a huge gap between
the target expiration and the current time the vCPU resumes running.
Because the target expiration is incremented by only one period on each
timer expiration, this leads to a series of timer expirations occurring
rapidly after the vCPU/VM resumes.

More critically, when the vCPU first triggers a periodic HV timer
expiration after resuming, advancing the expiration by only one period
will result in a target expiration in the past.  As a result, the delta
may be calculated as a negative value.  When the delta is converted into
an absolute value (tscdeadline is an unsigned u64), the resulting value
can overflow what the HV timer is capable of programming.  I.e. the large
value will exceed the VMX Preemption Timer's maximum bit width of
cpu_preemption_timer_multi + 32, and thus cause KVM to switch from the
HV timer to the software timer (hrtimers).

After switching to the software timer, periodic timer expiration callbacks
may be executed consecutively within a single clock interrupt handler,
because hrtimers honors KVM's request for an expiration in the past and
immediately re-invokes KVM's callback after reprogramming.  And because
the interrupt handler runs with IRQs disabled, restarting KVM's hrtimer
over and over until the target expiration is advanced to "now" can result
in a hard lockup.

E.g. the following hard lockup was triggered in the host when running a
Windows VM (only relevant because it used the APIC timer in periodic mode)
after resuming the VM from a long suspend (in the host).

  NMI watchdog: Watchdog detected hard LOCKUP on cpu 45
  ...
  RIP: 0010:advance_periodic_target_expiration+0x4d/0x80 [kvm]
  ...
  RSP: 0018:ff4f88f5d98d8ef0 EFLAGS: 00000046
  RAX: fff0103f91be678e RBX: fff0103f91be678e RCX: 00843a7d9e127bcc
  RDX: 0000000000000002 RSI: 0052ca4003697505 RDI: ff440d5bfbdbd500
  RBP: ff440d5956f99200 R08: ff2ff2a42deb6a84 R09: 000000000002a6c0
  R10: 0122d794016332b3 R11: 0000000000000000 R12: ff440db1af39cfc0
  R13: ff440db1af39cfc0 R14: ffffffffc0d4a560 R15: ff440db1af39d0f8
  FS:  00007f04a6ffd700(0000) GS:ff440db1af380000(0000) knlGS:000000e38a3b8000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 000000d5651feff8 CR3: 000000684e038002 CR4: 0000000000773ee0
  PKRU: 55555554
  Call Trace:
   <IRQ>
   apic_timer_fn+0x31/0x50 [kvm]
   __hrtimer_run_queues+0x100/0x280
   hrtimer_interrupt+0x100/0x210
   ? ttwu_do_wakeup+0x19/0x160
   smp_apic_timer_interrupt+0x6a/0x130
   apic_timer_interrupt+0xf/0x20
   </IRQ>

Moreover, if the suspend duration of the virtual machine is not long enough
to trigger a hard lockup in this scenario, since commit 98c25ead5eda
("KVM: VMX: Move preemption timer <=> hrtimer dance to common x86"), KVM
will continue using the software timer until the guest reprograms the APIC
timer in some way.  Since the periodic timer does not require frequent APIC
timer register programming, the guest may continue to use the software
timer in perpetuity.

Fixes: d8f2f498d9ed ("x86/kvm: fix LAPIC timer drift when guest uses periodic mode")
Cc: stable@vger.kernel.org
Signed-off-by: fuqiang wang <fuqiang.wng@gmail.com>
[sean: massage comments and changelog]
Link: https://patch.msgid.link/20251113205114.1647493-4-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/lapic.c |   28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1790,15 +1790,33 @@ static void advance_periodic_target_expi
 	ktime_t delta;
 
 	/*
-	 * Synchronize both deadlines to the same time source or
-	 * differences in the periods (caused by differences in the
-	 * underlying clocks or numerical approximation errors) will
-	 * cause the two to drift apart over time as the errors
-	 * accumulate.
+	 * Use kernel time as the time source for both the hrtimer deadline and
+	 * TSC-based deadline so that they stay synchronized.  Computing each
+	 * deadline independently will cause the two deadlines to drift apart
+	 * over time as differences in the periods accumulate, e.g. due to
+	 * differences in the underlying clocks or numerical approximation errors.
 	 */
 	apic->lapic_timer.target_expiration =
 		ktime_add_ns(apic->lapic_timer.target_expiration,
 				apic->lapic_timer.period);
+
+	/*
+	 * If the new expiration is in the past, e.g. because userspace stopped
+	 * running the VM for an extended duration, then force the expiration
+	 * to "now" and don't try to play catch-up with the missed events.  KVM
+	 * will only deliver a single interrupt regardless of how many events
+	 * are pending, i.e. restarting the timer with an expiration in the
+	 * past will do nothing more than waste host cycles, and can even lead
+	 * to a hard lockup in extreme cases.
+	 */
+	if (ktime_before(apic->lapic_timer.target_expiration, now))
+		apic->lapic_timer.target_expiration = now;
+
+	/*
+	 * Note, ensuring the expiration isn't in the past also prevents delta
+	 * from going negative, which could cause the TSC deadline to become
+	 * excessively large due to it an unsigned value.
+	 */
 	delta = ktime_sub(apic->lapic_timer.target_expiration, now);
 	apic->lapic_timer.tscdeadline = kvm_read_l1_tsc(apic->vcpu, tscl) +
 		nsec_to_cycles(apic->vcpu, delta);


