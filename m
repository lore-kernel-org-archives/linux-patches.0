Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85AD62E659;
	Tue,  8 Jul 2025 16:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992078; cv=none; b=jZImIqMR6040XFwXp6WHMhdFWv8G4YHw30S/A6FYLUKf0BE5YB1td5vuhmUfDhKlwQc3/jetEQVa5Kyr6Gbnv75odoWBdDe2Sb/FuPxU1kITJVqSlA53jKwUvYXAYxWv637QhemVKp2scf+SxmiO170LFeGl/zvsZWunDzxqTRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992078; c=relaxed/simple;
	bh=ThudXU7Hr55bc3ROAT9iB0UHvnMjPkswgC8enjlxttc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HSYE2rZecpymaoJcHXzHQcYDbpX865aqTMWRhncLtW8zh3txa3DBFFiLX78TnTm01vaxYpJoBZXylpnhMPeVR4Vl6DgnYig9nTeT+hb87A/qD3MOQvK8fznn2Fq+q232JpdCEm/xWeIFlqflidwpTTqk5U0Fp/PWDanjHDeemEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gjq4rOoL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gjq4rOoL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E326C4CEED;
	Tue,  8 Jul 2025 16:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992078;
	bh=ThudXU7Hr55bc3ROAT9iB0UHvnMjPkswgC8enjlxttc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gjq4rOoLIjUsBYN9EjVyesf0RbYWjvnYCiG650I0189HwdVsuC0XL37tVUwOjl/Gh
	 b+CAwULQz9UHsaq7z+ueX2OhVL7BGO3h6C9CfW6kuGmEHk9viLcoTdWIK1LTV6U8GC
	 JK2iPZtq3et5Tnzo8DXObkUsVo00ad6a2EJfHqpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 21/81] scsi: qla4xxx: Fix missing DMA mapping error in qla4xxx_alloc_pdu()
Date: Tue,  8 Jul 2025 18:23:13 +0200
Message-ID: <20250708162225.601673430@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162224.795155912@linuxfoundation.org>
References: <20250708162224.795155912@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3f2f9734ee42e..2925823a494a6 100644
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



