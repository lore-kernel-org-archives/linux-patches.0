Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B90125B3
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:18:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0790C433D2;
	Mon,  8 May 2023 10:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541089;
	bh=QvDiN8d/mMGJ07zgJtp6pyLoUdXXmYRuk4pUB9u+l6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VpOJFCFfbRT4T9/K8qLHsfVgfM5fR9sXK2JtYZH1rasf2TRESgIXnXtTKDJRQ4u+b
	 0e4Wr5Xd6WjBh0/QClioBW5GNW10nDP0vqD6Iruu6Rkq2sh7r1+IQGNpV1pl23FF6E
	 +mn5jD0s3rxLPRJMU9XTTMmtUTEBEm9YYd7oOk3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingui Yang <yangxingui@huawei.com>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 611/611] scsi: libsas: Grab the ATA port lock in sas_ata_device_link_abort()
Date: Mon,  8 May 2023 11:47:33 +0200
Message-Id: <20230508094441.766917233@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xingui Yang <yangxingui@huawei.com>

commit a67aad57d9aee41180aff36e54cb72fe4b8d5a5a upstream.

Grab the ATA port lock in sas_ata_device_link_abort() before calling
ata_link_abort() as outlined in this function's locking requirements.

Fixes: 44112922674b ("scsi: libsas: Add sas_ata_device_link_abort()")
Signed-off-by: Xingui Yang <yangxingui@huawei.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Jason Yan <yanaijie@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/libsas/sas_ata.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -890,7 +890,9 @@ void sas_ata_device_link_abort(struct do
 {
 	struct ata_port *ap = device->sata_dev.ap;
 	struct ata_link *link = &ap->link;
+	unsigned long flags;
 
+	spin_lock_irqsave(ap->lock, flags);
 	device->sata_dev.fis[2] = ATA_ERR | ATA_DRDY; /* tf status */
 	device->sata_dev.fis[3] = ATA_ABORTED; /* tf error */
 
@@ -898,6 +900,7 @@ void sas_ata_device_link_abort(struct do
 	if (force_reset)
 		link->eh_info.action |= ATA_EH_RESET;
 	ata_link_abort(link);
+	spin_unlock_irqrestore(ap->lock, flags);
 }
 EXPORT_SYMBOL_GPL(sas_ata_device_link_abort);
 


