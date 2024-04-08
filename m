Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6CFC7641E;
	Mon,  8 Apr 2024 13:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582556; cv=none; b=g9tgTm10g3jtNXQiVfXgFam71eeTzp0wvTxwO5927sEePB00TJGWD4CxBd6+FoyxOh+voNhCvLrUtGmuQATM5ZGLWj6m2RD8cMJfX0lUjofHulN+obZqulZCDN1VtSlnWI0IkfKGluS9fCdE/Wdqt+oRs7k6iRyGWmdcpQeLKGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582556; c=relaxed/simple;
	bh=L/oV5a9fseatXTzA3MF46cSSQDyYpdDsvmwqtkLYEiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cnTonL8CA1gYVNKgbFCcrKV3ViLpe2O0O2eRWFI1SPr9QBXTl8vc/lejKC0y3yGTvoazExLT/bA+bD+YzTkSQKCxXmuSZ2aPCuy3isTm8tRoiDO/t63DDBcnCaBt+19urCL/KLM2yn4J9F1niHrNmawPqvzcIldp0IZF2IPERyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v3BKc3hq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v3BKc3hq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4024C433C7;
	Mon,  8 Apr 2024 13:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582556;
	bh=L/oV5a9fseatXTzA3MF46cSSQDyYpdDsvmwqtkLYEiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v3BKc3hqgV21gUyWZlKNXwbrCmxZ3zbLlHCnm4ve84expx4BGw1fXOT9HK4Y/TJjd
	 5OgkRGtb65ehswKPbMS5wVDJ9FwxaW53PIgmZx+AybdaGx9GQlOB9ziGCl2h/+2e/l
	 X1GQHWPQXdzq4PEQ9328FTsWbKj1PejFn2aghCa4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raghavendra Rao Ananta <rananta@google.com>,
	Gavin Shan <gshan@redhat.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Quentin Perret <qperret@google.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 6.6 102/252] KVM: arm64: Ensure target address is granule-aligned for range TLBI
Date: Mon,  8 Apr 2024 14:56:41 +0200
Message-ID: <20240408125309.811722899@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

commit 4c36a156738887c1edd78589fe192d757989bcde upstream.

When zapping a table entry in stage2_try_break_pte(), we issue range
TLB invalidation for the region that was mapped by the table. However,
we neglect to align the base address down to the granule size and so
if we ended up reaching the table entry via a misaligned address then
we will accidentally skip invalidation for some prefix of the affected
address range.

Align 'ctx->addr' down to the granule size when performing TLB
invalidation for an unmapped table in stage2_try_break_pte().

Cc: Raghavendra Rao Ananta <rananta@google.com>
Cc: Gavin Shan <gshan@redhat.com>
Cc: Shaoqin Huang <shahuang@redhat.com>
Cc: Quentin Perret <qperret@google.com>
Fixes: defc8cc7abf0 ("KVM: arm64: Invalidate the table entries upon a range")
Signed-off-by: Will Deacon <will@kernel.org>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20240327124853.11206-5-will@kernel.org
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/hyp/pgtable.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -805,12 +805,15 @@ static bool stage2_try_break_pte(const s
 		 * Perform the appropriate TLB invalidation based on the
 		 * evicted pte value (if any).
 		 */
-		if (kvm_pte_table(ctx->old, ctx->level))
-			kvm_tlb_flush_vmid_range(mmu, ctx->addr,
-						kvm_granule_size(ctx->level));
-		else if (kvm_pte_valid(ctx->old))
+		if (kvm_pte_table(ctx->old, ctx->level)) {
+			u64 size = kvm_granule_size(ctx->level);
+			u64 addr = ALIGN_DOWN(ctx->addr, size);
+
+			kvm_tlb_flush_vmid_range(mmu, addr, size);
+		} else if (kvm_pte_valid(ctx->old)) {
 			kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu,
 				     ctx->addr, ctx->level);
+		}
 	}
 
 	if (stage2_pte_is_counted(ctx->old))


