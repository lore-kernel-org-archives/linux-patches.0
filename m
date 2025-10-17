Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AFAE336EF2;
	Fri, 17 Oct 2025 15:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715267; cv=none; b=OzLkwzMru6ogsEk4Zrvhx0e2nM0pAXzVoEiNWUM1hrcO/lNLmabqrQv8RGDsJr0uOItvVozzVQzT/a9yZr7O6MQPn/Z3D9EvSQ40gM0gZyCLLDrhRYD+C/9tM3Zy4pGUZ8MsmEjMDlB5CdQ3XnyBwMFhL98JESL2GxE8N6UMgWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715267; c=relaxed/simple;
	bh=Fu3Ppa2fNY5JyMCBcUKa+fjiWqP6J0R2Y4XyoYViokQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kQZYclfy74lN7H+sBw4vWSJSKgeKdy/jEYi24p3+J9edQByinBA0+N7009JRMPYlgIPNdUMo00uKCDTWiE7r3gCK8Ri18UYLqesajbvcPa7qemUwW3AMzWpNNR4I0b8RQQqzJ4sh1TxonIF7gW9Urq2UBQhfV6cpM5cdZ28amWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YK1zxZVP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YK1zxZVP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD8E1C4CEFE;
	Fri, 17 Oct 2025 15:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715267;
	bh=Fu3Ppa2fNY5JyMCBcUKa+fjiWqP6J0R2Y4XyoYViokQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YK1zxZVP79HTElRA31U80CUtKNMqxab/pnMplteMneh6R1Fvg22kBq3QIn16cE9Io
	 109K6NiY7XWBfWcf+VXl5QBc98Ny36j0cuT/513BApht3V7ogfml12h6rPD4zebU9u
	 g4Kb/L1IdIn78LlTws618exrAwaufSU44mLOdTIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Horgan <ben.horgan@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Quentin Perret <qperret@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.17 155/371] KVM: arm64: Fix debug checking for np-guests using huge mappings
Date: Fri, 17 Oct 2025 16:52:10 +0200
Message-ID: <20251017145207.541324466@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Horgan <ben.horgan@arm.com>

commit 2ba972bf71cb71d2127ec6c3db1ceb6dd0c73173 upstream.

When running with transparent huge pages and CONFIG_NVHE_EL2_DEBUG then
the debug checking in assert_host_shared_guest() fails on the launch of an
np-guest. This WARN_ON() causes a panic and generates the stack below.

In __pkvm_host_relax_perms_guest() the debug checking assumes the mapping
is a single page but it may be a block map. Update the checking so that
the size is not checked and just assumes the correct size.

While we're here make the same fix in __pkvm_host_mkyoung_guest().

  Info: # lkvm run -k /share/arch/arm64/boot/Image -m 704 -c 8 --name guest-128
  Info: Removed ghost socket file "/.lkvm//guest-128.sock".
