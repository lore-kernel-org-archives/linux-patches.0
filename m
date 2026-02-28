Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB7938F62E
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302200; cv=none; b=J5Am9Jww1LNrM4AMYdc9YD6jv/amSvPqOTvNc6l6d/qJq2Z1yhRM7BW4m5mmMbf1EKDC5wDTUKSPo2Ba0ZpJQcwXGpceBuOWrEP150D+TqsG6jKFcWkk50pPF83ujuHsra8iif7AGQKi//YA3kCwARPduVY82s8ypQLuR95Aaxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302200; c=relaxed/simple;
	bh=/AIIO0Tr81xWppELZO87MCvTTd9y8qnXUfM526F6rco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hGnDa9Ve0C7iBdv0FDY3eWmlQAejRmRYtb8tRP9bSkyE7g7fN9ZehdCpGLL5bjoX3hsNNH4FQJq8kEB9t1CLTtCTPkC8pAe2poytPsuLmHC9ZUfVHlHEs8Nfv9i0+wfW7gQkwidJUS7gwLkv1UB9ZGRunzI47da486khl9BgnEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hMnHAK6S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hMnHAK6S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 784B2C19425;
	Sat, 28 Feb 2026 18:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302200;
	bh=/AIIO0Tr81xWppELZO87MCvTTd9y8qnXUfM526F6rco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hMnHAK6Spu6CY6bMXo4TChBg8orzn0+FTxTjNoe4yXsMd82lV0W4jNH6Db31RUxsh
	 tRX+SWj6LEvgucqYEH7EAPeDKrNKFoJHGtkxI1YhC+SSxJKGJ8DC/LuDPvh+wvgoxD
	 vQYF/EvvQbCnkTpPNS5Yj1tp4guOXJ2k/Lh/SLtIbucGE8/uGUqMn9VhaCCqUhycZ+
	 AZ9EQE6DgDocOwl9UZIaqZLmD6RYMP7uGVV15Awxie+LyuHyNrWzO7fEoyQQWSHv69
	 XDVqDeaAT0p5nCudZPuB97hYmwh66FaFfeP02E5nktD0gAASpTLFZdTEqOjqKu/Sf/
	 /a8K4UY5AAblw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Zilin Guan <zilin@seu.edu.cn>,
	Don Brace <don.brace@microchip.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 204/283] scsi: smartpqi: Fix memory leak in pqi_report_phys_luns()
Date: Sat, 28 Feb 2026 13:05:46 -0500
Message-ID: <20260228180709.1583486-204-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index 0cdeb7aa55020..dc194c76f38b7 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -1240,7 +1240,8 @@ static inline int pqi_report_phys_luns(struct pqi_ctrl_info *ctrl_info, void **b
 			dev_err(&ctrl_info->pci_dev->dev,
 				"RPL returned unsupported data format %u\n",
 				rpl_response_format);
-			return -EINVAL;
+			rc = -EINVAL;
+			goto out_free_rpl_list;
 		} else {
 			dev_warn(&ctrl_info->pci_dev->dev,
 				"RPL returned extended format 2 instead of 4\n");
@@ -1252,8 +1253,10 @@ static inline int pqi_report_phys_luns(struct pqi_ctrl_info *ctrl_info, void **b
 
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
@@ -1274,6 +1277,10 @@ static inline int pqi_report_phys_luns(struct pqi_ctrl_info *ctrl_info, void **b
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

