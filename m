Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68CE73218C0;
	Mon, 18 Aug 2025 13:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525517; cv=none; b=gvcYYTZ90Vaj9DNiCou0ejWJ3OGjlc5LgxdlmEx5dWob98NCOu6fJcsLKQ27Jvz6ykM8yuyqpfOGucJ50P+YBzy85v2i6N3L4tp7dnkOcJAYBOgQw0l6x0h9Fl/BgQalftDssqGeBymG8fAzi1n3ip5eokSLDumA18YxBrk60rI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525517; c=relaxed/simple;
	bh=hJ3aeUd7cwIhgG1ckdEl+HHJ+JmBKcnytlf35IRZ16c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iiROv3xvPMw9fjchoZdFsqc0WyvewE9dgeC6HwH1ZbUxYh5NK+nmN9UxlM3z7clLJg5uC2VocUjcOIuK23KK+kKhD8IWM0biBiY8icX3ei7MFZ31N+5L3BiUM2WImYdpDHOcm+gDPsd9vgBigN8J/gJcSmEnoZf8wd392+4hAYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lPrxMz8G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lPrxMz8G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 922BBC4CEEB;
	Mon, 18 Aug 2025 13:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525517;
	bh=hJ3aeUd7cwIhgG1ckdEl+HHJ+JmBKcnytlf35IRZ16c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lPrxMz8GJSFJy8HJJkAxdtNbHav/a6RuyF0Djp/Celgdu2F25DoUrgXTlv1/zwXiD
	 7cRyPWIBPo2w2GN469fZPh0GAxD7GOl4ciF76Amz/2XzhtuAYBWuNCYd9yBYgXWKF/
	 rNuTYHlXoZCWIFow4IU28ZT04X1R84mnzH2O327A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Chen <chenl311@chinatelecom.cn>,
	Hanjun Guo <guohanjun@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 287/570] ACPI: Suppress misleading SPCR console message when SPCR table is absent
Date: Mon, 18 Aug 2025 14:44:34 +0200
Message-ID: <20250818124516.901655140@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

From: Li Chen <chenl311@chinatelecom.cn>

[ Upstream commit bad3fa2fb9206f4dcec6ddef094ec2fbf6e8dcb2 ]

The kernel currently alway prints:
"Use ACPI SPCR as default console: No/Yes "

even on systems that lack an SPCR table. This can
mislead users into thinking the SPCR table exists
on the machines without SPCR.

With this change, the "Yes" is only printed if
the SPCR table is present, parsed and !param_acpi_nospcr.
This avoids user confusion on SPCR-less systems.

Signed-off-by: Li Chen <chenl311@chinatelecom.cn>
Acked-by: Hanjun Guo <guohanjun@huawei.com>
Link: https://lore.kernel.org/r/20250620131309.126555-3-me@linux.beauty
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/acpi.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
index b9a66fc146c9..4d529ff7ba51 100644
--- a/arch/arm64/kernel/acpi.c
+++ b/arch/arm64/kernel/acpi.c
@@ -197,6 +197,8 @@ static int __init acpi_fadt_sanity_check(void)
  */
 void __init acpi_boot_table_init(void)
 {
+	int ret;
+
 	/*
 	 * Enable ACPI instead of device tree unless
 	 * - ACPI has been disabled explicitly (acpi=off), or
@@ -250,10 +252,12 @@ void __init acpi_boot_table_init(void)
 		 * behaviour, use acpi=nospcr to disable console in ACPI SPCR
 		 * table as default serial console.
 		 */
-		acpi_parse_spcr(earlycon_acpi_spcr_enable,
+		ret = acpi_parse_spcr(earlycon_acpi_spcr_enable,
 			!param_acpi_nospcr);
-		pr_info("Use ACPI SPCR as default console: %s\n",
-				param_acpi_nospcr ? "No" : "Yes");
+		if (!ret || param_acpi_nospcr || !IS_ENABLED(CONFIG_ACPI_SPCR_TABLE))
+			pr_info("Use ACPI SPCR as default console: No\n");
+		else
+			pr_info("Use ACPI SPCR as default console: Yes\n");
 
 		if (IS_ENABLED(CONFIG_ACPI_BGRT))
 			acpi_table_parse(ACPI_SIG_BGRT, acpi_parse_bgrt);
-- 
2.39.5



