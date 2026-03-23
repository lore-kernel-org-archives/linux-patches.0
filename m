Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A343803EF;
	Mon, 23 Mar 2026 14:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274938; cv=none; b=j8PcBvC+1UHsePsdcPPiraulxCWLDvO8bYNg/EmTG6eg6FZ+mHzpA2vcFwVhlC9wmNEeArmnwO90TY0pZo0rcylDqdmEFJpU2tm1Uozk23Nchqzihd2qOBRcXTYPIhKMADgVzX+whxM/r8aYFT9AoF7LdqtnhgRZo79QhMYugRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274938; c=relaxed/simple;
	bh=rveli3ebJ5wac5cRqhEZVp/j2aqEVFHcSHIWGvrH3Sk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PJ5IP4sk+tmqlRd55kGTj/zstEEhdO8IwIQuD2KOdJwgdG8qK67StKdcyv/NZY/Loglby176gthwWs9Wk/PQaEL/ROwSiG1X0fGCL7n3W78zWBWNXSlm4vjVnj0vGE5pSDfiigVzi1lPhxLgW0D0XRRFu0fuBTxDM8MavQEKuI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GZgwYZA5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GZgwYZA5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9390FC2BCB1;
	Mon, 23 Mar 2026 14:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274937;
	bh=rveli3ebJ5wac5cRqhEZVp/j2aqEVFHcSHIWGvrH3Sk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GZgwYZA53e/utFlvXnwjawjpso31rndKzpVOup90bStk/T/2vVGO1bkqkbNxBnFs4
	 G0rELzF9rSHz6VjzTsE53cW+QRxgct0lZ+l46wEV0YyORVRc+NEZaecf7U6hZUydFJ
	 bmkLSlrapT1/f/dMmjXjzMb8zlAfjE6IyjiXvJLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 163/212] ACPI: processor: Fix previous acpi_processor_errata_piix4() fix
Date: Mon, 23 Mar 2026 14:46:24 +0100
Message-ID: <20260323134508.888992810@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit bf504b229cb8d534eccbaeaa23eba34c05131e25 ]

After commi f132e089fe89 ("ACPI: processor: Fix NULL-pointer dereference
in acpi_processor_errata_piix4()"), device pointers may be dereferenced
after dropping references to the device objects pointed to by them,
which may cause a use-after-free to occur.

Moreover, debug messages about enabling the errata may be printed
if the errata flags corresponding to them are unset.

Address all of these issues by moving message printing to the points
in the code where the errata flags are set.

Fixes: f132e089fe89 ("ACPI: processor: Fix NULL-pointer dereference in acpi_processor_errata_piix4()")
Reported-by: Guenter Roeck <linux@roeck-us.net>
Closes: https://lore.kernel.org/linux-acpi/938e2206-def5-4b7a-9b2c-d1fd37681d8a@roeck-us.net/
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/5975693.DvuYhMxLoT@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_processor.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processor.c
index 85096ce7b658b..5a562e27d3a80 100644
--- a/drivers/acpi/acpi_processor.c
+++ b/drivers/acpi/acpi_processor.c
@@ -113,6 +113,10 @@ static int acpi_processor_errata_piix4(struct pci_dev *dev)
 				     PCI_ANY_ID, PCI_ANY_ID, NULL);
 		if (ide_dev) {
 			errata.piix4.bmisx = pci_resource_start(ide_dev, 4);
+			if (errata.piix4.bmisx)
+				dev_dbg(&ide_dev->dev,
+					"Bus master activity detection (BM-IDE) erratum enabled\n");
+
 			pci_dev_put(ide_dev);
 		}
 
@@ -131,20 +135,17 @@ static int acpi_processor_errata_piix4(struct pci_dev *dev)
 		if (isa_dev) {
 			pci_read_config_byte(isa_dev, 0x76, &value1);
 			pci_read_config_byte(isa_dev, 0x77, &value2);
-			if ((value1 & 0x80) || (value2 & 0x80))
+			if ((value1 & 0x80) || (value2 & 0x80)) {
 				errata.piix4.fdma = 1;
+				dev_dbg(&isa_dev->dev,
+					"Type-F DMA livelock erratum (C3 disabled)\n");
+			}
 			pci_dev_put(isa_dev);
 		}
 
 		break;
 	}
 
-	if (ide_dev)
-		dev_dbg(&ide_dev->dev, "Bus master activity detection (BM-IDE) erratum enabled\n");
-
-	if (isa_dev)
-		dev_dbg(&isa_dev->dev, "Type-F DMA livelock erratum (C3 disabled)\n");
-
 	return 0;
 }
 
-- 
2.51.0



