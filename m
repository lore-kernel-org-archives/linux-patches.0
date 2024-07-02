Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D70DC15218A;
	Tue,  2 Jul 2024 17:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940949; cv=none; b=Tn4kPr3tBeNohmcf7sXZdtQv6PW4+cszQ+UKHnRi/x8M3U+yNYDjgqY7S2tH6cA+KhiT4UynlAnqGzI1Hb7y8sqPeHJlJtMRjmIGWCNgPXazrVnayr5SgYZIC7sNjpOWpwjDHE7U521QmRk8ozhL3MnPVRhd7vXPxovLfBkzPMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940949; c=relaxed/simple;
	bh=X0TtqjYsP6wDSK0t8AaKuvC7n3Q4YIk/0Szf0ctni5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cVFQpDQDN2B2hZQz/eG9VbPRdLjekLzRBv7Ye5j5nRnHR01NVtGZ3L6r2kdJ4z1wUf3hoOb4bCVotYZEzhiX+6Eb1Bkx9TpK7jUQDlnwMFDFT8XCOY/94lXXUJ84seqCYhIqbwoXB5u5kxk6gPin6XZBEbVUP6pxEEjT6580qrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CP1Hm54P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CP1Hm54P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 436C2C116B1;
	Tue,  2 Jul 2024 17:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940949;
	bh=X0TtqjYsP6wDSK0t8AaKuvC7n3Q4YIk/0Szf0ctni5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CP1Hm54PCWNVKDCNwTjSE3Pb3mF02S1bO9sA3NTNlL9spwuF01NDAkT+v/F1wze93
	 FP//RqxaRv11vpGvPklYCBD7v9jC4I4h+8slN6mK0wekNh/jYxlJAzDvVlzUXKiZYi
	 lDaRQeUJ/DHUOyCeG6W7odLX49zeZJqpVgpvw6LM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 085/163] mmc: sdhci-pci-o2micro: Convert PCIBIOS_* return codes to errnos
Date: Tue,  2 Jul 2024 19:03:19 +0200
Message-ID: <20240702170236.281917074@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

commit a91bf3b3beadbb4f8b3bbc7969fb2ae1615e25c8 upstream.

sdhci_pci_o2_probe() uses pci_read_config_{byte,dword}() that return
PCIBIOS_* codes. The return code is then returned as is but as
sdhci_pci_o2_probe() is probe function chain, it should return normal
errnos.

Convert PCIBIOS_* returns code using pcibios_err_to_errno() into normal
errno before returning them. Add a label for read failure so that the
conversion can be done in one place rather than on all of the return
statements.

Fixes: 3d757ddbd68c ("mmc: sdhci-pci-o2micro: add Bayhub new chip GG8 support for UHS-I")
Fixes: d599005afde8 ("mmc: sdhci-pci-o2micro: Add missing checks in sdhci_pci_o2_probe")
Fixes: 706adf6bc31c ("mmc: sdhci-pci-o2micro: Add SeaBird SeaEagle SD3 support")
Fixes: 01acf6917aed ("mmc: sdhci-pci: add support of O2Micro/BayHubTech SD hosts")
Fixes: 26daa1ed40c6 ("mmc: sdhci: Disable ADMA on some O2Micro SD/MMC parts.")
Cc: stable@vger.kernel.org
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20240527132443.14038-2-ilpo.jarvinen@linux.intel.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-pci-o2micro.c |   41 ++++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 19 deletions(-)

