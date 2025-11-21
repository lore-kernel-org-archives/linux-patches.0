Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7454350A3C;
	Fri, 21 Nov 2025 13:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732556; cv=none; b=MO5ATc0zb9qp6Z7y1N6ZTYRImx4TgKR4eqloisTQmshJY4RoBIKfPhnAjGsMymd5zn0I9reoT3pzllW4sq8mVo1QvClkW+RlVFsHusgXfSqQfMiMIprlght+yV4vgz5U9PBWzHSiyHObSWHvdIrXT2Wt7mE6ZwFj5y6bvuo27b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732556; c=relaxed/simple;
	bh=tqZwMJUwSo+9DMEAQTtJZ5gFuNK6/hDPIb3dcY7b2/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KQkykiRjEu3Go6blfZxy8MVVYkQ+jEsHq8uDc3m1Sxzo+TOO0Dm+Gk1cl3Z0ho6VaAjal1Qe8kVyw9xz165LNsuwOe+mFUG3vsd+jGVtBUYNbyY7zN2hCzghHVVa4YJwxoPxiOezB4Xzhx3qh2EChRPxrVMoVZDjB07x/LB2ZUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O+Cu+bAo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O+Cu+bAo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 749FDC4CEF1;
	Fri, 21 Nov 2025 13:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732555;
	bh=tqZwMJUwSo+9DMEAQTtJZ5gFuNK6/hDPIb3dcY7b2/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O+Cu+bAo8F9oDB4FVFm+9dACK6lffqH2LfpE12BRY1xo74qBlE5w3eXEzTkGh/z/I
	 XylVwV3Kw0qBhM2mztUggOouON3ixtaDpNzAFjnqnqt4ieNZreV34f6PqYZVzZLXqe
	 WgKlKS6ez/1QHtwNJBP3kN6IumBi63GWSRAb+X5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 161/529] scsi: mpi3mr: Fix controller init failure on fault during queue creation
Date: Fri, 21 Nov 2025 14:07:40 +0100
Message-ID: <20251121130236.748665617@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b03e4b8cb67d6..b6ae7ba6de523 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -2117,6 +2117,8 @@ static int mpi3mr_create_op_queues(struct mpi3mr_ioc *mrioc)
 {
 	int retval = 0;
 	u16 num_queues = 0, i = 0, msix_count_op_q = 1;
+	u32 ioc_status;
+	enum mpi3mr_iocstate ioc_state;
 
 	num_queues = min_t(int, mrioc->facts.max_op_reply_q,
 	    mrioc->facts.max_op_req_q);
@@ -2172,6 +2174,14 @@ static int mpi3mr_create_op_queues(struct mpi3mr_ioc *mrioc)
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



