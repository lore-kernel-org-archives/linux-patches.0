Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5506183CC9;
	Mon, 12 Aug 2024 16:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723478845; cv=none; b=Bl7S3lBtDV13mXfXKakpqMwZRGu2fefN4giKe7Buabf2a93oLAuGO/8C1FWhRl6ve/zg4J8mx4ypqIahAfqXjS6ddh6PR91JeXy6UJpy63z6SrwukAYLV7PWkubSBTduZzcd1llWlgPdFrsUG/LOsRSeXrgLN/ZgDS9k1vTUC9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723478845; c=relaxed/simple;
	bh=5eaz8YQ4YoSl+ypCuiPTSDWzicjAayEwmfQHZaze+4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tk4jCBXdRuRHl7PsppHfzV+FvytFr3hQNz8Gv/sY0Wgb5HEgULQq8kudDa7q7AoE81U4uhxD9btAk2Kyu6SAweigJ7IVDif18OGaFYgKEFnw+nO5i7KB1c+DS3Q1cWk7iVe/iBqmaEVTu0NI8TE8n3WIj88dyb7iZZpJjqiZsJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XStKWvOk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XStKWvOk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11265C32782;
	Mon, 12 Aug 2024 16:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723478845;
	bh=5eaz8YQ4YoSl+ypCuiPTSDWzicjAayEwmfQHZaze+4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XStKWvOky9/MevSrSOac7Fw/VTJTJG7m7r9wX0beVKxkW8tpfsqZW0hgLZ9kSyv9Z
	 U6UgEIN21vZtV2AmH8Az9hWTz+iWjtSdLLByEBvIXdWZsMkCg+aOlOJxEE6x72k7xO
	 1Ae6UjIjGROcNb/Tc6CVJ+nfSMrSVhbtKvc57vUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 053/150] scsi: mpt3sas: Avoid IOMMU page faults on REPORT ZONES
Date: Mon, 12 Aug 2024 18:02:14 +0200
Message-ID: <20240812160127.214083679@linuxfoundation.org>
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

commit 82dbb57ac8d06dfe8227ba9ab11a49de2b475ae5 upstream.

Some firmware versions of the 9600 series SAS HBA byte-swap the REPORT
ZONES command reply buffer from ATA-ZAC devices by directly accessing the
buffer in the host memory. This does not respect the default command DMA
direction and causes IOMMU page faults on architectures with an IOMMU
enforcing write-only mappings for DMA_FROM_DEVICE DMA driection (e.g. AMD
hosts).

scsi 18:0:0:0: Direct-Access-ZBC ATA      WDC  WSH722020AL W870 PQ: 0 ANSI: 6
scsi 18:0:0:0: SATA: handle(0x0027), sas_addr(0x300062b2083e7c40), phy(0), device_name(0x5000cca29dc35e11)
scsi 18:0:0:0: enclosure logical id (0x300062b208097c40), slot(0)
scsi 18:0:0:0: enclosure level(0x0000), connector name( C0.0)
scsi 18:0:0:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
scsi 18:0:0:0: qdepth(32), tagged(1), scsi_level(7), cmd_que(1)
sd 18:0:0:0: Attached scsi generic sg2 type 20
sd 18:0:0:0: [sdc] Host-managed zoned block device
mpt3sas 0000:41:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0021 address=0xfff9b200 flags=0x0050]
mpt3sas 0000:41:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0021 address=0xfff9b300 flags=0x0050]
mpt3sas_cm0: mpt3sas_ctl_pre_reset_handler: Releasing the trace buffer due to adapter reset.
mpt3sas_cm0 fault info from func: mpt3sas_base_make_ioc_ready
mpt3sas_cm0: fault_state(0x2666)!
mpt3sas_cm0: sending diag reset !!
mpt3sas_cm0: diag reset: SUCCESS
sd 18:0:0:0: [sdc] REPORT ZONES start lba 0 failed
sd 18:0:0:0: [sdc] REPORT ZONES: Result: hostbyte=DID_RESET driverbyte=DRIVER_OK
sd 18:0:0:0: [sdc] 0 4096-byte logical blocks: (0 B/0 B)

Avoid such issue by always mapping the buffer of REPORT ZONES commands
using DMA_BIDIRECTIONAL (read+write IOMMU mapping). This is done by
introducing the helper function _base_scsi_dma_map() and using this helper
in _base_build_sg_scmd() and _base_build_sg_scmd_ieee() instead of calling
directly scsi_dma_map().

Fixes: 471ef9d4e498 ("mpt3sas: Build MPI SGL LIST on GEN2 HBAs and IEEE SGL LIST on GEN3 HBAs")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20240719073913.179559-3-dlemoal@kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2672,6 +2672,22 @@ _base_build_zero_len_sge_ieee(struct MPT
 	_base_add_sg_single_ieee(paddr, sgl_flags, 0, 0, -1);
 }
 
+static inline int _base_scsi_dma_map(struct scsi_cmnd *cmd)
+{
+	/*
+	 * Some firmware versions byte-swap the REPORT ZONES command reply from
+	 * ATA-ZAC devices by directly accessing in the host buffer. This does
+	 * not respect the default command DMA direction and causes IOMMU page
+	 * faults on some architectures with an IOMMU enforcing write mappings
+	 * (e.g. AMD hosts). Avoid such issue by making the report zones buffer
+	 * mapping bi-directional.
+	 */
+	if (cmd->cmnd[0] == ZBC_IN && cmd->cmnd[1] == ZI_REPORT_ZONES)
+		cmd->sc_data_direction = DMA_BIDIRECTIONAL;
+
+	return scsi_dma_map(cmd);
+}
+
 /**
  * _base_build_sg_scmd - main sg creation routine
  *		pcie_device is unused here!
@@ -2718,7 +2734,7 @@ _base_build_sg_scmd(struct MPT3SAS_ADAPT
 	sgl_flags = sgl_flags << MPI2_SGE_FLAGS_SHIFT;
 
 	sg_scmd = scsi_sglist(scmd);
-	sges_left = scsi_dma_map(scmd);
+	sges_left = _base_scsi_dma_map(scmd);
 	if (sges_left < 0)
 		return -ENOMEM;
 
@@ -2862,7 +2878,7 @@ _base_build_sg_scmd_ieee(struct MPT3SAS_
 	}
 
 	sg_scmd = scsi_sglist(scmd);
-	sges_left = scsi_dma_map(scmd);
+	sges_left = _base_scsi_dma_map(scmd);
 	if (sges_left < 0)
 		return -ENOMEM;
 


