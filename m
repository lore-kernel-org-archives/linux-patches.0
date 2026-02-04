Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B4D12BE035;
	Wed,  4 Feb 2026 15:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217200; cv=none; b=MOm/FxqtgI0ylPm2LRK4la15ZE7di44FGXZ4W+wk0WhCT2gUJDACbqB49K/QS86GPWdk1nYeucNqL0SnIAIKkmee/Ttn5+MHGnIekIhz/RUqu8NBknG2r0xMlFeIjUBvNjDvrUUAY4E5eX2r17e7t9aYagA1fjnO7Z2YKUIWX7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217200; c=relaxed/simple;
	bh=6gbXmXe6diIBsJhpeYlh2vfoAq9vCfhwZJeav5dHGi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=abfkYbhCKAEAmm3S/TP6kZry0QNrnzUX7UhzPI2HLhJMmF+xZarPbLzE6dPPMIEjrAPhHmEexpAHTOFqR+ZXgjvt5Ga+erBnF+IyCCv6D3OeHiX1PGtu6rhXz3vCwDlTGQi5j1epXmvgeYE/UgL97Si9gdx2g0sENFk9eynViQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hhhp27bU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hhhp27bU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9B9AC4CEF7;
	Wed,  4 Feb 2026 14:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217200;
	bh=6gbXmXe6diIBsJhpeYlh2vfoAq9vCfhwZJeav5dHGi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hhhp27bUotuDCPGsbnrgX5mQnFnDnHLzE5xGRcxhZjtxDQ5O4h22kD/4ubegj+Kio
	 kXG40VvrZBiqs9jN3nswZH06Kwj5GbBaEbBaqeOKp5rrDl/C8ocbgbLXlvhU8wfG6H
	 Bwi2gQJqhgolSAs+iLI0Y5YM5GOjgp8rzofWTxDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 153/206] scsi: qla2xxx: edif: Fix dma_free_coherent() size
Date: Wed,  4 Feb 2026 15:39:44 +0100
Message-ID: <20260204143903.712913133@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
User-Agent: quilt/0.69
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

commit 56bd3c0f749f45793d1eae1d0ddde4255c749bf6 upstream.

Earlier in the function, the ha->flt buffer is allocated with size
sizeof(struct qla_flt_header) + FLT_REGIONS_SIZE but freed in the error
path with size SFP_DEV_SIZE.

Fixes: 84318a9f01ce ("scsi: qla2xxx: edif: Add send, receive, and accept for auth_els")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Link: https://patch.msgid.link/20260112134326.55466-2-fourier.thomas@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_os.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4431,7 +4431,7 @@ qla2x00_mem_alloc(struct qla_hw_data *ha
 fail_elsrej:
 	dma_pool_destroy(ha->purex_dma_pool);
 fail_flt:
-	dma_free_coherent(&ha->pdev->dev, SFP_DEV_SIZE,
+	dma_free_coherent(&ha->pdev->dev, sizeof(struct qla_flt_header) + FLT_REGIONS_SIZE,
 	    ha->flt, ha->flt_dma);
 
 fail_flt_buffer:


