Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B54314D34;
	Mon, 17 Aug 2026 14:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975283; cv=none; b=F/UtmUc5GOXEyL5CyfiBDMufDFmgPjKGl46PbmiD/RnycFhKJUcyyj9oUeu6mxtXwMcRL0hjWgSAEOGY4ZIfN2diy1rGYp0qfGtVcorcxsmAZu/+no8ngz1NCq/azgwhKDJ3rMq9XL03s/50vNxp4XdJcacsbXf+TdUevC2PfV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975283; c=relaxed/simple;
	bh=Xfcd8fE/4jD46QGxdIPdIhCwJiFMtIZhNJat+IEbmT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kgyvqMTf7X68HzfZNQW2ZdF3jgiLWWfgb827Rn6Zi0tpD+qG2BqgYgsZKeD2Dxu/FHZ41p9chKOIMhuw6CE4OA7pqaazcLuUrg4PJsqq1Np+ZBoLWnHxtoGqhfRhqkF8y5pXuC8EXGx0rWYTMA4uW3b68eOGmOCG1K3W0oX5v6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SUH/8CQv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SUH/8CQv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D69F1F000E9;
	Mon, 17 Aug 2026 14:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975282;
	bh=nmi1PS6pUjdmIz9KV0iMOL9a1Ul+WeZ9wLG1omouA8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SUH/8CQvFchCoaorwoGtPT4228nyR0kkJetDDqZMRbaWU/RUinXVPe5REYIv893cg
	 PMpC9iwKykmRy6XtqGKZstlEB+Uf+REPk/lobgYaNjhXzyn28iQ7NjaL6izRS7BeSC
	 JXO6L4ser/tRmF8eiDoYcD8us4geTS8pLJGDZ+98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.18 225/250] KVM: x86/mmu: WARN and clear role.invalid when creating a child shadow page
Date: Mon, 17 Aug 2026 15:33:06 +0200
Message-ID: <20260817132545.710895212@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 5ec42d57655c690234c14aece6dd3f209778c1d8 upstream.

Explicitly clear role.invalid when deriving a child shadow page's role from
its parent to harden against bugs elsewhere in KVM, as violating KVM's
invariant that invalid pages are NOT on the list of active MMU pages leads
to use-after-free due to __kvm_mmu_prepare_zap_page() using list_add()
instead of list_move() when processing an invalid shadow page, i.e. makes a
bad situation far worse.

Yell loudly if the parent is invalid, as it means KVM has missed a validity
check, i.e. KVM is attempting to map memory using an invalid/obsolete root,
but continue on as the child is otherwise still a valid shadow page.

  ==================================================================
  BUG: KASAN: slab-use-after-free in __kvm_mmu_get_shadow_page+0x1817/0x1860 [kvm]
  Write of size 8 at addr ff11000153dd1368 by task repro/853

  CPU: 1 UID: 1000 PID: 853 Comm: repro Not tainted 7.2.0-rc2-3aec122bdcaf-next-vm #5 PREEMPT
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  Call Trace:
   <TASK>
   dump_stack_lvl+0x4b/0x70
   print_report+0x153/0x49c
   kasan_report+0xbc/0xf0
   __kvm_mmu_get_shadow_page+0x1817/0x1860 [kvm]
   mmu_alloc_root+0x141/0x320 [kvm]
   kvm_mmu_load+0x612/0x20f0 [kvm]
   kvm_arch_vcpu_ioctl_run+0x3dd5/0x6150 [kvm]
   kvm_vcpu_ioctl+0x5e4/0x10d0 [kvm]
   __x64_sys_ioctl+0x131/0x1b0
   do_syscall_64+0x67/0x5f0
   entry_SYSCALL_64_after_hwframe+0x4b/0x53
   </TASK>

  Allocated by task 853:
   kasan_save_stack+0x20/0x40
   kasan_save_track+0x14/0x30
   __kasan_slab_alloc+0x5f/0x70
   kmem_cache_alloc_noprof+0xfe/0x2e0
   __kvm_mmu_topup_memory_cache+0x135/0x530 [kvm]
   paging64_page_fault+0x318/0x1e30 [kvm]
   kvm_mmu_do_page_fault+0x21d/0x630 [kvm]
   kvm_mmu_page_fault+0x18c/0x17b0 [kvm]
   kvm_arch_vcpu_ioctl_run+0x1f35/0x6150 [kvm]
   kvm_vcpu_ioctl+0x5e4/0x10d0 [kvm]
   __x64_sys_ioctl+0x131/0x1b0
   do_syscall_64+0x67/0x5f0
   entry_SYSCALL_64_after_hwframe+0x4b/0x53

  Freed by task 853:
   kasan_save_stack+0x20/0x40
   kasan_save_track+0x14/0x30
   kasan_save_free_info+0x3b/0x60
   __kasan_slab_free+0x43/0x70
   kmem_cache_free+0xe2/0x400
   kvm_mmu_commit_zap_page.part.0+0x1e2/0x310 [kvm]
   kvm_mmu_free_roots+0x283/0x560 [kvm]
   kvm_arch_vcpu_ioctl_run+0x33c8/0x6150 [kvm]
   kvm_vcpu_ioctl+0x5e4/0x10d0 [kvm]
   __x64_sys_ioctl+0x131/0x1b0
   do_syscall_64+0x67/0x5f0
   entry_SYSCALL_64_after_hwframe+0x4b/0x53

Reported-by: Hyunwoo Kim <imv4bel@gmail.com>
Fixes: a770f6f28b1a ("KVM: MMU: Inherit a shadow page's guest level count from vcpu setup")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/mmu.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2415,6 +2415,9 @@ static union kvm_mmu_page_role kvm_mmu_c
 	role.direct = direct;
 	role.passthrough = 0;
 
+	WARN_ON_ONCE(role.invalid);
+	role.invalid = 0;
+
 	/*
 	 * If the guest has 4-byte PTEs then that means it's using 32-bit,
 	 * 2-level, non-PAE paging. KVM shadows such guests with PAE paging


