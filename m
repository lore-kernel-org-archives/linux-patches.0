Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A18A0471268;
	Tue, 21 Jul 2026 20:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664576; cv=none; b=MDbP0xfOapjwVqJ+FZVUr5z1cRjUcujwFafvB+0R0F6wyRBvI42nHKqZFsdKHnwr0GaoF1YeUjEUeNmjRQZAYRdsHCvucvMkoJ7qQRsaHc1v6EJTfBagQCuI4ihIfp/uwwOamFoNZ5PfSDxrSjsdfBxxXCYeoSBIEqz+Gj/PhcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664576; c=relaxed/simple;
	bh=MZx/mJaZNduZ3/1tDbqcv/yDzjw2YKID+kK181+qN9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mea6ByKYtbLLHkj19yu4H6J+XCsjYGoUyBCUnvw/8oviYlrLAJohNM4RIItam3tVxmr2+EA8wCDup0iGQQSnTTA9ASBoAQqF+PBbsJauns5ZffEAbOjmQ24US7jfLXQgKfhQsRzrHoBItSOWZjtOFXq3/5AEWdod1ibp1qLYPac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zozCNfPH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zozCNfPH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C99311F00A3A;
	Tue, 21 Jul 2026 20:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664575;
	bh=Kqn6cl+xc2NLE5MtVUFZHTcXnNj97tkwoHIJHkmpBM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zozCNfPHcWg0dbNyGrdxim1UM1tWqjmbKNawWeWw1nR9YDpqNzwmz5R+mQAJdyTa7
	 9hH1CfiBRD6W2YL7yfqx77KRGAyaMgp2fkBnx+1mwMrax3qr5Kk7bXaSKPN6QKnagb
	 Wd77VVaA/8uYipVx1OU0rnzwtQOMbP1XQ6HrHY4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.12 1245/1276] KVM: arm64: Fix propagation of TLBI level in kvm_pgtable_stage2_relax_perms()
Date: Tue, 21 Jul 2026 17:28:08 +0200
Message-ID: <20260721152513.955589898@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1314,7 +1314,7 @@ int kvm_pgtable_stage2_relax_perms(struc
 				   enum kvm_pgtable_prot prot)
 {
 	int ret;
-	s8 level = TLBI_TTL_UNKNOWN;
+	s8 level;
 	kvm_pte_t set = 0, clr = 0;
 
 	if (prot & KVM_PTE_LEAF_ATTR_HI_SW)
@@ -1333,7 +1333,8 @@ int kvm_pgtable_stage2_relax_perms(struc
 				       KVM_PGTABLE_WALK_HANDLE_FAULT |
 				       KVM_PGTABLE_WALK_SHARED);
 	if (!ret || ret == -EAGAIN)
-		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa_nsh, pgt->mmu, addr, level);
+		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa_nsh, pgt->mmu, addr,
+			     (ret == -EAGAIN) ? TLBI_TTL_UNKNOWN : level);
 	return ret;
 }
 


