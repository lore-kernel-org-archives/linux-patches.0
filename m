Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 776CE1F4C90;
	Tue, 26 Aug 2025 14:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217409; cv=none; b=hCA+YHfQWnaoyWDAA/9rm2U7YHJtzcpN5EgvtQrnLs4D1cxkufoSTAlbr1EDxiIvK4U6iotkPmJ1DBSspobRYFZdhMdnGIJEvM/lq1kPfco/4xwlO+OcHX7tup5EnLgsjE7b6cwxOulJ4f+tt3v6HMgr7Sy57+amNSX3w5rMBJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217409; c=relaxed/simple;
	bh=u29hMmuRpwnn7pAyUmd7NmNIYuIxEBRgQ6dN6NDgQ1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AVihXNR9qMLAeSegArmCYgi1qIqrzoPegzUgXT0cQud9Slhs++BDClSVgVMy1Sn60MqOr74snUPenEL1YMcpz1LFhG6F4UlJDAn2mku4U+Wqmsb1yswp+toBMjbJZqlfcBkxCMlIZKbCDgmZ0TnD4o+mxd/i/o9XQJbC39rf//E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M5wFSKLT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M5wFSKLT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0894CC4CEF1;
	Tue, 26 Aug 2025 14:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217409;
	bh=u29hMmuRpwnn7pAyUmd7NmNIYuIxEBRgQ6dN6NDgQ1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M5wFSKLTmh/IJ07dUb7oGx2LiWOxDZvauBK+ilWzy8jUn9NBQFntiSrVCK6xUi9iQ
	 ZFyOvqtcK3EuuHf6YTPw6naDsHUvWWW9i+DFaoxAT28rqRuCtWh5QNSbBkYepQ49jH
	 ay6XAJMRkLTTLWi49e9mB7EMgqhz7goCwMTf1brs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 131/523] scsi: mvsas: Fix dma_unmap_sg() nents value
Date: Tue, 26 Aug 2025 13:05:41 +0200
Message-ID: <20250826110927.734714277@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit 0141618727bc929fe868153d21797f10ce5bef3f ]

The dma_unmap_sg() functions should be called with the same nents as the
dma_map_sg(), not the value the map function returned.

Fixes: b5762948263d ("[SCSI] mvsas: Add Marvell 6440 SAS/SATA driver")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Link: https://lore.kernel.org/r/20250627134822.234813-2-fourier.thomas@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mvsas/mv_sas.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index a2a13969c686..239b81ab924f 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -829,7 +829,7 @@ static int mvs_task_prep(struct sas_task *task, struct mvs_info *mvi, int is_tmf
 	dev_printk(KERN_ERR, mvi->dev, "mvsas prep failed[%d]!\n", rc);
 	if (!sas_protocol_ata(task->task_proto))
 		if (n_elem)
-			dma_unmap_sg(mvi->dev, task->scatter, n_elem,
+			dma_unmap_sg(mvi->dev, task->scatter, task->num_scatter,
 				     task->data_dir);
 prep_out:
 	return rc;
@@ -880,7 +880,7 @@ static void mvs_slot_task_free(struct mvs_info *mvi, struct sas_task *task,
 	if (!sas_protocol_ata(task->task_proto))
 		if (slot->n_elem)
 			dma_unmap_sg(mvi->dev, task->scatter,
-				     slot->n_elem, task->data_dir);
+				     task->num_scatter, task->data_dir);
 
 	switch (task->task_proto) {
 	case SAS_PROTOCOL_SMP:
-- 
2.39.5



