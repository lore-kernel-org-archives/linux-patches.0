Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB46E14D435;
	Wed, 19 Jun 2024 13:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803329; cv=none; b=B77Hc4O+2Wodz27bND5d+JPLt3O9p+N+gM/isEqcCFVunbwXoR3wIvS9hczRKi+utSWisikRi+NnVebOfzcutn5nH/ItVGMxH+mQDBl6bLUJOs1m5ZvGGb9pnxdTn8OWJkR9Oi4f9ZYx1a0JUV58w3dZrt3esDz5h2GUU/m0rnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803329; c=relaxed/simple;
	bh=WYmC0l8zBGWJ5jkRtQZaTSJYNeiW5wYnHUUMECVZ0UM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ii58WxD7d7L5NiFcfujJrhE25cQTMchkBOeImN1NS9iBU4EIIfNwaxCAkCwIphdLj9M85QDU94TAkrGd6xTQIW6utEGq4jEkXgqXbAcxmVG8ngtAD+VaCWf7MUOwRDpEJAKvDWHP6MFyo3UMStkqzwRNIJ3k7uPOPLMEE/3E/0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SHcVMATj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SHcVMATj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A63EC2BBFC;
	Wed, 19 Jun 2024 13:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803329;
	bh=WYmC0l8zBGWJ5jkRtQZaTSJYNeiW5wYnHUUMECVZ0UM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SHcVMATjxzjCZExFk6zjZuUI4U55yGbP6dkwUaNUTF4+BrjnV1a212TvDO2FnjBoV
	 r7bHy7o/XO6Gi9GFAEMkr/rXLQX0E0UraETAUWyDtYeggGgovFi3QEQq9N3XVPRc4R
	 SbCZ5yrD3K/Uxa1JkVyawKmsrIbKfvxxPZ9d+8zE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aarrayy <lp610mh@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.9 230/281] ata: libata-core: Add ATA_HORKAGE_NOLPM for Crucial CT240BX500SSD1
Date: Wed, 19 Jun 2024 14:56:29 +0200
Message-ID: <20240619125618.813019903@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

commit 86aaa7e9d641c1ad1035ed2df88b8d0b48c86b30 upstream.

Commit 7627a0edef54 ("ata: ahci: Drop low power policy board type")
dropped the board_ahci_low_power board type, and instead enables LPM if:
-The AHCI controller reports that it supports LPM (Partial/Slumber), and
-CONFIG_SATA_MOBILE_LPM_POLICY != 0, and
-The port is not defined as external in the per port PxCMD register, and
-The port is not defined as hotplug capable in the per port PxCMD
 register.

Partial and Slumber LPM states can either be initiated by HIPM or DIPM.

For HIPM (host initiated power management) to get enabled, both the AHCI
controller and the drive have to report that they support HIPM.

For DIPM (device initiated power management) to get enabled, only the
drive has to report that it supports DIPM. However, the HBA will reject
device requests to enter LPM states which the HBA does not support.

The problem is that Crucial CT240BX500SSD1 drives do not handle low power
modes correctly. The problem was most likely not seen before because no
one had used this drive with a AHCI controller with LPM enabled.

Add a quirk so that we do not enable LPM for this drive, since we see
command timeouts if we do (even though the drive claims to support DIPM).

Fixes: 7627a0edef54 ("ata: ahci: Drop low power policy board type")
Cc: stable@vger.kernel.org
Reported-by: Aarrayy <lp610mh@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218832
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4180,8 +4180,9 @@ static const struct ata_blacklist_entry
 	{ "PIONEER BD-RW   BDR-207M",	NULL,	ATA_HORKAGE_NOLPM },
 	{ "PIONEER BD-RW   BDR-205",	NULL,	ATA_HORKAGE_NOLPM },
 
-	/* Crucial BX100 SSD 500GB has broken LPM support */
+	/* Crucial devices with broken LPM support */
 	{ "CT500BX100SSD1",		NULL,	ATA_HORKAGE_NOLPM },
+	{ "CT240BX500SSD1",		NULL,	ATA_HORKAGE_NOLPM },
 
 	/* 512GB MX100 with MU01 firmware has both queued TRIM and LPM issues */
 	{ "Crucial_CT512MX100*",	"MU01",	ATA_HORKAGE_NO_NCQ_TRIM |


