Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D342EE5FB;
	Tue, 22 Jul 2025 14:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193494; cv=none; b=QYO2A/dJJ35+b/Y12LeIVhG3OwGtvFfETAEB3XCYJAI49RUXywfwlMKd1Ds+iCHUmDJ060funwp82DgAeaMkWtee6/GFK5UjTnW2MbMI3IdSeHCy074KRr9RYS043iBGcoJHCQdVEw6m9QLjg83Gu0ypXBX9ehr8Zu2Joh7K1c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193494; c=relaxed/simple;
	bh=fbW+S1cDTqcvPRyZbKo0yWWeCKk5hYHwgHGgtWjrUxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=celCxrLodEG+nFlJlY/vb3rcNLP1xUEzTv+IJdL089BV+9xEmpnqmTjnn7ZYyQjCUUU5yxote1herFb30GSD64fPYRc3lTKrll9ItlXKsNNTPo808/wEa90C81j2GOeNd9OiKlPBC0sMhdsAI1njzQNuEQxZElQHGlosdxU2Iok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B4ydwvSH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B4ydwvSH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B865C4CEEB;
	Tue, 22 Jul 2025 14:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193493;
	bh=fbW+S1cDTqcvPRyZbKo0yWWeCKk5hYHwgHGgtWjrUxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B4ydwvSHAPryF+7d4Yh6NwhY4EIucGXpNjjvK8MtYU1FZW0pG8LKqOcQWkstXu4bt
	 mw1wazhHfMuUQdodU2SJwSlZ1Lm7N2W/09gokyvjV8TBQeeJKtxirzp1URcVfhkiDh
	 Vv+9/K+iDOp2qW9FhNHVsiUB/FU75e/vAHR1HP5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.15 067/187] mmc: sdhci_am654: Workaround for Errata i2312
Date: Tue, 22 Jul 2025 15:43:57 +0200
Message-ID: <20250722134348.239904100@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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
@@ -613,7 +613,8 @@ static const struct sdhci_ops sdhci_am65
 static const struct sdhci_pltfm_data sdhci_am654_pdata = {
 	.ops = &sdhci_am654_ops,
 	.quirks = SDHCI_QUIRK_MULTIBLOCK_READ_ACMD12,
-	.quirks2 = SDHCI_QUIRK2_PRESET_VALUE_BROKEN,
+	.quirks2 = SDHCI_QUIRK2_PRESET_VALUE_BROKEN |
+		   SDHCI_QUIRK2_DISABLE_HW_TIMEOUT,
 };
 
 static const struct sdhci_am654_driver_data sdhci_am654_sr1_drvdata = {
@@ -643,7 +644,8 @@ static const struct sdhci_ops sdhci_j721
 static const struct sdhci_pltfm_data sdhci_j721e_8bit_pdata = {
 	.ops = &sdhci_j721e_8bit_ops,
 	.quirks = SDHCI_QUIRK_MULTIBLOCK_READ_ACMD12,
-	.quirks2 = SDHCI_QUIRK2_PRESET_VALUE_BROKEN,
+	.quirks2 = SDHCI_QUIRK2_PRESET_VALUE_BROKEN |
+		   SDHCI_QUIRK2_DISABLE_HW_TIMEOUT,
 };
 
 static const struct sdhci_am654_driver_data sdhci_j721e_8bit_drvdata = {
@@ -667,7 +669,8 @@ static const struct sdhci_ops sdhci_j721
 static const struct sdhci_pltfm_data sdhci_j721e_4bit_pdata = {
 	.ops = &sdhci_j721e_4bit_ops,
 	.quirks = SDHCI_QUIRK_MULTIBLOCK_READ_ACMD12,
-	.quirks2 = SDHCI_QUIRK2_PRESET_VALUE_BROKEN,
+	.quirks2 = SDHCI_QUIRK2_PRESET_VALUE_BROKEN |
+		   SDHCI_QUIRK2_DISABLE_HW_TIMEOUT,
 };
 
 static const struct sdhci_am654_driver_data sdhci_j721e_4bit_drvdata = {


