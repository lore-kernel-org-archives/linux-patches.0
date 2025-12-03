Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4EA34E771;
	Wed,  3 Dec 2025 16:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780928; cv=none; b=qxJHiaL0un8XyS4ZnGDudFZkmbKzI+wGCoi1F3we1RSSqMBGcxmHmDMhzYPDFjcIhN1Zd1q3CNt9Zzd2UubF4FudApGtcNR9hKzs/+ULpTlAB00hZJpjaqlwODElgTJtbAz82I9aF6rkPLrGa6ZRMjk7smtor4TZn/Dedk/Sb+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780928; c=relaxed/simple;
	bh=sgOwnE/kUxo/M+P7p+4t2hzBQM5sfXn9RVsgY/wcXbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tn5VadOId791q17SNrQf1Nw3U3/J3X7rRHGVZ1kAFR4yG4/xwiGS82NKme/zhCLGmor4TWU+37pNT0LBbd5cxWdhGOVrTp4XPbiboMiQNgzakxVj7yVf6jkPmsYrNqMh3a97alZdGzL7sVuCHCctWPJOxLw0XEaEIV11az0W+O4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QUk7MDRi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QUk7MDRi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03756C4CEF5;
	Wed,  3 Dec 2025 16:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780928;
	bh=sgOwnE/kUxo/M+P7p+4t2hzBQM5sfXn9RVsgY/wcXbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QUk7MDRiZxoy2hkebeOnhNyDwCRA7+e+iIklU9tXcNQg2dcEGZCxWYC37Z3qLNGsl
	 StJqbPLko+sD1s7TOZbPS8yYalsigehQV0oRzHX2vCjqIJEHma8kbLJZQVqlgSfZvJ
	 KvZmS+WAHGrJoS7HedyJ9mTKK9JVpMuJohA87HM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Punit Agrawal <punit.agrawal@oss.qualcomm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.12 130/132] Revert "ACPI: Suppress misleading SPCR console message when SPCR table is absent"
Date: Wed,  3 Dec 2025 16:30:09 +0100
Message-ID: <20251203152348.131829533@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Punit Agrawal <punit.agrawal@oss.qualcomm.com>

commit eeb8c19896952e18fb538ec76e603884070a6c6a upstream.

This reverts commit bad3fa2fb9206f4dcec6ddef094ec2fbf6e8dcb2.

Commit bad3fa2fb920 ("ACPI: Suppress misleading SPCR console message
when SPCR table is absent") mistakenly assumes acpi_parse_spcr()
returning 0 to indicate a failure to parse SPCR. While addressing the
resultant incorrect logging it was deemed that dropping the message is
a better approach as it is not particularly useful.

Roll back the commit introducing the bug as a step towards dropping
the log message.

Link: https://lore.kernel.org/all/aQN0YWUYaPYWpgJM@willie-the-truck/
Signed-off-by: Punit Agrawal <punit.agrawal@oss.qualcomm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/acpi.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/arch/arm64/kernel/acpi.c
+++ b/arch/arm64/kernel/acpi.c
@@ -197,8 +197,6 @@ out:
  */
 void __init acpi_boot_table_init(void)
 {
-	int ret;
-
 	/*
 	 * Enable ACPI instead of device tree unless
 	 * - ACPI has been disabled explicitly (acpi=off), or
@@ -252,12 +250,10 @@ done:
 		 * behaviour, use acpi=nospcr to disable console in ACPI SPCR
 		 * table as default serial console.
 		 */
-		ret = acpi_parse_spcr(earlycon_acpi_spcr_enable,
+		acpi_parse_spcr(earlycon_acpi_spcr_enable,
 			!param_acpi_nospcr);
-		if (!ret || param_acpi_nospcr || !IS_ENABLED(CONFIG_ACPI_SPCR_TABLE))
-			pr_info("Use ACPI SPCR as default console: No\n");
-		else
-			pr_info("Use ACPI SPCR as default console: Yes\n");
+		pr_info("Use ACPI SPCR as default console: %s\n",
+				param_acpi_nospcr ? "No" : "Yes");
 
 		if (IS_ENABLED(CONFIG_ACPI_BGRT))
 			acpi_table_parse(ACPI_SIG_BGRT, acpi_parse_bgrt);


