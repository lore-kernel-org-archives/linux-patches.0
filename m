Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABA282F12D2;
	Fri, 17 Oct 2025 15:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713531; cv=none; b=deK1p9+WG5P6Rf6V1e8LDFM35mi9+bwUcZLjQlkO99ZBZadxwvs+WrvS14ABmJobAKZNbYaCoQAqZoIQEPZkmpDCs4N2vTQWMWqtUO6KK+N6GcPtB3WOIRs4mNUrQLjbDExq3qgA2Zjq2A9w0iiVeyXoIexBp/C0tEIVMDzvqB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713531; c=relaxed/simple;
	bh=4IMXBrYcG2BBxxlPBqefevzgE3uQekDmwm0nfJE1a+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P/ley7SwL3SOx3tTOIvSs1ChF2V+/T4Fwgg5a/LtJBtGqqsakSaDXvF0EZID9TOESPPH+ZiHs5pMwamj0wXGqQA5wIWWHAA+ivkJWafyMc3pHPRjdnA6m7TLQkppsB4R6CMkiRFmTFBS9p5vLAFpJJlEFbhiqS/ebaKt55fvSss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MQ7SKd2L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MQ7SKd2L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29A35C4CEE7;
	Fri, 17 Oct 2025 15:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713531;
	bh=4IMXBrYcG2BBxxlPBqefevzgE3uQekDmwm0nfJE1a+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MQ7SKd2LgvvGla4VbcHXXJyfm3n3MshjBRmdMiE3z15q2aN9Qiv6tlRZ/2LsqRGQ2
	 Qp2FGE7xGkPYh/GlmsgG/poyegqGXfIZ4Pt7+Y1FQctWhYHhbuwvUOsiPTABhehrzb
	 PO3w7byL/YFPcx7T1RDdLtH6MTy/iGfxRhqlLqf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 029/201] LoongArch: Remove CONFIG_ACPI_TABLE_UPGRADE in platform_init()
Date: Fri, 17 Oct 2025 16:51:30 +0200
Message-ID: <20251017145135.814998054@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit 6c3ca6654a74dd396bc477839ba8d9792eced441 ]

Both acpi_table_upgrade() and acpi_boot_table_init() are defined as
empty functions under !CONFIG_ACPI_TABLE_UPGRADE and !CONFIG_ACPI in
include/linux/acpi.h, there are no implicit declaration errors with
various configs.

  #ifdef CONFIG_ACPI_TABLE_UPGRADE
  void acpi_table_upgrade(void);
  #else
  static inline void acpi_table_upgrade(void) { }
  #endif

  #ifdef	CONFIG_ACPI
  ...
  void acpi_boot_table_init (void);
  ...
  #else	/* !CONFIG_ACPI */
  ...
  static inline void acpi_boot_table_init(void)
  {
  }
  ...
  #endif	/* !CONFIG_ACPI */

As Huacai suggested, CONFIG_ACPI_TABLE_UPGRADE is ugly and not necessary
here, just remove it. At the same time, just keep CONFIG_ACPI to prevent
potential build errors in future, and give a signal to indicate the code
is ACPI-specific. For the same reason, we also put acpi_table_upgrade()
under CONFIG_ACPI.

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Stable-dep-of: 98662be7ef20 ("LoongArch: Init acpi_gbl_use_global_lock to false")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kernel/setup.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/loongarch/kernel/setup.c b/arch/loongarch/kernel/setup.c
index 655dc2b1616f2..a494b13c9e90c 100644
--- a/arch/loongarch/kernel/setup.c
+++ b/arch/loongarch/kernel/setup.c
@@ -363,10 +363,8 @@ void __init platform_init(void)
 	arch_reserve_vmcore();
 	arch_parse_crashkernel();
 
-#ifdef CONFIG_ACPI_TABLE_UPGRADE
-	acpi_table_upgrade();
-#endif
 #ifdef CONFIG_ACPI
+	acpi_table_upgrade();
 	acpi_gbl_use_default_register_widths = false;
 	acpi_boot_table_init();
 #endif
-- 
2.51.0



