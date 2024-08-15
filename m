Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 591BA1714DD;
	Thu, 15 Aug 2024 14:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731023; cv=none; b=fYAfx/RNAcIW6C1m8rf3QUe6eeCI/yQz/Evs2ps/sAsn1oYvWvngeVoPtzEc8IV+TyTQGlffMLbPj4L1dnlFdBIkIwMdzpPrln3vPBNYlLUbDo9FTY/qHJ1UvGsRSYkaOuzrJqv1otXBk60Ca4oqBM6AJHuiMZiADEp6qI9ouY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731023; c=relaxed/simple;
	bh=eDF3IHU/OuVzp5uR0HbPH/uoTQ8kac6eR4lNNFvNLmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lzcrHLh2pEZyB2GJgPg6+14GQy0upmzyvP3pzGH9zFWpeF1lFDkS9ZIUoqOUbnYoCBuL56BfnH+Ek8dVt5Sdtau8yDncQDGpewqp0MHVmvA1GMLEQZltbwgTcpvF9pKX+rx/vyXipcxgNakuGlN1xL/52i+eO5to/H1fxLiU5ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PV7xjMoq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PV7xjMoq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 855CDC32786;
	Thu, 15 Aug 2024 14:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731022;
	bh=eDF3IHU/OuVzp5uR0HbPH/uoTQ8kac6eR4lNNFvNLmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PV7xjMoqxs5TR3pjqzaYswedBKziDkbjX2Z4qgbzDpTWZKSqy+SeWBK/LjBKom25t
	 kGtkD09rmswbqtF4YVhb/cEjlyV90TvEqLV3Q9iVgQJZZbSL2/LDQGL9EIhWmxy+tY
	 hEt99QY4BSY+BsyIxukID7ik5bJmCS+ZWEtU2Pjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gavin Shan <gshan@redhat.com>,
	Marc Zyngier <maz@kernel.org>,
	Quentin Perret <qperret@google.com>,
	Will Deacon <will@kernel.org>,
	Shaoqin Huang <shahuang@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 6.6 67/67] KVM: arm64: Dont pass a TLBI level hint when zapping table entries
Date: Thu, 15 Aug 2024 15:26:21 +0200
Message-ID: <20240815131840.869747090@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131838.311442229@linuxfoundation.org>
References: <20240815131838.311442229@linuxfoundation.org>
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

From: Will Deacon <will@kernel.org>

commit 36e008323926036650299cfbb2dca704c7aba849 upstream.

The TLBI level hints are for leaf entries only, so take care not to pass
them incorrectly after clearing a table entry.

Cc: Gavin Shan <gshan@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Quentin Perret <qperret@google.com>
Fixes: 82bb02445de5 ("KVM: arm64: Implement kvm_pgtable_hyp_unmap() at EL2")
Fixes: 6d9d2115c480 ("KVM: arm64: Add support for stage-2 map()/unmap() in generic page-table")
Signed-off-by: Will Deacon <will@kernel.org>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20240327124853.11206-3-will@kernel.org
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Cc: <stable@vger.kernel.org> # 6.6.y only
[will@: Use '0' instead of TLBI_TTL_UNKNOWN to indicate "no level"]
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/hyp/pgtable.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -523,7 +523,7 @@ static int hyp_unmap_walker(const struct
 
 		kvm_clear_pte(ctx->ptep);
 		dsb(ishst);
-		__tlbi_level(vae2is, __TLBI_VADDR(ctx->addr, 0), ctx->level);
+		__tlbi_level(vae2is, __TLBI_VADDR(ctx->addr, 0), 0);
 	} else {
 		if (ctx->end - ctx->addr < granule)
 			return -EINVAL;
@@ -861,10 +861,12 @@ static void stage2_unmap_put_pte(const s
 	if (kvm_pte_valid(ctx->old)) {
 		kvm_clear_pte(ctx->ptep);
 
-		if (!stage2_unmap_defer_tlb_flush(pgt) ||
-		    kvm_pte_table(ctx->old, ctx->level)) {
-			kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu,
-					ctx->addr, ctx->level);
+		if (kvm_pte_table(ctx->old, ctx->level)) {
+			kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ctx->addr,
+				     0);
+		} else if (!stage2_unmap_defer_tlb_flush(pgt)) {
+			kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ctx->addr,
+				     ctx->level);
 		}
 	}
 


