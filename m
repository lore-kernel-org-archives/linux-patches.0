Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 544E4175A62;
	Sat, 28 Feb 2026 17:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301423; cv=none; b=Vt8BxKMdDtYqSlrJslbYi9zyD8C8bCujLAE6xUcisrzXzH1NLiTdA/XN2KBBnAvuN501liYgdUAYNip76MKJlzoVRrDmo0WPnzK3Akd5/T21JTgIE1s7KIvE3KcVDbpuLqxITe3EAScA3SFJCXtS5yW4C3swbVUCV0/GCDHPyYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301423; c=relaxed/simple;
	bh=USkyuhDvxldscB+giJ7RJhd/BoaY92yHbxg2oleRDLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VXR0QsKeUX1CYFtZXtbm7SYB2BpLYWhj8wSI/jYP6ELnSw2b+GN/YaevmQJevOvmJh9eaJzk/XH3PN4WhpV1kyfCwrl/RehB0QR2jm2QXwNxhs0eRXUCv8nDFGnpN3zbKFXQHNu1wOFwMHyMP3vxlnTsoB+j9ZctEqeLdrC3Ez4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M1kISCko; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M1kISCko"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4745C19424;
	Sat, 28 Feb 2026 17:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301423;
	bh=USkyuhDvxldscB+giJ7RJhd/BoaY92yHbxg2oleRDLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M1kISCkoRcp2QhGILabceT6CK89PGfGgCwS7B24AWT4RYcy11kI0nYPoUKGU3yfW+
	 1j8SYUxL1TXe6e6WiFuyG51WCbHh3JdG4l9vVG/fvZQUMH4SI0fyLsPg60GNm5Sgl1
	 NWPjAAwX4JDGFfMy3wfdwlWk/QGvqnxm7t1kJRJ0I2PqEWTVtc129ld+kOxN7pZr3d
	 lftbXhsFbvKctAI1bvZLdRMmau4IkbEelV0SFbIoHtiKowD+COj5mM9bQOgzD80K5Z
	 s+0D9ucLmEtg4NWG8jJ5NPhgEFA5T0+yLSaJjGkoYx68IYUeT3eLWvjTmkU+IAmvdO
	 O/bscxvyGu5PA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Vasiliy Kovalev <kovalev@altlinux.org>,
	Sean Christopherson <seanjc@google.com>,
	stable@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 613/752] KVM: x86: Add SRCU protection for reading PDPTRs in __get_sregs2()
Date: Sat, 28 Feb 2026 12:45:24 -0500
Message-ID: <20260228174750.1542406-613-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Vasiliy Kovalev <kovalev@altlinux.org>

[ Upstream commit 95d848dc7e639988dbb385a8cba9b484607cf98c ]

Add SRCU read-side protection when reading PDPTR registers in
__get_sregs2().

Reading PDPTRs may trigger access to guest memory:
kvm_pdptr_read() -> svm_cache_reg() -> load_pdptrs() ->
kvm_vcpu_read_guest_page() -> kvm_vcpu_gfn_to_memslot()

kvm_vcpu_gfn_to_memslot() dereferences memslots via __kvm_memslots(),
which uses srcu_dereference_check() and requires either kvm->srcu or
kvm->slots_lock to be held. Currently only vcpu->mutex is held,
triggering lockdep warning:

=============================
WARNING: suspicious RCU usage in kvm_vcpu_gfn_to_memslot
6.12.59+ #3 Not tainted

include/linux/kvm_host.h:1062 suspicious rcu_dereference_check() usage!

other info that might help us debug this:

rcu_scheduler_active = 2, debug_locks = 1
1 lock held by syz.5.1717/15100:
 #0: ff1100002f4b00b0 (&vcpu->mutex){+.+.}-{3:3}, at: kvm_vcpu_ioctl+0x1d5/0x1590

Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0xf0/0x120 lib/dump_stack.c:120
 lockdep_rcu_suspicious+0x1e3/0x270 kernel/locking/lockdep.c:6824
 __kvm_memslots include/linux/kvm_host.h:1062 [inline]
 __kvm_memslots include/linux/kvm_host.h:1059 [inline]
 kvm_vcpu_memslots include/linux/kvm_host.h:1076 [inline]
 kvm_vcpu_gfn_to_memslot+0x518/0x5e0 virt/kvm/kvm_main.c:2617
 kvm_vcpu_read_guest_page+0x27/0x50 virt/kvm/kvm_main.c:3302
 load_pdptrs+0xff/0x4b0 arch/x86/kvm/x86.c:1065
 svm_cache_reg+0x1c9/0x230 arch/x86/kvm/svm/svm.c:1688
 kvm_pdptr_read arch/x86/kvm/kvm_cache_regs.h:141 [inline]
 __get_sregs2 arch/x86/kvm/x86.c:11784 [inline]
 kvm_arch_vcpu_ioctl+0x3e20/0x4aa0 arch/x86/kvm/x86.c:6279
 kvm_vcpu_ioctl+0x856/0x1590 virt/kvm/kvm_main.c:4663
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:907 [inline]
 __se_sys_ioctl fs/ioctl.c:893 [inline]
 __x64_sys_ioctl+0x18b/0x210 fs/ioctl.c:893
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xbd/0x1d0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Suggested-by: Sean Christopherson <seanjc@google.com>
Cc: stable@vger.kernel.org
Fixes: 6dba94035203 ("KVM: x86: Introduce KVM_GET_SREGS2 / KVM_SET_SREGS2")
Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
Link: https://patch.msgid.link/20260123222801.646123-1-kovalev@altlinux.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 79d0abaf71dde..aeb7f902b3c7f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12147,9 +12147,11 @@ static void __get_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2)
 		return;
 
 	if (is_pae_paging(vcpu)) {
+		kvm_vcpu_srcu_read_lock(vcpu);
 		for (i = 0 ; i < 4 ; i++)
 			sregs2->pdptrs[i] = kvm_pdptr_read(vcpu, i);
 		sregs2->flags |= KVM_SREGS2_FLAGS_PDPTRS_VALID;
+		kvm_vcpu_srcu_read_unlock(vcpu);
 	}
 }
 
-- 
2.51.0

