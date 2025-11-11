Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C05346E60;
	Tue, 11 Nov 2025 01:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824238; cv=none; b=lYAfoKfl9sR2ZxoB1yYC1iavpOeTC9sVXOofMv9CXEIvnVdPJPKDPghEsHmYFCWinSZ+QpdcMHtfGUG7HIWhdcN8BWg51GMhj56H/4e6LrZnFEJP+0DEjC9LnmKCg/2xtpisRf610xptFFEhmLOH/qToJH1lPyWt5TnPb/ncXaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824238; c=relaxed/simple;
	bh=O86u+7M1UbXPnKbiAmACFonFxng1DjsFbnmIQewolYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BAJuzpLdW+34XQ412pt19x9D4mHtCsFDjiwm6ueKL6ooNkOBbgrHV4bBGwfnmh3odrl3gOchzV2sIwu8ehVanbs++T5a5r7QHI12aJGfUu1hcb5Lqnsb7SftNVO/2uE1tf7gR04UThC2OytNcrhMutPpgfUehe5Qv4I8rVeVpRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dzk4GT+I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dzk4GT+I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4654C4CEF5;
	Tue, 11 Nov 2025 01:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824238;
	bh=O86u+7M1UbXPnKbiAmACFonFxng1DjsFbnmIQewolYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dzk4GT+INHdPzLIyS0Pv3V5PbBAxAr+1N7SjoVTKtzpugdVEHmayFgDUy91Wwvv3v
	 3RzESOhhezy5rC34AGrOhPcAN0G7RW7OwOlWH///ucjLVEGy8lZrV1oXn0EbkHu0Uf
	 P1CAFg6UbKTify2+OcMu2hvdX3zLuuYiGfoWTR+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Heidelberg <m.heidelberg@cab.de>,
	Alexander Sverdlin <alexander.sverdlin@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 468/849] eeprom: at25: support Cypress FRAMs without device ID
Date: Tue, 11 Nov 2025 09:40:38 +0900
Message-ID: <20251111004547.745840653@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Heidelberg <m.heidelberg@cab.de>

[ Upstream commit 1b434ed000cd474f074e62e8ab876f87449bb4ac ]

Not all FRAM chips have a device ID and implement the corresponding read
command. For such chips this led to the following error on module
loading:

    at25 spi2.0: Error: no Cypress FRAM (id 00)

The device ID contains the memory size, so devices without this ID are
supported now by setting the size manually in Devicetree using the
"size" property.

Tested with FM25L16B and "size = <2048>;":

    at25 spi2.0: 2 KByte fm25 fram, pagesize 4096

According to Infineon/Cypress datasheets, these FRAMs have a device ID:

    FM25V01A
    FM25V02A
    FM25V05
    FM25V10
    FM25V20A
    FM25VN10

but these do not:

    FM25040B
    FM25640B
    FM25C160B
    FM25CL64B
    FM25L04B
    FM25L16B
    FM25W256

So all "FM25V*" FRAMs and only these have a device ID. The letter after
"FM25" (V/C/L/W) only describes the voltage range, though.

Link: https://lore.kernel.org/all/20250401133148.38330-1-m.heidelberg@cab.de/
Signed-off-by: Markus Heidelberg <m.heidelberg@cab.de>
Reviewed-by: Alexander Sverdlin <alexander.sverdlin@gmail.com>
Link: https://lore.kernel.org/r/20250815095839.4219-3-m.heidelberg@cab.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/eeprom/at25.c | 67 ++++++++++++++++++++------------------
 1 file changed, 36 insertions(+), 31 deletions(-)

diff --git a/drivers/misc/eeprom/at25.c b/drivers/misc/eeprom/at25.c
index 2d0492867054f..c90150f728369 100644
--- a/drivers/misc/eeprom/at25.c
+++ b/drivers/misc/eeprom/at25.c
@@ -379,37 +379,49 @@ static int at25_fram_to_chip(struct device *dev, struct spi_eeprom *chip)
 	struct at25_data *at25 = container_of(chip, struct at25_data, chip);
 	u8 sernum[FM25_SN_LEN];
 	u8 id[FM25_ID_LEN];
