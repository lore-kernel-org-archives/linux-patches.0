Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D18D33C534;
	Tue, 11 Nov 2025 01:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823456; cv=none; b=QbAOKNo7/DzJ+K9SFXFcuBBkICX9UU/GSQZarwGhmrZJZA+ONOig3NLP9J2OZKcIzVIQNQXZ3QzLuNfO7kwT1mBDSZ1UD96rg5CIMRrJeP5O62jyXIOD5KzojehjM9JX3lRFVtq1uVZ98+PTq2XO5+I0c4zlc3ax2nfI2HgdPiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823456; c=relaxed/simple;
	bh=wsm62C6ED7zR6GQa05AiTQVT3c9LFW/x2I9400k8GmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LeYVu5BJ6JCoHJUJbIuSXslwrXrwx3ujSp/+cVxNtcB9nkrhFJ14Tddu0GebL3oRmoOoegWFnlK+bEk1i7mO6bifYVzqGTdwykZN+V5XWEd/qBafqcuq45fnVgCDN5UmMGQacARICNFssKnU+C2gLxMn127ahQSG3QSW9q8eMYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0GEg0yjG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0GEg0yjG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F81EC19424;
	Tue, 11 Nov 2025 01:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823456;
	bh=wsm62C6ED7zR6GQa05AiTQVT3c9LFW/x2I9400k8GmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0GEg0yjGkhTS/NXQqQw4kVaompehdoe2wRPbSwygwtAkurw2pujhU2X9p4UK4/JTa
	 Pu7NPmibSKEWC32V+OIq38B3DpWrAAw4B8jLO+VwDM7VGfRGtjlcVRgdBBUFWv4qnU
	 DAPt2vhu9WCwqkFDCkdzRDvQg2Z6td/pcVWmvQm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 250/565] scsi: mpi3mr: Fix controller init failure on fault during queue creation
Date: Tue, 11 Nov 2025 09:41:46 +0900
Message-ID: <20251111004532.531604839@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

[ Upstream commit 829fa1582b6ff607b0e2fe41ba1c45c77f686618 ]

Firmware can enter a transient fault while creating operational queues.
The driver fails the load immediately.

Add a retry loop that checks controller status and history bit after
queue creation. If either indicates a fault, retry init up to a set
limit before failing.

Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Link: https://lore.kernel.org/r/20250820084138.228471-3-chandrakanth.patil@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 82cbe98e8a044..acb2f7b04fb8f 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -2337,6 +2337,8 @@ static int mpi3mr_create_op_queues(struct mpi3mr_ioc *mrioc)
 {
 	int retval = 0;
 	u16 num_queues = 0, i = 0, msix_count_op_q = 1;
+	u32 ioc_status;
+	enum mpi3mr_iocstate ioc_state;
 
 	num_queues = min_t(int, mrioc->facts.max_op_reply_q,
 	    mrioc->facts.max_op_req_q);
@@ -2392,6 +2394,14 @@ static int mpi3mr_create_op_queues(struct mpi3mr_ioc *mrioc)
 		retval = -1;
 		goto out_failed;
 	}
+	ioc_status = readl(&mrioc->sysif_regs->ioc_status);
+	ioc_state = mpi3mr_get_iocstate(mrioc);
+	if ((ioc_status & MPI3_SYSIF_IOC_STATUS_RESET_HISTORY) ||
+	    ioc_state != MRIOC_STATE_READY) {
+		mpi3mr_print_fault_info(mrioc);
+		retval = -1;
+		goto out_failed;
+	}
 	mrioc->num_op_reply_q = mrioc->num_op_req_q = i;
 	ioc_info(mrioc,
 	    "successfully created %d operational queue pairs(default/polled) queue = (%d/%d)\n",
-- 
2.51.0



