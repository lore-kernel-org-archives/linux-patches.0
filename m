Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE491C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:26:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69B31C433D7;
	Wed, 23 Nov 2022 09:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669195571;
	bh=soRwJoUSQTL/JWkcmwznr+5z0qWTyhROorY2T+v/c78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wxUK94whyn3PRKnxAEXUTwvg5GYa3hFftYBLXe5Meh6eFt7aL1/Tp0Y3BdPrjvB8f
	 dcs89yYE1kjcaedLax+UayyP7O9ZWfbPS6PH4KiEv+4tVp5+U4kmU1Jry/eGmuyo6A
	 NzvY0kLLpFI3DRqnuHDthgomUs6KfEuPTa613BHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chevron Li <chevron.li@bayhubtech.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 121/149] mmc: sdhci-pci-o2micro: fix card detect fail issue caused by CD# debounce timeout
Date: Wed, 23 Nov 2022 09:51:44 +0100
Message-Id: <20221123084602.294440946@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.945845710@linuxfoundation.org>
References: <20221123084557.945845710@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chevron Li <chevron.li@bayhubtech.com>

commit 096cc0cddf58232bded309336961784f1d1c85f8 upstream.

The SD card is recognized failed sometimes when resume from suspend.
Because CD# debounce time too long then card present report wrong.
Finally, card is recognized failed.

Signed-off-by: Chevron Li <chevron.li@bayhubtech.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20221104095512.4068-1-chevron.li@bayhubtech.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-pci-o2micro.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/mmc/host/sdhci-pci-o2micro.c
+++ b/drivers/mmc/host/sdhci-pci-o2micro.c
@@ -31,6 +31,7 @@
 #define O2_SD_CAPS		0xE0
 #define O2_SD_ADMA1		0xE2
 #define O2_SD_ADMA2		0xE7
+#define O2_SD_MISC_CTRL2	0xF0
 #define O2_SD_INF_MOD		0xF1
 #define O2_SD_MISC_CTRL4	0xFC
 #define O2_SD_MISC_CTRL		0x1C0
@@ -822,6 +823,12 @@ static int sdhci_pci_o2_probe(struct sdh
 		/* Set Tuning Windows to 5 */
 		pci_write_config_byte(chip->pdev,
 				O2_SD_TUNING_CTRL, 0x55);
+		//Adjust 1st and 2nd CD debounce time
+		pci_read_config_dword(chip->pdev, O2_SD_MISC_CTRL2, &scratch_32);
+		scratch_32 &= 0xFFE7FFFF;
+		scratch_32 |= 0x00180000;
+		pci_write_config_dword(chip->pdev, O2_SD_MISC_CTRL2, scratch_32);
+		pci_write_config_dword(chip->pdev, O2_SD_DETECT_SETTING, 1);
 		/* Lock WP */
 		ret = pci_read_config_byte(chip->pdev,
 					   O2_SD_LOCK_WP, &scratch);


