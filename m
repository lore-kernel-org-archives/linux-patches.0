Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C431C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:19:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94702C433B5;
	Wed, 23 Nov 2022 09:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669195162;
	bh=lF99DBn/bAt0yX+MWp29CCZr2RBmkxt0E00loTnWUi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fwDCg+NTFrrI8KqVQGFotOw3f6zJs2D5QKFfqE47JpBzkyxpEiuXnx/5Tb7CaH+J+
	 ZDSsvqQiXKUBx6k/X1J1biP3J7eMrNSQ5ly85e4dBYbQJtVMKFh3UgKihlK6NrCKCc
	 q5TZ7sTTRvwPAFjKJBZ3SkNc3V9RKquTPraaZbxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chevron Li <chevron.li@bayhubtech.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 135/156] mmc: sdhci-pci-o2micro: fix card detect fail issue caused by CD# debounce timeout
Date: Wed, 23 Nov 2022 09:51:32 +0100
Message-Id: <20221123084602.796755059@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
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
 #define O2_SD_TUNING_CTRL	0x300
@@ -777,6 +778,12 @@ int sdhci_pci_o2_probe(struct sdhci_pci_
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


