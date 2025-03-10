Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE8223372F;
	Mon, 10 Mar 2025 17:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627830; cv=none; b=BsZTzRE9hmK2aG+H4ArMRGPo3DfWM88EjC1dkY2lHwqECOIotvfmAMw7Zy3wWicvvJexaC7QAlIfx/gzxx8lqYdqBKJEGirU1E2AfvZOq7f6QejpOe4R5ZR1Wws9wuOVQSvePzgFv4ltmuNk2FGN1JyjpZ/CppiRxN8nG0WSecE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627830; c=relaxed/simple;
	bh=z3eLuin3BQ22mugZidU3HprZjOtFcDDek/DgSPRJ2Hk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZAdnjovcoDORfCekCeJRxX3ZXxfgNDkYjAUEqt8EKARnF1BUkM/TQRJ1y9HQ256RIqRWEbOEJNN21RA6Ot1ZZfOCJnpIHBP8kQb8PTIWsbhbrqvOTgMbzAtJHnWOEbJG2kriWtj1qI52HdZ/kq8t4WLpxyq53Ko8r2bvL/8C4PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VgNyazFF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VgNyazFF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67387C4CEE5;
	Mon, 10 Mar 2025 17:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627829;
	bh=z3eLuin3BQ22mugZidU3HprZjOtFcDDek/DgSPRJ2Hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VgNyazFFhyuRqj+xMun5/Qb7aQGFkZqTmjy2Cy1xDTCUmAS/0/1787aF7n1yubSVR
	 XHOhSJ2pDkwBsDogLFh1XRb/fR+iFkUlBO/Zl+ZnQeMhsdRmBnYmVEjFJp8C7zU8Ce
	 9RGtREm9yHi/fset0ilaEOxpKtHgsUGcQAQh9KqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.12 265/269] Revert "KVM: PPC: e500: Mark "struct page" dirty in kvmppc_e500_shadow_map()"
Date: Mon, 10 Mar 2025 18:06:58 +0100
Message-ID: <20250310170508.351495005@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit dec857329fb9a66a5bce4f9db14c97ef64725a32 which is
commit c9be85dabb376299504e0d391d15662c0edf8273 upstream.

It should not have been applied.

Link: https://lore.kernel.org/r/CABgObfb5U9zwTQBPkPB=mKu-vMrRspPCm4wfxoQpB+SyAnb5WQ@mail.gmail.com
Reported-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kvm/e500_mmu_host.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/arch/powerpc/kvm/e500_mmu_host.c
+++ b/arch/powerpc/kvm/e500_mmu_host.c
@@ -242,7 +242,7 @@ static inline int tlbe_is_writable(struc
 	return tlbe->mas7_3 & (MAS3_SW|MAS3_UW);
 }
 
-static inline bool kvmppc_e500_ref_setup(struct tlbe_ref *ref,
+static inline void kvmppc_e500_ref_setup(struct tlbe_ref *ref,
 					 struct kvm_book3e_206_tlb_entry *gtlbe,
 					 kvm_pfn_t pfn, unsigned int wimg)
 {
@@ -252,7 +252,11 @@ static inline bool kvmppc_e500_ref_setup
 	/* Use guest supplied MAS2_G and MAS2_E */
 	ref->flags |= (gtlbe->mas2 & MAS2_ATTRIB_MASK) | wimg;
 
-	return tlbe_is_writable(gtlbe);
+	/* Mark the page accessed */
+	kvm_set_pfn_accessed(pfn);
+
+	if (tlbe_is_writable(gtlbe))
+		kvm_set_pfn_dirty(pfn);
 }
 
 static inline void kvmppc_e500_ref_release(struct tlbe_ref *ref)
@@ -333,7 +337,6 @@ static inline int kvmppc_e500_shadow_map
 	unsigned int wimg = 0;
 	pgd_t *pgdir;
 	unsigned long flags;
-	bool writable = false;
 
 	/* used to check for invalidations in progress */
 	mmu_seq = kvm->mmu_invalidate_seq;
@@ -487,9 +490,7 @@ static inline int kvmppc_e500_shadow_map
 			goto out;
 		}
 	}
-	writable = kvmppc_e500_ref_setup(ref, gtlbe, pfn, wimg);
-	if (writable)
-		kvm_set_pfn_dirty(pfn);
+	kvmppc_e500_ref_setup(ref, gtlbe, pfn, wimg);
 
 	kvmppc_e500_setup_stlbe(&vcpu_e500->vcpu, gtlbe, tsize,
 				ref, gvaddr, stlbe);


