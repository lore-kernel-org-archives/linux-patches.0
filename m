Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314DC23A98D;
	Tue,  8 Jul 2025 16:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992753; cv=none; b=oIAO9+C5S6AqMPAldAcqFJDgTs+bZUs+t+JHrffT8kn0rYj+QzPMlPlnBNFqaFuaKW+WVobka5fyPDihbpUG0hmQcMuGPJm8/QRVtmEi6zLR28+T4PO1qNuTwe1kDRdQyUHnC0RUV+UBhn/pIWedlBOfHUayfyZjEuGdr8JClrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992753; c=relaxed/simple;
	bh=omHJ4LpciwZjM3BG0I97LTtAP3Ot6D76pe830SvMO6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QwQSUNp9064ImNSA0811bq17WaRoNj5li8dQ39tfPv417ugnjJ3jqtY5FbVhGiNXlnMQ3IhYhqI3LiCrx4yVASAGgR7kBnXy3fOx2KJcDKDB4HM1jOfTcJmi6+G4KM54ahY5dpR8XiQ3Xe+EJWidVGq2sXXje7B4bTr4FA78FTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rERZH0BY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rERZH0BY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6649C4CEED;
	Tue,  8 Jul 2025 16:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992753;
	bh=omHJ4LpciwZjM3BG0I97LTtAP3Ot6D76pe830SvMO6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rERZH0BY8qw2Epskx3vrOV6C1g7KBD3Ygwdo1TIcH4WnPgwRO8OTjdrcoRn8cYtzj
	 wS0mkkRG9XRyY8ss6IfBjWM6V3RZZOstTSJEaCTz4b/kRnR1MCNnqBIscLt/Iz1pq/
	 s1N1+/P1vIhPCtWtgshyFhcS1bhqE1WJIRwks6Ow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 038/232] scsi: qla4xxx: Fix missing DMA mapping error in qla4xxx_alloc_pdu()
Date: Tue,  8 Jul 2025 18:20:34 +0200
Message-ID: <20250708162242.427047916@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d91f54a6e752f..97e9ca5a2a02c 100644
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