[ 1406.521757] kvm [141]: nVHE hyp BUG at: arch/arm64/kvm/hyp/nvhe/mem_protect.c:1088!
[ 1406.521804] kvm [141]: nVHE call trace:
[ 1406.521828] kvm [141]:  [<ffff8000811676b4>] __kvm_nvhe_hyp_panic+0xb4/0xe8
[ 1406.521946] kvm [141]:  [<ffff80008116d12c>] __kvm_nvhe_assert_host_shared_guest+0xb0/0x10c
[ 1406.522049] kvm [141]:  [<ffff80008116f068>] __kvm_nvhe___pkvm_host_relax_perms_guest+0x48/0x104
[ 1406.522157] kvm [141]:  [<ffff800081169df8>] __kvm_nvhe_handle___pkvm_host_relax_perms_guest+0x64/0x7c
[ 1406.522250] kvm [141]:  [<ffff800081169f0c>] __kvm_nvhe_handle_trap+0x8c/0x1a8
[ 1406.522333] kvm [141]:  [<ffff8000811680fc>] __kvm_nvhe___skip_pauth_save+0x4/0x4
[ 1406.522454] kvm [141]: ---[ end nVHE call trace ]---
[ 1406.522477] kvm [141]: Hyp Offset: 0xfffece8013600000
[ 1406.522554] Kernel panic - not syncing: HYP panic:
[ 1406.522554] PS:834003c9 PC:0000b1806db6d170 ESR:00000000f2000800
[ 1406.522554] FAR:ffff8000804be420 HPFAR:0000000000804be0 PAR:0000000000000000
[ 1406.522554] VCPU:0000000000000000
[ 1406.523337] CPU: 3 UID: 0 PID: 141 Comm: kvm-vcpu-0 Not tainted 6.16.0-rc7 #97 PREEMPT
[ 1406.523485] Hardware name: FVP Base RevC (DT)
[ 1406.523566] Call trace:
[ 1406.523629]  show_stack+0x18/0x24 (C)
[ 1406.523753]  dump_stack_lvl+0xd4/0x108
[ 1406.523899]  dump_stack+0x18/0x24
[ 1406.524040]  panic+0x3d8/0x448
[ 1406.524184]  nvhe_hyp_panic_handler+0x10c/0x23c
[ 1406.524325]  kvm_handle_guest_abort+0x68c/0x109c
[ 1406.524500]  handle_exit+0x60/0x17c
[ 1406.524630]  kvm_arch_vcpu_ioctl_run+0x2e0/0x8c0
[ 1406.524794]  kvm_vcpu_ioctl+0x1a8/0x9cc
[ 1406.524919]  __arm64_sys_ioctl+0xac/0x104
[ 1406.525067]  invoke_syscall+0x48/0x10c
[ 1406.525189]  el0_svc_common.constprop.0+0x40/0xe0
[ 1406.525322]  do_el0_svc+0x1c/0x28
[ 1406.525441]  el0_svc+0x38/0x120
[ 1406.525588]  el0t_64_sync_handler+0x10c/0x138
[ 1406.525750]  el0t_64_sync+0x1ac/0x1b0
[ 1406.525876] SMP: stopping secondary CPUs
[ 1406.525965] Kernel Offset: disabled
[ 1406.526032] CPU features: 0x0000,00000080,8e134ca1,9446773f
[ 1406.526130] Memory Limit: none
[ 1406.959099] ---[ end Kernel panic - not syncing: HYP panic:
[ 1406.959099] PS:834003c9 PC:0000b1806db6d170 ESR:00000000f2000800
[ 1406.959099] FAR:ffff8000804be420 HPFAR:0000000000804be0 PAR:0000000000000000
[ 1406.959099] VCPU:0000000000000000 ]

Signed-off-by: Ben Horgan <ben.horgan@arm.com>
Fixes: f28f1d02f4eaa ("KVM: arm64: Add a range to __pkvm_host_unshare_guest()")
Cc: Vincent Donnefort <vdonnefort@google.com>
Cc: Quentin Perret <qperret@google.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: stable@vger.kernel.org
Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1010,9 +1010,12 @@ static int __check_host_shared_guest(str
 		return ret;
 	if (!kvm_pte_valid(pte))
 		return -ENOENT;
-	if (kvm_granule_size(level) != size)
+	if (size && kvm_granule_size(level) != size)
 		return -E2BIG;
 
+	if (!size)
+		size = kvm_granule_size(level);
+
 	state = guest_get_page_state(pte, ipa);
 	if (state != PKVM_PAGE_SHARED_BORROWED)
 		return -EPERM;
@@ -1100,7 +1103,7 @@ int __pkvm_host_relax_perms_guest(u64 gf
 	if (prot & ~KVM_PGTABLE_PROT_RWX)
 		return -EINVAL;
 
-	assert_host_shared_guest(vm, ipa, PAGE_SIZE);
+	assert_host_shared_guest(vm, ipa, 0);
 	guest_lock_component(vm);
 	ret = kvm_pgtable_stage2_relax_perms(&vm->pgt, ipa, prot, 0);
 	guest_unlock_component(vm);
@@ -1156,7 +1159,7 @@ int __pkvm_host_mkyoung_guest(u64 gfn, s
 	if (pkvm_hyp_vm_is_protected(vm))
 		return -EPERM;
 
-	assert_host_shared_guest(vm, ipa, PAGE_SIZE);
+	assert_host_shared_guest(vm, ipa, 0);
 	guest_lock_component(vm);
 	kvm_pgtable_stage2_mkyoung(&vm->pgt, ipa, 0);
 	guest_unlock_component(vm);


