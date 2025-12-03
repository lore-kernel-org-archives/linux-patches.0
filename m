Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54728337BA1;
	Wed,  3 Dec 2025 15:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777333; cv=none; b=jT5GgDkXe3hzfIaQ6LB7CDFPh8OPdjqL24o+wWkpGtZv2OMT2+qXWLMuw7jvZS+qQWZixMTk/ZuPRpRyJSe1gpHBF4b83119fWx2jjfpMeNBzKinAUtrSKZoNG2LE/tSUltbwFMVNOeYbdnnGR3ELdk4ymHYKXvIFZto5pjllDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777333; c=relaxed/simple;
	bh=/ar478P2ru2WrAhSK2IUygj5nWNAHio/+pMXCED51TQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TMymo2SVZrUBdw5ib8fQJmaCYmeF/cY2ybdLF4qlvIeBmIjfaOUqF0WbNsGZKE7LupdCByjrUze2potk5PJ+MFw10VTKMM1CFn9anF2Wmu1X8WHc5HZCyohhWtyFbvYTIweTOhwhubKWGMvn7zdt8U4kJEZIakHVU79A5hwolOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uE6qh/vP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uE6qh/vP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71616C4CEF5;
	Wed,  3 Dec 2025 15:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777332;
	bh=/ar478P2ru2WrAhSK2IUygj5nWNAHio/+pMXCED51TQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uE6qh/vP6XJpOT4vOubNRdLTVR5S4kJfscjqKuiKnUz/uczyRHGS7sknaplgKuzd1
	 DL60tXR583P9ZFGpMZNWgap1pCkNIB5zka+bULR93cBoknmG8jbPNTmIlBSHBQ8QQE
	 hmHWu0KSCLapNpBRBYHmm5acoEWNO556wj6bM+AM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Punit Agrawal <punit.agrawal@oss.qualcomm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.17 145/146] Revert "ACPI: Suppress misleading SPCR console message when SPCR table is absent"
Date: Wed,  3 Dec 2025 16:28:43 +0100
Message-ID: <20251203152351.781479463@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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


