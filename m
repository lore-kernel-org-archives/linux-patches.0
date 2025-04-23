Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D47E1F193C;
	Wed, 23 Apr 2025 15:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420459; cv=none; b=Q2w8ETIpqFzleFgRIaaDfIGEJWOnqNo8FwhX6rRlUXqydMk1uy90geA828BrirJ1BPlvuipxLhpSm+rGs2giJjR/saF1nabXSxozvqeLcelctkHH7liSY7tBRUBdR//pBmsccLiT4VdyMjG2ZAPpzZK9gVYJRuQLeltoHerQYPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420459; c=relaxed/simple;
	bh=/OJrhaULIEQCjaYvSSsye8hUB5WDk90rp1dSDq3i6C8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JuEXt4EjRrMZnJTp+nVpfHxgwPzIXVZEkL4CyBw52+lVCMqLVCmI1LCg3pVj8eUlg1ub5NzloF/WHwXsTndr808m1QZK5qrHUyIccGwzP42TZ+Xt+Vnjy/XyRoF5pWMcIS1gA6UISUU9yQv4H1wu+xqra3bI+Eqx6fF1i1PeGqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AjQyu+Kk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AjQyu+Kk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3615FC4CEE2;
	Wed, 23 Apr 2025 15:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420458;
	bh=/OJrhaULIEQCjaYvSSsye8hUB5WDk90rp1dSDq3i6C8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AjQyu+Kko6hojzPxeF8KnHZAFNALSWWQ7Pbxk8zwM7e81v/NZBY8+7Dud4pHeqdhq
	 gXCyhXSGJa563lQdT9r6zmW/Kg0e+UjIAUhWunS5ioTEJT4hxHQ+eYVWyxB4Oc94b4
	 Ck8c9E2o8WV/kPeTYqnuYv6rp4vhNP7Ta7rMsFwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Pemberton <lists@philpem.me.uk>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 076/393] ata: libata-eh: Do not use ATAPI DMA for a device limited to PIO mode
Date: Wed, 23 Apr 2025 16:39:32 +0200
Message-ID: <20250423142646.445807074@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit 91ec84f8eaddbc93d7c62e363d68aeb7b89879c7 ]

atapi_eh_request_sense() currently uses ATAPI DMA if the SATA controller
has ATA_FLAG_PIO_DMA (PIO cmds via DMA) set.

However, ATA_FLAG_PIO_DMA is a flag that can be set by a low-level driver
on a port at initialization time, before any devices are scanned.

If a controller detects a connected device that only supports PIO, we set
the flag ATA_DFLAG_PIO.

Modify atapi_eh_request_sense() to not use ATAPI DMA if the connected
device only supports PIO.

Reported-by: Philip Pemberton <lists@philpem.me.uk>
Closes: https://lore.kernel.org/linux-ide/c6722ee8-5e21-4169-af59-cbbae9edc02f@philpem.me.uk/
Tested-by: Philip Pemberton <lists@philpem.me.uk>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20250221015422.20687-2-cassel@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-eh.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 9cc0225221849..3263fc13491e1 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1496,8 +1496,15 @@ unsigned int atapi_eh_request_sense(struct ata_device *dev,
 	tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
 	tf.command = ATA_CMD_PACKET;
 
-	/* is it pointless to prefer PIO for "safety reasons"? */
-	if (ap->flags & ATA_FLAG_PIO_DMA) {
+	/*
+	 * Do not use DMA if the connected device only supports PIO, even if the
+	 * port prefers PIO commands via DMA.
+	 *
+	 * Ideally, we should call atapi_check_dma() to check if it is safe for
+	 * the LLD to use DMA for REQUEST_SENSE, but we don't have a qc.
+	 * Since we can't check the command, perhaps we should only use pio?
+	 */
+	if ((ap->flags & ATA_FLAG_PIO_DMA) && !(dev->flags & ATA_DFLAG_PIO)) {
 		tf.protocol = ATAPI_PROT_DMA;
 		tf.feature |= ATAPI_PKT_DMA;
 	} else {
-- 
2.39.5



