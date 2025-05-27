Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C92F1194A45;
	Tue, 27 May 2025 16:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364654; cv=none; b=RTrHR92jyZt/i5uk3hWVYe0Ffy1AWQmFktvDVKE6UrA+d6PPg10jIZn8Sf5HZ6xx0ZWw4L4p7x+B0AgetN7uL/koLwPsIrhxkzgP3AXwza6dTOs9GcTbn4jjb5UD/pmVyGolkEFeeuDQLU9Ttv7CfAWF7KOCkXIwbnT35jqgfz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364654; c=relaxed/simple;
	bh=YUtYVDkS6Oc70dkXUoV9H7gBCHjD5OZ0NQymkRgLDCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IJb9StR3yKUMwIl8GVJp+wijkrNcaNyZkaF+9o1ot2GEnBrs0ijTib2PDk0epIaQbM59DDDNf/iHK+Z6hFhDh4YqD9eY85Bre/1vDcTbaykrA0Pwyw4wlFL+JmeVVd7mKNsLJ1tilCRohWIoT1V1sHUmxFbZFYrNhrejYqIyBB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xQRiObJ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xQRiObJ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FF81C4CEE9;
	Tue, 27 May 2025 16:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364654;
	bh=YUtYVDkS6Oc70dkXUoV9H7gBCHjD5OZ0NQymkRgLDCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xQRiObJ+/oTNVBrHif+xo0roSeVTzjhxDIFk6ngqxg+cSzqKUzndX98mvFnQrJ2N1
	 iXUdE4sYlho6AbO8w5Q1FPtqZVKpWL9vaC0ewyWdhVg+xR+fW1CFOMCGN9RnihR4+Z
	 BwVYmK77A8jiqxKDI1DVJ7G6kDelFToy31N+QSaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 125/626] s390/tlb: Use mm_has_pgste() instead of mm_alloc_pgste()
Date: Tue, 27 May 2025 18:20:18 +0200
Message-ID: <20250527162450.108375264@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 9291ea091b29bb3e37c4b3416c7c1e49e472c7d5 ]

An mm has pgstes only after s390_enable_sie() has been called, while
mm_alloc_pgste() may be always true (e.g. via sysctl setting).

Limit the calls to gmap_unlink() in pte_free_tlb() to those cases
where there might be something to unlink.

Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/tlb.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/include/asm/tlb.h b/arch/s390/include/asm/tlb.h
index e95b2c8081eb8..793afe236df07 100644
--- a/arch/s390/include/asm/tlb.h
+++ b/arch/s390/include/asm/tlb.h
@@ -85,7 +85,7 @@ static inline void pte_free_tlb(struct mmu_gather *tlb, pgtable_t pte,
 	tlb->mm->context.flush_mm = 1;
 	tlb->freed_tables = 1;
 	tlb->cleared_pmds = 1;
-	if (mm_alloc_pgste(tlb->mm))
+	if (mm_has_pgste(tlb->mm))
 		gmap_unlink(tlb->mm, (unsigned long *)pte, address);
 	tlb_remove_ptdesc(tlb, pte);
 }
-- 
2.39.5



