Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CAB92FA0FD;
	Tue, 12 Aug 2025 17:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021491; cv=none; b=D/fULs1OSjUE33Qd2SJTdTjwmSNceqQvKOwMFPxYkdyW19V3tkFFBtUeAx0xnr0OBjmll5Jjy0+5Fl1qjjbw7yk5XZQk8ytoAKeDxu/8ryz0po8WEtVpUNusEa3mWnqCKLc1VeMO9POYQEppdUbPL8mLRAlcuAUU3KZqHrmAA78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021491; c=relaxed/simple;
	bh=S9rNluleaaZsMvb2qFcxUO8w1Q38+lBGNpVFHq2JHY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MuWz/bGbMFPMZWDht+27M5zixa70CljA7q36P35NYRQTsk/d/xCoA0KHA6hLxv6MypraH6YNC+9iL49glLicrbWMDKlkhIJSV4vCp76fOSDBl57MOltRUmIY5TKRDpN5+FPL1ZSCOw051V9jYFWQ6alnfDHXyvHo1u7wwlzbYoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AzJpJa4d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AzJpJa4d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDDE2C4CEF0;
	Tue, 12 Aug 2025 17:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021491;
	bh=S9rNluleaaZsMvb2qFcxUO8w1Q38+lBGNpVFHq2JHY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AzJpJa4d5K2PaBLwYPwyZGwC0oNJ6Ag0lQ8gZ77882AUN8o/a2QN3CP2RIMWx9SfP
	 +TQ4n21RY2DiXkGuBldXnWz8QBHhzaHg3sgqXLR9ItIQ/WhOHChoqAWyJZ9fwHPoUh
	 2C6puSRUGNVFjrS1gIeatoPUlBDunr06EesjVKJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 138/262] scsi: mvsas: Fix dma_unmap_sg() nents value
Date: Tue, 12 Aug 2025 19:28:46 +0200
Message-ID: <20250812172958.973225865@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1444b1f1c4c8..d6897432cf0f 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -828,7 +828,7 @@ static int mvs_task_prep(struct sas_task *task, struct mvs_info *mvi, int is_tmf
 	dev_printk(KERN_ERR, mvi->dev, "mvsas prep failed[%d]!\n", rc);
 	if (!sas_protocol_ata(task->task_proto))
 		if (n_elem)
-			dma_unmap_sg(mvi->dev, task->scatter, n_elem,
+			dma_unmap_sg(mvi->dev, task->scatter, task->num_scatter,
 				     task->data_dir);
 prep_out:
 	return rc;
@@ -874,7 +874,7 @@ static void mvs_slot_task_free(struct mvs_info *mvi, struct sas_task *task,
 	if (!sas_protocol_ata(task->task_proto))
 		if (slot->n_elem)
 			dma_unmap_sg(mvi->dev, task->scatter,
-				     slot->n_elem, task->data_dir);
+				     task->num_scatter, task->data_dir);
 
 	switch (task->task_proto) {
 	case SAS_PROTOCOL_SMP:
-- 
2.39.5



