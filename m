Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A9D426693;
	Mon, 17 Aug 2026 14:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978279; cv=none; b=TZOdnIHSi7Q0IO9k0xzYxwgDDCunYKLx/c/sjiUAQcAPXMKcmXOYQ0rFdvkdepN3JFnx+ASaoemViAYaV2V2ckRw3nR3y1hUSBK0v4iAsyDYd/inKIZAd5DwzMqU1kn733L6Tm5xxBKAkaFXa6Jp4FiHmWByU6uWnrP2bJIdf+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978279; c=relaxed/simple;
	bh=p5dacGHBl/xkjMyyO1u60bY5hJ7CdpzKFSIpLBJWMcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=etJ2cWVMucKGAPtfkpNPKoIV63sv+qnctYAYsuBH0bM5qVlNMxPlBGcTQK17zjHdHQJ2IThkjdT431kc5GT/BK9l8HRh9Suezq95UAf1JRV/lH+NpjxmIEj6r8JLZhFGq4CNGysluBoAvoZEOiAAFu8go9pARN/lLJ7xzSZm6Rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cOMDxj44; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cOMDxj44"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EFF21F000E9;
	Mon, 17 Aug 2026 14:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978278;
	bh=xqOI+gyzjPx5vS3qWByHc3l2GL1M+WLDB1Ns2NarETE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cOMDxj44kP+i2eMoi0vk6k5GPQsgkny70Ejh9Hj2121yLsNdb/iaDLgUDETgsj1eo
	 eJrEWEzgJt7l/sTcEM6e60GRrXPyOhv6auK2irDoQT+vk1S53/Nhk+iBY8AIgk/vni
	 VIiqN756Gp4ZCkA72/VwcAOLpchJPr7iY/euhGfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.12 161/181] KVM: x86/mmu: WARN and clear role.invalid when creating a child shadow page
Date: Mon, 17 Aug 2026 15:34:15 +0200
Message-ID: <20260817132542.022864737@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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
@@ -2291,6 +2291,9 @@ static union kvm_mmu_page_role kvm_mmu_c
 	role.direct = direct;
 	role.passthrough = 0;
 
+	WARN_ON_ONCE(role.invalid);
+	role.invalid = 0;
+
 	/*
 	 * If the guest has 4-byte PTEs then that means it's using 32-bit,
 	 * 2-level, non-PAE paging. KVM shadows such guests with PAE paging


