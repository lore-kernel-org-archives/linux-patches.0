Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F6C168C9
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:04:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCD62C433EF;
	Mon,  8 May 2023 11:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543856;
	bh=E/mjO3w316du/4NCN5FEqQc8cNavz00WxbU33FV8TRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EyOUE/sOpNFVzlR8ybbzdxXfIZ/Spk9TkEXyJq7l4UA5FPpNLg6hBT1mzQcSd+nHK
	 cCqlHwqKh/IhcaBVmnRiQyyR1PHj8lTBGcOrco/1U3tc1adjuVhrI+cw0WrBI3o3pI
	 5NiU2vZRHejW98lxZwLow6h1/LlZpxLfAO1jXkpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgii Kruglov <georgy.kruglov@yandex.ru>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 224/694] mmc: sdhci-of-esdhc: fix quirk to ignore command inhibit for data
Date: Mon,  8 May 2023 11:40:59 +0200
Message-Id: <20230508094439.625384939@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Georgii Kruglov <georgy.kruglov@yandex.ru>

[ Upstream commit 0dd8316037a2a6d85b2be208bef9991de7b42170 ]

If spec_reg is equal to 'SDHCI_PRESENT_STATE', esdhc_readl_fixup()
fixes up register value and returns it immediately. As a result, the
further block
(spec_reg == SDHCI_PRESENT_STATE)
    &&(esdhc->quirk_ignore_data_inhibit == true),
is never executed.

The patch merges the second block into the first one.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 1f1929f3f2fa ("mmc: sdhci-of-esdhc: add quirk to ignore command inhibit for data")
Signed-off-by: Georgii Kruglov <georgy.kruglov@yandex.ru>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20230321203715.3975-1-georgy.kruglov@yandex.ru
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-of-esdhc.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/mmc/host/sdhci-of-esdhc.c b/drivers/mmc/host/sdhci-of-esdhc.c
index 4712adac7f7c0..48ca1cf15b199 100644
--- a/drivers/mmc/host/sdhci-of-esdhc.c
+++ b/drivers/mmc/host/sdhci-of-esdhc.c
@@ -133,6 +133,7 @@ static u32 esdhc_readl_fixup(struct sdhci_host *host,
 			return ret;
 		}
 	}
+
 	/*
 	 * The DAT[3:0] line signal levels and the CMD line signal level are
 	 * not compatible with standard SDHC register. The line signal levels
@@ -144,6 +145,16 @@ static u32 esdhc_readl_fixup(struct sdhci_host *host,
 		ret = value & 0x000fffff;
 		ret |= (value >> 4) & SDHCI_DATA_LVL_MASK;
 		ret |= (value << 1) & SDHCI_CMD_LVL;
+
+		/*
+		 * Some controllers have unreliable Data Line Active
+		 * bit for commands with busy signal. This affects
+		 * Command Inhibit (data) bit. Just ignore it since
+		 * MMC core driver has already polled card status
+		 * with CMD13 after any command with busy siganl.
+		 */
+		if (esdhc->quirk_ignore_data_inhibit)
+			ret &= ~SDHCI_DATA_INHIBIT;
 		return ret;
 	}
 
@@ -158,19 +169,6 @@ static u32 esdhc_readl_fixup(struct sdhci_host *host,
 		return ret;
 	}
 
-	/*
-	 * Some controllers have unreliable Data Line Active
-	 * bit for commands with busy signal. This affects
-	 * Command Inhibit (data) bit. Just ignore it since
-	 * MMC core driver has already polled card status
-	 * with CMD13 after any command with busy siganl.
-	 */
-	if ((spec_reg == SDHCI_PRESENT_STATE) &&
-	(esdhc->quirk_ignore_data_inhibit == true)) {
-		ret = value & ~SDHCI_DATA_INHIBIT;
-		return ret;
-	}
-
 	ret = value;
 	return ret;
 }
-- 
2.39.2



