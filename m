Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 646093128D5;
	Sat, 25 Oct 2025 16:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409760; cv=none; b=P5n/RROUEyEZYwMcS6PSRtP9BPdEuYuepNHB7xIuSi58J84xZmc00LosKsoGRpfoglWxVkXZ4Jm7fse23RMnFiLyGlU/S+b22w6OWWzdv6aEQMia+XjwAsSyGCRI8mhNlWzwSV+bSIvYHE0TEDAB65q3ANWW0kH81wyaaQqvmVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409760; c=relaxed/simple;
	bh=DLsgk+G2fdsy+V/2r6O+KhyI1bbKSHSfhMliRgDoufQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VzjkPwMckMKK8FzT52ey/R1xwIGmbP85rkhwuAyBCx/SGKh4F3NP3Zm/sSsddbp63BhPJZ5hlopRO798CcZCrYwqz2UMQ5AJJBPrUmwjCRgvQwVuitMpx/MYqwn74wSwDQcwuVjgR/p+WfCbmKgyeuEmncfioRntviJCymzxAoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gVQU/GD9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gVQU/GD9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B3E5C4CEFB;
	Sat, 25 Oct 2025 16:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409760;
	bh=DLsgk+G2fdsy+V/2r6O+KhyI1bbKSHSfhMliRgDoufQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gVQU/GD9oiv32uwXAVYr/BEGPY6LyDLS2Xe9xTJSwvpiK/4nSBmg2fVk+yVzsdJAy
	 9rS/GYRYq2yKRQspL6/cCZ+F+cqqyapBLI1fl8MFQMBZDiL1Iu92hm9pcpM/3EZ7P5
	 yg+8azV+Y+iEW2Hsve5BIalx/WJyZDxQFtFP5+xKeSyZ2Hkl/v8OTbM22EhADKMrMn
	 BbfKFWvvZEl1Z7u0UFIpuHngYyR150oX9U4Pm9XIaKdVHV44v+McWzEAfiEwpITDHy
	 wlylnfPxD8TWYe0VH3ejEupaw3fOziKFhGiWHFS7pbJe2G/vlHV7aiAfPXAeSjrmD1
	 ETD1LRwbt3KQg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Markus Heidelberg <m.heidelberg@cab.de>,
	Alexander Sverdlin <alexander.sverdlin@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	alexander.deucher@amd.com,
	alexandre.f.demers@gmail.com
Subject: [PATCH AUTOSEL 6.17] eeprom: at25: support Cypress FRAMs without device ID
Date: Sat, 25 Oct 2025 12:01:23 -0400
Message-ID: <20251025160905.3857885-452-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

YES

- Fixes real user-visible failure: FRAMs without RDID (e.g., FM25L16B)
  fail probe with “Error: no Cypress FRAM (id 00)”. The change allows
  specifying capacity via Devicetree, unblocking these devices.
- Minimal, targeted change: Adds an early DT override for size and falls
  back to existing ID-based detection otherwise.
  - New path: reads `size` DT property and sets capacity when present
    (drivers/misc/eeprom/at25.c:387–389).
  - Fallback path: unchanged logic to read RDID, vendor check, and size
    decode (drivers/misc/eeprom/at25.c:391,
    drivers/misc/eeprom/at25.c:401, drivers/misc/eeprom/at25.c:406–417).
  - Serial number read only when RDID is used, avoiding uninitialized
    access when `size` is provided (drivers/misc/eeprom/at25.c:419–424).
  - Address width flags remain derived from total size as before
    (drivers/misc/eeprom/at25.c:427–430). Page size unchanged for FRAMs
    (drivers/misc/eeprom/at25.c:432).
- Aligns with existing bindings: The binding already documents `size`
  and explicitly says it’s also used for FRAMs without device ID;
  example shows a FRAM node with only `size`
  (Documentation/devicetree/bindings/eeprom/at25.yaml:55,
  Documentation/devicetree/bindings/eeprom/at25.yaml:59,
  Documentation/devicetree/bindings/eeprom/at25.yaml:151,
  Documentation/devicetree/bindings/eeprom/at25.yaml:155).
- No architectural changes: Only affects FRAM identification in a leaf
  driver; broader SPI/nvmem flows unchanged.
- Low regression risk:
  - If `size` is absent, behavior is unchanged (still uses RDID).
  - If `size` is present for FRAMs with RDID, driver skips ID read and
    the device still works (potentially loses serial-number exposure,
    but that’s a benign tradeoff vs previous hard failure on no-RDID
    devices).
  - Uses established property-reading pathway already used for non-FRAM
    EEPROMs (drivers/misc/eeprom/at25.c:325–333), so code pattern is
    consistent.
- Scope and stability: Single file touch in `drivers/misc/eeprom`, self-
  contained, no API/ABI changes, no cross-subsystem implications.

Conclusion: This is a clear bugfix enabling supported hardware that
previously failed to probe, with a small and contained change that
follows the binding and carries low risk. Suitable for stable backport.

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