+	u32 val;
 	int i;
 
 	strscpy(chip->name, "fm25", sizeof(chip->name));
 
-	/* Get ID of chip */
-	fm25_aux_read(at25, id, FM25_RDID, FM25_ID_LEN);
-	/* There are inside-out FRAM variations, detect them and reverse the ID bytes */
-	if (id[6] == 0x7f && id[2] == 0xc2)
-		for (i = 0; i < ARRAY_SIZE(id) / 2; i++) {
-			u8 tmp = id[i];
-			int j = ARRAY_SIZE(id) - i - 1;
+	if (!device_property_read_u32(dev, "size", &val)) {
+		chip->byte_len = val;
+	} else {
+		/* Get ID of chip */
+		fm25_aux_read(at25, id, FM25_RDID, FM25_ID_LEN);
+		/* There are inside-out FRAM variations, detect them and reverse the ID bytes */
+		if (id[6] == 0x7f && id[2] == 0xc2)
+			for (i = 0; i < ARRAY_SIZE(id) / 2; i++) {
+				u8 tmp = id[i];
+				int j = ARRAY_SIZE(id) - i - 1;
+
+				id[i] = id[j];
+				id[j] = tmp;
+			}
+		if (id[6] != 0xc2) {
+			dev_err(dev, "Error: no Cypress FRAM (id %02x)\n", id[6]);
+			return -ENODEV;
+		}
 
-			id[i] = id[j];
-			id[j] = tmp;
+		switch (id[7]) {
+		case 0x21 ... 0x26:
+			chip->byte_len = BIT(id[7] - 0x21 + 4) * 1024;
+			break;
+		case 0x2a ... 0x30:
+			/* CY15B116QN ... CY15B116QN */
+			chip->byte_len = BIT(((id[7] >> 1) & 0xf) + 13);
+			break;
+		default:
+			dev_err(dev, "Error: unsupported size (id %02x)\n", id[7]);
+			return -ENODEV;
 		}
-	if (id[6] != 0xc2) {
-		dev_err(dev, "Error: no Cypress FRAM (id %02x)\n", id[6]);
-		return -ENODEV;
-	}
 
-	switch (id[7]) {
-	case 0x21 ... 0x26:
-		chip->byte_len = BIT(id[7] - 0x21 + 4) * 1024;
-		break;
-	case 0x2a ... 0x30:
-		/* CY15B116QN ... CY15B116QN */
-		chip->byte_len = BIT(((id[7] >> 1) & 0xf) + 13);
-		break;
-	default:
-		dev_err(dev, "Error: unsupported size (id %02x)\n", id[7]);
-		return -ENODEV;
+		if (id[8]) {
+			fm25_aux_read(at25, sernum, FM25_RDSN, FM25_SN_LEN);
+			/* Swap byte order */
+			for (i = 0; i < FM25_SN_LEN; i++)
+				at25->sernum[i] = sernum[FM25_SN_LEN - 1 - i];
+		}
 	}
 
 	if (chip->byte_len > 64 * 1024)
@@ -417,13 +429,6 @@ static int at25_fram_to_chip(struct device *dev, struct spi_eeprom *chip)
 	else
 		chip->flags |= EE_ADDR2;
 
-	if (id[8]) {
-		fm25_aux_read(at25, sernum, FM25_RDSN, FM25_SN_LEN);
-		/* Swap byte order */
-		for (i = 0; i < FM25_SN_LEN; i++)
-			at25->sernum[i] = sernum[FM25_SN_LEN - 1 - i];
-	}
-
 	chip->page_size = PAGE_SIZE;
 	return 0;
 }
-- 
2.51.0



