Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB102359A61
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302426; cv=none; b=ojYEp5yzIkYMmWRynJgdudEgzCTdMkwN/46wPSiiTikfeQ/XAbEf5vP/ewHHdQU2Ky038FsrOn1pQbFFowNpWbFfvEcBwLabpHHljoCNVU2T3/UqZ5yR44txkFuZA2H5vT/mvyasTM/F6rx8f4+EhOIjdATGxCtViMDd0C45bEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302426; c=relaxed/simple;
	bh=3zms6Cqqxv9XnDs71dweZOUuwLLD4UqXPLFb7Oeiet0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZNBYiNZqOKxFZWxniWF/lgPR/xhsdR+4ILw7GWUSc1sow+Y8Z8VL3Bo7xjjjDLBchS3ngt6mQkN69nskybRHtPa3j9SM8sMEkLBlj4tNyHc8oEvYg3ghIOpvs0VW+IyBusLG9zY4YS4mISdf9V8Cw7MX8+rr5HX68NfKkQhMjBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G2XkKdTB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G2XkKdTB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04820C19423;
	Sat, 28 Feb 2026 18:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302426;
	bh=3zms6Cqqxv9XnDs71dweZOUuwLLD4UqXPLFb7Oeiet0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G2XkKdTBZh3VvSTQhBRJl7E3cygJ4C1CdG/OVvWxF13l7XeaswFDTdbuQjhEXct13
	 4P22ivpINupkRBDtsxmt/IrkxPVLzUXogMTrGSqW4ClwLDQ9QxEXBBWdVqvbwFt4/g
	 BakkS3pbh15Za9zRbEOBv4IKn+b9ETsrzLqWD/IVLKqS0we3PEEdEhaiAl8rmW/Fn+
	 HrfJZpD2L/OjELXiCC+F5l7jUazkiX1vaJcpcDrrqGbdhK/I/OUo9L8MzXl7MiWcQK
	 ujPjGXGMacXG/KRx9Lykal7Nz/jlLyKHruZiX6X+MDOtIf3jHGi8KcOgE8TVIKI10x
	 NnmNEQXP4jR2w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Zilin Guan <zilin@seu.edu.cn>,
	Don Brace <don.brace@microchip.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 163/232] scsi: smartpqi: Fix memory leak in pqi_report_phys_luns()
Date: Sat, 28 Feb 2026 13:10:16 -0500
Message-ID: <20260228181127.1592657-163-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index 5c0f23dd808c4..5dd116554ef62 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -1213,7 +1213,8 @@ static inline int pqi_report_phys_luns(struct pqi_ctrl_info *ctrl_info, void **b
 			dev_err(&ctrl_info->pci_dev->dev,
 				"RPL returned unsupported data format %u\n",
 				rpl_response_format);
-			return -EINVAL;
+			rc = -EINVAL;
+			goto out_free_rpl_list;
 		} else {
 			dev_warn(&ctrl_info->pci_dev->dev,
 				"RPL returned extended format 2 instead of 4\n");
@@ -1225,8 +1226,10 @@ static inline int pqi_report_phys_luns(struct pqi_ctrl_info *ctrl_info, void **b
 
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
@@ -1247,6 +1250,10 @@ static inline int pqi_report_phys_luns(struct pqi_ctrl_info *ctrl_info, void **b
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

