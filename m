Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4FC44ED1BA;
	Fri,  9 Oct 2026 14:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557179; cv=none; b=Vgr0mS2KTfT/ASgSKo0IbIvc58m3g9NeV7G6KLhSs1xJGsYxxHsXlSCaIYly1FhWsOoIhxs1p4RYtX7vj4D9q/1QKu/7/WcunlH6HqgOenaRg3f8M9m4CLgSPzNdUZggZ397smZcrnh0YSjh05jepIiYlaQOAB6qa3/xd5vzbT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557179; c=relaxed/simple;
	bh=Aol49URDvE054s71q+FBztELMJapX1xCJGHE6WM/Sks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l9r979scf0IhPBcaIqYy0z/hUAiUEmA2oT6QrT/2GQSbmkKPu2HiFG+C1/oX8aY81J6NWG057krHj3La9MP7zl2Fi+CTlEXNdHhOBZL7+Vr58AuQWtWBSgZp3bXlbL5+SrDQGfuxbOtkweDe+s7omhO3NO5ReXg+UYR1KKYPGxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o/J7Au2x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o/J7Au2x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DBD61F000FF;
	Fri,  9 Oct 2026 14:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557178;
	bh=pDxnFtb3L43TjYcq9sNFsCYpDw1LGr008CUx1NhcD0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o/J7Au2xJEdDDBmmAzNlC8vRdTg8u96OvPYPpjsJZxV/AY0CZu2eZPm4Z09XNgbaj
	 0aHwQ4OdEruicY2PKE1Dr7pyW2ZbTpIImJwWTJm5godHYTSd/NIKx6ee7VtaZbuWH4
	 20BoBeXyjNemp/bIYcYo0LHjTP4kge4nC1seBafM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Schneider <gbrls@osec.io>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 7.2 314/428] KVM: x86/mmu: Bail from shadow walks if the root is invalid or a dummy
Date: Fri,  9 Oct 2026 16:10:51 +0200
Message-ID: <20261009140953.022269505@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit b6249c1d5665098c8bf12f8d3e4712bf04c775bc upstream.

When walking shadow page tables, immediately terminate the walk if the root
is a "dummy" root, i.e. a root whose top-level page table is backed by the
zero page, but otherwise doesn't exist.  If memslot creation races with a
stage-2 page fault (EPT violation or #NPF) from L2, then if the stars align,
KVM will attempt to walk shadow page tables using the zero page and hit a
NULL pointer deref.

  BUG: kernel NULL pointer dereference, address: 0000000000000021
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 0 P4D 0
  Oops: Oops: 0000 [#1] SMP
  CPU: 30 UID: 1000 PID: 941 Comm: qemu Not tainted 7.2.0-rc2-1b731e5ded48-next-vm #1741 PREEMPTLAZY
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  RIP: 0010:__kvm_mmu_invalidate_addr+0xea/0x210 [kvm]
  Call Trace:
   <TASK>
   kvm_mmu_invalidate_addr+0x92/0xe0 [kvm]
   __kvm_inject_emulated_page_fault+0x67/0x80 [kvm]
   ept_page_fault+0x160/0x850 [kvm]
   kvm_mmu_do_page_fault+0x102/0x1f0 [kvm]
   kvm_mmu_page_fault+0x8e/0x6b0 [kvm]
   vmx_handle_exit+0x163/0x640 [kvm_intel]
   kvm_arch_vcpu_ioctl_run+0x960/0x2120 [kvm]
   kvm_vcpu_ioctl+0x2c7/0x970 [kvm]
   __x64_sys_ioctl+0x90/0xd0
   do_syscall_64+0x67/0x5f0
   entry_SYSCALL_64_after_hwframe+0x4b/0x53
  RIP: 0033:0x7f606d0b53bb

Opportunistically harden the shadow walks against fully invalid roots, but
WARN, as all callers are expected/required to pre-check for a valid root.
Don't WARN in the dummy root case as the whole point of using a dummy root
is to provide a root that's valid enough to enter the guest, i.e. it should
Just Work for all flows except those that *need* to know about dummy roots.

Alternatively, KVM could allocate a dedicated page and associated shadow
page structure for the dummy root, which is very tempting as it such an
approach should be more resilient against unexpected behavior.  But that
would be a much larger and thus riskier change than simply terminating
walks of dummy roots.

Fixes: 0e3223d8d00a ("KVM: x86/mmu: Use dummy root, backed by zero page, for !visible guest roots")
Reported-by: Gabriel Schneider <gbrls@osec.io>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20260925234256.2384816-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/mmu.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2506,6 +2506,12 @@ static void shadow_walk_init_using_root(
 {
 	iterator->addr = addr;
 	iterator->shadow_addr = root;
+
+	if (WARN_ON_ONCE(!VALID_PAGE(root)) || kvm_mmu_is_dummy_root(root)) {
+		iterator->level = 0;
+		return;
+	}
+
 	iterator->level = vcpu->arch.mmu->root_role.level;
 
 	if (iterator->level >= PT64_ROOT_4LEVEL &&


