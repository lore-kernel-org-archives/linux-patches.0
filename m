Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEFD641D4F7;
	Wed, 30 Sep 2026 19:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790797138; cv=none; b=JlgqwejNSyJdkp4Pj2Yek8YjPRCAjWSTN+LpesV3AuzZluQoMlEnDhOoQCXDh9cVLCfiZqcdOG60ngI6HGNrLkAxawuRf2bT1k5fuexC2deXwT9lMGLtk6ElvKuGSPRjeVHuCw7Alf+obnASKDFlZ0VcMQcUPH15mChsIDmCpck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790797138; c=relaxed/simple;
	bh=YuVG21/c1MWC3K3ExrC6QgtkAip/V9kEkiKPeQ3ceYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZlZmPakt/JKejr06fTCYQoLbkzoA/gfajwpLukMUDbpYC/YXZj61j2P6sMyOFArl1RfGlfL2gf4vUVuUoT1c/aXq1nDhD0uKkpBVstUPuz+NRWuRgi5ATyP4X3lUtJl7/T5D9d8heVPlalm/NT6k2aVMAlMjg7QBP50lNnckz5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gD1AMu0N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gD1AMu0N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 544D01F0089A;
	Wed, 30 Sep 2026 19:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790797136;
	bh=a2GrFL7Mk/NNK0NeTKoXB8f/a8kfmwltFcRqpPE/IcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gD1AMu0NEtOJfge+XVzPmAQIcfv6+Vnlg8hK/StNx+1DZj35xyBmzgMnJCM5odUMq
	 VNcn948vHvE8S+ZGsGLN3Xrwv1t//sKevLriyj7BnkVTbyKzUYQVdCfVNkjlPKUrOl
	 /uPnkL1BvViIO5S0fGW+mW9cIRMekCmqnJaTEKiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Myeonghun Pak <mhun512@gmail.com>,
	Anup Patel <anup@brainfault.org>
Subject: [PATCH 6.6 1143/1193] RISC-V: KVM: Synchronize hrtimer callback during teardown
Date: Wed, 30 Sep 2026 17:30:27 +0200
Message-ID: <20260930152459.632078345@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

commit aaad136d56d91252517272b68cd533e5714698d5 upstream.

The non-Sstc hrtimer callback clears next_set before its final uses of
the enclosing vCPU.  If teardown observes next_set as false while the
callback is still running, kvm_riscv_vcpu_timer_cancel() skips
hrtimer_cancel() and kvm_destroy_vcpus() can free the vCPU before the
callback enters kvm_riscv_vcpu_set_interrupt().

A guest can arm the timer with SBI TIME and request shutdown with SBI
legacy shutdown or SRST.  A VMM that honors KVM_EXIT_SYSTEM_EVENT and
destroys the VM supplies the teardown side of the race; no post-launch
host ioctl is needed to arm or request teardown.

On upstream master 62cc90241548, generic KASAN reported:

  BUG: KASAN: slab-use-after-free in do_raw_spin_lock
  Write of size 4 at addr ff60000005e58898

  kvm_riscv_vcpu_set_interrupt
  kvm_riscv_vcpu_hrtimer_expired
  __hrtimer_run_queues
  hrtimer_interrupt

The object was allocated by KVM_CREATE_VCPU and freed concurrently by:

  kvm_destroy_vcpus
  kvm_arch_destroy_vm
  kvm_destroy_vm
  __fput

For deterministic validation, I added mdelay(1000) immediately after
the existing next_set = false assignment.  This only widens the
existing post-clear callback window.  A no-delay trace build naturally
reached the callback-after-teardown-start/before-deinit ordering in 12
of 200 runs, but 1,500 stock-kernel stress iterations did not produce a
KASAN report, so natural reproduction is timing-sensitive.

Always invoke hrtimer_cancel() for an initialized timer.  Preserve the
existing -EINVAL result when the timer is no longer set, but only after
synchronizing with a running callback.

With this patch, hrtimer_cancel() blocked for the full widened callback
window before vCPU destruction.  KASAN reported no error in 100
fixed-and-widened runs or 200 fix-only timing-sweep runs.

Fixes: 3a9f66cb25e1 ("RISC-V: KVM: Add timer functionality")
Cc: stable@vger.kernel.org
Assisted-by: OpenAI:GPT-5.6
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Link: https://lore.kernel.org/r/20260731163550.46991-1-mhun512@gmail.com
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kvm/vcpu_timer.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/riscv/kvm/vcpu_timer.c
+++ b/arch/riscv/kvm/vcpu_timer.c
@@ -60,10 +60,13 @@ static enum hrtimer_restart kvm_riscv_vc
 
 static int kvm_riscv_vcpu_timer_cancel(struct kvm_vcpu_timer *t)
 {
-	if (!t->init_done || !t->next_set)
+	if (!t->init_done)
 		return -EINVAL;
 
 	hrtimer_cancel(&t->hrt);
+
+	if (!t->next_set)
+		return -EINVAL;
 	t->next_set = false;
 
 	return 0;


