Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F9152FD1B2;
	Tue, 12 Aug 2025 18:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025024; cv=none; b=Zwk/2hFrqcCyoXAGGEDwkTMHzHXrecMBw/9+PH1na1/kt6vsI5G2ZCP6OuIAdwXxaPN7IYxfvaCQY4kzNzZUT4Id+NHbvz5fnbraIS99p3yjdZBSa1xzuAs+ISvoKPMpBeQF2h3ZCufbmpDZOvCMYVNQrZqzLrK4dY8WpLfpBSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025024; c=relaxed/simple;
	bh=9zUiI8g7o7QNXs2XXdPgxHAyKs3qFgI2NdDFEICwkek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=II0WVKZenh7xdZkl/14BHvvBC6KCS845CjAmQ8Urka5Rk+obY8LmpqBuOhmB6bA/k8Ho8EYpnPUHeTMxbKXVpWgko29Gv3dz8lRNkuikzC/yF/vVBbWzUnHldDonMh8eAFD37L7XGAzCncpVZe2J72cB4w7YaXNI/bK4xTx+09s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o3rh/pjq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o3rh/pjq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A88C7C4CEF0;
	Tue, 12 Aug 2025 18:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025024;
	bh=9zUiI8g7o7QNXs2XXdPgxHAyKs3qFgI2NdDFEICwkek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o3rh/pjqKNNEA/b/3PQx44auKIo7+0UGNC0kLrgeyCl+FFfowIC+98lwqdwbOmiRM
	 tglj8W+QfopZZnVdjW6b5Hsq/x+HwXK85tZOjzgwQ1vzjEfVETvadTjJ3wvnjqtK/N
	 5bWPK4QbqdatLCxGHkeema6KJyYqqeT2w8euD2DM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 547/627] s390/mm: Allocate page table with PAGE_SIZE granularity
Date: Tue, 12 Aug 2025 19:34:02 +0200
Message-ID: <20250812173452.720498231@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sumanth Korikkar <sumanthk@linux.ibm.com>

[ Upstream commit daa8af80d283ee9a7d42dd6f164a65036665b9d4 ]

Make vmem_pte_alloc() consistent by always allocating page table of
PAGE_SIZE granularity, regardless of whether page_table_alloc() (with
slab) or memblock_alloc() is used. This ensures page table can be fully
freed when the corresponding page table entries are removed.

Fixes: d08d4e7cd6bf ("s390/mm: use full 4KB page for 2KB PTE")
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/mm/vmem.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/s390/mm/vmem.c b/arch/s390/mm/vmem.c
index 448dd6ed1069..f48ef361bc83 100644
--- a/arch/s390/mm/vmem.c
+++ b/arch/s390/mm/vmem.c
@@ -64,13 +64,12 @@ void *vmem_crst_alloc(unsigned long val)
 
 pte_t __ref *vmem_pte_alloc(void)
 {
-	unsigned long size = PTRS_PER_PTE * sizeof(pte_t);
 	pte_t *pte;
 
 	if (slab_is_available())
-		pte = (pte_t *) page_table_alloc(&init_mm);
+		pte = (pte_t *)page_table_alloc(&init_mm);
 	else
-		pte = (pte_t *) memblock_alloc(size, size);
+		pte = (pte_t *)memblock_alloc(PAGE_SIZE, PAGE_SIZE);
 	if (!pte)
 		return NULL;
 	memset64((u64 *)pte, _PAGE_INVALID, PTRS_PER_PTE);
-- 
2.39.5



