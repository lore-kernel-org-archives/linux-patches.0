Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A845F43F8B1;
	Mon, 31 Aug 2026 14:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184822; cv=none; b=iKehvuljU8xaF80r9vwDziVkiS3cyrdVPg/ubOzSx0mCemXThAcpITBaK4XbtGN/XqTONVYMfLdo4qtOJAKbuBJHCyYL71vYx/vHn0oQeCwmhnhn+GOIBnHq3cRi9hh+ChBV3f1SO4WaN8vd4W1b4h/Y8vkkKL35Ht6HDzT7Wrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184822; c=relaxed/simple;
	bh=BinzQEXbMxMGY1Zbsn1ZoCFoH/djNpmdhTSDttgpQ5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EojbxJVQo/Qf/2bGPkOPbU4RHjfJC0OR8z0QdAxdD2OxXzms7Js9Blv35wjkbK4cYOaXFS6mcYrRFafPZO3SXzNB6/JaGc0siNcQt5kLKFpUH1bRXFNZ/b1HUwDHWXViJJ8z7lohniM8zqOvB8e3c5sSzvXidG4a2EqPl7nuTJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SzlRqb/n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SzlRqb/n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E5D31F00A3D;
	Mon, 31 Aug 2026 14:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184820;
	bh=gWlY9Jp80kJ5qfk7OHp7NtBxJk20TWGtKGWEXGQ1Dl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SzlRqb/nns8YnTb+hcTU5GURx9gYpdz0Esc8vLiTr7kXyJhC5mfViwC7Gpci7kt5l
	 PSyJJGnTUjJ8QT0NGB/30o3uwRGZh6uKjn8tIQ8/Ep5bZ89sTWpB0aWPH7HGAWf5I2
	 D2dGPMaZVd14ouo37+9rWFORPfAmfZjCfxrL5jqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 22/92] KVM: arm64: Prevent access to vCPU events before init
Date: Mon, 31 Aug 2026 15:34:20 +0200
Message-ID: <20260831133400.752848191@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.482388899@linuxfoundation.org>
References: <20260831133359.482388899@linuxfoundation.org>
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
index 672684d67e399..b589ed95c89e6 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1414,6 +1414,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	case KVM_GET_VCPU_EVENTS: {
 		struct kvm_vcpu_events events;
 
+		if (!kvm_vcpu_initialized(vcpu))
+			return -ENOEXEC;
+
 		if (kvm_arm_vcpu_get_events(vcpu, &events))
 			return -EINVAL;
 
@@ -1425,6 +1428,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	case KVM_SET_VCPU_EVENTS: {
 		struct kvm_vcpu_events events;
 
+		if (!kvm_vcpu_initialized(vcpu))
+			return -ENOEXEC;
+
 		if (copy_from_user(&events, argp, sizeof(events)))
 			return -EFAULT;
 
-- 
2.53.0



