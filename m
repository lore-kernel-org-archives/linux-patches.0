Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A4123D2AB;
	Tue,  8 Jul 2025 16:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993364; cv=none; b=pareL+k45Cto/o63KfrKZY6ioG4pCvWu8uxcq9Du39SMsUP8ivw16hxZkbU8p3SAI4S//vbdPHG+Rj4oEnV74Jj4kfx0fdliBcQR0FuBcfn1QDCEQxzSMUlbZHyvP/XteBvMt7gtcW1llK+Md4Muyt2Gs3RhltpA6gGQwmCGjsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993364; c=relaxed/simple;
	bh=UH98qpj8p+Wnkbq5Q12KATVX+kfcVfXnymdjRyLqRq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dXMSPHD0a88DAeF56UTNmb5EBCW18WaXmEPgyDllCCc4t41XYIXrQXckdsayqRdtH3RaZ/x3f1A7sGAIxI0kzak01FZ1Ap65ZqM0UIZ4r+L9CGwx8SL3/i81zv9sRQLiLRQA2Zvy2uU3moU+o0eTSd32LjzoyTgMkGBQXJKYHFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yvCxgHwZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yvCxgHwZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CFEBC4CEED;
	Tue,  8 Jul 2025 16:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993364;
	bh=UH98qpj8p+Wnkbq5Q12KATVX+kfcVfXnymdjRyLqRq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yvCxgHwZ5yJ4vFBwd8sp4DgTu/i6d+5SL/QQyH8Z2aixId4hVr5FM3I/iG6ae4zvf
	 qJlQJls1JzKZsabilXm0qUALymED/WB0fEmkGYT3AYCyT/VeE6uiD41U+FLJbv5nDR
	 i+IEXRq1M74Ga0rFBax4KLTMwad7SQUtmOaT+rPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 049/178] scsi: qla2xxx: Fix DMA mapping test in qla24xx_get_port_database()
Date: Tue,  8 Jul 2025 18:21:26 +0200
Message-ID: <20250708162237.966786448@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 0cd6f3e148824..13b6cb1b93acd 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2147,7 +2147,7 @@ qla24xx_get_port_database(scsi_qla_host_t *vha, u16 nport_handle,
 
 	pdb_dma = dma_map_single(&vha->hw->pdev->dev, pdb,
 	    sizeof(*pdb), DMA_FROM_DEVICE);
-	if (!pdb_dma) {
+	if (dma_mapping_error(&vha->hw->pdev->dev, pdb_dma)) {
 		ql_log(ql_log_warn, vha, 0x1116, "Failed to map dma buffer.\n");
 		return QLA_MEMORY_ALLOC_FAILED;
 	}
-- 
2.39.5



