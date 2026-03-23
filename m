Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F7F71FC101;
	Mon, 23 Mar 2026 14:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275430; cv=none; b=TubD+2GDo9Man1mJlUbTqXz0+9ug808AV5V4pilcuSJWEXqMwEw825M1c+fkIXLZmLssfVUW8YmqZHUn4bLqfIJZm+6M1ThFesTZUkBfGWcJuLFnP+TDcx+cB/PVUBlRF7ZWVp9X5IpHA2zBuBV2GnCqPWCV4uVP39wNE4px/Jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275430; c=relaxed/simple;
	bh=MjYAhC/ZkuHIKs+n1e6DkKV3uGDpnIlfpCX0fRGGlDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JdZ6UljZ5uZRpsd/7D/kgt19Ij+8gZqcxWvGAHCzjjU6Nu8APqe96Fw00v+Q2ugepAqqZsgSNSvonjmOEzRn3lIn0wOiGXr5RW/dkVRTcJlEQjdDeT09rOdu0GSM7M7y72QUmwIoQngP39RrawMquedoXhNerux+JpC28Twn+W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LCzwV1wa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LCzwV1wa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC8ABC4CEF7;
	Mon, 23 Mar 2026 14:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275430;
	bh=MjYAhC/ZkuHIKs+n1e6DkKV3uGDpnIlfpCX0fRGGlDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LCzwV1waNAE7UBQSErhP1ZNMFXoHCuWRrfV1FiJwhngAx6osjXcgMQLIF1wR7kPFJ
	 pFGYGAv5PLB3UomHMBpzyY737BTGmshLgykrPScFZ1SmIiqClctAnyioLRZf1R4PcA
	 r7TyZDk/J8s2yDzMlhyUjmbPsLk74RJIJffSXNZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pedro Falcato <pfalcato@suse.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.12 095/460] ata: libata-core: Add BRIDGE_OK quirk for QEMU drives
Date: Mon, 23 Mar 2026 14:41:31 +0100
Message-ID: <20260323134528.994077377@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pedro Falcato <pfalcato@suse.de>

commit b92b0075ee1870f78f59ab1f7da7dbfdd718ad7a upstream.

Currently, whenever you boot with a QEMU drive over an AHCI interface,
you get:
[    1.632121] ata1.00: applying bridge limits

This happens due to the kernel not believing the given drive is SATA,
since word 93 of IDENTIFY (ATA_ID_HW_CONFIG) is non-zero. The result is
a pretty severe limit in max_hw_sectors_kb, which limits our IO sizes.

QEMU has set word 93 erroneously for SATA drives but does not, in any
way, emulate any of these real hardware details. There is no PATA
drive and no SATA cable.

As such, add a BRIDGE_OK quirk for QEMU HARDDISK. Special care is taken
to limit this quirk to "2.5+", to allow for fixed future versions.

This results in the max_hw_sectors being limited solely by the
controller interface's limits. Which, for AHCI controllers, takes it
from 128KB to 32767KB.

Cc: stable@vger.kernel.org
Signed-off-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4144,6 +4144,7 @@ static const struct ata_dev_quirks_entry
 	/* Devices that do not need bridging limits applied */
 	{ "MTRON MSP-SATA*",		NULL,	ATA_QUIRK_BRIDGE_OK },
 	{ "BUFFALO HD-QSU2/R5",		NULL,	ATA_QUIRK_BRIDGE_OK },
+	{ "QEMU HARDDISK",		"2.5+",	ATA_QUIRK_BRIDGE_OK },
 
 	/* Devices which aren't very happy with higher link speeds */
 	{ "WD My Book",			NULL,	ATA_QUIRK_1_5_GBPS },


