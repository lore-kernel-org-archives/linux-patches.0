Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1A5233713;
	Tue, 29 Apr 2025 17:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947830; cv=none; b=rxzu5XpdHBXHlq9GIUkEQIi8hlLvtVUK/scovAoJUIfUTWIu2SRaWOL3BWyggU6Qcq+zM2O/LEuQsVSS0kVIJrMsYQPZiHrpiDABdeNOhtBsn5C9wah8NvIDr8zXXK1Ftnkyavcrvh8qcc/Qso3Ngixhh0Q9g3hhyZkU7V0P8U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947830; c=relaxed/simple;
	bh=Bvbnk79ii3jwXDE7z4h5yo/Nobtpg1wBlQvx2ILq9vo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PoY0wZSPsrzZQfPZ+OrhPrGKxmFpeyQU9GAgdVFmiUBIedSxnWBqHjhLexnG1Hjt7blm2XCjSLSe61gpzefX2sWZqqRBIlZ0P85UKu87uTfIvl+ecGaDzxxU7dc95Eg4YDJ9qNT/d5nVQmtw+6W/Aj7AGvFExNFFlp9Ogc+eKYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y7115iz+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y7115iz+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5201C4CEE9;
	Tue, 29 Apr 2025 17:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947829;
	bh=Bvbnk79ii3jwXDE7z4h5yo/Nobtpg1wBlQvx2ILq9vo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y7115iz+cl/yE4puAEW+PwLA+wUZjjrNrz4PohijMeGDYJUP/wo227V+JR0FAQrgv
	 UCn8Y2dUpfJzdLjyR/eKD/7+JgbIov9Zw5IPBEykhsWGUau801bI/v5dmP9VpL3fki
	 O+u9neGjzBOvRFKC3ZHJVIUVOY/6Jev1FwZJEon4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Igor Pylypiv <ipylypiv@google.com>
Subject: [PATCH 6.12 116/280] ata: libata-scsi: Improve CDL control
Date: Tue, 29 Apr 2025 18:40:57 +0200
Message-ID: <20250429161119.857332955@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

commit 17e897a456752ec9c2d7afb3d9baf268b442451b upstream.

With ATA devices supporting the CDL feature, using CDL requires that the
feature be enabled with a SET FEATURES command. This command is issued
as the translated command for the MODE SELECT command issued by
scsi_cdl_enable() when the user enables CDL through the device
cdl_enable sysfs attribute.

Currently, ata_mselect_control_ata_feature() always translates a MODE
SELECT command for the ATA features subpage of the control mode page to
a SET FEATURES command to enable or disable CDL based on the cdl_ctrl
field. However, there is no need to issue the SET FEATURES command if:
1) The MODE SELECT command requests disabling CDL and CDL is already
   disabled.
2) The MODE SELECT command requests enabling CDL and CDL is already
   enabled.

Fix ata_mselect_control_ata_feature() to issue the SET FEATURES command
only when necessary. Since enabling CDL also implies a reset of the CDL
statistics log page, avoiding useless CDL enable operations also avoids
clearing the CDL statistics log.

Also add debug messages to clearly signal when CDL is being enabled or
disabled using a SET FEATURES command.

Fixes: df60f9c64576 ("scsi: ata: libata: Add ATA feature control sub-page translation")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Igor Pylypiv <ipylypiv@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-scsi.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3757,17 +3757,27 @@ static unsigned int ata_mselect_control_
 	/* Check cdl_ctrl */
 	switch (buf[0] & 0x03) {
 	case 0:
-		/* Disable CDL */
+		/* Disable CDL if it is enabled */
+		if (!(dev->flags & ATA_DFLAG_CDL_ENABLED))
+			return 0;
+		ata_dev_dbg(dev, "Disabling CDL\n");
 		cdl_action = 0;
 		dev->flags &= ~ATA_DFLAG_CDL_ENABLED;
 		break;
 	case 0x02:
-		/* Enable CDL T2A/T2B: NCQ priority must be disabled */
+		/*
+		 * Enable CDL if not already enabled. Since this is mutually
+		 * exclusive with NCQ priority, allow this only if NCQ priority
+		 * is disabled.
+		 */
+		if (dev->flags & ATA_DFLAG_CDL_ENABLED)
+			return 0;
 		if (dev->flags & ATA_DFLAG_NCQ_PRIO_ENABLED) {
 			ata_dev_err(dev,
 				"NCQ priority must be disabled to enable CDL\n");
 			return -EINVAL;
 		}
+		ata_dev_dbg(dev, "Enabling CDL\n");
 		cdl_action = 1;
 		dev->flags |= ATA_DFLAG_CDL_ENABLED;
 		break;


