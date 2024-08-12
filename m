Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E226186E47;
	Mon, 12 Aug 2024 16:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479089; cv=none; b=FhoZyzLgmdLGY1QQ+7kFxsmX03GxZoSFagF2GlXH/2bLyfLpWnJC2O/2kIurJh6l42uSID/x81NcKfYHZ1ymz+9EZSgBe5825FwR2n5vi8NTRSsgWI7BuVvo6XS3kRM/9IaorgxRmF3kh1vJ9kaTSBFpm5wQZ5CfzQnO1iO2aU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479089; c=relaxed/simple;
	bh=EoXXmKfwKdVGvVfUrKHKW1vLuDsZ8TeR3JyoINcye6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JUFL8JlyPUzN8JHzcWI3Z/Rk5rAvanTy9EZp34J0j3HUKWRJmvDdLIiNJQwTkkpm2ZG8pRU/bWJI6ouuv0KoZcQPi5XbD0HKo0pgZXQ6Y8uZGtBUKc+J2TMd+6jCstKfB0hxPJYAzEpaahFt+KCRYDdfCpj8u/Mk55kslvG0Txw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SzHdyTgX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SzHdyTgX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D01F1C32782;
	Mon, 12 Aug 2024 16:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479089;
	bh=EoXXmKfwKdVGvVfUrKHKW1vLuDsZ8TeR3JyoINcye6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SzHdyTgX1u9XnmbzeZWZww5gO5oC8lW4Ub2dI8eJKFSJz5pzZGHYeVw/r+bjhhywC
	 F34g9yB/YVQg5dsG8MMv1PWqsVuKrQPRXjUdr8Li7bdgcwplVRPQX+j9MKnWm5oGHo
	 GTfUDRH56kMZwd11Uvo0q852n8Ey6Jti0AOUDj/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 098/150] scsi: mpi3mr: Avoid IOMMU page faults on REPORT ZONES
Date: Mon, 12 Aug 2024 18:02:59 +0200
Message-ID: <20240812160128.942948810@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

commit 1abc900ddda8ad2ef739fedf498d415655b6c3b8 upstream.

Some firmware versions of the 9600 series SAS HBA byte-swap the REPORT
ZONES command reply buffer from ATA-ZAC devices by directly accessing the
buffer in the host memory. This does not respect the default command DMA
direction and causes IOMMU page faults on architectures with an IOMMU
enforcing write-only mappings for DMA_FROM_DEVICE DMA direction (e.g. AMD
hosts), leading to the device capacity to be dropped to 0:

scsi 18:0:58:0: Direct-Access-ZBC ATA      WDC  WSH722626AL W930 PQ: 0 ANSI: 7
scsi 18:0:58:0: Power-on or device reset occurred
sd 18:0:58:0: Attached scsi generic sg9 type 20
sd 18:0:58:0: [sdj] Host-managed zoned block device
mpi3mr 0000:c1:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0001 address=0xfec0c400 flags=0x0050]
mpi3mr 0000:c1:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0001 address=0xfec0c500 flags=0x0050]
sd 18:0:58:0: [sdj] REPORT ZONES start lba 0 failed
sd 18:0:58:0: [sdj] REPORT ZONES: Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
sd 18:0:58:0: [sdj] 0 4096-byte logical blocks: (0 B/0 B)
sd 18:0:58:0: [sdj] Write Protect is off
sd 18:0:58:0: [sdj] Mode Sense: 6b 00 10 08
sd 18:0:58:0: [sdj] Write cache: enabled, read cache: enabled, supports DPO and FUA
sd 18:0:58:0: [sdj] Attached SCSI disk

Avoid this issue by always mapping the buffer of REPORT ZONES commands
using DMA_BIDIRECTIONAL, that is, using a read-write IOMMU mapping.

Suggested-by: Christoph Hellwig <hch@lst.de>
Fixes: 023ab2a9b4ed ("scsi: mpi3mr: Add support for queue command processing")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20240719073913.179559-2-dlemoal@kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -3389,6 +3389,17 @@ static int mpi3mr_prepare_sg_scmd(struct
 		    scmd->sc_data_direction);
 		priv->meta_sg_valid = 1; /* To unmap meta sg DMA */
 	} else {
+		/*
+		 * Some firmware versions byte-swap the REPORT ZONES command
+		 * reply from ATA-ZAC devices by directly accessing in the host
+		 * buffer. This does not respect the default command DMA
+		 * direction and causes IOMMU page faults on some architectures
+		 * with an IOMMU enforcing write mappings (e.g. AMD hosts).
+		 * Avoid such issue by making the REPORT ZONES buffer mapping
+		 * bi-directional.
+		 */
+		if (scmd->cmnd[0] == ZBC_IN && scmd->cmnd[1] == ZI_REPORT_ZONES)
+			scmd->sc_data_direction = DMA_BIDIRECTIONAL;
 		sg_scmd = scsi_sglist(scmd);
 		sges_left = scsi_dma_map(scmd);
 	}


