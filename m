Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C95035690A;
	Tue, 26 Aug 2025 14:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218258; cv=none; b=figToWETOhGeyZd1fuC7JN/fRW9bMOyYFCHP13wpmgglUFfp/9EFwmMWmO+tokgqTPSvfyQV2R0oUyNGaIJipw/0N81Bxozxlm+/+HgVfkyAz6FExesWfYcysE4wM4hgLVyqqK6r6umi+vt0d8dmz/Ge4RI+5yfXOKEsC/ZYEKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218258; c=relaxed/simple;
	bh=7vfTfbvwnGtjjyJyxR+6TitsQmPGUwXVhHUWUs658e0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QAEFkEBP94gBlI4cchvUqrK/fkUcgBBnuySctq62+8B7RlG7nZglq5YqaD+DpQ4nTjUz8H+N0DKpOsnUjhpbZwFs75DIWL4BEqBMdi/4peSBLPhSvP1vyUgnmgTbFD4fDaD1AafN+6qXdnQsI4DDHWAEXL+bzZEY0/HY49ZMInE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vCLPErmD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vCLPErmD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6DA8C4CEF1;
	Tue, 26 Aug 2025 14:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218258;
	bh=7vfTfbvwnGtjjyJyxR+6TitsQmPGUwXVhHUWUs658e0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vCLPErmDOtlIlqUDlC3FCinkfbrQr2/GlcP4AX2Oxn7O1+Si5/MPceewGu63McFre
	 6by7UVGES5hhRNvH6S5dofCERmAZZGBuDR9LM2jAvXiTD5R2L2yT4ai3ZKfHHi+9zz
	 dNp0dbT5ysLwXKVCxWs8+kdsV4UViTkRSH3UmHfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Wang <jinpu.wang@ionos.com>,
	Ajish Koshy <Ajish.Koshy@microchip.com>,
	Viswas G <Viswas.G@microchip.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	Shivani Agarwal <shivani.agarwal@broadcom.com>
Subject: [PATCH 5.10 454/523] scsi: pm80xx: Fix memory leak during rmmod
Date: Tue, 26 Aug 2025 13:11:04 +0200
Message-ID: <20250826110935.649092161@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ajish Koshy <Ajish.Koshy@microchip.com>

[ Upstream commit 51e6ed83bb4ade7c360551fa4ae55c4eacea354b ]

Driver failed to release all memory allocated. This would lead to memory
leak during driver removal.

Properly free memory when the module is removed.

Link: https://lore.kernel.org/r/20210906170404.5682-5-Ajish.Koshy@microchip.com
Acked-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Ajish Koshy <Ajish.Koshy@microchip.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
[Shivani: Modified to apply on 5.10.y]
Signed-off-by: Shivani Agarwal <shivani.agarwal@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/pm8001/pm8001_init.c |   11 +++++++++++
 drivers/scsi/pm8001/pm8001_sas.h  |    1 +
 2 files changed, 12 insertions(+)

--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -1166,6 +1166,7 @@ pm8001_init_ccb_tag(struct pm8001_hba_in
 		goto err_out;
 
 	/* Memory region for ccb_info*/
+	pm8001_ha->ccb_count = ccb_count;
 	pm8001_ha->ccb_info = (struct pm8001_ccb_info *)
 		kcalloc(ccb_count, sizeof(struct pm8001_ccb_info), GFP_KERNEL);
 	if (!pm8001_ha->ccb_info) {
@@ -1226,6 +1227,16 @@ static void pm8001_pci_remove(struct pci
 			tasklet_kill(&pm8001_ha->tasklet[j]);
 #endif
 	scsi_host_put(pm8001_ha->shost);
+
+	for (i = 0; i < pm8001_ha->ccb_count; i++) {
+		dma_free_coherent(&pm8001_ha->pdev->dev,
+			sizeof(struct pm8001_prd) * PM8001_MAX_DMA_SG,
+			pm8001_ha->ccb_info[i].buf_prd,
+			pm8001_ha->ccb_info[i].ccb_dma_handle);
+	}
+	kfree(pm8001_ha->ccb_info);
+	kfree(pm8001_ha->devices);
+
 	pm8001_free(pm8001_ha);
 	kfree(sha->sas_phy);
 	kfree(sha->sas_port);
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -515,6 +515,7 @@ struct pm8001_hba_info {
 	u32			iomb_size; /* SPC and SPCV IOMB size */
 	struct pm8001_device	*devices;
 	struct pm8001_ccb_info	*ccb_info;
+	u32			ccb_count;
 #ifdef PM8001_USE_MSIX
 	int			number_of_intr;/*will be used in remove()*/
 	char			intr_drvname[PM8001_MAX_MSIX_VEC]


