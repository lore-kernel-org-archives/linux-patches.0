Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D424810A35;
	Mon,  4 Mar 2024 21:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588771; cv=none; b=KvprtrqQD3I2UN9BImf1dRddATGQ/KoLg4z/prklvIbvmyLuZpNCnPHz81DohRKChDTnXTAgFZTGds+NUvqntDCKLTG1cjw4XVMUVLVh6e9LIlg4O8alvxluHkwLwP6r3fw1c4fL5TPhqUiS3VfNNQ8I/eSGRM9vnPTjpboQYnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588771; c=relaxed/simple;
	bh=6KgzlPWF9J/tmEZPQ0lQaZue3yk6EHl26Ff8yq4Suz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hB+q+UKQFOGJ7qPB8BjniJLMpxu5Cpv65ovHz+8NBAPLs1/l8s7iRAbGEOXMHZfc8NOEuuEEKjRtBWmYbA4yVAaoaPOHgIpqsGDFBx4r5a30smpYlyAavv5jF+jV4zITlRohPzGTfd26qUsWQ+ppJFll++m4bA050rMnxfuHoro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BE1dJz1F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BE1dJz1F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65896C433C7;
	Mon,  4 Mar 2024 21:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588771;
	bh=6KgzlPWF9J/tmEZPQ0lQaZue3yk6EHl26Ff8yq4Suz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BE1dJz1FtIPPdz3kIs391XsnPfUpsmSGCsXDa1T/GrWpJudGCJnIS4dzqzuoP/Pck
	 7sDcb6NuZnPUXt0uWciSP21Igcb5WxjnoLLIAqAmajs9QQqoDIkEK4q26I4VeR3Vkx
	 /znL1UZ3REAEAQZ2cCRQtTR8yJabsUdNB2zKevLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Elad Nachman <enachman@marvell.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.1 090/215] mmc: sdhci-xenon: add timeout for PHY init complete
Date: Mon,  4 Mar 2024 21:22:33 +0000
Message-ID: <20240304211559.859407190@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


