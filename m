Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A4A7E105;
	Mon,  8 Apr 2024 13:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582831; cv=none; b=V4+zwsljSwtzPASFYL3GiQ0rYQHnfKTEr9I2Nr1UEXKSSZLbuJsRDlkj0qf61b4OtyC6EOtPDerpbCOj+u3G6Gq+R4JdJ0Wb4OpkcJ1NkZauvcCkJzyH6pgu1JnmqcrY/+M20Az6FozVOLmK/xhbCnjpRfoJwBTfC8/kth7KYgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582831; c=relaxed/simple;
	bh=LvvFNEqnEIeQCDpIFU7RR7OiSGxpOXk3+9QcHArveK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qx6ZFoLddYMiQ9Mxp0wdT/BLAYl3lKOvlFRr37g/66Juj/QPaVjaS+CJtBun1ewy6+7Vtc4rSercX4zr2i4d/7leWUyNqghCpSm0+q/gtCOAC20U7/Zwfqv8vOtNvKCRm0sW0lf1RgGc/bQkPnJxy/U4EQnk7xe2pPP2pqIKmBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GoxTjwCo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GoxTjwCo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 982EBC433C7;
	Mon,  8 Apr 2024 13:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582831;
	bh=LvvFNEqnEIeQCDpIFU7RR7OiSGxpOXk3+9QcHArveK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GoxTjwCoIX5lxJqZIAbBgMWoqxOcEX320OgOBDQmDZvhXb0W5YRRGGQ1WrMvQzUVs
	 9VtW1tmZbv43ygOA3cbjZMWCo39VmV3mxuZB/2EaPmEgxHdsGd4Xdx8KvX/J2MgQXt
	 V+YQN6RZnA5rpmFF/Oa5PYEZB0/eHKIx0bnxIAv0=
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
Subject: [PATCH 6.8 097/273] KVM: arm64: Ensure target address is granule-aligned for range TLBI
Date: Mon,  8 Apr 2024 14:56:12 +0200
Message-ID: <20240408125312.310698810@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
@@ -829,12 +829,15 @@ static bool stage2_try_break_pte(const s
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


