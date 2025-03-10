Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 763EB22ACDC;
	Mon, 10 Mar 2025 17:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628274; cv=none; b=WfiKpcBIfq8RXOE5ACo9pwk2Omvr7stlQiLUSbXVDDB73F/tnmUl8zcDX/CIlKOBz5Hxh9OOQIot+MzdUrbwLVGSF9WG6sODl9hz/60WmGhnY8MNbX3bvDRAVUrgeS0UAob4G/KLim9dTHoZ5lWn3inOWvnMVCw4cmBgKm1cICw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628274; c=relaxed/simple;
	bh=700NkAp/4AxpLOMLkeTAKyLxVEQzinTUCm7LcZgxDiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RLbeI4R8S0nSeqSs82rE2J/FFSKKthGmiDrgNh/NWv0bFMHEE4vJEoKM1jjUT0H7+q5uKer+ouJohRnwTBxgs6TckvfnXNtn8it6Ze+Ydb8eej58gRmkFSOdL5bt/9o0QijlugJfPnGtHRtd7FALPUzn6XZ9OVX4iDDMR9jh6gI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OrgQHnIR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OrgQHnIR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D296C4CEEC;
	Mon, 10 Mar 2025 17:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628273;
	bh=700NkAp/4AxpLOMLkeTAKyLxVEQzinTUCm7LcZgxDiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OrgQHnIRZ7/D3FHIc5uQ8JwTbMSrhSZvdD9ObrrGF75rsjUnEzSzPYqTCigMbICdq
	 g5uhXdThBWOEr+uKZcV8hmOk5tKL/epAe11i7uxd5tcE56IdkkSpkmG4Q/fgxjf4ky
	 iNILNVimvok4xMWQTYHMRFZNG2WfMvX2WHlawNSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.6 136/145] Revert "KVM: PPC: e500: Mark "struct page" dirty in kvmppc_e500_shadow_map()"
Date: Mon, 10 Mar 2025 18:07:10 +0100
Message-ID: <20250310170440.246428388@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 15d60c13b704f770ba45c58477380d4577cebfa3 which is
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


