Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3535F2D77FF;
	Wed, 25 Feb 2026 06:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002629; cv=none; b=sdzgBXI0XQyagJu5NthbSMDzrwYVaFvnqQ6z3PKJgjJEAx+hX9AQB25EjQWITdsTwvig0aHN2ZCumfFP2fvYcAZLzO42QlYq/S16mRGB+EoxzA5NZ9kEWOiWoCozYmdHOru3DljF6kOrl5gc2gviwJBZn8BQ7L8KJA0DiBRwS+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002629; c=relaxed/simple;
	bh=r7OjbhwFDjx2QAyb8042xX89N5/RH4NO74gAy0hoXVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dn9Vf1h/lLXq8/2yW/1xN1r5Bzjk4/J8qey+HxsHvPK8O3+iSWIU3l37RqIxWydM5t4wtWvUb5p0SorLcOAC9A1JB3/RuomaaYrtJJrbdMYkdsiOUdcZS+JuFjDg/30vWPCEuW8C9wEsxwq/jonDKCMxi9j2nH0nOaMfk4QjQN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PpV5sfbm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PpV5sfbm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F96DC116D0;
	Wed, 25 Feb 2026 06:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002629;
	bh=r7OjbhwFDjx2QAyb8042xX89N5/RH4NO74gAy0hoXVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PpV5sfbmWAWvz/8eqZOr4caaEln6FJqWV5SZmmkLWoEkgCFOWK3+SsELeiZaOfc1o
	 tMMegfkveWeW9NrxbxkZ7joyFgp/PX7sf0NWJitXWOBTNtItu6S7S6WFEuQCKKH+TN
	 vTZYuUKRWcVpHNQsqEJdqqWKv1AR5n/asaQCc8qA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Don Brace <don.brace@microchip.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 391/641] scsi: smartpqi: Fix memory leak in pqi_report_phys_luns()
Date: Tue, 24 Feb 2026 17:21:57 -0800
Message-ID: <20260225012358.051613886@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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
index 98e93900254cb..5a6e1bb57e7c8 100644
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



