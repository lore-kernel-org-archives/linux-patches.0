Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B86BC2E49BD;
	Tue,  8 Jul 2025 17:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751994142; cv=none; b=Xu6CQfXEhPKiEfl+nkgNbmmFATOrJ7/PNiUK9j/2lYR/wThN9DC+QPBbvi9TvXNAlXTSg+m2AJChFBjQioVgYyxFA+X6Lfa4KUPXbr4Nch+sfO7o3MpRGCFolXY1FVBV9ydU5vOZaOw5sSAuGZNkGDfV7xwrwJOMsfhKoGgFsFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751994142; c=relaxed/simple;
	bh=MTb+yEDDtsiHnZ+3/1eue8UXyBNf8QMUVxxUP/qOz/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YmgmilHVNbPO6QROjHXRGnuHv52OdTljoo2I8zOzBU7a8N0fdeAY7cn0Sp2CH08M8IXAKgDM5NMbfHn6Q+X3blREsTRNi1BbHfnD8naAhsjwRsRcoH3pfWaSnkqp/h4V3uU6UqeuxX+Gpsy9QhFFKZOGbiOBE9qDaVeG20YrOxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wT9Y3lfJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wT9Y3lfJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41F0DC4CEED;
	Tue,  8 Jul 2025 17:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751994142;
	bh=MTb+yEDDtsiHnZ+3/1eue8UXyBNf8QMUVxxUP/qOz/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wT9Y3lfJ+KBqx4f5zaQbvxBHYmPlFZRYqK3Pz8BRYYF5VV9S1zvt619thzUGAAIj3
	 rIVTNhUJpeDonN7pYKQ3zMi7ZhKXImXoJUO/fG9uQdC37PlFOmP27svtYV+E5JBqNS
	 IVdco7a7OIfczZn/IyMIoAPWc/Qfmjy3gT6kSmaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 109/160] scsi: qla2xxx: Fix DMA mapping test in qla24xx_get_port_database()
Date: Tue,  8 Jul 2025 18:22:26 +0200
Message-ID: <20250708162234.499284401@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit c3b214719a87735d4f67333a8ef3c0e31a34837c ]

dma_map_XXX() functions return as error values DMA_MAPPING_ERROR which is
often ~0.  The error value should be tested with dma_mapping_error() like
it was done in qla26xx_dport_diagnostics().

Fixes: 818c7f87a177 ("scsi: qla2xxx: Add changes in preparation for vendor extended FDMI/RDP")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Link: https://lore.kernel.org/r/20250617161115.39888-2-fourier.thomas@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index d2ff54beb7cd7..7a28582b1f73a 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2141,7 +2141,7 @@ qla24xx_get_port_database(scsi_qla_host_t *vha, u16 nport_handle,
 
 	pdb_dma = dma_map_single(&vha->hw->pdev->dev, pdb,
 	    sizeof(*pdb), DMA_FROM_DEVICE);
-	if (!pdb_dma) {
+	if (dma_mapping_error(&vha->hw->pdev->dev, pdb_dma)) {
 		ql_log(ql_log_warn, vha, 0x1116, "Failed to map dma buffer.\n");
 		return QLA_MEMORY_ALLOC_FAILED;
 	}
-- 
2.39.5



