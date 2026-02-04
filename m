Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A434B426EC1;
	Wed,  4 Feb 2026 15:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218438; cv=none; b=XRN+cKcTVUKAFB5QZbHWxWQsRTEpkdikiNZ19dOxsuahFSsI15U2mFX1lqOYhtCe+5oOtOFBSrLsFBTMn/dEBdVGPavac80cdFuZ3PGdpLOB5wGpR6+kje/8vZUDp/K3R6CY2mPrCZKk2FLOtEqhqxe5Fmfz3emAF71RZfjgy7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218438; c=relaxed/simple;
	bh=Hdpu7mzeMxOAiestlOGxIvhiKIZjd9bf/jzzxBa9mUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EayZ95/PK17lbtS5t5MQl9phCX6oRUej+ndiyvKPlI6k3riac3N3eR8EddGA9DN0peLDtuATfRrGrZ+mah/gZh4vlLgSbE/PN8p3bde+pyNASTiZhTiV7qlgrVGXJ3rHW6D5yUzrnjbYWq5RSQJt0y6BFSsWiVbJ9lK2utS3IIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UQOsvKeI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UQOsvKeI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4B9CC19425;
	Wed,  4 Feb 2026 15:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218438;
	bh=Hdpu7mzeMxOAiestlOGxIvhiKIZjd9bf/jzzxBa9mUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UQOsvKeI0YsA6QPrnKXLbtPFYSk5lk1U6IRajgwdCez9Kzi8u67Ns2iN6kzhnF7iJ
	 u4u85McJr873FYbSBAjfxhMji3xtKiEbqKZapI+ggHhzyxcN14F8RUnPp8H1eCXdpm
	 Z8duPI0WX2BdpccuadNPvIuFCiag/ihPTh1l6qI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 30/72] scsi: qla2xxx: edif: Fix dma_free_coherent() size
Date: Wed,  4 Feb 2026 15:40:33 +0100
Message-ID: <20260204143846.717883958@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143845.603454952@linuxfoundation.org>
References: <20260204143845.603454952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4482,7 +4482,7 @@ fail_lsrjt:
 fail_elsrej:
 	dma_pool_destroy(ha->purex_dma_pool);
 fail_flt:
-	dma_free_coherent(&ha->pdev->dev, SFP_DEV_SIZE,
+	dma_free_coherent(&ha->pdev->dev, sizeof(struct qla_flt_header) + FLT_REGIONS_SIZE,
 	    ha->flt, ha->flt_dma);
 
 fail_flt_buffer:


