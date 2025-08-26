Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF7324DD11;
	Tue, 26 Aug 2025 13:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215409; cv=none; b=UxNQAso/dRaNqq+Is/lXoouEL6EL0bZhQfuNVPq58itmugAiT9pi1//vvY+zVzCwhVNA3cjcJAwmpwMUBesMYQnegEPaPpBai3HD16GDZK8llZ2W50ZB5wAOhP18E1SXvoA0qmfGRSlNzbzdf4rg/mT/tKA5FZTeTPLAmeemgns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215409; c=relaxed/simple;
	bh=w9e+tgWFkkSp+8OQ6/al256LFqwibCemOBWhxejePy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lcyZwYcY02W70KaMY7+VbHqiY6b0luGcRWm3r55yAeZvUStY6H9djBlBouKHJwh6qIx71HmeMpLR8Y1WKaopJuU2a9bY8tAS/C7tcIS9kqrYMbcn4ZLToiIznze2AYCSCL81VWeA8qe9nDc5BuE85sUSmB/17ebF+3WC5gio6rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zXiOiy1U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zXiOiy1U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8024C4CEF1;
	Tue, 26 Aug 2025 13:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215409;
	bh=w9e+tgWFkkSp+8OQ6/al256LFqwibCemOBWhxejePy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zXiOiy1ULNOiApgopmkO/2zD1aUF/hie0pLd0p4Gfu75lCwT6AOjHhmRbXR/4JMgI
	 A7/ohcR4fLzLDdpHHab30wy+DYRC31d7dgrh9/r+YJHalKf3sBbRfHN63jvbweIjFB
	 HZjR4DGYjF09rH6zuHsb64c4Mnp0f/N2F+Upn1Cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 022/644] mmc: sdhci_am654: Workaround for Errata i2312
Date: Tue, 26 Aug 2025 13:01:53 +0200
Message-ID: <20250826110947.058476329@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


