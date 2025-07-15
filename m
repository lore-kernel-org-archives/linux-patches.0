Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF18A2E2657;
	Tue, 15 Jul 2025 13:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586439; cv=none; b=Ul7EG2bFOVjm9Z2hxGxLA11CwNAAmeW3D1jLbRlWoN7K67Pw3Q7oM6WAQz6jGBjkRuKfzRlnYLtPafDeLPDIKbzAPGzMr+dlTLyV2M/xOtheFY7OZ5LF4Ip351XOVuMTfmjVD7VnqUzphwqSxTIDyDsLnmcClXRjk0wDSfo8pZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586439; c=relaxed/simple;
	bh=+XdO7MJOpkAY8mf2c88I/xyDfdZB0huNCR76UMOYj9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nVlp4AokM64piQKkKlLSmaDxKrQI3oFqOUtlNKU+8IfAmFeMXx8LHtQjZWPJUd9Bz34CC1HMmTj/qXPKbUYecyHbWCtwmmDpogmKQ8XWHA0dILoReA9kK0pawW212BqTmVhUdCaA5C+eJuCVjVJwT1XPkYMLrvxM6cD2y6EX7SM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C3AfNmsG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C3AfNmsG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83325C4CEE3;
	Tue, 15 Jul 2025 13:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586438;
	bh=+XdO7MJOpkAY8mf2c88I/xyDfdZB0huNCR76UMOYj9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C3AfNmsGEWb3gprmwGYnMfD7CY7TmgPKTUfCeK/sJAGOR6UgUPwrM3c8e+nY4SVeB
	 KngwiW01IRkxZ9vQhROkA8N98MCSM+WjqmzKbsum16luviwV95sG1R8YO3BWDhkA78
	 D5aTJMXXfTGb6sdXf7n3qcnfQsIBV1xVn18+6c8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 064/148] scsi: qla4xxx: Fix missing DMA mapping error in qla4xxx_alloc_pdu()
Date: Tue, 15 Jul 2025 15:13:06 +0200
Message-ID: <20250715130802.891900825@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index ea15bbe0397fc..af1c45dd2f38a 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -3394,6 +3394,8 @@ static int qla4xxx_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 		task_data->data_dma = dma_map_single(&ha->pdev->dev, task->data,
 						     task->data_count,
 						     DMA_TO_DEVICE);
+		if (dma_mapping_error(&ha->pdev->dev, task_data->data_dma))
+			return -ENOMEM;
 	}
 
 	DEBUG2(ql4_printk(KERN_INFO, ha, "%s: MaxRecvLen %u, iscsi hrd %d\n",
-- 
2.39.5



