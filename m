Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F7B572682;
	Wed,  9 Sep 2026 14:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963986; cv=none; b=cKtTCc+AlQiOGambsX3ytIQhWLU7NXRsDMUpgkTwwQ2OJlhsPyyRX/y4RulFh1Lsr7+bKtdI6JtrBlwse0adKR291Py1fyiyTRw3YbYyynrULYCHQfPDj9vlQnfugqfKiL3+4y9hXBn+/MUjTSITZC4IuUTlAkNX/bYPhy4tXOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963986; c=relaxed/simple;
	bh=Ot5cT67zKJUl9u45pZvy21pDPwoQqOIc8a2vY1Nz8gc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T3G4pUAWFyGRQRzFH7HAKf4OhxzasSxUgAdo/FZ1txWZLSQvFQXqZrWG/V4awOyZWMrBEa7jebfCxx5wIewgMQr1jpoMnLRV5ZSG7GkKP3tiMZvIOklO2h6tmVZKhdh3RZPjmReRYrU9w9YZ8kRGjEOTZgzGNV5VWsMijkujnYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kK85IDZR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kK85IDZR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39C4F1F00A3A;
	Wed,  9 Sep 2026 14:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963984;
	bh=pnLfbiHsCSmSA6FVZMKX9g9tqkuTaYjFQkQLp/3TS/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kK85IDZRCrzhb+/PQo/dZbF2jsDfcnWFuc7E4ZUcG+1gL49vPE7E430RAEJcQ0A9W
	 NNlKKD2V5Q7dJVDllaB4YnUx1iaj70RvhaQL1ePecmyz6lBsnSM9aOS610W2M9yXfy
	 fc3gYBmBnkn21K4bcVpMR8HePHgGKXmI/pcJ0m/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Cui <cuitao@kylinos.cn>,
	Bibo Mao <maobibo@loongson.cn>,
	Zeng Chi <zengchi@kylinos.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.18 265/583] LoongArch: KVM: Preserve memslot arch flags on KVM_MR_FLAGS_ONLY
Date: Wed,  9 Sep 2026 15:39:10 +0200
Message-ID: <20260909134247.277489016@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Zeng Chi <zengchi@kylinos.cn>

commit 27a9bfee3bbcb3cabb77797354f07e0e44e49831 upstream.

kvm_arch_prepare_memory_region() computes new->arch.flags, i.e. whether
a memslot is KVM_MEM_HUGEPAGE_CAPABLE or KVM_MEM_HUGEPAGE_INCAPABLE,
only for KVM_MR_CREATE and KVM_MR_MOVE, and returns early for every
other change. But the generic code allocates a zeroed memslot for every
change and never copies old->arch, so after a KVM_MR_FLAGS_ONLY update,
e.g. toggling KVM_MEM_LOG_DIRTY_PAGES for live migration, the active
memslot has arch.flags == 0.

With both flags clear, fault_supports_huge_mapping() falls through to
the alignment check on the HVA range alone, which no longer verifies
that the GPA and HVA have the same offset within a PMD. A memslot that
was marked KVM_MEM_HUGEPAGE_INCAPABLE because of a GPA/HVA offset
mismatch can then be mapped with PMD entries on read faults, and since
kvm_map_page() aligns the gfn and the pfn independently, the guest ends
up accessing the wrong host pages, exactly the "d -> f, e -> g" case
described in the comment above the check.

Carry the arch flags over from the old memslot for KVM_MR_FLAGS_ONLY,
as the GPA, HVA and size are guaranteed to be unchanged for that case.

Cc: stable@vger.kernel.org
Fixes: 7ab6fb505b2a ("LoongArch: KVM: Optimization for memslot hugepage checking")
Tested-by: Tao Cui <cuitao@kylinos.cn>
Reviewed-by: Tao Cui <cuitao@kylinos.cn>
Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Zeng Chi <zengchi@kylinos.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kvm/mmu.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/arch/loongarch/kvm/mmu.c
+++ b/arch/loongarch/kvm/mmu.c
@@ -383,6 +383,16 @@ int kvm_arch_prepare_memory_region(struc
 	hva_t hva_start;
 	size_t size, gpa_offset, hva_offset;
 
+	/*
+	 * The generic code allocates a fresh, zeroed memslot for every change,
+	 * so the arch flags computed below must be carried over when only the
+	 * userspace flags change, e.g. when dirty logging is toggled.
+	 */
+	if (change == KVM_MR_FLAGS_ONLY) {
+		new->arch = old->arch;
+		return 0;
+	}
+
 	if ((change != KVM_MR_MOVE) && (change != KVM_MR_CREATE))
 		return 0;
 	/*


