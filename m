Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F51F41B37C;
	Wed,  4 Feb 2026 15:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218727; cv=none; b=RA4FKdXAmrNTXcj2LADaQQ8r6I7djP/QpH0YiXRnehwauKVgaRRKkGO+hp3RZve2Q8GEE4hmY38nhpY5rZTZH1M1VTdzJz+ui7LXERApHRwC70rT0oWkmdBl8gWDIGpT3MT2thK8VQg1TBr7n74CxR0RKmQk8pFeuLcUvV2qr4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218727; c=relaxed/simple;
	bh=xkIp0huhjp3z5DkBB7YBsFHf25KagRl36eTOSBnBjo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s3iza7U6VsgOR+wAV7P0RyKmtL/GL+C/Sl5YE7/RQrW9PKvNGS5f8N7O+58/X3s/JxM5ul2Sip4K/OtHAgAbXWS5FnvppwtMK3SNTM/lLzwiSNkd6PwyLNkMvIhEWfo81fNDgwmfoTP8lp/tN1X61EDmv7l4hVgHT5gIuG66d28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GE3KStNi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GE3KStNi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D83F8C4CEF7;
	Wed,  4 Feb 2026 15:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218727;
	bh=xkIp0huhjp3z5DkBB7YBsFHf25KagRl36eTOSBnBjo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GE3KStNiv2cHRO+tYVbNoSuCryXmWjfJXTkIdbuvz1/WXvMI2V3EZIEKItWSl8mTZ
	 bSktKFTLO0FKP6MwKqWZxEDq8ylK/krjpVSbmqRWbaNsgkJOQex2/JK8vZ0tf38Rj+
	 IGEolWwRIRSCUnmFg6Mwwf0Jgg/x/23Eaxx3nfKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.12 42/87] scsi: qla2xxx: edif: Fix dma_free_coherent() size
Date: Wed,  4 Feb 2026 15:40:40 +0100
Message-ID: <20260204143848.429921932@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143846.906385641@linuxfoundation.org>
References: <20260204143846.906385641@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4484,7 +4484,7 @@ fail_lsrjt:
 fail_elsrej:
 	dma_pool_destroy(ha->purex_dma_pool);
 fail_flt:
-	dma_free_coherent(&ha->pdev->dev, SFP_DEV_SIZE,
+	dma_free_coherent(&ha->pdev->dev, sizeof(struct qla_flt_header) + FLT_REGIONS_SIZE,
 	    ha->flt, ha->flt_dma);
 
 fail_flt_buffer:


