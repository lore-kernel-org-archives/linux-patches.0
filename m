Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF111F09B3;
	Tue, 11 Nov 2025 01:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823719; cv=none; b=Q5+OEHO65jdWozX4F6jt6lMTVtMxyBpO9jPumsif7i6cmwmSPtjxtKxsNhrjVz/xIIB0JInqW9iWkDWqX//aFb1d4rP2NAeHNC1pxH3WnrRetEVWh2LY3mg3RZAX2f2r01I/zoQ0ltp8lH/1PV46JL4VgCVb36IWC34PL9tHFV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823719; c=relaxed/simple;
	bh=0Y5vM24drnNVcjNRiPxnKm6ii86LIkoQxFVaV4zo6k8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D1BBc1WLGn+tqbAk8OPppwsPcp6IhqdbvwHgY7owlTqRn2BsYFc9Z9KOjQnYsYWK2Hnk4oeCCbg9FFzDrV10NZX2aCT9nMBNL3zNmRVb/5Toqzr2ipWheEGwa4dESzAQswpeuk05kOjLUD0FSwYvX98k+DjiG9dggIQ2ALnIWiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xFQDQG0S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xFQDQG0S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1589DC116B1;
	Tue, 11 Nov 2025 01:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823719;
	bh=0Y5vM24drnNVcjNRiPxnKm6ii86LIkoQxFVaV4zo6k8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xFQDQG0S+NR1XRsaWFwKlTppizF9sIT5TUEY76qIpLGLs0bxSVNk10sHS2O20DZcn
	 w2+Nfmqd6qeqBbZus4lToWZO9c3kuV1PGlujk/x+zM8iC5ii70mVJuWLlkHs4mO0K9
	 jfpdbSj2/mj1CoCvb8WActlklnM4XMw2SM7hLnYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 356/849] scsi: mpi3mr: Fix controller init failure on fault during queue creation
Date: Tue, 11 Nov 2025 09:38:46 +0900
Message-ID: <20251111004545.025605025@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 9e18cc2747104..8fe6e0bf342e2 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -2353,6 +2353,8 @@ static int mpi3mr_create_op_queues(struct mpi3mr_ioc *mrioc)
 {
 	int retval = 0;
 	u16 num_queues = 0, i = 0, msix_count_op_q = 1;
+	u32 ioc_status;
+	enum mpi3mr_iocstate ioc_state;
 
 	num_queues = min_t(int, mrioc->facts.max_op_reply_q,
 	    mrioc->facts.max_op_req_q);
@@ -2408,6 +2410,14 @@ static int mpi3mr_create_op_queues(struct mpi3mr_ioc *mrioc)
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



