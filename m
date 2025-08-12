Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7000D1EBFE0;
	Tue, 12 Aug 2025 18:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022957; cv=none; b=E4C4gEhun44xdCXrs05QfSRVrKifCcCozpNFT+c7w3xMGLPv5Q4Rwt0y+oG8MdRwOxxQFALdbPFgu6psedNMt0LWkTNgrWEGAJ1YkpZ9ojSi7SlG/67AbgPgrCDY6ifHlWJ+hOwdAXnKVy3hw2aqhS462SphRz5bgFpBTJGiacc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022957; c=relaxed/simple;
	bh=8aJFs9uj9Yh1GTsG/Io9oyTrd/NWBsFLKGkFYRpq3yI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S9XDb/DNcyKlggs4GQDnxxwdXO8FhwIlpfE5XXhbTR45+PNRRmnguGRaARFeFKsXM9ytn9c9m2h1sf69hJVGsz3aaoIZu+7TYjmG8OYw9shO07oqVz2b1v7QOCO5wrkrJ5y7f1UOJ5k4EF7a4mJvjYgppyj/BfJ3XmTXwEIyXOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mcRqDdng; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mcRqDdng"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 772D8C4CEF7;
	Tue, 12 Aug 2025 18:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022955;
	bh=8aJFs9uj9Yh1GTsG/Io9oyTrd/NWBsFLKGkFYRpq3yI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mcRqDdngszE7PtfCS9agZ/hU9DxEinFtAMIWQdFq+1lzwBaF6oWOiG9yecoCLpzEY
	 CwzaQB8+HGXcZV6Xdo5X7L3oR+zWUjmXA4+umsaBktTYRBuWhznHwqcoe5lVZ/UOs5
	 TFaTrOlGMf6mhsXNc+fgL3RMyC2+Wlmnbl0p+CHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 307/369] s390/mm: Allocate page table with PAGE_SIZE granularity
Date: Tue, 12 Aug 2025 19:30:04 +0200
Message-ID: <20250812173028.279688600@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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
index 665b8228afeb..dd971826652a 100644
--- a/arch/s390/mm/vmem.c
+++ b/arch/s390/mm/vmem.c
@@ -63,13 +63,12 @@ void *vmem_crst_alloc(unsigned long val)
 
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



