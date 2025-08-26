Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1442218F2FC;
	Tue, 26 Aug 2025 13:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213904; cv=none; b=C+Jtc8c18WxIk1i/zDZXun46ER3qiyqIMgpGmZZwEcqhvLuEiJznJfnfbpiWcmgnFm+REuexfvQptqJ/kR2vMTOTz0IpGkgHglUqntuJizHx943qEROoNgg8GiG0jtIXWjqSapF007FioRP/M7X5rDIliDJO0mRlWO/MHjTg6No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213904; c=relaxed/simple;
	bh=5NQourxqfRnFBuuQLZF7yvFt5OEuOYgYz2gKRfDzPzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rQiEwKHO120e/tHotHo4RXYBCOeX3HRhuwyJd/ZJEcj878qMNQ1cJvd/5DTWmMx0yP+suuLaiM4FVThF8NIeLqJ8aVIRYt61vzeTGY3FEo+1d+5SWx2JrssSQjkWrES2KP1kxmAbzFV6+8PGWkP/O+8dgkK98fyh41zZCeJ293Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wxONGDkg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wxONGDkg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C99EC4CEF1;
	Tue, 26 Aug 2025 13:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213903;
	bh=5NQourxqfRnFBuuQLZF7yvFt5OEuOYgYz2gKRfDzPzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wxONGDkgWt+GLmZt0RRDJkDamsJTwgSPDn1P3BEm+T/Kd6d1S7PP4P4AY3NNIHxso
	 EzIu4x+X1WyFn9/o34XZoviw4p3F/na5xZLN7I1a5s2myl8hIS6oOwX+bcGm6dh7E6
	 JgtsXDIvgVFlMZJREeT9KHG8wCFDYvP7HFLzT9X8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Marek Vasut <marek.vasut+renesas@mailbox.org>
Subject: [PATCH 6.6 524/587] usb: renesas-xhci: Fix External ROM access timeouts
Date: Tue, 26 Aug 2025 13:11:13 +0200
Message-ID: <20250826111006.328526578@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Marek Vasut <marek.vasut+renesas@mailbox.org>

commit f9420f4757752f056144896024d5ea89e5a611f1 upstream.

Increase the External ROM access timeouts to prevent failures during
programming of External SPI EEPROM chips. The current timeouts are
too short for some SPI EEPROMs used with uPD720201 controllers.

The current timeout for Chip Erase in renesas_rom_erase() is 100 ms ,
the current timeout for Sector Erase issued by the controller before
Page Program in renesas_fw_download_image() is also 100 ms. Neither
timeout is sufficient for e.g. the Macronix MX25L5121E or MX25V5126F.

MX25L5121E reference manual [1] page 35 section "ERASE AND PROGRAMMING
PERFORMANCE" and page 23 section "Table 8. AC CHARACTERISTICS (Temperature
= 0°C to 70°C for Commercial grade, VCC = 2.7V ~ 3.6V)" row "tCE" indicate
that the maximum time required for Chip Erase opcode to complete is 2 s,
and for Sector Erase it is 300 ms .

MX25V5126F reference manual [2] page 47 section "13. ERASE AND PROGRAMMING
PERFORMANCE (2.3V - 3.6V)" and page 42 section "Table 8. AC CHARACTERISTICS
(Temperature = -40°C to 85°C for Industrial grade, VCC = 2.3V - 3.6V)" row
"tCE" indicate that the maximum time required for Chip Erase opcode to
complete is 3.2 s, and for Sector Erase it is 400 ms .

Update the timeouts such, that Chip Erase timeout is set to 5 seconds,
and Sector Erase timeout is set to 500 ms. Such lengthy timeouts ought
to be sufficient for majority of SPI EEPROM chips.

[1] https://www.macronix.com/Lists/Datasheet/Attachments/8634/MX25L5121E,%203V,%20512Kb,%20v1.3.pdf
[2] https://www.macronix.com/Lists/Datasheet/Attachments/8750/MX25V5126F,%202.5V,%20512Kb,%20v1.1.pdf

Fixes: 2478be82de44 ("usb: renesas-xhci: Add ROM loader for uPD720201")
Cc: stable <stable@kernel.org>
Signed-off-by: Marek Vasut <marek.vasut+renesas@mailbox.org>
Link: https://lore.kernel.org/r/20250802225526.25431-1-marek.vasut+renesas@mailbox.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci-renesas.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/usb/host/xhci-pci-renesas.c
+++ b/drivers/usb/host/xhci-pci-renesas.c
@@ -47,8 +47,9 @@
 #define RENESAS_ROM_ERASE_MAGIC				0x5A65726F
 #define RENESAS_ROM_WRITE_MAGIC				0x53524F4D
 
-#define RENESAS_RETRY	10000
-#define RENESAS_DELAY	10
+#define RENESAS_RETRY			50000	/* 50000 * RENESAS_DELAY ~= 500ms */
+#define RENESAS_CHIP_ERASE_RETRY	500000	/* 500000 * RENESAS_DELAY ~= 5s */
+#define RENESAS_DELAY			10
 
 static int renesas_fw_download_image(struct pci_dev *dev,
 				     const u32 *fw, size_t step, bool rom)
@@ -405,7 +406,7 @@ static void renesas_rom_erase(struct pci
 	/* sleep a bit while ROM is erased */
 	msleep(20);
 
-	for (i = 0; i < RENESAS_RETRY; i++) {
+	for (i = 0; i < RENESAS_CHIP_ERASE_RETRY; i++) {
 		retval = pci_read_config_byte(pdev, RENESAS_ROM_STATUS,
 					      &status);
 		status &= RENESAS_ROM_STATUS_ERASE;


