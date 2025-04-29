Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E0D1519A6;
	Tue, 29 Apr 2025 18:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950387; cv=none; b=XmOUFXZXqRfxBuRXJmkaXEeAXYVFo8sgs0m8q3DwEDuOcf4+pYoSbtKmeCk3ID1M8ufv5pfAuR58QNl8CXXTym42gtFqtNJITdjCiUzQFDvmcJSOdO2NvhOz13eV1XUOBiV4mfaQJZq6uYe8/QOM/c+xX7xsLTuja2fhYEYIlO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950387; c=relaxed/simple;
	bh=ar1CzgXaX5HIiJmT+Wc8fKs4urOyZCuUjHV0xI/am1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R8Vjk/vEzItSSp/2DqP+X9A9bZYZnlMaVwiPsrIkHjonLyxxvdR+NX9Mgalvh5Uocn4ayedSbyBuVYkmqWyjwkIh7ZzzS9Iw9xQGDxUKCOwv2DaKFG8yCWKHi9WfN2NHNftgLk46CI+wwT8CIh97KVwm9R/lp1YqKdW8H9WQ2pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PnSxuZRW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PnSxuZRW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC1CAC4CEE3;
	Tue, 29 Apr 2025 18:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950387;
	bh=ar1CzgXaX5HIiJmT+Wc8fKs4urOyZCuUjHV0xI/am1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PnSxuZRWia9c+qJjmeK6/EzqB9PLdoigcgg7PpIwF2ykcGCV8h/zAJEcmAQos1LaF
	 l+1+Z3ZAs1l+C2+oFoUCaCmxX++9/6+FvJ3bnDW+RFogL5rypKsl4AmnM+ny7A5VoL
	 bElIhcAy3SFyeT+hfQCRcF/DebozU2MB4MvcGOKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Xu <peterx@redhat.com>,
	Hongchen Zhang <zhanghongchen@loongson.cn>,
	Ming Wang <wangming01@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 080/204] LoongArch: Return NULL from huge_pte_offset() for invalid PMD
Date: Tue, 29 Apr 2025 18:42:48 +0200
Message-ID: <20250429161102.692805610@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

From: Ming Wang <wangming01@loongson.cn>

commit bd51834d1cf65a2c801295d230c220aeebf87a73 upstream.

LoongArch's huge_pte_offset() currently returns a pointer to a PMD slot
even if the underlying entry points to invalid_pte_table (indicating no
mapping). Callers like smaps_hugetlb_range() fetch this invalid entry
value (the address of invalid_pte_table) via this pointer.

The generic is_swap_pte() check then incorrectly identifies this address
as a swap entry on LoongArch, because it satisfies the "!pte_present()
&& !pte_none()" conditions. This misinterpretation, combined with a
coincidental match by is_migration_entry() on the address bits, leads to
kernel crashes in pfn_swap_entry_to_page().

Fix this at the architecture level by modifying huge_pte_offset() to
check the PMD entry's content using pmd_none() before returning. If the
entry is invalid (i.e., it points to invalid_pte_table), return NULL
instead of the pointer to the slot.

Cc: stable@vger.kernel.org
Acked-by: Peter Xu <peterx@redhat.com>
Co-developed-by: Hongchen Zhang <zhanghongchen@loongson.cn>
Signed-off-by: Hongchen Zhang <zhanghongchen@loongson.cn>
Signed-off-by: Ming Wang <wangming01@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/mm/hugetlbpage.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/loongarch/mm/hugetlbpage.c
+++ b/arch/loongarch/mm/hugetlbpage.c
@@ -47,7 +47,7 @@ pte_t *huge_pte_offset(struct mm_struct
 				pmd = pmd_offset(pud, addr);
 		}
 	}
-	return (pte_t *) pmd;
+	return pmd_none(pmdp_get(pmd)) ? NULL : (pte_t *) pmd;
 }
 
 int pmd_huge(pmd_t pmd)


