Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E502E92DE;
	Tue, 15 Jul 2025 13:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587635; cv=none; b=vDoxaKdy83sS489K1V/76+hRaurNdBFH8PfmgBiJlYA2dYDYWmc3wdMw+BAKRDdMiV1F/fdHKFUz2MtSqNea77Ekp9/0WY69l38TyaFET5VMLcW+JbZliMGYaWMfPnW53+ATYoIKYxc4hzkdM4xEecUY5sDzQG2GJ8ac1yJkldI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587635; c=relaxed/simple;
	bh=s+oziVp/RsM2En5cUb/5L2CDVDaI2n//XSiVflGRjGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XeMIJMB7WEIx1zuSF1Ud940z9vUFYNlRZHmTeDRjeI8tgIO4WXew3PRzNlnrZxX++z6a+UW4N2wtqRUyicgLigtif4AOsdwXs56lucU1cx65eOe6SS+BtbBMHInDTg2xRWXqUBLzzdRRD0zdGGbN1gcXGbokQney51X07s8jw2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zvBCjkgk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zvBCjkgk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72C9AC4CEF4;
	Tue, 15 Jul 2025 13:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587633;
	bh=s+oziVp/RsM2En5cUb/5L2CDVDaI2n//XSiVflGRjGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zvBCjkgk1MpFNAF49PxTQo7nyx/ghDEiJUsx4NY9bQwjmUKJnPxMybCbE/Hm1D0rQ
	 8h8nV+snJy8AQgK30A3aNa6untBGkpqcc1BdSFheZ/uiUJnGeuBpdXst7daKQPbA2O
	 MTZ3DKdczHtsU/wFUAmlbeXPhRTRRfecFnubb3gA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 085/208] scsi: qla2xxx: Fix DMA mapping test in qla24xx_get_port_database()
Date: Tue, 15 Jul 2025 15:13:14 +0200
Message-ID: <20250715130814.347632522@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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
index 21ba7100ff676..8b7c71e779a78 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2097,7 +2097,7 @@ qla24xx_get_port_database(scsi_qla_host_t *vha, u16 nport_handle,
 
 	pdb_dma = dma_map_single(&vha->hw->pdev->dev, pdb,
 	    sizeof(*pdb), DMA_FROM_DEVICE);
-	if (!pdb_dma) {
+	if (dma_mapping_error(&vha->hw->pdev->dev, pdb_dma)) {
 		ql_log(ql_log_warn, vha, 0x1116, "Failed to map dma buffer.\n");
 		return QLA_MEMORY_ALLOC_FAILED;
 	}
-- 
2.39.5



