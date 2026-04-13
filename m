Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC9830BBAE;
	Mon, 13 Apr 2026 16:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097792; cv=none; b=YRyy9mcGSIVR4WuLFYTtumwEKV5/lEoG3dA4kt46MloWSLs1DbK6An3fXeUJJDIglXXzMxIgd0V9gtWyPXNFVdT0celK2okrRKP8nC94AzTBYXJwCM58iaEP3XrBs8aqVqYFqTHXRWUnE6KgH2LQPHETwGwykW0hOiECOgPQ7T0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097792; c=relaxed/simple;
	bh=2BgpkBnULRjosV4jFKWyW2AOP9OSe4yqxfMfGumZhe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qqMW7irlbjvZEE/TB3cFI4D7FnfDVJ1OAEgrERQTZ3b9C3FOsEDYg5J6Kvi1Q27UTa8I9w4PE1LsuTJrZCgnNUD2g/tfi4P8nrnbjU0LLhiG7T0HOiP8MpdB4r9YbQKokC+eWkRK0BK/Do4vIJaN44JUpOAxlJVMMiM0iHJLLN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vpl6jKCU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vpl6jKCU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5690CC2BCAF;
	Mon, 13 Apr 2026 16:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097792;
	bh=2BgpkBnULRjosV4jFKWyW2AOP9OSe4yqxfMfGumZhe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vpl6jKCUxcMVt93KfggelKtm9IfzbtQhB5aXxR/bj4/LUEw/r0RB/v6UYaZCxNMaa
	 g4iI3CxqCRSxaUTQsSzq50rv2WGgQcRd78HgmWMiPgaKxdEgSHbHs7G0H86acvW7jT
	 mzIWF5NkDmJCx+tfamYYUOmON0U7Uufr9gyo33zY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 275/570] ACPI: processor: Fix previous acpi_processor_errata_piix4() fix
Date: Mon, 13 Apr 2026 17:56:46 +0200
Message-ID: <20260413155840.784801418@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 669398045c0fd..07acdaee6ce5c 100644
--- a/drivers/acpi/acpi_processor.c
+++ b/drivers/acpi/acpi_processor.c
@@ -96,6 +96,10 @@ static int acpi_processor_errata_piix4(struct pci_dev *dev)
 				     PCI_ANY_ID, PCI_ANY_ID, NULL);
 		if (ide_dev) {
 			errata.piix4.bmisx = pci_resource_start(ide_dev, 4);
+			if (errata.piix4.bmisx)
+				dev_dbg(&ide_dev->dev,
+					"Bus master activity detection (BM-IDE) erratum enabled\n");
+
 			pci_dev_put(ide_dev);
 		}
 
@@ -114,20 +118,17 @@ static int acpi_processor_errata_piix4(struct pci_dev *dev)
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



