Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F70419FA7E;
	Thu, 15 Aug 2024 14:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731020; cv=none; b=RZZDo9+p9EU1xqZve0w/ns7l/aD7977MEZSob6BPMvuA6Svzy8KJZKU4x94IcKWvJl9xGlG3oGW6TH/PrjtJ+n6jUYNZHu2AQ7ALpW7XmW4ZRSH40PgCQ3lDDJEp0YzxZoJYsBmUtBD2IIT8rrqk5qXkVIRGcjSmVJczMFNciYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731020; c=relaxed/simple;
	bh=ugS3K1+nnHkdh08wZUprrJqiLw3HyRIRjsHehbaUJXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RWwxNjaeHgh8QZtfGjn1O1dqiFJx9DRQWrNyubx89f+Jyn0ntwUuUTnoINEdjnw1zjnd21A1Hldi0dKH+2rLUh88zsvBNlc5skcwpwCxj519iupRMoBh36khQHtw/HANlHzw4VjRsrqdK32Xl311cjs7qQNVDG3KJpDa3K30oRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fhn67ybl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fhn67ybl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C2CBC4AF0C;
	Thu, 15 Aug 2024 14:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731019;
	bh=ugS3K1+nnHkdh08wZUprrJqiLw3HyRIRjsHehbaUJXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fhn67yblE7jUojzvtiosBcO6jyEmKdc2EeblfRQ98OuuGQXSp8UI0xqtCyLSz4jrh
	 wKHcHGGQuuTbHG4BCw0e9tUijYOvXepm7NFSsnyMDVCaFUyPY12tZ4/vOmlMWHauz5
	 FKb4c455GEfx7pw6CzbdAJxLHbX6VbOcS7mPmlN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raghavendra Rao Ananta <rananta@google.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.6 66/67] KVM: arm64: Dont defer TLB invalidation when zapping table entries
Date: Thu, 15 Aug 2024 15:26:20 +0200
Message-ID: <20240815131840.831660720@linuxfoundation.org>
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

commit f62d4c3eb687d87b616b4279acec7862553bda77 upstream.

Commit 7657ea920c54 ("KVM: arm64: Use TLBI range-based instructions for
unmap") introduced deferred TLB invalidation for the stage-2 page-table
so that range-based invalidation can be used for the accumulated
addresses. This works fine if the structure of the page-tables remains
unchanged, but if entire tables are zapped and subsequently freed then
we transiently leave the hardware page-table walker with a reference
to freed memory thanks to the translation walk caches. For example,
stage2_unmap_walker() will free page-table pages:

	if (childp)
		mm_ops->put_page(childp);

and issue the TLB invalidation later in kvm_pgtable_stage2_unmap():

	if (stage2_unmap_defer_tlb_flush(pgt))
		/* Perform the deferred TLB invalidations */
		kvm_tlb_flush_vmid_range(pgt->mmu, addr, size);

For now, take the conservative approach and invalidate the TLB eagerly
when we clear a table entry. Note, however, that the existing level
hint passed to __kvm_tlb_flush_vmid_ipa() is incorrect and will be
fixed in a subsequent patch.

Cc: Raghavendra Rao Ananta <rananta@google.com>
Cc: Shaoqin Huang <shahuang@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20240327124853.11206-2-will@kernel.org
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Cc: <stable@vger.kernel.org> # 6.6.y only
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/hyp/pgtable.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -861,9 +861,11 @@ static void stage2_unmap_put_pte(const s
 	if (kvm_pte_valid(ctx->old)) {
 		kvm_clear_pte(ctx->ptep);
 
-		if (!stage2_unmap_defer_tlb_flush(pgt))
+		if (!stage2_unmap_defer_tlb_flush(pgt) ||
+		    kvm_pte_table(ctx->old, ctx->level)) {
 			kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu,
 					ctx->addr, ctx->level);
+		}
 	}
 
 	mm_ops->put_page(ctx->ptep);


