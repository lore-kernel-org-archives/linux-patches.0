Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADAD033A01F;
	Mon, 18 Aug 2025 13:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523768; cv=none; b=EXo8+hoZexsWuvK+Y4e6z9LOhbkKaEdua80PXlkki07XvxK9bE47URuHtexNvUIiznAjcfUK37CHL6IXH2Q2yBsTHbiZEwmvLh/1O5poihpMXIc6u1fzTPqVYQf9zcv6mxDCCsrWps6npmpcUijM8FnuTYjT7QDKiqEyFCnMqcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523768; c=relaxed/simple;
	bh=zU6Fo75mPV49tbvL5+am5zYB3CFf85vry7gFxJfszbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QXUjYuZtWyGbUR7QmbQC7Iv7pRlX2Keo9qwXIC/0wUrw91Gd0xP4tn0xhi57utNczVSSe3vlWfsLq9HaWWY4UwJp+reIdU9pmsB8oGxUKICnHZVatR5QCDu3lCwkmdzKF8w+Yo4kMmTVCfuZHxWQY09EyW3fj+HD0XcZdxmlDyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fz2fIfen; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fz2fIfen"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20A6DC4CEEB;
	Mon, 18 Aug 2025 13:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523768;
	bh=zU6Fo75mPV49tbvL5+am5zYB3CFf85vry7gFxJfszbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fz2fIfencrhYWTCKS4nUczL5eXDIpGTU+OF3wcTqg1MbAR8FCiGJjiBB1aboDGvem
	 iwqVo42eYQRK4NnQBhulTZPepbHqOikIztyATWfVh3D03tpw0H5kj6XvNB5eMkNc3v
	 lu9Ze3RGfYetMGzUu/PAaY20laUAcb/rnXCu2phc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Chen <chenl311@chinatelecom.cn>,
	Hanjun Guo <guohanjun@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 268/515] ACPI: Suppress misleading SPCR console message when SPCR table is absent
Date: Mon, 18 Aug 2025 14:44:14 +0200
Message-ID: <20250818124508.738416946@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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



