Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B64B62E9EB2;
	Tue, 15 Jul 2025 13:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587636; cv=none; b=i2oulGk+rhqynm9BJundOQ7Jnq4zexJhit0YfZC+t+nMCWB/cX3jHGMV4zARwd0XS7SaQQv1gppdGDkVYUxpn8H82CUiqwI5pkdbmWeKOqjM5vtFDW8c3WxXFjy068GE4hl4U1M5Zc1Rbq2Am4pPSRteD3trnhFbHOc2nykpTbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587636; c=relaxed/simple;
	bh=VkLf374+okmpTvkgaQUb2Zwbzp+EyWCNzFmz+ZweOzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kbsrh6yZUVN+jT6bhMf7eusLuwZy/rn6SB8SuczknsdA//Cmvw2VxuuenSc6R3w3ML/0pFxZxkMDmsqA93i2l21u/Y6nQNHBG0l7nVf4ksIABIHZs7lWMWLVbR1xUHNclwougMNk3lAsK7DBWqMzkpMghFm56mjaFNN3w8gTtjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zkKuXvWR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zkKuXvWR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43237C4CEF4;
	Tue, 15 Jul 2025 13:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587636;
	bh=VkLf374+okmpTvkgaQUb2Zwbzp+EyWCNzFmz+ZweOzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zkKuXvWRWdm4PJCIgvrrxLA7AEYHC4S7AzSJ9GlgUQxAIzqZiGUOM5yp7v+pqSfW+
	 qphIGaKskBrHprdeB/m1AD5850j/wuQTUtAOPldOVM858KhfIIOLhLf+gTM2SsA3da
	 hcD9kypD9rUq7ULkt0rxsaNfvjac0T1B2SFOVHdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 086/208] scsi: qla4xxx: Fix missing DMA mapping error in qla4xxx_alloc_pdu()
Date: Tue, 15 Jul 2025 15:13:15 +0200
Message-ID: <20250715130814.387091692@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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
index 05ae9b1157096..f02d8bbea3e51 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -3425,6 +3425,8 @@ static int qla4xxx_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 		task_data->data_dma = dma_map_single(&ha->pdev->dev, task->data,
 						     task->data_count,
 						     DMA_TO_DEVICE);
+		if (dma_mapping_error(&ha->pdev->dev, task_data->data_dma))
+			return -ENOMEM;
 	}
 
 	DEBUG2(ql4_printk(KERN_INFO, ha, "%s: MaxRecvLen %u, iscsi hrd %d\n",
-- 
2.39.5



