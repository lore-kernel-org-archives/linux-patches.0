Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EC0A4C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 12:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A61D0C433D6;
	Mon, 14 Nov 2022 12:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668430211;
	bh=d2264aBBD0gS+AzQSTXIwrYw0L4tcWppFU/ti/axhig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T3sHpr8GQiE2yEoP4jhIVknbOicBHC5yLRcubsAkKOpYJAy5HezoXmEeXiHU9MA4t
	 gr30q/5F+4lrQrRl0kDT4qJTt/wvFyqzunaqlFRizgsIPu5X7t8z8a+9qh698QE3t7
	 0yKNkYMInQH6EIKKLhdz3SEexwkQFP1Y9dIh0szA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Norris <briannorris@chromium.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 59/95] mmc: sdhci_am654: Fix SDHCI_RESET_ALL for CQHCI
Date: Mon, 14 Nov 2022 13:45:53 +0100
Message-Id: <20221114124444.961011329@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124442.530286937@linuxfoundation.org>
References: <20221114124442.530286937@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Brian Norris <briannorris@chromium.org>

commit 162503fd1c3a1d4e14dbe7f399c1d1bec1c8abbc upstream.

[[ NOTE: this is completely untested by the author, but included solely
    because, as noted in commit df57d73276b8 ("mmc: sdhci-pci: Fix
    SDHCI_RESET_ALL for CQHCI for Intel GLK-based controllers"), "other
    drivers using CQHCI might benefit from a similar change, if they
    also have CQHCI reset by SDHCI_RESET_ALL." We've now seen the same
    bug on at least MSM, Arasan, and Intel hardware. ]]

SDHCI_RESET_ALL resets will reset the hardware CQE state, but we aren't
tracking that properly in software. When out of sync, we may trigger
various timeouts.

It's not typical to perform resets while CQE is enabled, but this may
occur in some suspend or error recovery scenarios.

Include this fix by way of the new sdhci_and_cqhci_reset() helper.

This patch depends on (and should not compile without) the patch
entitled "mmc: cqhci: Provide helper for resetting both SDHCI and
CQHCI".

Fixes: f545702b74f9 ("mmc: sdhci_am654: Add Support for Command Queuing Engine to J721E")
Signed-off-by: Brian Norris <briannorris@chromium.org>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20221026124150.v4.6.I35ca9d6220ba48304438b992a76647ca8e5b126f@changeid
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci_am654.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/mmc/host/sdhci_am654.c
+++ b/drivers/mmc/host/sdhci_am654.c
@@ -15,6 +15,7 @@
 #include <linux/sys_soc.h>
 
 #include "cqhci.h"
+#include "sdhci-cqhci.h"
 #include "sdhci-pltfm.h"
 
 /* CTL_CFG Registers */
@@ -378,7 +379,7 @@ static void sdhci_am654_reset(struct sdh
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 	struct sdhci_am654_data *sdhci_am654 = sdhci_pltfm_priv(pltfm_host);
 
-	sdhci_reset(host, mask);
+	sdhci_and_cqhci_reset(host, mask);
 
 	if (sdhci_am654->quirks & SDHCI_AM654_QUIRK_FORCE_CDTEST) {
 		ctrl = sdhci_readb(host, SDHCI_HOST_CONTROL);
@@ -464,7 +465,7 @@ static struct sdhci_ops sdhci_am654_ops
 	.set_clock = sdhci_am654_set_clock,
 	.write_b = sdhci_am654_write_b,
 	.irq = sdhci_am654_cqhci_irq,
-	.reset = sdhci_reset,
+	.reset = sdhci_and_cqhci_reset,
 };
 
 static const struct sdhci_pltfm_data sdhci_am654_pdata = {
@@ -494,7 +495,7 @@ static struct sdhci_ops sdhci_j721e_8bit
 	.set_clock = sdhci_am654_set_clock,
 	.write_b = sdhci_am654_write_b,
 	.irq = sdhci_am654_cqhci_irq,
-	.reset = sdhci_reset,
+	.reset = sdhci_and_cqhci_reset,
 };
 
 static const struct sdhci_pltfm_data sdhci_j721e_8bit_pdata = {


