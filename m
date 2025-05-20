Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631BB243370;
	Tue, 20 May 2025 14:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749761; cv=none; b=WKdJc2tcmp+wr75z53+87x7iteG3h/qSZ+ZFLaTc1gtQ+MDYI5Z9wIwSB2hILBfQ2kpQiCkqvJfCB3Z0mDZ7i8P9UTiLGf0WH0Z9rMHqRa73kkBFj3c0zr2ARcIihpG/SxatWru/Ckj9AuDd7FCezlnviyid/L2ZE7eRBptHBQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749761; c=relaxed/simple;
	bh=f+HI5qdaIbAkj/23doF5SajQBzNTjYeX+j5hMb5eRxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VGQat+cHCSSxAA/nRrTDhcuyav/PC4he7YRY8RESERKm5r8HTCccMDvNbMUp6X9jNNm36KI7+LMVSQLkSKrf1GxJ6H0noUxTSoomGEOVMb/d3WfBJvHQiGieX7QdNnEoH6Da0sIIwUbOz5UZwhYvKrcOC8M155y6fkV2NvxjACY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GMLffeVJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GMLffeVJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8155C4CEEA;
	Tue, 20 May 2025 14:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749761;
	bh=f+HI5qdaIbAkj/23doF5SajQBzNTjYeX+j5hMb5eRxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GMLffeVJEYqfrM3jJ3JNXJMDfNiqgGSJB9MjENraaaB3pOhLHwwlgc2hsAMaoWh36
	 K/abTiRnBlQ88OcdE/ZHHfxjhcnTw7hGaged/4+WI2zT19gtPbieXwNC5e81HY9Kw4
	 03YiQPlbMKPD7l+ByTDC4X9bFMV/fA15W/nRsVe4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Mikhail Lobanov <m.lobanov@rosa.ru>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 021/117] KVM: SVM: Forcibly leave SMM mode on SHUTDOWN interception
Date: Tue, 20 May 2025 15:49:46 +0200
Message-ID: <20250520125804.822676745@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
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

From: Mikhail Lobanov <m.lobanov@rosa.ru>

[ Upstream commit a2620f8932fa9fdabc3d78ed6efb004ca409019f ]

Previously, commit ed129ec9057f ("KVM: x86: forcibly leave nested mode
on vCPU reset") addressed an issue where a triple fault occurring in
nested mode could lead to use-after-free scenarios. However, the commit
did not handle the analogous situation for System Management Mode (SMM).

This omission results in triggering a WARN when KVM forces a vCPU INIT
after SHUTDOWN interception while the vCPU is in SMM. This situation was
reprodused using Syzkaller by:

  1) Creating a KVM VM and vCPU
  2) Sending a KVM_SMI ioctl to explicitly enter SMM
  3) Executing invalid instructions causing consecutive exceptions and
     eventually a triple fault

The issue manifests as follows:

  WARNING: CPU: 0 PID: 25506 at arch/x86/kvm/x86.c:12112
  kvm_vcpu_reset+0x1d2/0x1530 arch/x86/kvm/x86.c:12112
  Modules linked in:
  CPU: 0 PID: 25506 Comm: syz-executor.0 Not tainted
  6.1.130-syzkaller-00157-g164fe5dde9b6 #0
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
  BIOS 1.12.0-1 04/01/2014
  RIP: 0010:kvm_vcpu_reset+0x1d2/0x1530 arch/x86/kvm/x86.c:12112
  Call Trace:
   <TASK>
   shutdown_interception+0x66/0xb0 arch/x86/kvm/svm/svm.c:2136
   svm_invoke_exit_handler+0x110/0x530 arch/x86/kvm/svm/svm.c:3395
   svm_handle_exit+0x424/0x920 arch/x86/kvm/svm/svm.c:3457
   vcpu_enter_guest arch/x86/kvm/x86.c:10959 [inline]
   vcpu_run+0x2c43/0x5a90 arch/x86/kvm/x86.c:11062
   kvm_arch_vcpu_ioctl_run+0x50f/0x1cf0 arch/x86/kvm/x86.c:11283
   kvm_vcpu_ioctl+0x570/0xf00 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4122
   vfs_ioctl fs/ioctl.c:51 [inline]
   __do_sys_ioctl fs/ioctl.c:870 [inline]
   __se_sys_ioctl fs/ioctl.c:856 [inline]
   __x64_sys_ioctl+0x19a/0x210 fs/ioctl.c:856
   do_syscall_x64 arch/x86/entry/common.c:51 [inline]
   do_syscall_64+0x35/0x80 arch/x86/entry/common.c:81
   entry_SYSCALL_64_after_hwframe+0x6e/0xd8

Architecturally, INIT is blocked when the CPU is in SMM, hence KVM's WARN()
in kvm_vcpu_reset() to guard against KVM bugs, e.g. to detect improper
emulation of INIT.  SHUTDOWN on SVM is a weird edge case where KVM needs to
do _something_ sane with the VMCB, since it's technically undefined, and
INIT is the least awful choice given KVM's ABI.

So, double down on stuffing INIT on SHUTDOWN, and force the vCPU out of
SMM to avoid any weirdness (and the WARN).

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: ed129ec9057f ("KVM: x86: forcibly leave nested mode on vCPU reset")
Cc: stable@vger.kernel.org
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Mikhail Lobanov <m.lobanov@rosa.ru>
Link: https://lore.kernel.org/r/20250414171207.155121-1-m.lobanov@rosa.ru
[sean: massage changelog, make it clear this isn't architectural behavior]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/smm.c     | 1 +
 arch/x86/kvm/svm/svm.c | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/arch/x86/kvm/smm.c b/arch/x86/kvm/smm.c
index b42111a24cc28..8e38c51359d05 100644
--- a/arch/x86/kvm/smm.c
+++ b/arch/x86/kvm/smm.c
@@ -131,6 +131,7 @@ void kvm_smm_changed(struct kvm_vcpu *vcpu, bool entering_smm)
 
 	kvm_mmu_reset_context(vcpu);
 }
+EXPORT_SYMBOL_GPL(kvm_smm_changed);
 
 void process_smi(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 0c01887124b6c..c84a1451f194c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2225,6 +2225,10 @@ static int shutdown_interception(struct kvm_vcpu *vcpu)
 	 */
 	if (!sev_es_guest(vcpu->kvm)) {
 		clear_page(svm->vmcb);
+#ifdef CONFIG_KVM_SMM
+		if (is_smm(vcpu))
+			kvm_smm_changed(vcpu, false);
+#endif
 		kvm_vcpu_reset(vcpu, true);
 	}
 
-- 
2.39.5



