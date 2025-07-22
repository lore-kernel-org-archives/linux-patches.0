Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DF55433A8;
	Tue, 22 Jul 2025 13:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192034; cv=none; b=hp3Bon4sj6pWUDSpkMTU2o+h9E/ctPxRd6QwrQcYXNEWtgt5rhSy4VeLYDsLNW01XUgDSXLuOJNxNgALmAqKslAosQGtlOz/qoq83nCuQXkg3WdyZSS0ZZ5vSoJOJ7Q6lZSDx7yfZ1ylU74fnz82pD91qlT3rIDqggwZZA/WQS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192034; c=relaxed/simple;
	bh=D0PcPSntyGkBYxtoNihpnoXrDj7DHaZrGfVk62yOpLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=szyZB/8SoBeojfMC4HOffj6kOJq0EHVITV4cMkU5jWywxaVouQ/ul0osMKSyWTjB/qlpa6VQo4GXGDB1XpH249vaWXQfdJSxKe38akVwRwQLr3f4PkC5dL5NWLMmVb0+4U+jEfcK+x2vgqMW6jXCsIeAVQvsWUkcqYbYRSCZO5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2lifzK5u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2lifzK5u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A276C4AF0B;
	Tue, 22 Jul 2025 13:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192033;
	bh=D0PcPSntyGkBYxtoNihpnoXrDj7DHaZrGfVk62yOpLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2lifzK5uQHQCimaUSRzGv+2bOj0CYrfXxrYf9O6A/cBe29O9bdAIMc9PWxz8O/Y47
	 dLawxEPoXxCTcaNzM6LKSOM9ErAeCkjEQH7XeoQ7RfgJv0x4UElKqxCw9RL5katyXt
	 lEof8+0nIBX1jt1k3rxLUa66MjuHesQohM8pUo+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.1 25/79] mmc: sdhci_am654: Workaround for Errata i2312
Date: Tue, 22 Jul 2025 15:44:21 +0200
Message-ID: <20250722134329.299051676@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134328.384139905@linuxfoundation.org>
References: <20250722134328.384139905@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Judith Mendez <jm@ti.com>

commit 6d0b1c01847fedd7c85a5cdf59b8cfc7d14512e6 upstream.

Errata i2312 [0] for K3 silicon mentions the maximum obtainable
timeout through MMC host controller is 700ms. And for commands taking
longer than 700ms, hardware timeout should be disabled and software
timeout should be used.

The workaround for Errata i2312 can be achieved by adding
SDHCI_QUIRK2_DISABLE_HW_TIMEOUT quirk in sdhci_am654.

[0] https://www.ti.com/lit/pdf/sprz487

Signed-off-by: Judith Mendez <jm@ti.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Fixes: 41fd4caeb00b ("mmc: sdhci_am654: Add Initial Support for AM654 SDHCI driver")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250626231452.3460987-1-jm@ti.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci_am654.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/mmc/host/sdhci_am654.c
+++ b/drivers/mmc/host/sdhci_am654.c
@@ -558,7 +558,8 @@ static struct sdhci_ops sdhci_am654_ops
 static const struct sdhci_pltfm_data sdhci_am654_pdata = {
 	.ops = &sdhci_am654_ops,
 	.quirks = SDHCI_QUIRK_MULTIBLOCK_READ_ACMD12,
-	.quirks2 = SDHCI_QUIRK2_PRESET_VALUE_BROKEN,
+	.quirks2 = SDHCI_QUIRK2_PRESET_VALUE_BROKEN |
+		   SDHCI_QUIRK2_DISABLE_HW_TIMEOUT,
 };
 
 static const struct sdhci_am654_driver_data sdhci_am654_sr1_drvdata = {
@@ -588,7 +589,8 @@ static struct sdhci_ops sdhci_j721e_8bit
 static const struct sdhci_pltfm_data sdhci_j721e_8bit_pdata = {
 	.ops = &sdhci_j721e_8bit_ops,
 	.quirks = SDHCI_QUIRK_MULTIBLOCK_READ_ACMD12,
-	.quirks2 = SDHCI_QUIRK2_PRESET_VALUE_BROKEN,
+	.quirks2 = SDHCI_QUIRK2_PRESET_VALUE_BROKEN |
+		   SDHCI_QUIRK2_DISABLE_HW_TIMEOUT,
 };
 
 static const struct sdhci_am654_driver_data sdhci_j721e_8bit_drvdata = {
@@ -612,7 +614,8 @@ static struct sdhci_ops sdhci_j721e_4bit
 static const struct sdhci_pltfm_data sdhci_j721e_4bit_pdata = {
 	.ops = &sdhci_j721e_4bit_ops,
 	.quirks = SDHCI_QUIRK_MULTIBLOCK_READ_ACMD12,
-	.quirks2 = SDHCI_QUIRK2_PRESET_VALUE_BROKEN,
+	.quirks2 = SDHCI_QUIRK2_PRESET_VALUE_BROKEN |
+		   SDHCI_QUIRK2_DISABLE_HW_TIMEOUT,
 };
 
 static const struct sdhci_am654_driver_data sdhci_j721e_4bit_drvdata = {


