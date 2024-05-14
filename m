Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD662B9AD;
	Tue, 14 May 2024 11:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685060; cv=none; b=NRQjDmOzrRHQ7190L1m2mJ29RmkYJ10Shu7Gz7jMR+yJO6LystcrOQub1zXgl6D1+o3cT5xdMQhMUHe2u5s9Q8Pus1u0SzsV4H1q1tJZY2Vjw0LkNM6kJtAorTYpRJqAh410NdcKU6AJXfIwku2nHYS8JsnmJz+IuXvnnD5z8/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685060; c=relaxed/simple;
	bh=IkfWI9RZEa2NkDQW/0WTkcmBoudmct5ge15HCdrYQM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=igS4c/ro50BaCGsk8Rh6qxHyYEjZv/ko96JoPhFJiqnXrVZ9k1M9LMkJDkW5fL8oU6/WD0am9fuuuEzd10RCbG2qsCiHB4KQET9oppfPfFDnNmpXnGXLthdPkLRiRcLNKv4ZFTn2cF+FCT6/p9/LePLWswRhFeYG0Fe6A4rOEJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0DBRXcQH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0DBRXcQH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA11FC2BD10;
	Tue, 14 May 2024 11:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685060;
	bh=IkfWI9RZEa2NkDQW/0WTkcmBoudmct5ge15HCdrYQM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0DBRXcQHH7OaSOKDNreE3FML3NqBWpLPtmq48Nw8LivOWbLdAaOeFYLPXlSUp979F
	 SYOwnQO9/URrlEaCvhiWDuWbRX9gXX21osFlZjoCzlN7L91wPG4jUsEJvulaIqtsSR
	 mmeuGAxLzPTMKIh7tFY90QP11BSRmNMBCQC/Pr2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 098/301] scsi: lpfc: Remove IRQF_ONESHOT flag from threaded IRQ handling
Date: Tue, 14 May 2024 12:16:09 +0200
Message-ID: <20240514101035.951986782@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2c336953e56ca..76c883cc66ed6 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -13051,7 +13051,7 @@ lpfc_sli4_enable_msix(struct lpfc_hba *phba)
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



