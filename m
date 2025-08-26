Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9BF12D0621;
	Tue, 26 Aug 2025 13:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215837; cv=none; b=ofhkPCWh10bRUOpvJutTfVKh4AO/7Xt2S71JytTMk0JoGSWSMZpNPYjO7QuSUj1Ko/9BDXJDErAgRk9Tfsqqb+l3ilcakCppfBoLLzMhpGfv6sLUtPLnyADBngvFD5ujnd3RgoCkXGIok2AKvMJENRnx2JGINDvQy6m8JF57kWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215837; c=relaxed/simple;
	bh=FJJdiygfjHaM4kxjKxQ2ygoILzaf8a4wsIou7K/8f/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sr8DZo6CPPa1bBv/2mfPgviMzV4yA9Sg5HtWs+BSDHK95XfZEaEuroGkiNxF+Zr8kUS1p/LW4tOSmt9PxE/vQuruq6+AVRQg2k1ZI806vyIuh8XxwFvrYHIGNSARHuXOjDHhWEf2a2c2OZa0etqsZUSNif7A02NwGz2u/IljUwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V76Um84T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V76Um84T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 403E1C4CEF1;
	Tue, 26 Aug 2025 13:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215836;
	bh=FJJdiygfjHaM4kxjKxQ2ygoILzaf8a4wsIou7K/8f/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V76Um84TTYHlhgu4hTqzxhO0thpgyOOCy8JNpyZuyS6wDixMSZqVQxq1yOgCbn0m8
	 3WmYZZzYqbBZGHJ5hCkrYgnmi4jYnAaG17gNWIFd8l0K4A7HhgS5rIB2eLC5TSvbim
	 56qb0tTE8To32ZqRDyXMTRRbHPHxbftoKGWj4Cak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 184/644] scsi: mvsas: Fix dma_unmap_sg() nents value
Date: Tue, 26 Aug 2025 13:04:35 +0200
Message-ID: <20250826110951.023359882@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 04d3710c683f..efd11fabff93 100644
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



