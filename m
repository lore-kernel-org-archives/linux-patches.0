Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D55646D094;
	Tue, 21 Jul 2026 18:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659628; cv=none; b=IdO1c9P+eqAxPl6cwRMhxX5KDy1Y8QNkvTBngUX9fy6MVXvG784sYHKjYJwQkZJjPLy0wzDWSTiyHRDZxuJlrMJ3cTiNAwQ1DUAz11KlDuh9mWLugErOqZajCzHmru8NiWs/jmuG5o2SHo2lcr9TXmpLqT6U3Wiw6NBenua3Ejg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659628; c=relaxed/simple;
	bh=ee446u0OxKUxri62aZssX/9ThvMmBcunmO5YTeoAj+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jtWa8j54TxFdywd/s0vEbfwe4rehT7z0jPSXFS+13rgmDyV5R2i6FI1pXYrfxKxas/+n12tIEJPlIn44K8a4hB0nMIABo6891UcvccLP2g/VerojWzC4rN8Y6F9Y9XCflfq1KXH263QXLiOfJ7EillX+VW8VoUxB2a1L/3p44ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E7i8fzjC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E7i8fzjC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD6761F000E9;
	Tue, 21 Jul 2026 18:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659627;
	bh=9etvMbvxZLGzRpzhHJF6+dPjHuF+lKz8DXYeQqhnoKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E7i8fzjCktWI47M9yceZO39TvekUuCcoCJ/F5+a1+lqnm81tgnNEDJjWUnvhPQrmB
	 8CVflkn4DcSgEDLIymAfXn/1RSsG8rMFzmoGWF2JtgeG43H8IfBq6xxCU/Ypuarm24
	 ljdPZzt9vrJv4oE3fbgTLsbmQiSB5M5B4fbSodLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.18 1593/1611] KVM: arm64: Fix propagation of TLBI level in kvm_pgtable_stage2_relax_perms()
Date: Tue, 21 Jul 2026 17:28:29 +0200
Message-ID: <20260721152551.308240210@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
@@ -1291,7 +1291,7 @@ int kvm_pgtable_stage2_relax_perms(struc
 				   enum kvm_pgtable_prot prot, enum kvm_pgtable_walk_flags flags)
 {
 	int ret;
-	s8 level = TLBI_TTL_UNKNOWN;
+	s8 level;
 	kvm_pte_t set = 0, clr = 0;
 
 	if (prot & KVM_PTE_LEAF_ATTR_HI_SW)
@@ -1308,7 +1308,8 @@ int kvm_pgtable_stage2_relax_perms(struc
 
 	ret = stage2_update_leaf_attrs(pgt, addr, 1, set, clr, NULL, &level, flags);
 	if (!ret || ret == -EAGAIN)
-		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa_nsh, pgt->mmu, addr, level);
+		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa_nsh, pgt->mmu, addr,
+			     (ret == -EAGAIN) ? TLBI_TTL_UNKNOWN : level);
 	return ret;
 }
 


