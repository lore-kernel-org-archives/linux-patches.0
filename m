Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A91EA19D068;
	Thu, 15 Aug 2024 14:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730835; cv=none; b=akT3ioqEEetglXxswS+YuBYVxxydr9nEt92oVOi1sJeYhKXZiL0ZJ/qw2aM+n3W/MfpBvxZAfRM8uUcXA6kdGhsR3JxXPvV3lXXwbx5C0dq8I1nkE4irZi4oJUQD0HCeBeQJJwtl10Znuxab0oS5O4SME5eJMS+tIJQKMTlbKiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730835; c=relaxed/simple;
	bh=Jh8KQXbLm68ZvPBNBwY/zKZCBouOznE2HBeZXoTI1WY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bG2zMdidPP6ZtyAXu5IFSf36Rx9d9A11X2qC59j6KQtX38WeIOUBYVExVyuKQcZQfVB7NjZKIbWp9mo8QgQr7Xj5zNSn3lHzvRSa2jRgXQRj9KeprmidptCR8CWW21mZW54ioaAWpiGlDdM64qZslDSyWF5h0ZUFO6p0q9/t+rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JuHCGD4n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JuHCGD4n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B25C5C4AF0C;
	Thu, 15 Aug 2024 14:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730835;
	bh=Jh8KQXbLm68ZvPBNBwY/zKZCBouOznE2HBeZXoTI1WY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JuHCGD4nliuhm6ksR/u0KX94mItGiFTGMfcexJPOEl4zCA7hfM8F30GE4eon7GJtl
	 M1obgblTZFj6T055o5Dzc+oNFF84Ai19eGWetU52FpZIlaEPFF5fpPtC/PcduEQP0P
	 sg5U4a3FKpQK7Tmiu1hOsQo45fUvmCsAu16+x0UE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gavin Shan <gshan@redhat.com>,
	Marc Zyngier <maz@kernel.org>,
	Quentin Perret <qperret@google.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.1 38/38] KVM: arm64: Dont pass a TLBI level hint when zapping table entries
Date: Thu, 15 Aug 2024 15:26:12 +0200
Message-ID: <20240815131834.416876331@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131832.944273699@linuxfoundation.org>
References: <20240815131832.944273699@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20240327124853.11206-3-will@kernel.org
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Cc: <stable@vger.kernel.org> # 6.1.y only
[will@: Use '0' instead of TLBI_TTL_UNKNOWN_to indicate "no level". Force
        level to 0 in stage2_put_pte() if we're clearing a table entry.]
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/hyp/pgtable.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -475,7 +475,7 @@ static int hyp_unmap_walker(u64 addr, u6
 
 		kvm_clear_pte(ptep);
 		dsb(ishst);
-		__tlbi_level(vae2is, __TLBI_VADDR(addr, 0), level);
+		__tlbi_level(vae2is, __TLBI_VADDR(addr, 0), 0);
 	} else {
 		if (end - addr < granule)
 			return -EINVAL;
@@ -699,8 +699,14 @@ static void stage2_put_pte(kvm_pte_t *pt
 	 * Clear the existing PTE, and perform break-before-make with
 	 * TLB maintenance if it was valid.
 	 */
-	if (kvm_pte_valid(*ptep)) {
+	kvm_pte_t pte = *ptep;
+
+	if (kvm_pte_valid(pte)) {
 		kvm_clear_pte(ptep);
+
+		if (kvm_pte_table(pte, level))
+			level = 0;
+
 		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, addr, level);
 	}
 


