Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B2EAD58;
	Wed, 19 Jun 2024 13:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802942; cv=none; b=XYbT/vQWt9lA9aMiLyibrXBnZbaCQ1LRnwqfEJqHVIZzEXw3SnPLZJoygHBWf6XdG3TnEaKGzzKJvDRHcD1jrZAbYztnU40qEgCmfh6gK+jIy+wbOYL4YeBeUiykaAXUWx9Gw04Q5gc9jTJuu8puMVSGaqWcZvLIvTna1qQK9BE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802942; c=relaxed/simple;
	bh=Ukcb7h6ZgrmuUUOQcx1M+6rUjqDRy70R5DJpH22pBeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SksIPe3/eyXoFSlGTD+VH6n20BWMPZMJRjgnLKrTB1XBkGdzBkuZUEA+DkoG4+dFJdy5y0Yvq7JTNG2LsAbHVZeDGLOvFoxL0fjUsjr6h7eZq15UmtC23GFASZ4XKzIjy4hbaVepEiHmzy16nOnOxjyRRgPaSOtuRukWMh32Xpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hcWpBj1u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hcWpBj1u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58648C2BBFC;
	Wed, 19 Jun 2024 13:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802942;
	bh=Ukcb7h6ZgrmuUUOQcx1M+6rUjqDRy70R5DJpH22pBeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hcWpBj1uv5w9jV3J4qYRX4VFoICEJkCQt536Qk0n7zkWSUrlHfhUFhut/ROiJ9qOU
	 XQY/+7X020lG2MuPozAjvmqewj09ET/pgbhwYKEin0bdT1AWSoRLxNx6jFcupMy1Bu
	 2FNhS1ZIrtIwcQLykxU7fQikTkng9/+jW3F7arM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.9 099/281] ata: libata-scsi: Set the RMB bit only for removable media devices
Date: Wed, 19 Jun 2024 14:54:18 +0200
Message-ID: <20240619125613.660267796@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

commit a6a75edc8669a4f030546c7390808ef0cc034742 upstream.

The SCSI Removable Media Bit (RMB) should only be set for removable media,
where the device stays and the media changes, e.g. CD-ROM or floppy.

The ATA removable media device bit is obsoleted since ATA-8 ACS (2006),
but before that it was used to indicate that the device can have its media
removed (while the device stays).

Commit 8a3e33cf92c7 ("ata: ahci: find eSATA ports and flag them as
removable") introduced a change to set the RMB bit if the port has either
the eSATA bit or the hot-plug capable bit set. The reasoning was that the
author wanted his eSATA ports to get treated like a USB stick.

This is however wrong. See "20-082r23SPC-6: Removable Medium Bit
Expectations" which has since been integrated to SPC, which states that:

"""
Reports have been received that some USB Memory Stick device servers set
the removable medium (RMB) bit to one. The rub comes when the medium is
actually removed, because... The device server is removed concurrently
with the medium removal. If there is no device server, then there is no
device server that is waiting to have removable medium inserted.

Sufficient numbers of SCSI analysts see such a device:
- not as a device that supports removable medium;
but
- as a removable, hot pluggable device.
"""

The definition of the RMB bit in the SPC specification has since been
clarified to match this.

Thus, a USB stick should not have the RMB bit set (and neither shall an
eSATA nor a hot-plug capable port).

Commit dc8b4afc4a04 ("ata: ahci: don't mark HotPlugCapable Ports as
external/removable") then changed so that the RMB bit is only set for the
eSATA bit (and not for the hot-plug capable bit), because of a lot of bug
reports of SATA devices were being automounted by udisks. However,
treating eSATA and hot-plug capable ports differently is not correct.

>From the AHCI 1.3.1 spec:
Hot Plug Capable Port (HPCP): When set to '1', indicates that this port's
signal and power connectors are externally accessible via a joint signal
and power connector for blindmate device hot plug.

So a hot-plug capable port is an external port, just like commit
45b96d65ec68 ("ata: ahci: a hotplug capable port is an external port")
claims.

In order to not violate the SPC specification, modify the SCSI INQUIRY
data to only set the RMB bit if the ATA device can have its media removed.

This fixes a reported problem where GNOME/udisks was automounting devices
connected to hot-plug capable ports.

Fixes: 45b96d65ec68 ("ata: ahci: a hotplug capable port is an external port")
Cc: stable@vger.kernel.org
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Thomas Weißschuh <linux@weissschuh.net>
Tested-by: Thomas Weißschuh <linux@weissschuh.net>
Reported-by: Thomas Weißschuh <linux@weissschuh.net>
Closes: https://lore.kernel.org/linux-ide/c0de8262-dc4b-4c22-9fac-33432e5bddd3@t-8ch.de/
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
[cassel: wrote commit message]
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-scsi.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1828,11 +1828,11 @@ static unsigned int ata_scsiop_inq_std(s
 		2
 	};
 
-	/* set scsi removable (RMB) bit per ata bit, or if the
-	 * AHCI port says it's external (Hotplug-capable, eSATA).
+	/*
+	 * Set the SCSI Removable Media Bit (RMB) if the ATA removable media
+	 * device bit (obsolete since ATA-8 ACS) is set.
 	 */
-	if (ata_id_removable(args->id) ||
-	    (args->dev->link->ap->pflags & ATA_PFLAG_EXTERNAL))
+	if (ata_id_removable(args->id))
 		hdr[1] |= (1 << 7);
 
 	if (args->dev->class == ATA_DEV_ZAC) {


