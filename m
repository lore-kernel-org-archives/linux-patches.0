Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498B12116F6;
	Tue, 17 Mar 2026 17:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767610; cv=none; b=ZvV2OBJUuP6bdh+Xd6t15QwZUtTQ7eyfwu24DeoHZpt+MNRc/kDsR9m8BJ8+BT2rtfaQlgeidDs5vsgucbmEC/WUKHmOQLPrjkCSG0Vhy4ssCQOAke/T9p/dPaj+7TQbd5oOJWaDIIvK9Y56kUArjCG+zBhLGvFQxD4OSO/MfaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767610; c=relaxed/simple;
	bh=67sQdvUhJihgFQlRpkqthqAiRtrb5oHzHITmLvpmzlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MTcCqHlAKTWGE9PDSj602kMx3n1eODyLW5QPp/CVOwivqeMAbrZrG1dA0wBManZlDwh6kzH0seLrypdqwWEXx6QP3Co+4iIHUI0tsxSHRKYkJQYgFRs5BCNjMHoQOTXx4v/DFZ5XJsaZIsnTAISmj00JAfZ/uGWE7nxL7RX5Ss4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F+/jerf/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F+/jerf/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B119BC4CEF7;
	Tue, 17 Mar 2026 17:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767610;
	bh=67sQdvUhJihgFQlRpkqthqAiRtrb5oHzHITmLvpmzlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F+/jerf/MiDZsOV69ckwiEd786ZHfrRnEmKnuMTe+RbaBmxgR3RMERykggklKeJuW
	 2a2PzwU2R00cSLUH/XDNanOFuXDKW9f7XUaN9haOVftsU47ZJ4w3biDoiv0nnopT7i
	 sKzbIBBxOQ/+yEb2EDURgyrt2c1mM04a9Dk/XxNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <tabba@google.com>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.18 122/333] KVM: arm64: Fix protected mode handling of pages larger than 4kB
Date: Tue, 17 Mar 2026 17:32:31 +0100
Message-ID: <20260317163003.890762161@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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
@@ -1712,14 +1712,12 @@ static int user_mem_abort(struct kvm_vcp
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


