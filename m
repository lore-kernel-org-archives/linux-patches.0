Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1CAF31CA6E;
	Mon, 18 Aug 2025 13:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522233; cv=none; b=LGN4+o5KBQeFeN2A6nGt5MhZ3+rbV0uNdHpxaYASp99m5hpGrnEPSmDVyoGPAPCUMj4Vbe9ThqSNd9IGixXtX84fuesJbzPJFYns0DNyHU4nbNIRTrM1AYXgyiwqMY6IBtPe85GEZcBOFQJGd4kd3N6m9EwkIJl88jNgMSAM6zY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522233; c=relaxed/simple;
	bh=I/2zz5wvr252p60Tr0N//cHCsxdBjcC/PWZ+nCCCtqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HBdN6mr9BYaeKV6WcprKVuKyLG4Bg+e+SLe6k7WIcy+AqMsT74y/caV2+2DLh8iGTxQju84/Dh8EwyrTfk7EkJ2yyhFNFWwz1F5kkQachlpsKe5HZ9zx1n+ZPl3W2NcpJ9pdPdzh7q7ZANzkqqNcfzVYPsooZs39a+gJV+rb3V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zq3UHSlr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zq3UHSlr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A03C4CEEB;
	Mon, 18 Aug 2025 13:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522233;
	bh=I/2zz5wvr252p60Tr0N//cHCsxdBjcC/PWZ+nCCCtqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zq3UHSlr4+gbyY+yAUw7aDgj1+eYl6A9MIMpAaNsJbXA5w3j6vKizywv4VgRhdqgy
	 uJmzIgur45KXnzmf5/j9Y+5DSQd+jG7YxRZal2hqcTWjocqcdF8FCtnAhEYjYKxVhN
	 6DgvvVKQTA59zexA3pdja7DK1pQ2m6H2APS3E+Bs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Chen <chenl311@chinatelecom.cn>,
	Hanjun Guo <guohanjun@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 222/444] ACPI: Suppress misleading SPCR console message when SPCR table is absent
Date: Mon, 18 Aug 2025 14:44:08 +0200
Message-ID: <20250818124457.168346613@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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
index e6f66491fbe9..862bb1cba4f0 100644
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



