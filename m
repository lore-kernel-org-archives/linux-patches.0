Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2BE22E7656;
	Tue, 12 Aug 2025 19:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026683; cv=none; b=Oygcl+GVRaqFoGGkrtVYyZytRqE/gEBE7/qQ7OSFvEpHvXOOYzRaqUFo01X0iu2Vt3UjYSqFMXjloUpU2S7WD0Oyi1iGeT3V5edCTbaqhQdQRW6Q0/3jfT66IZGyR7hf0XRLS27oAF0+NSQxupmwklFNRx7r/xwPbmYjOOjWEAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026683; c=relaxed/simple;
	bh=xJNphrtQizt5KTaXkBW/zSkfFn1dLFd1/o2BFDS7Fyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H9FJ4tFgTvNqn1oUzLbj1kJvUbSKyli2FpPqdPFtBYNBI/LCG0Bz3895F9mEiS4RjH7cutxsj16EHGzsd1mOZMlZDv7xWPGHHdmRDDS8YAjGkByoP6uBvQQTKMuqVwet6Lm6tvPT1mn9Rmj3YlHnjWz5y6Xs5Gsymu+lxgkmOJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yi1gmnE9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yi1gmnE9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FCCDC4CEF7;
	Tue, 12 Aug 2025 19:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026682;
	bh=xJNphrtQizt5KTaXkBW/zSkfFn1dLFd1/o2BFDS7Fyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yi1gmnE9iCDKEd4Vqf2+cB6K2Sbn/G5kvATbiAAQ9fnYy6rDB4h/pina7Jowu3WMn
	 +GevTlkteLpoXId7unRZsnfWbwrjLy2wk3wHZTTseqTbW/+acmvYzx3Qm5vAxtIfLB
	 6Rga5a5GdDKNaVy5daKIsP/KxtcAinKUzawu/b3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 410/480] s390/mm: Allocate page table with PAGE_SIZE granularity
Date: Tue, 12 Aug 2025 19:50:18 +0200
Message-ID: <20250812174414.338070540@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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



