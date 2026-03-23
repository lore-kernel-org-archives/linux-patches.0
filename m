Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CAF13B9DA6;
	Mon, 23 Mar 2026 15:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278961; cv=none; b=anJNDLccVm1jCk8Qh8co9eayHAH22YEP6RMgb+AI2D8t8o7UQ5Q6mt+ZBMJi+rwtXCuN0ljy+J1PSHv9JnGPkkotpFq0m56yaO564mYU9tMWc/aZa4AMf7tF6i8RemjkSRSZY/kJa/xoa3MCeCBNvuQpPoJq9jCLEFzofrvg2qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278961; c=relaxed/simple;
	bh=vAqDgDR801n0mcDihkNWQdH3hazGCya3SgoUvRWeypE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MqnT4lNe7GES/gSPTGnRu+cd5qveb7984xxIOflrGJKMf17LmUAi62CR6lvx2kQCCRBQEhxmbGwatN7JCzs0+8So3RWGSDiz1Bodp4mdmG4BH+Eu7ZkE8z3/hB0aqDsTGMd7lcRjeS575Uukw4H1c+U/dyhU0Jx/X1h7gu//u/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L3wcU/o9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L3wcU/o9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E737BC4CEF7;
	Mon, 23 Mar 2026 15:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278961;
	bh=vAqDgDR801n0mcDihkNWQdH3hazGCya3SgoUvRWeypE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L3wcU/o92nWQF0SFno35Pmd5tY8iDR0sNmRx7Etu5uA6AEtxCZ4A30MEGCfqA766c
	 MyP3mHI/3d5hOiZHV6uCLMUwXk9QIVotQx1J7kgaANgwn3b1VdhJRYUupfWFMscExC
	 gyHe3DE7rKaDWO8/73fXwykXpdgoGJOmllam8tYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luke Wang <ziniu.wang_1@nxp.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 475/567] mmc: sdhci: fix timing selection for 1-bit bus width
Date: Mon, 23 Mar 2026 14:46:35 +0100
Message-ID: <20260323134545.738292700@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

From: Luke Wang <ziniu.wang_1@nxp.com>

commit 5e3486e64094c28a526543f1e8aa0d5964b7f02d upstream.

When 1-bit bus width is used with HS200/HS400 capabilities set,
mmc_select_hs200() returns 0 without actually switching. This
causes mmc_select_timing() to skip mmc_select_hs(), leaving eMMC
in legacy mode (26MHz) instead of High Speed SDR (52MHz).

Per JEDEC eMMC spec section 5.3.2, 1-bit mode supports High Speed
SDR. Drop incompatible HS200/HS400/UHS/DDR caps early so timing
selection falls through to mmc_select_hs() correctly.

Fixes: f2119df6b764 ("mmc: sd: add support for signal voltage switch procedure")
Signed-off-by: Luke Wang <ziniu.wang_1@nxp.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -4497,8 +4497,15 @@ int sdhci_setup_host(struct sdhci_host *
 	 * their platform code before calling sdhci_add_host(), and we
 	 * won't assume 8-bit width for hosts without that CAP.
 	 */
-	if (!(host->quirks & SDHCI_QUIRK_FORCE_1_BIT_DATA))
+	if (host->quirks & SDHCI_QUIRK_FORCE_1_BIT_DATA) {
+		host->caps1 &= ~(SDHCI_SUPPORT_SDR104 | SDHCI_SUPPORT_SDR50 | SDHCI_SUPPORT_DDR50);
+		if (host->quirks2 & SDHCI_QUIRK2_CAPS_BIT63_FOR_HS400)
+			host->caps1 &= ~SDHCI_SUPPORT_HS400;
+		mmc->caps2 &= ~(MMC_CAP2_HS200 | MMC_CAP2_HS400 | MMC_CAP2_HS400_ES);
+		mmc->caps &= ~(MMC_CAP_DDR | MMC_CAP_UHS);
+	} else {
 		mmc->caps |= MMC_CAP_4_BIT_DATA;
+	}
 
 	if (host->quirks2 & SDHCI_QUIRK2_HOST_NO_CMD23)
 		mmc->caps &= ~MMC_CAP_CMD23;


