Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B773F2C21F6;
	Tue, 12 Aug 2025 18:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024502; cv=none; b=P24AjKIJItio7uOCBahFRWAgny/FEO6XTgK5r3UJDWrHAzTjg3QIYpxw0PV7hQkzHVSvDKLJKEbJJr52Kpv3MZR7vq2tVzBxfJo1A5+RTmCUKFI2sbRGgu9wVdP1sR1FlF6pyGdX2+S7qsssyncto1BqJzGiPzQglx6UOx9VUzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024502; c=relaxed/simple;
	bh=143ppc0PIpy+tlcs0VzkbGX0zcmvKfu2ylcaFSd67es=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r3CIL68BrXXLOGrmSjplRKtejp5QQu6dM95WTNOLg1t9b0wEpZ5R/xmnyvGYcMjLMWhRPa/44JTK9i1DyxSzBJdbV5gKagpmCHhttXVCREa09CRmCSnUEMPOkJ/i7I8A9qXL3VH35k9hJlm5QTMYSTwR+GuxxLJpPRGhGaFqztA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hYAal+Mv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hYAal+Mv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2585AC4CEF0;
	Tue, 12 Aug 2025 18:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024502;
	bh=143ppc0PIpy+tlcs0VzkbGX0zcmvKfu2ylcaFSd67es=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hYAal+MvCGvgQv+kBZXpG7rClYbd8lQ0UmO8cwqF8Xu0doAKQVlvvlIclrlCZhYUG
	 KnJxCAXytGQprJW9k24qaDUPlDRo4EqfP8DML1g8NsThCDuHxiHXZbe/oUm2Ra+kBf
	 r4l/Mwly+DA0qrGRyuYJQOf9jIgz8KGXsdID8xfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 393/627] scsi: mvsas: Fix dma_unmap_sg() nents value
Date: Tue, 12 Aug 2025 19:31:28 +0200
Message-ID: <20250812173434.248467537@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 6c46654b9cd9..15b3d9d55a4b 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -818,7 +818,7 @@ static int mvs_task_prep(struct sas_task *task, struct mvs_info *mvi, int is_tmf
 	dev_printk(KERN_ERR, mvi->dev, "mvsas prep failed[%d]!\n", rc);
 	if (!sas_protocol_ata(task->task_proto))
 		if (n_elem)
-			dma_unmap_sg(mvi->dev, task->scatter, n_elem,
+			dma_unmap_sg(mvi->dev, task->scatter, task->num_scatter,
 				     task->data_dir);
 prep_out:
 	return rc;
@@ -864,7 +864,7 @@ static void mvs_slot_task_free(struct mvs_info *mvi, struct sas_task *task,
 	if (!sas_protocol_ata(task->task_proto))
 		if (slot->n_elem)
 			dma_unmap_sg(mvi->dev, task->scatter,
-				     slot->n_elem, task->data_dir);
+				     task->num_scatter, task->data_dir);
 
 	switch (task->task_proto) {
 	case SAS_PROTOCOL_SMP:
-- 
2.39.5



