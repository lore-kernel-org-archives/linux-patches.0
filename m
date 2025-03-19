Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C63F51C5F26;
	Wed, 19 Mar 2025 14:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395060; cv=none; b=D1IpRVdhLexvpL97TagwW1Hjgo7quk43UTot6/JZACYq/rhoqRaoL1HPweE4zaJph8wdalXPsSbNBBulbe5t+hjdT3ZkGLplpb4DmvRDbv60tzzLt7pA1W1I2QsFMngVa33bETtYOJPJK2kOhhDD+9xF3qgfIk2DMhhk+y+WvYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395060; c=relaxed/simple;
	bh=Ph/mIF0AIwe8gUB+s+ZYhCBUIQjpy3RN/29SyDhkde8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X6dSd8zKlki0cR0JbLRnknCRVz7Yskh8g4EM07VsO/MsYuB/jsZK7Ck/VldlY8DcRD4d9fWawUbbrFS/gI61OzEjZz9RcI6mu+2oVjjqGl9oHgnXZT5xoGauau8wUOElTbz99meIYZh47zczUI+bKSyslh5LuAFE1MwcmCO6t0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D3OKGg9L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D3OKGg9L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99934C4CEE9;
	Wed, 19 Mar 2025 14:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395060;
	bh=Ph/mIF0AIwe8gUB+s+ZYhCBUIQjpy3RN/29SyDhkde8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D3OKGg9LHe+RT+sHAb+YSgpubQ36ID43aJRhaX55jzvFw4qKvYmoqAt98wiAYeKra
	 pj6J+uDjPWT9BcTYYwxNGHmoubVFUCEDDmOSxh3vt32VDWxV1J6NjXu8GXeFqFo1uJ
	 bHAfIqaQmN8GtYTHoDBTHTdW4akm47wIr6VugGY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 094/231] LoongArch: Fix kernel_page_present() for KPRANGE/XKPRANGE
Date: Wed, 19 Mar 2025 07:29:47 -0700
Message-ID: <20250319143029.165108042@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

From: Huacai Chen <chenhuacai@loongson.cn>

[ Upstream commit 619b52777a4972bdb6ddf86ac54c6f68a47b51c4 ]

Now kernel_page_present() always return true for KPRANGE/XKPRANGE
addresses, this isn't correct because hibernation (ACPI S4) use it
to distinguish whether a page is saveable. If all KPRANGE/XKPRANGE
addresses are considered as saveable, then reserved memory such as
EFI_RUNTIME_SERVICES_CODE / EFI_RUNTIME_SERVICES_DATA will also be
saved and restored.

Fix this by returning true only if the KPRANGE/XKPRANGE address is in
memblock.memory.

Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/mm/pageattr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/loongarch/mm/pageattr.c b/arch/loongarch/mm/pageattr.c
index ffd8d76021d47..aca4e86d2d888 100644
--- a/arch/loongarch/mm/pageattr.c
+++ b/arch/loongarch/mm/pageattr.c
@@ -3,6 +3,7 @@
  * Copyright (C) 2024 Loongson Technology Corporation Limited
  */
 
+#include <linux/memblock.h>
 #include <linux/pagewalk.h>
 #include <linux/pgtable.h>
 #include <asm/set_memory.h>
@@ -167,7 +168,7 @@ bool kernel_page_present(struct page *page)
 	unsigned long addr = (unsigned long)page_address(page);
 
 	if (addr < vm_map_base)
-		return true;
+		return memblock_is_memory(__pa(addr));
 
 	pgd = pgd_offset_k(addr);
 	if (pgd_none(pgdp_get(pgd)))
-- 
2.39.5



