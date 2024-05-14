Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBD26320F;
	Tue, 14 May 2024 10:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682687; cv=none; b=NR/2YNfTzUtUhBCvqmhY/v/n7jzpAw9wRyWpwVwo7ePlmoN3+IungscnDott+hNSWlFmhvS5VeyJlfOls1kWmGpoSdULC9esLVl5doHoL1QK0B2WDT6uSTMND6qMo6ob3MBK53w1NdqWFbUc3MRGBRo6AfuDhqEMBpCfvcp5NeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682687; c=relaxed/simple;
	bh=vV+x23bXcuBmYPIVrKChnItaK8/e28yMfeT+YJ0r34c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TUg1pnMYxAQZRRfoQS0qhovS57VWtxgriR70aJNpUX21Z8BQOfwxkjTTtgEoNxJs6JBznIfkFtHCAWXjNvRTDO60pKr2/h2XUd7jVHpOVKVmMWLPNosXjRdGiCNvycgPoSTgj5eEvZRmgWUxGH0jUPFmvmv0qTxF5KFFXK7Mrso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jVK9U9ry; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jVK9U9ry"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16630C2BD10;
	Tue, 14 May 2024 10:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682686;
	bh=vV+x23bXcuBmYPIVrKChnItaK8/e28yMfeT+YJ0r34c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jVK9U9ryskc0VOcrf3qldIt4g24R+Ebt3ms8HHuirkZbptT7AFr+MKx3BKNRoYEPZ
	 AExb6UkoYEozEK5U05x5ubPKcd6oMuMXbn/xWuq5lpSTLT/sPymVahHgfV22cbmDz6
	 sTcFqhUcplAzg2eRqtSt8+zQPpIcBfxvdgh9NsYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 098/336] scsi: lpfc: Remove IRQF_ONESHOT flag from threaded IRQ handling
Date: Tue, 14 May 2024 12:15:02 +0200
Message-ID: <20240514101042.304664881@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit 4623713e7ade46bfc63a3eade836f566ccbcd771 ]

IRQF_ONESHOT is found to mask HBA generated interrupts when thread_fn is
running.  As a result, some EQEs/CQEs miss timely processing resulting in
SCSI layer attempts to abort commands due to io_timeout.  Abort CQEs are
also not processed leading to the observations of hangs and spam of "0748
abort handler timed out waiting for aborting I/O" log messages.

Remove the IRQF_ONESHOT flag.  The cmpxchg and xchg atomic operations on
lpfc_queue->queue_claimed already protect potential parallel access to an
EQ/CQ should the thread_fn get interrupted by the primary irq handler.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20240305200503.57317-4-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 70bcee64bc8c6..7820a1a7aa6d1 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -13047,7 +13047,7 @@ lpfc_sli4_enable_msix(struct lpfc_hba *phba)
 		rc = request_threaded_irq(eqhdl->irq,
 					  &lpfc_sli4_hba_intr_handler,
 					  &lpfc_sli4_hba_intr_handler_th,
-					  IRQF_ONESHOT, name, eqhdl);
+					  0, name, eqhdl);
 		if (rc) {
 			lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
 					"0486 MSI-X fast-path (%d) "
-- 
2.43.0



