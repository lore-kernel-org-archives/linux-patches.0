Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DACDC13A265;
	Mon, 23 Jun 2025 13:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684547; cv=none; b=cJpT00APoiry/S3JFJPT+8ypTu/FLCOPVrAHD0VdggPMHDCb4tDqyHH/sUmeXbKEUlhNeHLvpJ0Osr7TtYb66PDdAS3MRXWoe+87gYALImY4X7F63q1/7OxESUAO/AFeUM+Sy8nyELetKutl6a3H8GZyBlHB+2GYVvyUpxBO734=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684547; c=relaxed/simple;
	bh=LQpcAt4YvVLtc8/un4eZGqTdQZajWy0T3Z+KfTifEyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XKl5lCYXmI24eXonUY6HwdFoZZudgbacAF4lK8ZSAeojeE2C0lJm1seRvZkYgPZnJ5PjF7rHo3/LN6XsJoYn1vZBADNTtliYNnPbaNW6sJyk85gE199aSHpscvDm620NzkGLeLmO089ee/Qi3mxBqlPAzV69bKwWufLWZeGcPXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QyP5q4g6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QyP5q4g6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EB18C4CEEA;
	Mon, 23 Jun 2025 13:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684547;
	bh=LQpcAt4YvVLtc8/un4eZGqTdQZajWy0T3Z+KfTifEyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QyP5q4g6kZ4CxkDOARIrjtISr2A08dPVWyGzKoskOFw3lkfhTaQgZj9p/RmrrBydH
	 r6a3951nk3Un1n5MkWUJ15u1oKEHDNm2tl6i/C+8yzSsote88JDplPTkI/z574tKqV
	 D38kg9B8KoQZJtBC2/3Twbom5MS+MJHCQxHk2SnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Yang <andyybtc79@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hans de Goede <hansg@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.15 108/592] ata: ahci: Disallow LPM for ASUSPRO-D840SA motherboard
Date: Mon, 23 Jun 2025 15:01:06 +0200
Message-ID: <20250623130702.847471069@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

commit b5acc3628898baa63658bc4125f9525f9b3dd4f3 upstream.

A user has bisected a regression which causes graphical corruptions on his
screen to commit 7627a0edef54 ("ata: ahci: Drop low power policy board
type").

Simply reverting commit 7627a0edef54 ("ata: ahci: Drop low power policy
board type") makes the graphical corruptions on his screen to go away.
(Note: there are no visible messages in dmesg that indicates a problem
with AHCI.)

The user also reports that the problem occurs regardless if there is an
HDD or an SSD connected via AHCI, so the problem is not device related.

The devices also work fine on other motherboards, so it seems specific to
the ASUSPRO-D840SA motherboard.

While enabling low power modes for AHCI is not supposed to affect
completely unrelated hardware, like a graphics card, it does however
allow the system to enter deeper PC-states, which could expose ACPI issues
that were previously not visible (because the system never entered these
lower power states before).

There are previous examples where enabling LPM exposed serious BIOS/ACPI
bugs, see e.g. commit 240630e61870 ("ahci: Disable LPM on Lenovo 50 series
laptops with a too old BIOS").

Since there hasn't been any BIOS update in years for the ASUSPRO-D840SA
motherboard, disable LPM for this board, in order to avoid entering lower
PC-states, which triggers graphical corruptions.

Cc: stable@vger.kernel.org
Reported-by: Andy Yang <andyybtc79@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220111
Fixes: 7627a0edef54 ("ata: ahci: Drop low power policy board type")
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hans de Goede <hansg@kernel.org>
Link: https://lore.kernel.org/r/20250612141750.2108342-2-cassel@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/ahci.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1410,8 +1410,15 @@ static bool ahci_broken_suspend(struct p
 
 static bool ahci_broken_lpm(struct pci_dev *pdev)
 {
+	/*
+	 * Platforms with LPM problems.
+	 * If driver_data is NULL, there is no existing BIOS version with
+	 * functioning LPM.
+	 * If driver_data is non-NULL, then driver_data contains the DMI BIOS
+	 * build date of the first BIOS version with functioning LPM (i.e. older
+	 * BIOS versions have broken LPM).
+	 */
 	static const struct dmi_system_id sysids[] = {
-		/* Various Lenovo 50 series have LPM issues with older BIOSen */
 		{
 			.matches = {
 				DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
@@ -1446,6 +1453,13 @@ static bool ahci_broken_lpm(struct pci_d
 			 */
 			.driver_data = "20180310", /* 2.35 */
 		},
+		{
+			.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+				DMI_MATCH(DMI_PRODUCT_VERSION, "ASUSPRO D840MB_M840SA"),
+			},
+			/* 320 is broken, there is no known good version yet. */
+		},
 		{ }	/* terminate list */
 	};
 	const struct dmi_system_id *dmi = dmi_first_match(sysids);
@@ -1455,6 +1469,9 @@ static bool ahci_broken_lpm(struct pci_d
 	if (!dmi)
 		return false;
 
+	if (!dmi->driver_data)
+		return true;
+
 	dmi_get_date(DMI_BIOS_DATE, &year, &month, &date);
 	snprintf(buf, sizeof(buf), "%04d%02d%02d", year, month, date);
 


