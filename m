Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22094E55B;
	Tue, 25 Mar 2025 12:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905918; cv=none; b=U3zwXfueL5l0samWB58ww0/X6LZXIJ7WG1TP9uwxx+qYCv/3TFfxAtNTlQfyPy2OhQUKvCjFpTiLMhbjh8AJ7N922OEvO/ibjs0mC31HMoQ2oYQzKoe+HoP6HrrRVyAElWg3nZWML662guJowEgrfggOh1fpaZJYoz+/SL0eB1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905918; c=relaxed/simple;
	bh=4Yoad1X9FChufHyyVM0NoP2IQllLx76NYLtJ3Hhbqy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mXrcXhjUVqJaLNk29QlIKeqAxY0d4/OcleSq60J2MMoULuVQdgWl+R3ofLE8YR4XrpeeVcxm7b6hGTM4kokAzfHARNU9YfqC4WDnj20yFWFMtsPNZCgNJI3GZgi4jIiLCUkYL5sV62/bgltKop0Gw4C6JKQG98ayZq0oaXgodNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ifAXwNaK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ifAXwNaK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6F50C4CEE9;
	Tue, 25 Mar 2025 12:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905918;
	bh=4Yoad1X9FChufHyyVM0NoP2IQllLx76NYLtJ3Hhbqy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ifAXwNaKnUKVV5zJKDR9kkTq244Jj4+PUXHRMJN11G6+S7JsnROEUCPPCUZKXfIh1
	 7VucLd6rjBHd0F96h7Wr48j01I1wWDNE+tEwvSDYFhoGrn6OGXI3FjIDjiSbPYwn03
	 XAtVGBvouU2fZFgimJSmVVN1x/woNEc2Wq/URuuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Eric <eric.4.debian@grabatoulnz.fr>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 036/119] ata: libata-core: Add ATA_QUIRK_NO_LPM_ON_ATI for certain Samsung SSDs
Date: Tue, 25 Mar 2025 08:21:34 -0400
Message-ID: <20250325122149.984960958@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit f2aac4c73c9945cce156fd58a9a2f31f2c8a90c7 ]

Before commit 7627a0edef54 ("ata: ahci: Drop low power policy board type")
the ATI AHCI controllers specified board type 'board_ahci' rather than
board type 'board_ahci'. This means that LPM was historically not enabled
for the ATI AHCI controllers.

By looking at commit 7a8526a5cd51 ("libata: Add ATA_HORKAGE_NO_NCQ_ON_ATI
for Samsung 860 and 870 SSD."), it is clear that, for some unknown reason,
that Samsung SSDs do not play nice with ATI AHCI controllers. (When using
other AHCI controllers, NCQ can be enabled on these Samsung SSDs without
issues.)

In a similar way, from user reports, it is clear the ATI AHCI controllers
can enable LPM on e.g. Maxtor HDDs perfectly fine, but when enabling LPM
on certain Samsung SSDs, things break. (E.g. the SSDs will not get detected
by the ATI AHCI controller even after a COMRESET.)

Yet, when using LPM on these Samsung SSDs with other AHCI controllers, e.g.
Intel AHCI controllers, these Samsung drives appear to work perfectly fine.

Considering that the combination of ATI + Samsung, for some unknown reason,
does not seem to work well, disable LPM when detecting an ATI AHCI
controller with a problematic Samsung SSD.

Apply this new ATA_QUIRK_NO_LPM_ON_ATI quirk for all Samsung SSDs that have
already been reported to not play nice with ATI (ATA_QUIRK_NO_NCQ_ON_ATI).

Fixes: 7627a0edef54 ("ata: ahci: Drop low power policy board type")
Suggested-by: Hans de Goede <hdegoede@redhat.com>
Reported-by: Eric <eric.4.debian@grabatoulnz.fr>
Closes: https://lore.kernel.org/linux-ide/Z8SBZMBjvVXA7OAK@eldamar.lan/
Tested-by: Eric <eric.4.debian@grabatoulnz.fr>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20250317170348.1748671-2-cassel@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-core.c | 14 +++++++++++---
 include/linux/libata.h    |  2 ++
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index c085dd81ebe7f..d956735e2a764 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2845,6 +2845,10 @@ int ata_dev_configure(struct ata_device *dev)
 	    (id[ATA_ID_SATA_CAPABILITY] & 0xe) == 0x2)
 		dev->quirks |= ATA_QUIRK_NOLPM;
 
