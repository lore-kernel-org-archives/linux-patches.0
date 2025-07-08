Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2945881E;
	Tue,  8 Jul 2025 16:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992231; cv=none; b=bjemKnydv2mncXD221dAI92GdJT0Z1fZo0fGm4HPGKHd/Ji91FHXzvUWBk54WSK+D264uWrVF7Q0dqlw4dVR9CDJUbdHlR13pZadOy31wpGmnI/o/rYTGPNTVjvCLeIKEc1K1tQUZdrQLb4b1qTy2kAi2Yqt3c7BCMIsORi7/EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992231; c=relaxed/simple;
	bh=mODEdIfVXH/wYA/VllQKJuyFdRHxJdiiTkeFv7rDcjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fxe07mL2xhLCgpmSrYT+k7E7wwSOikznp7E5QbgR1he+xwT4Tg1cbT5QSIyhXKe5JKxDeb/ZJVpql5C8LD2QREiyEnVn23hLhSrWzrK1My6lCUuDVbPVIb10B8UuR8Wn8E7JG2qO2CesPOMKUv63B+aoTbqAQmQMdok10OuhtMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zxw9LtdU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zxw9LtdU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFC33C4CEED;
	Tue,  8 Jul 2025 16:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992231;
	bh=mODEdIfVXH/wYA/VllQKJuyFdRHxJdiiTkeFv7rDcjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zxw9LtdUrZPJvNVLCTNJSXHisPzRl5yDYV7nxtZqmyixAKNjWDEOD2T/ll+ly7J6i
	 65m+lHmiGm4NHt5q+3N9xir2UbmxJCoBGiSroXHryr8x3SZ9MVZVn0NyGRGJD9N4aD
	 cHGOwsve1ULxKwatm8U1DZewMjDr56BRzJLH3AAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 023/132] scsi: qla2xxx: Fix DMA mapping test in qla24xx_get_port_database()
Date: Tue,  8 Jul 2025 18:22:14 +0200
Message-ID: <20250708162231.400783059@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
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



