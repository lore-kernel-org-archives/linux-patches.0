Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656261C6AB;
	Mon,  4 Mar 2024 21:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589298; cv=none; b=ue5YOM0ww5cItDjnYz/MMn/3UAiJx2zlCqIhzu38HgICkPn4i8e5TGiiYaicj46BjLoq4DdUa6kvFohyXPlrncEJhWOIuKpiU13iCj69ONAKswNwJsQpAOsaPy3G+NDZ2gMg2RFsewRJ34E0dBClKE4lGreLB+dE20UXlqGjgVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589298; c=relaxed/simple;
	bh=31RS71XkNiuns8RDNydkyMjtxbve4vH4T/KD9cCeL+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P/OlS8hhyut2r/d5noz3VPxeRoADS5c5LYga3govb7QfYHSAijrNrwNKjtfAN8mB0YD2uAiBe8jE7Y8X1IpXb9Y0KQZmrsBZrK86py9J2Z2NAC5wAA/UXyf7CsJL7ksLmo0BBQGt9//iGItn2oxN2RupM1lCOiykkGzRM0s0pwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yE6Z+TKt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yE6Z+TKt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED74DC433F1;
	Mon,  4 Mar 2024 21:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589298;
	bh=31RS71XkNiuns8RDNydkyMjtxbve4vH4T/KD9cCeL+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yE6Z+TKtN1aEE9qWKy9wlxJ+XK9wMEuHgdXqWed6CrVP0Uj7zyix1Cz/Jy0Zcimyu
	 aiYZg9uYN5LVIOIVZCQsZLKFORnkY5+hjDBf41t2cm7//Tpd8TCJzfMul/GvqtKzmD
	 YbEKycPRmRqEVWA9kLwaWSC/tar6NTXaf3VTtHxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Elad Nachman <enachman@marvell.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 56/84] mmc: sdhci-xenon: add timeout for PHY init complete
Date: Mon,  4 Mar 2024 21:24:29 +0000
Message-ID: <20240304211544.240947636@linuxfoundation.org>
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

commit 09e23823ae9a3e2d5d20f2e1efe0d6e48cef9129 upstream.

AC5X spec says PHY init complete bit must be polled until zero.
We see cases in which timeout can take longer than the standard
calculation on AC5X, which is expected following the spec comment above.
According to the spec, we must wait as long as it takes for that bit to
toggle on AC5X.
Cap that with 100 delay loops so we won't get stuck forever.

Fixes: 06c8b667ff5b ("mmc: sdhci-xenon: Add support to PHYs of Marvell Xenon SDHC")
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Elad Nachman <enachman@marvell.com>
Link: https://lore.kernel.org/r/20240222191714.1216470-3-enachman@marvell.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-xenon-phy.c |   29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

--- a/drivers/mmc/host/sdhci-xenon-phy.c
+++ b/drivers/mmc/host/sdhci-xenon-phy.c
@@ -109,6 +109,8 @@
 #define XENON_EMMC_PHY_LOGIC_TIMING_ADJUST	(XENON_EMMC_PHY_REG_BASE + 0x18)
 #define XENON_LOGIC_TIMING_VALUE		0x00AA8977
 
+#define XENON_MAX_PHY_TIMEOUT_LOOPS		100
+
 /*
  * List offset of PHY registers and some special register values
  * in eMMC PHY 5.0 or eMMC PHY 5.1
@@ -259,18 +261,27 @@ static int xenon_emmc_phy_init(struct sd
 	/* get the wait time */
 	wait /= clock;
 	wait++;
-	/* wait for host eMMC PHY init completes */
-	udelay(wait);
 
-	reg = sdhci_readl(host, phy_regs->timing_adj);
-	reg &= XENON_PHY_INITIALIZAION;
-	if (reg) {
+	/*
+	 * AC5X spec says bit must be polled until zero.
+	 * We see cases in which timeout can take longer
+	 * than the standard calculation on AC5X, which is
+	 * expected following the spec comment above.
+	 * According to the spec, we must wait as long as
+	 * it takes for that bit to toggle on AC5X.
+	 * Cap that with 100 delay loops so we won't get
+	 * stuck here forever:
+	 */
+
+	ret = read_poll_timeout(sdhci_readl, reg,
+				!(reg & XENON_PHY_INITIALIZAION),
+				wait, XENON_MAX_PHY_TIMEOUT_LOOPS * wait,
+				false, host, phy_regs->timing_adj);
+	if (ret)
 		dev_err(mmc_dev(host->mmc), "eMMC PHY init cannot complete after %d us\n",
-			wait);
-		return -ETIMEDOUT;
-	}
+			wait * XENON_MAX_PHY_TIMEOUT_LOOPS);
 
-	return 0;
+	return ret;
 }
 
 #define ARMADA_3700_SOC_PAD_1_8V	0x1


