Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 627D237312B;
	Sat, 28 Feb 2026 17:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301506; cv=none; b=Oxp2LtbFw4ND5XS9p6eo280sKulwRBoSh1r44lmK7lEAKm1y6QoRk1ucNI6Re0TsNj5xxILEy3EYJZWGOL3uomNfzF+pFg7+/aj1AEPAtwLCxdSZwJkMgTqsjpfZOeQM/CEiWJZ8OPuKfRwCyVsLfLh2B1Q6pSr4wrhxJ8n62oY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301506; c=relaxed/simple;
	bh=qFB2osV4uyJ47nNetqOZrBvwt9IAQKHhsyyqPsciP6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cR/Lu9+6KsBSeEwCjcvLiubI4XNhxz5dwcLY6Mf2f28BCFhT2vcfn3bQv8JqfRgqyNnXYB5mzAMbveFhT6mxaDQexSEmM0znA7SO5pRTwBizO2D6r9L9n2GUTo9RaAwc+C3XHY9gcXusp22rNzuP62o+Vqi+ruMsxfnX6esAIiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GHWQJtQC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GHWQJtQC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADDDDC19423;
	Sat, 28 Feb 2026 17:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301506;
	bh=qFB2osV4uyJ47nNetqOZrBvwt9IAQKHhsyyqPsciP6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GHWQJtQCiSHz/QYEqWxdzAAlDekElds/E5wWGqjxgL7YkBoahtcWb+fb4ekBwzZN0
	 rcPKqD2Ovoa/2CvErgZqDDjXIOpcqhyRSiregoC/OBnIg3+QqHITYD5pIxNFeChHfH
	 ZhuzGGhCiHKI3nAvK/dbus5+DgeTs2f4Gl0Kb7H9yHrfI2dvdR5+OQ1BXQuzOOFZE/
	 KFXmcfZYaMBXAuPwvBhGDlHl8Mo9HupcbanFLy4Ut53g64m+N7v6Qvp/VrcOgSug33
	 kf716Wq9qOQ99VyFPjhPRBPYfnwdZwu2Fm7i1jxAljks46z9adQbgF7EHjcKyEv8s+
	 s5ZKALYAdXp2g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Tiezhu Yang <yangtiezhu@loongson.cn>,
	stable@vger.kernel.org,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 691/752] LoongArch: Disable instrumentation for setup_ptwalker()
Date: Sat, 28 Feb 2026 12:46:42 -0500
Message-ID: <20260228174750.1542406-691-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit 7cb37af61f09c9cfd90c43c9275307c16320cbf2 ]

According to Documentation/dev-tools/kasan.rst, software KASAN modes use
compiler instrumentation to insert validity checks. Such instrumentation
might be incompatible with some parts of the kernel, and therefore needs
to be disabled, just use the attribute __no_sanitize_address to disable
instrumentation for the low level function setup_ptwalker().

Otherwise bringing up the secondary CPUs failed when CONFIG_KASAN is set
(especially when PTW is enabled), here are the call chains:

    smpboot_entry()
      start_secondary()
        cpu_probe()
          per_cpu_trap_init()
            tlb_init()
              setup_tlb_handler()
                setup_ptwalker()

The reason is the PGD registers are configured in setup_ptwalker(), but
KASAN instrumentation may cause TLB exceptions before that.

Cc: stable@vger.kernel.org
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/mm/tlb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/loongarch/mm/tlb.c b/arch/loongarch/mm/tlb.c
index 3b427b319db21..f46c15d6e7eae 100644
--- a/arch/loongarch/mm/tlb.c
+++ b/arch/loongarch/mm/tlb.c
@@ -202,7 +202,7 @@ void __update_tlb(struct vm_area_struct *vma, unsigned long address, pte_t *ptep
 	local_irq_restore(flags);
 }
 
-static void setup_ptwalker(void)
+static void __no_sanitize_address setup_ptwalker(void)
 {
 	unsigned long pwctl0, pwctl1;
 	unsigned long pgd_i = 0, pgd_w = 0;
-- 
2.51.0