--- a/drivers/mmc/host/sdhci-pci-o2micro.c
+++ b/drivers/mmc/host/sdhci-pci-o2micro.c
@@ -823,7 +823,7 @@ static int sdhci_pci_o2_probe(struct sdh
 		ret = pci_read_config_byte(chip->pdev,
 				O2_SD_LOCK_WP, &scratch);
 		if (ret)
-			return ret;
+			goto read_fail;
 		scratch &= 0x7f;
 		pci_write_config_byte(chip->pdev, O2_SD_LOCK_WP, scratch);
 
@@ -834,7 +834,7 @@ static int sdhci_pci_o2_probe(struct sdh
 		ret = pci_read_config_byte(chip->pdev,
 				O2_SD_CLKREQ, &scratch);
 		if (ret)
-			return ret;
+			goto read_fail;
 		scratch |= 0x20;
 		pci_write_config_byte(chip->pdev, O2_SD_CLKREQ, scratch);
 
@@ -843,7 +843,7 @@ static int sdhci_pci_o2_probe(struct sdh
 		 */
 		ret = pci_read_config_byte(chip->pdev, O2_SD_CAPS, &scratch);
 		if (ret)
-			return ret;
+			goto read_fail;
 		scratch |= 0x01;
 		pci_write_config_byte(chip->pdev, O2_SD_CAPS, scratch);
 		pci_write_config_byte(chip->pdev, O2_SD_CAPS, 0x73);
@@ -856,7 +856,7 @@ static int sdhci_pci_o2_probe(struct sdh
 		ret = pci_read_config_byte(chip->pdev,
 				O2_SD_INF_MOD, &scratch);
 		if (ret)
-			return ret;
+			goto read_fail;
 		scratch |= 0x08;
 		pci_write_config_byte(chip->pdev, O2_SD_INF_MOD, scratch);
 
@@ -864,7 +864,7 @@ static int sdhci_pci_o2_probe(struct sdh
 		ret = pci_read_config_byte(chip->pdev,
 				O2_SD_LOCK_WP, &scratch);
 		if (ret)
-			return ret;
+			goto read_fail;
 		scratch |= 0x80;
 		pci_write_config_byte(chip->pdev, O2_SD_LOCK_WP, scratch);
 		break;
@@ -875,7 +875,7 @@ static int sdhci_pci_o2_probe(struct sdh
 		ret = pci_read_config_byte(chip->pdev,
 				O2_SD_LOCK_WP, &scratch);
 		if (ret)
-			return ret;
+			goto read_fail;
 
 		scratch &= 0x7f;
 		pci_write_config_byte(chip->pdev, O2_SD_LOCK_WP, scratch);
@@ -886,7 +886,7 @@ static int sdhci_pci_o2_probe(struct sdh
 						    O2_SD_FUNC_REG0,
 						    &scratch_32);
 			if (ret)
-				return ret;
+				goto read_fail;
 			scratch_32 = ((scratch_32 & 0xFF000000) >> 24);
 
 			/* Check Whether subId is 0x11 or 0x12 */
@@ -898,7 +898,7 @@ static int sdhci_pci_o2_probe(struct sdh
 							    O2_SD_FUNC_REG4,
 							    &scratch_32);
 				if (ret)
-					return ret;
+					goto read_fail;
 
 				/* Enable Base Clk setting change */
 				scratch_32 |= O2_SD_FREG4_ENABLE_CLK_SET;
@@ -921,7 +921,7 @@ static int sdhci_pci_o2_probe(struct sdh
 		ret = pci_read_config_dword(chip->pdev,
 					    O2_SD_CLK_SETTING, &scratch_32);
 		if (ret)
-			return ret;
+			goto read_fail;
 
 		scratch_32 &= ~(0xFF00);
 		scratch_32 |= 0x07E0C800;
@@ -931,14 +931,14 @@ static int sdhci_pci_o2_probe(struct sdh
 		ret = pci_read_config_dword(chip->pdev,
 					    O2_SD_CLKREQ, &scratch_32);
 		if (ret)
-			return ret;
+			goto read_fail;
 		scratch_32 |= 0x3;
 		pci_write_config_dword(chip->pdev, O2_SD_CLKREQ, scratch_32);
 
 		ret = pci_read_config_dword(chip->pdev,
 					    O2_SD_PLL_SETTING, &scratch_32);
 		if (ret)
-			return ret;
+			goto read_fail;
 
 		scratch_32 &= ~(0x1F3F070E);
 		scratch_32 |= 0x18270106;
@@ -949,7 +949,7 @@ static int sdhci_pci_o2_probe(struct sdh
 		ret = pci_read_config_dword(chip->pdev,
 					    O2_SD_CAP_REG2, &scratch_32);
 		if (ret)
-			return ret;
+			goto read_fail;
 		scratch_32 &= ~(0xE0);
 		pci_write_config_dword(chip->pdev,
 				       O2_SD_CAP_REG2, scratch_32);
@@ -961,7 +961,7 @@ static int sdhci_pci_o2_probe(struct sdh
 		ret = pci_read_config_byte(chip->pdev,
 					   O2_SD_LOCK_WP, &scratch);
 		if (ret)
-			return ret;
+			goto read_fail;
 		scratch |= 0x80;
 		pci_write_config_byte(chip->pdev, O2_SD_LOCK_WP, scratch);
 		break;
@@ -971,7 +971,7 @@ static int sdhci_pci_o2_probe(struct sdh
 		ret = pci_read_config_byte(chip->pdev,
 				O2_SD_LOCK_WP, &scratch);
 		if (ret)
-			return ret;
+			goto read_fail;
 
 		scratch &= 0x7f;
 		pci_write_config_byte(chip->pdev, O2_SD_LOCK_WP, scratch);
@@ -979,7 +979,7 @@ static int sdhci_pci_o2_probe(struct sdh
 		ret = pci_read_config_dword(chip->pdev,
 					    O2_SD_PLL_SETTING, &scratch_32);
 		if (ret)
-			return ret;
+			goto read_fail;
 
 		if ((scratch_32 & 0xff000000) == 0x01000000) {
 			scratch_32 &= 0x0000FFFF;
@@ -998,7 +998,7 @@ static int sdhci_pci_o2_probe(struct sdh
 						    O2_SD_FUNC_REG4,
 						    &scratch_32);
 			if (ret)
-				return ret;
+				goto read_fail;
 			scratch_32 |= (1 << 22);
 			pci_write_config_dword(chip->pdev,
 					       O2_SD_FUNC_REG4, scratch_32);
@@ -1017,7 +1017,7 @@ static int sdhci_pci_o2_probe(struct sdh
 		ret = pci_read_config_byte(chip->pdev,
 					   O2_SD_LOCK_WP, &scratch);
 		if (ret)
-			return ret;
+			goto read_fail;
 		scratch |= 0x80;
 		pci_write_config_byte(chip->pdev, O2_SD_LOCK_WP, scratch);
 		break;
@@ -1028,7 +1028,7 @@ static int sdhci_pci_o2_probe(struct sdh
 		/* UnLock WP */
 		ret = pci_read_config_byte(chip->pdev, O2_SD_LOCK_WP, &scratch);
 		if (ret)
-			return ret;
+			goto read_fail;
 		scratch &= 0x7f;
 		pci_write_config_byte(chip->pdev, O2_SD_LOCK_WP, scratch);
 
@@ -1057,13 +1057,16 @@ static int sdhci_pci_o2_probe(struct sdh
 		/* Lock WP */
 		ret = pci_read_config_byte(chip->pdev, O2_SD_LOCK_WP, &scratch);
 		if (ret)
-			return ret;
+			goto read_fail;
 		scratch |= 0x80;
 		pci_write_config_byte(chip->pdev, O2_SD_LOCK_WP, scratch);
 		break;
 	}
 
 	return 0;
+
+read_fail:
+	return pcibios_err_to_errno(ret);
 }
 
 #ifdef CONFIG_PM_SLEEP


