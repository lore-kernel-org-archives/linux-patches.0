Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F078F2DECB2
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301867; cv=none; b=AaKcgh9KVuY7fltzbRcS6qsKPya2OsrAWleWOf4p5IE6ubYeYnohMSxTM61Ox0rEBwmt3cZQ605F7dZg5qp9/Ary7w51n6M8u5JRahiJceexWaF5iSG4zihtL6gIQYFjFVJsQvLfSho0lt0TTPP6zPG3Z1wpWxnK3Nn7e7Ug1tI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301867; c=relaxed/simple;
	bh=kgbyvQJ4NpjPLnQFuXcApcskAhErNDLym6+0ZaVJuQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ABiX5t2uZvDWymHv5MBQhqOqmmM7bozhsxDHgoIwjzLispO0SxBHNfgvpKmzmu8pJOroevwucATsdHPFnrvjM/Nz9w3SfqHGIBvhnEeTfoipuSHuAA7fRSFPBwF/vDRPiqSBO8LjMK2EUCCTNq/dNQ10IFJ/SoRzdSnlD/wKOxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BdN0kyZC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BdN0kyZC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A098C19424;
	Sat, 28 Feb 2026 18:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301866;
	bh=kgbyvQJ4NpjPLnQFuXcApcskAhErNDLym6+0ZaVJuQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BdN0kyZCSBZcsvKHLoZ0v7TjhzMvZKkciNYtizOfd7O2wO89ej/+oDvhUl8qtgNxA
	 Qndina4eboFdIJUhcIULiIOJJ4f+ntVoVrrxu7ASnvg9Ql8UO4cJw7/ltgrfav59Ju
	 4an0CnW/lKjtVbotztB4cqo+3nRHJ/F+vVnPlgbm+7834tMaKGMgq6Z20/9lAQVbE1
	 mNeA99MnYyac9iaNmr/fmcrWRX1uCQRASMan1w5IE4F2/4z9ys/z4fQtQI3qghiJQd
	 zfFBMYKT8v6N7v1WR1Y44KRMPEJvHQX68qhlY8VWuTwXDgnGGgCwNFLG1CpjQJlrox
	 0gJcdQ4I82rzA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Zilin Guan <zilin@seu.edu.cn>,
	Don Brace <don.brace@microchip.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 290/385] scsi: smartpqi: Fix memory leak in pqi_report_phys_luns()
Date: Sat, 28 Feb 2026 12:58:32 -0500
Message-ID: <20260228180011.1568201-290-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit 41b37312bd9722af77ec7817ccf22d7a4880c289 ]

pqi_report_phys_luns() fails to release the rpl_list buffer when
encountering an unsupported data format or when the allocation for
rpl_16byte_wwid_list fails. These early returns bypass the cleanup logic,
leading to memory leaks.

Consolidate the error handling by adding an out_free_rpl_list label and use
goto statements to ensure rpl_list is consistently freed on failure.

Compile tested only. Issue found using a prototype static analysis tool and
code review.

Fixes: 28ca6d876c5a ("scsi: smartpqi: Add extended report physical LUNs")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Tested-by: Don Brace <don.brace@microchip.com>
Acked-by: Don Brace <don.brace@microchip.com>
Link: https://patch.msgid.link/20260131093641.1008117-1-zilin@seu.edu.cn
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index f0fb22e4117eb..e7836f66c89ad 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -1239,7 +1239,8 @@ static inline int pqi_report_phys_luns(struct pqi_ctrl_info *ctrl_info, void **b
 			dev_err(&ctrl_info->pci_dev->dev,
 				"RPL returned unsupported data format %u\n",
 				rpl_response_format);
-			return -EINVAL;
+			rc = -EINVAL;
+			goto out_free_rpl_list;
 		} else {
 			dev_warn(&ctrl_info->pci_dev->dev,
 				"RPL returned extended format 2 instead of 4\n");
@@ -1251,8 +1252,10 @@ static inline int pqi_report_phys_luns(struct pqi_ctrl_info *ctrl_info, void **b
 
 	rpl_16byte_wwid_list = kmalloc(struct_size(rpl_16byte_wwid_list, lun_entries,
 						   num_physicals), GFP_KERNEL);
-	if (!rpl_16byte_wwid_list)
-		return -ENOMEM;
+	if (!rpl_16byte_wwid_list) {
+		rc = -ENOMEM;
+		goto out_free_rpl_list;
+	}
 
 	put_unaligned_be32(num_physicals * sizeof(struct report_phys_lun_16byte_wwid),
 		&rpl_16byte_wwid_list->header.list_length);
@@ -1273,6 +1276,10 @@ static inline int pqi_report_phys_luns(struct pqi_ctrl_info *ctrl_info, void **b
 	*buffer = rpl_16byte_wwid_list;
 
 	return 0;
+
+out_free_rpl_list:
+	kfree(rpl_list);
+	return rc;
 }
 
 static inline int pqi_report_logical_luns(struct pqi_ctrl_info *ctrl_info, void **buffer)
-- 
2.51.0

