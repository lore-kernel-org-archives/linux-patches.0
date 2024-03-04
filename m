Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080A27868F;
	Mon,  4 Mar 2024 21:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589301; cv=none; b=XX2Nr8+Ez4KeJDB4VHVmqZ67qAVjnHMstIOVifqcdtIIeDjWv8ZjplKYI2yqO1YkAVHP3AL60wUiZ4HN67wJqVRufCxHz4Tga4S/qRSDRlSpjZ1yEQLMaaX79G7J7Q2w7USyGu8wTc3VacUYey0izvhle5TuOcyhUZvRYLt8Tck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589301; c=relaxed/simple;
	bh=zvlGhIzB3OsTf/HuB9NMmM37Rf9MXvbJUUndeIqtNWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tnTy7dKRuobDJCe2aML3RWQtmg3SPRq6u6RZllpXKRvO2jIRrLz4rPVmkLmHknABaDmYJUx70nqQnCVR8AX5RoE9zV8RJEQhIf6kqYlYyYRmkn4fhtFK4Y8L5KlKj2bbz/OKtxmtQPyQSWpzvwjrl/PAGEIH/qhXDMT41Dip2r8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=crWX0Emr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="crWX0Emr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E9D7C433F1;
	Mon,  4 Mar 2024 21:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589300;
	bh=zvlGhIzB3OsTf/HuB9NMmM37Rf9MXvbJUUndeIqtNWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=crWX0Emr/8AgswOS9CBcePFBErEwZaL2fU4sAaUSE9CIsByekJ3TaeqljU1pJPP1l
	 mMZgEArpWrFnby0cU+dK7ETyuaig59mEWxsMMPeTDiVS+X8XxOcsVIgU7PG5N6YyEd
	 Mw8c3J7I1CN8pp5UxUAtTR1PP7bwqcto8nxUlh5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Elad Nachman <enachman@marvell.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 57/84] mmc: sdhci-xenon: fix PHY init clock stability
Date: Mon,  4 Mar 2024 21:24:30 +0000
Message-ID: <20240304211544.282435084@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211542.332206551@linuxfoundation.org>
References: <20240304211542.332206551@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Elad Nachman <enachman@marvell.com>

commit 8e9f25a290ae0016353c9ea13314c95fb3207812 upstream.

Each time SD/mmc phy is initialized, at times, in some of
the attempts, phy fails to completes its initialization
which results into timeout error. Per the HW spec, it is
a pre-requisite to ensure a stable SD clock before a phy
initialization is attempted.

Fixes: 06c8b667ff5b ("mmc: sdhci-xenon: Add support to PHYs of Marvell Xenon SDHC")
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Elad Nachman <enachman@marvell.com>
Link: https://lore.kernel.org/r/20240222200930.1277665-1-enachman@marvell.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-xenon-phy.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/drivers/mmc/host/sdhci-xenon-phy.c
+++ b/drivers/mmc/host/sdhci-xenon-phy.c
@@ -11,6 +11,7 @@
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/ktime.h>
+#include <linux/iopoll.h>
 #include <linux/of_address.h>
 
 #include "sdhci-pltfm.h"
@@ -218,6 +219,19 @@ static int xenon_alloc_emmc_phy(struct s
 	return 0;
 }
 
+static int xenon_check_stability_internal_clk(struct sdhci_host *host)
+{
+	u32 reg;
+	int err;
+
+	err = read_poll_timeout(sdhci_readw, reg, reg & SDHCI_CLOCK_INT_STABLE,
+				1100, 20000, false, host, SDHCI_CLOCK_CONTROL);
+	if (err)
+		dev_err(mmc_dev(host->mmc), "phy_init: Internal clock never stabilized.\n");
+
+	return err;
+}
+
 /*
  * eMMC 5.0/5.1 PHY init/re-init.
  * eMMC PHY init should be executed after:
@@ -234,6 +248,11 @@ static int xenon_emmc_phy_init(struct sd
 	struct xenon_priv *priv = sdhci_pltfm_priv(pltfm_host);
 	struct xenon_emmc_phy_regs *phy_regs = priv->emmc_phy_regs;
 
+	int ret = xenon_check_stability_internal_clk(host);
+
+	if (ret)
+		return ret;
+
 	reg = sdhci_readl(host, phy_regs->timing_adj);
 	reg |= XENON_PHY_INITIALIZAION;
 	sdhci_writel(host, reg, phy_regs->timing_adj);


