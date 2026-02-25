Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D260F1EB5E1;
	Wed, 25 Feb 2026 01:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983372; cv=none; b=rCIbwIijITKX44ck9u8wpaVCjiWjLKcKa7aGzgBbjv2Qqm5bdtQyPkcx14abEuXHhvMjoSQAHhUdLiRVBp6TC7EFutMBM1SnOAuEKNEC6G+QJRhiEfuqMY36K5E7Ffl10YWWfcqA2KDyPSugpu2cjLI/dKojv7Ac9MjrJ6ERyjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983372; c=relaxed/simple;
	bh=f9C/d4mo/GSdTxN9fTAtnwCqW7HCtQ2ZXMU48avg9uE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m/IZj3ja6MyYU2pg/xleztA+64j9BkiJijjXaOSlnq+BwJt9ByhtfTwR3UjZwSs5+8p9rxLGfrVx/7s4AVJ+zIEfZqHFqtS0nqBh8eBD30JxqKye6Q+sTIeeE3A5ZK0+Tvo8wOaiMR3u+AYJdmLRXzI0QOqa6/YPpbuo9t1AJKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V339VKSO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V339VKSO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8743DC19423;
	Wed, 25 Feb 2026 01:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983372;
	bh=f9C/d4mo/GSdTxN9fTAtnwCqW7HCtQ2ZXMU48avg9uE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V339VKSOmyL2BlhYc9pIkS2qkoqeBLP7+ywA3ZnaNSU2GI41YxbBi2m5ebtHsjpLA
	 3c6ki3k+3nn3LvJNtji9PGlOmeBywcDDmM6vOOhJf0QVZsXET02sbkt6FS6ClgrK1u
	 URXE6o5h6bTM47LLwmNOPLiaeUgzd1k8f/YpiTQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Don Brace <don.brace@microchip.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 498/781] scsi: smartpqi: Fix memory leak in pqi_report_phys_luns()
Date: Tue, 24 Feb 2026 17:20:07 -0800
Message-ID: <20260225012412.017241961@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index fe549e2b7c940..c829d9590558d 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -1241,7 +1241,8 @@ static inline int pqi_report_phys_luns(struct pqi_ctrl_info *ctrl_info, void **b
 			dev_err(&ctrl_info->pci_dev->dev,
 				"RPL returned unsupported data format %u\n",
 				rpl_response_format);
-			return -EINVAL;
+			rc = -EINVAL;
+			goto out_free_rpl_list;
 		} else {
 			dev_warn(&ctrl_info->pci_dev->dev,
 				"RPL returned extended format 2 instead of 4\n");
@@ -1253,8 +1254,10 @@ static inline int pqi_report_phys_luns(struct pqi_ctrl_info *ctrl_info, void **b
 
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
@@ -1275,6 +1278,10 @@ static inline int pqi_report_phys_luns(struct pqi_ctrl_info *ctrl_info, void **b
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



