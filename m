Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A9343F23DD;
	Tue, 17 Mar 2026 16:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766092; cv=none; b=E8w+wVnpq5Kqk/93+mgKLgsycabyru/fhaScxrC+xO3rVbqk8YUdYawZFeY4JiJqKem1GsHM0lIVoPZbOjewDdqA9spRDAk4m99bA5mQGQNLE+qNWt6iEjpCYdMuxSJd979FmyOYGQ0LeG2eBemyBjBbo5uyX8cB71KBf/gK8Jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766092; c=relaxed/simple;
	bh=IX8XhHk9FuFshYtZ2mXPUWj6WRqcaVQ4bLHXuMP6LNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aZkO4S5733E18flu5Ma0m4lYM8SKDr8OigGUEOvXYQv+F9cVwmg+DxXkWiCRM+qQV8wDCRBO61nRs4BoEvb0h+ewr/4aR56e+wqWQlLduCikx+oDVZ+rNigbmdHumsa+f7HySgHRWrVoRJSTJZm8M6/yNhN4qewksFAwBlWn0sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S0rdWo0x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S0rdWo0x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 851EEC4CEF7;
	Tue, 17 Mar 2026 16:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766092;
	bh=IX8XhHk9FuFshYtZ2mXPUWj6WRqcaVQ4bLHXuMP6LNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S0rdWo0xLErtOt+TKGWiMLnIpp7RvBPqFBWwSSiGK+IbUuXi37SSUvlspXbs4bYhj
	 mnU9Q8ei/wcHvoJrLCDL+hdDVf8Q0NtAMnmeBhL3dClp1OZelDAvWheTYHKHFIEZBj
	 gOa7OB5qfC5mvYLD52ZI78UdubrWdUVi4lwgEjGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <tabba@google.com>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.19 135/378] KVM: arm64: Fix protected mode handling of pages larger than 4kB
Date: Tue, 17 Mar 2026 17:31:32 +0100
Message-ID: <20260317163011.982006007@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

commit 08f97454b7fa39bfcf82524955c771d2d693d6fe upstream.

Since 3669ddd8fa8b5 ("KVM: arm64: Add a range to pkvm_mappings"),
pKVM tracks the memory that has been mapped into a guest in a
side data structure. Crucially, it uses it to find out whether
a page has already been mapped, and therefore refuses to map it
twice. So far, so good.

However, this very patch completely breaks non-4kB page support,
with guests being unable to boot. The most obvious symptom is that
we take the same fault repeatedly, and not making forward progress.
A quick investigation shows that this is because of the above
rejection code.

As it turns out, there are multiple issues at play:

- while the HPFAR_EL2 register gives you the faulting IPA minus
  the bottom 12 bits, it will still give you the extra bits that
  are part of the page offset for anything larger than 4kB,
  even for a level-3 mapping

- pkvm_pgtable_stage2_map() assumes that the address passed as
  a parameter is aligned to the size of the intended mapping

- the faulting address is only aligned for a non-page mapping

When the planets are suitably aligned (pun intended), the guest
faults on a page by accessing it past the bottom 4kB, and extra bits
get set in the HPFAR_EL2 register. If this results in a page mapping
(which is likely with large granule sizes), nothing aligns it further
down, and pkvm_mapping_iter_first() finds an intersection that
doesn't really exist. We assume this is a spurious fault and return
-EAGAIN. And again...

This doesn't hit outside of the protected code, as the page table
code always aligns the IPA down to a page boundary, hiding the issue
for everyone else.

Fix it by always forcing the alignment on vma_pagesize, irrespective
of the value of vma_pagesize.

Fixes: 3669ddd8fa8b5 ("KVM: arm64: Add a range to pkvm_mappings")
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://https://patch.msgid.link/20260222141000.3084258-1-maz@kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/mmu.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1753,14 +1753,12 @@ static int user_mem_abort(struct kvm_vcp
 	}
 
 	/*
-	 * Both the canonical IPA and fault IPA must be hugepage-aligned to
-	 * ensure we find the right PFN and lay down the mapping in the right
-	 * place.
+	 * Both the canonical IPA and fault IPA must be aligned to the
+	 * mapping size to ensure we find the right PFN and lay down the
+	 * mapping in the right place.
 	 */
-	if (vma_pagesize == PMD_SIZE || vma_pagesize == PUD_SIZE) {
-		fault_ipa &= ~(vma_pagesize - 1);
-		ipa &= ~(vma_pagesize - 1);
-	}
+	fault_ipa = ALIGN_DOWN(fault_ipa, vma_pagesize);
+	ipa = ALIGN_DOWN(ipa, vma_pagesize);
 
 	gfn = ipa >> PAGE_SHIFT;
 	mte_allowed = kvm_vma_mte_allowed(vma);


