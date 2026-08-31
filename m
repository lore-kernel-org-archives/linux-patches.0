Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 386F3431A34;
	Mon, 31 Aug 2026 14:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184977; cv=none; b=eP5/JaopHxThgQrKWM9gSJF7UeFGudKykyyRQj/pAdOYOSWzFhCEowneLH2VmsQpGqJfa36vL0VsgJN9T/mvkqspNjuEgHl2oSXdsOVmH8VLVbIeYBpjhBo6FVqtW5/Nf0EostICoA3ZBJQSJIh/jBa53UqkUEjU3C3f9sqjDVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184977; c=relaxed/simple;
	bh=T/JaC08lWPTHPd5UCzRLGDazFd6iY8fF20f1xVFaA+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gEN3PyWGAKdFVgfDj3JDkoKdatNNXCtzio7S5f4hw800WIfyVV6+ExGQkRzCM6sHFXxiMHzO85fcTKiHlab5WTTJmL+dDThf/hugk7ZJGpPzkmuwDATE3477Tu9KCxtJPmfiFmIjkDkOEWDUaCirIs2r2gNiIkV1CgagvFpwAMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PM7F5+3U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PM7F5+3U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 933F71F000E9;
	Mon, 31 Aug 2026 14:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184976;
	bh=3zdliVXA+k0Jtgp6y1fnK/pnNmLwB5x4yMteWiqPXqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PM7F5+3UJAP/qSHwVIz/qz6r4klsTWa0ab+7CAvN7Tl8R9DQdU1sFPC7szflRNZnk
	 qzV5MubjAEJIEX5A/CBeYdzGjd8CHM38gUVRmXcjFFgW6Qt+OIq7PBc3yW7WrUbUmo
	 M12Ao5063I3S/l4FGPykfIY2nVuENPpi7W7ansOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 11/69] KVM: arm64: Prevent access to vCPU events before init
Date: Mon, 31 Aug 2026 15:34:44 +0200
Message-ID: <20260831133359.072287714@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133358.601894154@linuxfoundation.org>
References: <20260831133358.601894154@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Upton <oliver.upton@linux.dev>

[ Upstream commit 0aa1b76fe1429629215a7c79820e4b96233ac4a3 ]

Another day, another syzkaller bug. KVM erroneously allows userspace to
pend vCPU events for a vCPU that hasn't been initialized yet, leading to
KVM interpreting a bunch of uninitialized garbage for routing /
injecting the exception.

In one case the injection code and the hyp disagree on whether the vCPU
has a 32bit EL1 and put the vCPU into an illegal mode for AArch64,
tripping the BUG() in exception_target_el() during the next injection:

  kernel BUG at arch/arm64/kvm/inject_fault.c:40!
  Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
  CPU: 3 UID: 0 PID: 318 Comm: repro Not tainted 6.17.0-rc4-00104-g10fd0285305d #6 PREEMPT
  Hardware name: linux,dummy-virt (DT)
  pstate: 21402009 (nzCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
  pc : exception_target_el+0x88/0x8c
  lr : pend_serror_exception+0x18/0x13c
  sp : ffff800082f03a10
  x29: ffff800082f03a10 x28: ffff0000cb132280 x27: 0000000000000000
  x26: 0000000000000000 x25: ffff0000c2a99c20 x24: 0000000000000000
  x23: 0000000000008000 x22: 0000000000000002 x21: 0000000000000004
  x20: 0000000000008000 x19: ffff0000c2a99c20 x18: 0000000000000000
  x17: 0000000000000000 x16: 0000000000000000 x15: 00000000200000c0
  x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
  x11: 0000000000000000 x10: 0000000000000000 x9 : 0000000000000000
  x8 : ffff800082f03af8 x7 : 0000000000000000 x6 : 0000000000000000
  x5 : ffff800080f621f0 x4 : 0000000000000000 x3 : 0000000000000000
  x2 : 000000000040009b x1 : 0000000000000003 x0 : ffff0000c2a99c20
  Call trace:
   exception_target_el+0x88/0x8c (P)
   kvm_inject_serror_esr+0x40/0x3b4
   __kvm_arm_vcpu_set_events+0xf0/0x100
   kvm_arch_vcpu_ioctl+0x180/0x9d4
   kvm_vcpu_ioctl+0x60c/0x9f4
   __arm64_sys_ioctl+0xac/0x104
   invoke_syscall+0x48/0x110
   el0_svc_common.constprop.0+0x40/0xe0
   do_el0_svc+0x1c/0x28
   el0_svc+0x34/0xf0
   el0t_64_sync_handler+0xa0/0xe4
   el0t_64_sync+0x198/0x19c
  Code: f946bc01 b4fffe61 9101e020 17fffff2 (d4210000)

Reject the ioctls outright as no sane VMM would call these before
KVM_ARM_VCPU_INIT anyway. Even if it did the exception would've been
thrown away by the eventual reset of the vCPU's state.

Cc: stable@vger.kernel.org # 6.17
Fixes: b7b27facc7b5 ("arm/arm64: KVM: Add KVM_GET/SET_VCPU_EVENTS")
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/arm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 5ca8782edb960..ca69ae7f86d70 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1313,6 +1313,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	case KVM_GET_VCPU_EVENTS: {
 		struct kvm_vcpu_events events;
 
+		if (!kvm_vcpu_initialized(vcpu))
+			return -ENOEXEC;
+
 		if (kvm_arm_vcpu_get_events(vcpu, &events))
 			return -EINVAL;
 
@@ -1324,6 +1327,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	case KVM_SET_VCPU_EVENTS: {
 		struct kvm_vcpu_events events;
 
+		if (!kvm_vcpu_initialized(vcpu))
+			return -ENOEXEC;
+
 		if (copy_from_user(&events, argp, sizeof(events)))
 			return -EFAULT;
 
-- 
2.53.0



