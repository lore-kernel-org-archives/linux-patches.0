Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A442E5B2A;
	Tue,  8 Jul 2025 17:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751994054; cv=none; b=GJD871nnmJpxEESDn8JiS7DBMG+viJakZICEJ03b4cJMRHg1mq8MIFXmMJGPKjA9v+xtFrztt3jSkDUv43Xnd4kjgR2kDuusrR0iWsFkri0XUtOSBQNlXtqX0o1Jkx4LO9ELmjkpJ3F4SC+WvcDRQpHCQyL/XXxN8vVgcPgo/Qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751994054; c=relaxed/simple;
	bh=DiAMrM8idigVU7HYG/yTQEpFz7yi9/sI/uiBgQaxdd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=umBo6lWwtenzMJQHdT7Si/CXHA0+vdBIRoCIURoYGR6RM34zDNGUGWaHBqk+JGTN82QDDOqDw+stLSGxb5MxYW8g65LuTCQ7eApo4oM1WeEVSFjmkS5v2+Nxpfk+vlw++ldXkLufYQLpAvfrEdhOvcoldf1jJqVHrmnc2e2Ze6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jl3VLYkX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jl3VLYkX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F461C4CEED;
	Tue,  8 Jul 2025 17:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751994053;
	bh=DiAMrM8idigVU7HYG/yTQEpFz7yi9/sI/uiBgQaxdd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jl3VLYkXTQZ7dRRWyzP4aWWROJFpKT+/T1dQUkvfH0vwC0DX1QlcuQ5F9QwTN1myV
	 2LfoL/nbgu9sjv0ucHtBkcRRzM14hOPba8Dwd0v18LDm2GIGtIGqOBa4CXGrPHhWw6
	 QPSMBuO7kDXEiUwJ32MVW6yLBO89z5B3My8/i8m8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 110/160] scsi: qla4xxx: Fix missing DMA mapping error in qla4xxx_alloc_pdu()
Date: Tue,  8 Jul 2025 18:22:27 +0200
Message-ID: <20250708162234.524083308@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

[ Upstream commit 00f452a1b084efbe8dcb60a29860527944a002a1 ]

dma_map_XXX() can fail and should be tested for errors with
dma_mapping_error().

Fixes: b3a271a94d00 ("[SCSI] qla4xxx: support iscsiadm session mgmt")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Link: https://lore.kernel.org/r/20250618071742.21822-2-fourier.thomas@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla4xxx/ql4_os.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index dc466a364fb1f..ab89f3171a093 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -3420,6 +3420,8 @@ static int qla4xxx_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 		task_data->data_dma = dma_map_single(&ha->pdev->dev, task->data,
 						     task->data_count,
 						     DMA_TO_DEVICE);
+		if (dma_mapping_error(&ha->pdev->dev, task_data->data_dma))
+			return -ENOMEM;
 	}
 
 	DEBUG2(ql4_printk(KERN_INFO, ha, "%s: MaxRecvLen %u, iscsi hrd %d\n",
-- 
2.39.5