+	if (dev->quirks & ATA_QUIRK_NO_LPM_ON_ATI &&
+	    ata_dev_check_adapter(dev, PCI_VENDOR_ID_ATI))
+		dev->quirks |= ATA_QUIRK_NOLPM;
+
 	if (ap->flags & ATA_FLAG_NO_LPM)
 		dev->quirks |= ATA_QUIRK_NOLPM;
 
@@ -3897,6 +3901,7 @@ static const char * const ata_quirk_names[] = {
 	[__ATA_QUIRK_MAX_SEC_1024]	= "maxsec1024",
 	[__ATA_QUIRK_MAX_TRIM_128M]	= "maxtrim128m",
 	[__ATA_QUIRK_NO_NCQ_ON_ATI]	= "noncqonati",
+	[__ATA_QUIRK_NO_LPM_ON_ATI]	= "nolpmonati",
 	[__ATA_QUIRK_NO_ID_DEV_LOG]	= "noiddevlog",
 	[__ATA_QUIRK_NO_LOG_DIR]	= "nologdir",
 	[__ATA_QUIRK_NO_FUA]		= "nofua",
@@ -4142,13 +4147,16 @@ static const struct ata_dev_quirks_entry __ata_dev_quirks[] = {
 						ATA_QUIRK_ZERO_AFTER_TRIM },
 	{ "Samsung SSD 860*",		NULL,	ATA_QUIRK_NO_NCQ_TRIM |
 						ATA_QUIRK_ZERO_AFTER_TRIM |
-						ATA_QUIRK_NO_NCQ_ON_ATI },
+						ATA_QUIRK_NO_NCQ_ON_ATI |
+						ATA_QUIRK_NO_LPM_ON_ATI },
 	{ "Samsung SSD 870*",		NULL,	ATA_QUIRK_NO_NCQ_TRIM |
 						ATA_QUIRK_ZERO_AFTER_TRIM |
-						ATA_QUIRK_NO_NCQ_ON_ATI },
+						ATA_QUIRK_NO_NCQ_ON_ATI |
+						ATA_QUIRK_NO_LPM_ON_ATI },
 	{ "SAMSUNG*MZ7LH*",		NULL,	ATA_QUIRK_NO_NCQ_TRIM |
 						ATA_QUIRK_ZERO_AFTER_TRIM |
-						ATA_QUIRK_NO_NCQ_ON_ATI, },
+						ATA_QUIRK_NO_NCQ_ON_ATI |
+						ATA_QUIRK_NO_LPM_ON_ATI },
 	{ "FCCT*M500*",			NULL,	ATA_QUIRK_NO_NCQ_TRIM |
 						ATA_QUIRK_ZERO_AFTER_TRIM },
 
diff --git a/include/linux/libata.h b/include/linux/libata.h
index c1a85d46eba6d..4f62c43059c21 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -88,6 +88,7 @@ enum ata_quirks {
 	__ATA_QUIRK_MAX_SEC_1024,	/* Limit max sects to 1024 */
 	__ATA_QUIRK_MAX_TRIM_128M,	/* Limit max trim size to 128M */
 	__ATA_QUIRK_NO_NCQ_ON_ATI,	/* Disable NCQ on ATI chipset */
+	__ATA_QUIRK_NO_LPM_ON_ATI,	/* Disable LPM on ATI chipset */
 	__ATA_QUIRK_NO_ID_DEV_LOG,	/* Identify device log missing */
 	__ATA_QUIRK_NO_LOG_DIR,		/* Do not read log directory */
 	__ATA_QUIRK_NO_FUA,		/* Do not use FUA */
@@ -432,6 +433,7 @@ enum {
 	ATA_QUIRK_MAX_SEC_1024		= (1U << __ATA_QUIRK_MAX_SEC_1024),
 	ATA_QUIRK_MAX_TRIM_128M		= (1U << __ATA_QUIRK_MAX_TRIM_128M),
 	ATA_QUIRK_NO_NCQ_ON_ATI		= (1U << __ATA_QUIRK_NO_NCQ_ON_ATI),
+	ATA_QUIRK_NO_LPM_ON_ATI		= (1U << __ATA_QUIRK_NO_LPM_ON_ATI),
 	ATA_QUIRK_NO_ID_DEV_LOG		= (1U << __ATA_QUIRK_NO_ID_DEV_LOG),
 	ATA_QUIRK_NO_LOG_DIR		= (1U << __ATA_QUIRK_NO_LOG_DIR),
 	ATA_QUIRK_NO_FUA		= (1U << __ATA_QUIRK_NO_FUA),
-- 
2.39.5



