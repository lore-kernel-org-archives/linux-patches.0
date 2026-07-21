Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E1D3FE650;
	Tue, 21 Jul 2026 17:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655051; cv=none; b=OC2Y7hnK2xx2hhun9T2kn+RxIENFRQcJQthoF5/KdQChTYBNoQr8pWDgGCnlsk7Y9hWB0dwfMkcJz6TMIoHoCWgtTgV9MsgGNPJjTha0cHW1qhEkPojVrGeK0tGNkvyViTLOx18DvTy14g1jh5NlNO7IZ8TqboIGGeLZULyHdzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655051; c=relaxed/simple;
	bh=Bbn64iRBT2bHyx9Z1QO9A+hzb5P8hUISphd0BBYb8jc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gRuKpVxhGpMkNYpUY/rlxnTNywVz9Vr/Fu941dv82HATGdLhnGOF8XHHxS80z/1LKEzop8kn2c653OSF6ow7PlTU/GLtWMNOcs4CBIrSYaPNTJOC+80OzejuSq5BXwZQBP7FuxDREN1jrID7nw3tGSEIDEcuB+Gt2WDqrDKNhUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FN/+mwad; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FN/+mwad"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C29CD1F000E9;
	Tue, 21 Jul 2026 17:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655050;
	bh=lyfvqPXfIsbz8UIBwu/yxkPUlIBe95mLWl5UlFUCIa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FN/+mwad1NzDg8mM4IVVMoUu1uJ7dP4xatOjO7TG/0ObFIKoFmziNPXNbBboMeHQ6
	 w6b1px+n8bxcvyes0uOoUjK/Cv2IsSjuoQouUheuIWpJrvvg90y54xqk+2i4iXktvz
	 IgJsz0OSTxuaLskuewscOLJDVB3DS46L1+DIY83M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 7.1 1935/2077] KVM: arm64: Fix propagation of TLBI level in kvm_pgtable_stage2_relax_perms()
Date: Tue, 21 Jul 2026 17:26:48 +0200
Message-ID: <20260721152638.349490856@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

commit 8d187d4b33c262c0f3e44842553521151d8629e8 upstream.

Assigning the invalidation level (an s8 value) with TLBI_TTL_UNKNOWN
(a 32bit signed value) is not ideal, to say the least. Instead of
this, only pass TLBI_TTL_UNKNOWN to __kvm_tlb_flush_vmid_ipa_nsh()
when we know for sure that we don't have a provided level.

Fixes: 100baf0184896 ("KVM: arm64: Ensure level is always initialized when relaxing perms")
Reported-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Oliver Upton <oupton@kernel.org>
Link: https://lore.kernel.org/r/akztC7H2IsEKaq4i@sirena.org.uk
Link: https://patch.msgid.link/20260707162935.1900874-1-maz@kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/hyp/pgtable.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1358,7 +1358,7 @@ int kvm_pgtable_stage2_relax_perms(struc
 				   enum kvm_pgtable_prot prot, enum kvm_pgtable_walk_flags flags)
 {
 	kvm_pte_t xn = 0, set = 0, clr = 0;
-	s8 level = TLBI_TTL_UNKNOWN;
+	s8 level;
 	int ret;
 
 	if (prot & KVM_PTE_LEAF_ATTR_HI_SW)
@@ -1379,7 +1379,8 @@ int kvm_pgtable_stage2_relax_perms(struc
 
 	ret = stage2_update_leaf_attrs(pgt, addr, 1, set, clr, NULL, &level, flags);
 	if (!ret || ret == -EAGAIN)
-		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa_nsh, pgt->mmu, addr, level);
+		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa_nsh, pgt->mmu, addr,
+			     (ret == -EAGAIN) ? TLBI_TTL_UNKNOWN : level);
 	return ret;
 }
 


