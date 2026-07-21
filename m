Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D385D3346A6;
	Tue, 21 Jul 2026 18:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659028; cv=none; b=W2A35m8a2hWxTORLe/Nzg2WsiP1zYUF/RGsdyghUMRR6yxjW78rjvx0ik//zICGMy+b711eF6Ma7jdA3Ioxcui/buzdqmZJBRIZju+0/IMMrs9gWkjjsrJmfLO2DC8mNxCjCJFzm8aWRlFWbavQkxJufeTnHQRqjLYdpG1xBPNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659028; c=relaxed/simple;
	bh=1kXanpGJrLBpxTvqQmuMj7rdUyuraw/2KjYX1jXGZ+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pMyJxM++cN3qPng7Pl4K+18/48Js1GhnW5urA9uQ7lDuSV2qbuDXB9ZsshQzAhgqVRd/klDhiH94POxGHVOTZGVCAaGKUs44H/yt1wdyCyN2opBcqNyku60148r3mY4OrCNzN+Z4OCcqw1XZaSEfj/Sjkpr1Yy4UR4xbFQN3JzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GtZ7DxQr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GtZ7DxQr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 460EA1F000E9;
	Tue, 21 Jul 2026 18:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659027;
	bh=3HDR8p0s9GE1HfdOTl9VB1QG6niPOAkPgdFSx0N0X4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GtZ7DxQrNOgLpBXPdC+fXGSh7yi7e/FH5UvX6G0Qbot/iDS4yiMNmQVUY1RtGM2u0
	 amCKwVdY1CBj8wTvTb624HjqUXE48228vTFSyKZbPvbOa4foyQAQdeYUpHCWiXY7CI
	 qT6SlQcG7nCnPcdPkw8aP0zWSU0KZ+GKdZC5ooI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.18 1366/1611] scsi: lpfc: Fix memory leak in lpfc_sli4_driver_resource_setup()
Date: Tue, 21 Jul 2026 17:24:42 +0200
Message-ID: <20260721152546.176637878@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

commit 1bd28625e25be549ee7c47532e7c3ef91c682410 upstream.

The memory allocated for mboxq using mempool_alloc() is not freed in
some of the early exit error paths. Fix that by moving the
mempool_free() call to an earlier point after last use.

Fixes: d79c9e9d4b3d ("scsi: lpfc: Support dynamic unbounded SGL lists on G7 hardware.")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Reviewed-by: Justin Tee <justin.tee@broadcom.com>
Link: https://patch.msgid.link/20260707065304.949135-1-nihaal@cse.iitm.ac.in
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/lpfc/lpfc_init.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -8194,6 +8194,7 @@ lpfc_sli4_driver_resource_setup(struct l
 		mempool_free(mboxq, phba->mbox_mem_pool);
 		goto out_free_bsmbx;
 	}
+	mempool_free(mboxq, phba->mbox_mem_pool);
 
 	/*
 	 * 1 for cmd, 1 for rsp, NVME adds an extra one
@@ -8316,8 +8317,6 @@ lpfc_sli4_driver_resource_setup(struct l
 		goto out_free_sg_dma_buf;
 	}
 
-	mempool_free(mboxq, phba->mbox_mem_pool);
-
 	/* Verify OAS is supported */
 	lpfc_sli4_oas_verify(phba);
 


