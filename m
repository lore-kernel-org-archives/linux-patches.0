Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF163C46C
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S2m/wAOg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F08E9C433C7;
	Wed, 15 Nov 2023 19:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077551;
	bh=e/dw/pXZAO/IZsYr2uFhqhDbNSl+3ucNuNjZNRvVPho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S2m/wAOggoHCyZJIAvrEQZf1RTFcix7QViHrTG4YeISKrf+7M2VeIuIKlJtdmp4SY
	 mHDKZlhZl6TEZd0qY5Y+iKGFJaCP/9X6CDX5rvKbxX6iVQc7s1pjgi89324EtTXXoA
	 XDGJE7Ge8p+DCv5WD6Olh3iNojsmQQ86/gUBUvg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tyrel Datwyler <tyreld@linux.ibm.com>,
	Brian King <brking@linux.vnet.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 351/603] scsi: ibmvfc: Fix erroneous use of rtas_busy_delay with hcall return code
Date: Wed, 15 Nov 2023 14:14:56 -0500
Message-ID: <20231115191637.818076947@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tyrel Datwyler <tyreld@linux.ibm.com>

[ Upstream commit 670106eb4c8b23475f8c2b3416005a312afa622f ]

Commit 0217a272fe13 ("scsi: ibmvfc: Store return code of H_FREE_SUB_CRQ
during cleanup") wrongly changed the busy loop check to use
rtas_busy_delay() instead of H_BUSY and H_IS_LONG_BUSY(). The busy return
codes for RTAS and hypercalls are not the same.

Fix this issue by restoring the use of H_BUSY and H_IS_LONG_BUSY().

Fixes: 0217a272fe13 ("scsi: ibmvfc: Store return code of H_FREE_SUB_CRQ  during cleanup")
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Link: https://lore.kernel.org/r/20230921225435.3537728-5-tyreld@linux.ibm.com
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index ce9eb00e2ca04..470e8e6c41b62 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -22,7 +22,6 @@
 #include <linux/bsg-lib.h>
 #include <asm/firmware.h>
 #include <asm/irq.h>
-#include <asm/rtas.h>
 #include <asm/vio.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -5804,7 +5803,7 @@ static int ibmvfc_register_scsi_channel(struct ibmvfc_host *vhost,
 irq_failed:
 	do {
 		rc = plpar_hcall_norets(H_FREE_SUB_CRQ, vdev->unit_address, scrq->cookie);
-	} while (rtas_busy_delay(rc));
+	} while (rc == H_BUSY || H_IS_LONG_BUSY(rc));
 reg_failed:
 	LEAVE;
 	return rc;
-- 
2.42.0



