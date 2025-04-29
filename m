Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6744C21ABC1;
	Tue, 29 Apr 2025 17:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948612; cv=none; b=INMlpKvb0HmOCoG+StYhrse702N5v9DHxuCwUP2SgQvcOB0jKubggVXdDxH9DmY8RnM6/NN/I+nryzNDl1uQz8YSEmdty+PPDUdio59TFq85Y0LZtp63QXj/1Ty8ZU6cSwFKY9kztRKzj71zqkgiKuQleOP1aSuOzZj/sZKrf20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948612; c=relaxed/simple;
	bh=d9iUVIcb05VzhH2ztjcnKAuwqMZFcba7NNY7yttI7lY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EPUKx6RZwSYwipAAoG5P/PZ2HBxQnCP0APSnbMrhnW3pJwuF12yOY+w3INQ/7G5fQaMCf41WszJFLxj0OEj6nN5sBjR/XO+10AbIk4YS2ioF8cq474ON26+RrcrLn8U4JBI32GAHFd7V7kT3LRmwBCwZKIcFY6qVy3NvfC4yCdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iy+2HSOG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iy+2HSOG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8005C4CEE3;
	Tue, 29 Apr 2025 17:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948611;
	bh=d9iUVIcb05VzhH2ztjcnKAuwqMZFcba7NNY7yttI7lY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Iy+2HSOGpmafjBsm6PeMnqzsU+56E2TpljTq6ODUeCjrQqJcDZsK4sO4XgH+VK3uH
	 9JM92a9CpqWwcmiFnvmeTo8Bvjkc4jhrAm8mUL8LKbFaLLN6GutTOcea34WN7AGGnY
	 x6A1Ia0CML6dtmO5cMZDMhZye4dkUPBUyfMt3oDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Pemberton <lists@philpem.me.uk>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 029/373] ata: libata-eh: Do not use ATAPI DMA for a device limited to PIO mode
Date: Tue, 29 Apr 2025 18:38:26 +0200
Message-ID: <20250429161124.334649667@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 10742d72f44fb..f0b690b39bf7a 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1479,8 +1479,15 @@ unsigned int atapi_eh_request_sense(struct ata_device *dev,
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



