Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78CF13F54CE;
	Tue, 17 Mar 2026 17:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767596; cv=none; b=FU+XwQ0QJ+dhJFqXHXc+ywmTCtiz8gxUCuoDAbfsQF4LecgadnxL7+vhomREop3Ta1QO1qbQC+IYz4SO8AbmOonl+c3IRbNOnxWHwUsbLeQv1UoqyaY+h6/XgLd4FWeqBve67xyf1ELUz0R164UOxY46+OYqYXfJt3ZGaE/LUQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767596; c=relaxed/simple;
	bh=NVYZOUW3gi9ZiAcooBdU43QGKx7aXL9cZQ/QrAmIYas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jOXz857FjAqYKVnwGWgNo++tr80QN9l/f7T4POIaaC5o+RZlB7AKcnf8Wtt0vfEVMPKQdCTL0owm8+RHNywOWuvCJmsvxklcIJCw37xOg1ZT7P4ePdzbedHi1cuiVML7fFAUWzwv11m5vY1OqDN7chdbmhbnTFrTOSHLUneb/14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c82965s1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c82965s1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE1D0C4CEF7;
	Tue, 17 Mar 2026 17:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767596;
	bh=NVYZOUW3gi9ZiAcooBdU43QGKx7aXL9cZQ/QrAmIYas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c82965s1+TdGFYgZkm2co07U6Gpx/aa8yG6BYzyt/TxbALyzCSfpaW2a3EZz1leFV
	 kg5pJCBkGHihUPCcAzhBFBP9JsQws2rATTiQdTddPyAA/Gi+zUaF1UF5tl2e+J59Ie
	 IAikGaP+hwFzeLQlxZAFBdZw34iKsJppFKOOL/j4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pedro Falcato <pfalcato@suse.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.18 120/333] ata: libata-core: Add BRIDGE_OK quirk for QEMU drives
Date: Tue, 17 Mar 2026 17:32:29 +0100
Message-ID: <20260317163003.817403492@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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
@@ -4199,6 +4199,7 @@ static const struct ata_dev_quirks_entry
 	/* Devices that do not need bridging limits applied */
 	{ "MTRON MSP-SATA*",		NULL,	ATA_QUIRK_BRIDGE_OK },
 	{ "BUFFALO HD-QSU2/R5",		NULL,	ATA_QUIRK_BRIDGE_OK },
+	{ "QEMU HARDDISK",		"2.5+",	ATA_QUIRK_BRIDGE_OK },
 
 	/* Devices which aren't very happy with higher link speeds */
 	{ "WD My Book",			NULL,	ATA_QUIRK_1_5_GBPS },


