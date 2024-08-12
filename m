Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 747ED1494B8;
	Mon, 12 Aug 2024 16:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480430; cv=none; b=MkU7C7fq3MX9yu27IsafFJrgY8rxLR2GIAqx03pWmI2A7aLRx3hxOxS1qIeZFjhK56owkoju8arEgZPmArYPiBZ4rK8WVAB4pU6Dq2ug9n10p3t33o8ksL5DPFPSU5uvGQaSKWelxU/ed9SVI/IAS2Ne8NCBnmo22Gxv7biWzCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480430; c=relaxed/simple;
	bh=ZFTHX+G21JnCZ0oL3mv0m59GMVemJ50oruqqtnWpO+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eSPa8ZntG0abJ2Qnru2D6eovos39zS+oT4g8SFYIXDO4iHmnQ3+K9XVAoTexoC8UNxHJpYUit1gn+hjvh9nWnFcwn0ovvMM1t/46lUB13uUdb+aqgj7viHurFahhH4WbWanYFT6BBtE+3QQldFhqlVBvZgAremQSi2NlBhDvZvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NJMZbrbc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NJMZbrbc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA3D9C4AF0C;
	Mon, 12 Aug 2024 16:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480430;
	bh=ZFTHX+G21JnCZ0oL3mv0m59GMVemJ50oruqqtnWpO+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NJMZbrbcbR8OsVb3o3YcN/SgbFQ38eIhR0k6gOfez/6Fa2tUVUjzl8X+mPV7zjomX
	 AjFdsxCFBmyyKmIxwdEG6hsekFQfjZgqEkUJKUAgcRqxKgk7gqyavK3ww9jzwkLvmM
	 +6ZqKA+3DjRF+hPoqLg8nRCMpJQqGoj13m9X/A3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.10 194/263] scsi: mpi3mr: Avoid IOMMU page faults on REPORT ZONES
Date: Mon, 12 Aug 2024 18:03:15 +0200
Message-ID: <20240812160153.970447292@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3453,6 +3453,17 @@ static int mpi3mr_prepare_sg_scmd(struct
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


