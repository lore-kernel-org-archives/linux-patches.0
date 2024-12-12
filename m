Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE131547F0;
	Thu, 12 Dec 2024 15:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017724; cv=none; b=fkFJgzE548e2gDnamGb7+et5rPOP7Sio3X6Ppdrb2XHKuAafEsr+enRZJRH9ana/0Cu3oFO5poVDIQIbAt2hlpWysW8VD2LhxUK1nH57xaa4HXunudZHvTc2+LYr4uKfqBvRcIC3nt3eNjhpU/c3HD2TzduaZfKxDGU09lTonu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017724; c=relaxed/simple;
	bh=akmwgcMFCQJzTFB84vtuaJhvIgUyEGFE9xg0KmSCJN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oMHxC9Zday0frwubEpyL+CFk5Pa+OERBwPwli6BNpmxvwV9P9EKNLlb0RYVfph5ENb0B9Zz+8HC1EZKbRe06glzt7ziKnQ3i0lUvtyBWGl2E49MmDGzxr6ml6bv25QBkfDE7DNfYNTkjxVTB/5ujZ9YCRPv4S/u1FrL/A3b8KYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sTh0XSlO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sTh0XSlO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D60EC4CECE;
	Thu, 12 Dec 2024 15:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017723;
	bh=akmwgcMFCQJzTFB84vtuaJhvIgUyEGFE9xg0KmSCJN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sTh0XSlOM5kJMw2fZ6c1bk4F3ba5w+s+fmWhqZSWASLHpqzroTnNJKYI84K5LWZpF
	 HHnGkkZ5uE+XKhZrLff8lbK6+1dF7OT1BEQe+nD8i+8W9WAf20x/Uhocgwyvgoe52G
	 YBeYa99xLf5NosjMkPb8urT1VRt8sJJQxoa/MtWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Potapenko <glider@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 064/356] KVM: arm64: Dont retire aborted MMIO instruction
Date: Thu, 12 Dec 2024 15:56:23 +0100
Message-ID: <20241212144247.159841482@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Oliver Upton <oliver.upton@linux.dev>

[ Upstream commit e735a5da64420a86be370b216c269b5dd8e830e2 ]

Returning an abort to the guest for an unsupported MMIO access is a
documented feature of the KVM UAPI. Nevertheless, it's clear that this
plumbing has seen limited testing, since userspace can trivially cause a
WARN in the MMIO return:

  WARNING: CPU: 0 PID: 30558 at arch/arm64/include/asm/kvm_emulate.h:536 kvm_handle_mmio_return+0x46c/0x5c4 arch/arm64/include/asm/kvm_emulate.h:536
  Call trace:
   kvm_handle_mmio_return+0x46c/0x5c4 arch/arm64/include/asm/kvm_emulate.h:536
   kvm_arch_vcpu_ioctl_run+0x98/0x15b4 arch/arm64/kvm/arm.c:1133
   kvm_vcpu_ioctl+0x75c/0xa78 virt/kvm/kvm_main.c:4487
   __do_sys_ioctl fs/ioctl.c:51 [inline]
   __se_sys_ioctl fs/ioctl.c:893 [inline]
   __arm64_sys_ioctl+0x14c/0x1c8 fs/ioctl.c:893
   __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
   invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
   el0_svc_common+0x1e0/0x23c arch/arm64/kernel/syscall.c:132
   do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
   el0_svc+0x38/0x68 arch/arm64/kernel/entry-common.c:712
   el0t_64_sync_handler+0x90/0xfc arch/arm64/kernel/entry-common.c:730
   el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598

The splat is complaining that KVM is advancing PC while an exception is
pending, i.e. that KVM is retiring the MMIO instruction despite a
pending synchronous external abort. Womp womp.

Fix the glaring UAPI bug by skipping over all the MMIO emulation in
case there is a pending synchronous exception. Note that while userspace
is capable of pending an asynchronous exception (SError, IRQ, or FIQ),
it is still safe to retire the MMIO instruction in this case as (1) they
are by definition asynchronous, and (2) KVM relies on hardware support
for pending/delivering these exceptions instead of the software state
machine for advancing PC.

Cc: stable@vger.kernel.org
Fixes: da345174ceca ("KVM: arm/arm64: Allow user injection of external data aborts")
Reported-by: Alexander Potapenko <glider@google.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20241025203106.3529261-2-oliver.upton@linux.dev
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/mmio.c | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
index 886ef30e12196..2aa503ff742ee 100644
--- a/arch/arm64/kvm/mmio.c
+++ b/arch/arm64/kvm/mmio.c
@@ -72,6 +72,31 @@ unsigned long kvm_mmio_read_buf(const void *buf, unsigned int len)
 	return data;
 }
 
+static bool kvm_pending_sync_exception(struct kvm_vcpu *vcpu)
+{
+	if (!vcpu_get_flag(vcpu, PENDING_EXCEPTION))
+		return false;
+
+	if (vcpu_el1_is_32bit(vcpu)) {
+		switch (vcpu_get_flag(vcpu, EXCEPT_MASK)) {
+		case unpack_vcpu_flag(EXCEPT_AA32_UND):
+		case unpack_vcpu_flag(EXCEPT_AA32_IABT):
+		case unpack_vcpu_flag(EXCEPT_AA32_DABT):
+			return true;
+		default:
+			return false;
+		}
+	} else {
+		switch (vcpu_get_flag(vcpu, EXCEPT_MASK)) {
+		case unpack_vcpu_flag(EXCEPT_AA64_EL1_SYNC):
+		case unpack_vcpu_flag(EXCEPT_AA64_EL2_SYNC):
+			return true;
+		default:
+			return false;
+		}
+	}
+}
+
 /**
  * kvm_handle_mmio_return -- Handle MMIO loads after user space emulation
  *			     or in-kernel IO emulation
@@ -84,8 +109,11 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu)
 	unsigned int len;
 	int mask;
 
-	/* Detect an already handled MMIO return */
-	if (unlikely(!vcpu->mmio_needed))
+	/*
+	 * Detect if the MMIO return was already handled or if userspace aborted
+	 * the MMIO access.
+	 */
+	if (unlikely(!vcpu->mmio_needed || kvm_pending_sync_exception(vcpu)))
 		return 1;
 
 	vcpu->mmio_needed = 0;
-- 
2.43.0



