Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65AB620E023;
	Tue, 12 Aug 2025 19:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026262; cv=none; b=Q/b1mwWrKXSYBJe3cTtOZzccBXemKgoQcVUtqk3UVXyzK+SjyMeJ2y4BdC9sYMg+h16Bxv3fdxyqNayeDGfzbcCFX7OZQnoAjn+m/27LssWStpfFmQx3d8lqzoj8890R+ViF874z1Gtz8VDuIqcW8qsPLjtaKoHrgWqnUqa98f8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026262; c=relaxed/simple;
	bh=kcr4WfbjVxDmSnaa7rFQ9NuFdefWVu/EMRUQpxjLW3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EhyLnuMkagsVx6C9IJDd6yxFOnYuJzya+AifZt7DyHOk6Ss3E1cyDdvF4NCMheMXoa7mDNnM3JX2fs8vCYuyCak0Xe3SpHi3DaOkZ6XralS/bGjnajSumqk7Sw/5hJ/du5i7xFYesED6TljZHVXwRBj2pc4kZCawNobwuINeQoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L57jo2Yc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L57jo2Yc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA37C4CEF0;
	Tue, 12 Aug 2025 19:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026262;
	bh=kcr4WfbjVxDmSnaa7rFQ9NuFdefWVu/EMRUQpxjLW3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L57jo2YcNZsqFuOW138VE1r2hNlTgeOPUv3N2x8PfgCsjJ2t++Llx2u+r+uqJ32DR
	 JaLDTPtI/Rsb/4jZwNII3Nfa7dOXMWXjjf/6jOTbF+Zc99oMahA/IcpWHf8gbkDpTm
	 KS72WrCENXYpXj/JxKbR6/7RRYITm9twCMUB4hE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 285/480] scsi: mvsas: Fix dma_unmap_sg() nents value
Date: Tue, 12 Aug 2025 19:48:13 +0200
Message-ID: <20250812174409.186893519@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 52ac10226cb0..3f12096528b1 100644
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



