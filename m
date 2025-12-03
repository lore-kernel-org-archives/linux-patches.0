Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23CAF34B43D;
	Wed,  3 Dec 2025 16:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777696; cv=none; b=K3n3XUrvjPy9ydMPJT53JcSwbupTOhe6nixA+5rO/ZHK8NFVTo2fQQB/OMn3w3uTyldgrvIQ2LQAnKcY+6R9gH0J8QWzjJ/gPnhdAFaNEE0fbLCz9gU9+enRNOkpIfsF6YGRQBWAeW9WWwZmbtNN6j7qG32tdGR8kKNlPI5LZI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777696; c=relaxed/simple;
	bh=AjK02SNPxPTagaMjXuL+iY05FGYrkJlg92etNeTRcYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pmqjDiy+jIw59zrFQDaJLnMRdEWCrUidDi8jcNjaR3GVbEfKGkIIMBd6DAMLk//wAYIXVg2uQLSOPvUtqZo90vicvqK16n90YKJ85m0f1HzQ29U1fnKEXmQN55Dx24YiiP/BjJUMweYRqs0YM9efMIFe8kZXdpBZe1y5grrq5bQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xeBdIn3T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xeBdIn3T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 954A9C4CEF5;
	Wed,  3 Dec 2025 16:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777696;
	bh=AjK02SNPxPTagaMjXuL+iY05FGYrkJlg92etNeTRcYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xeBdIn3TZ/DrsYWBkkCGe3NH2QZq8AxmMnNyjcmchHiXNlbXbIbv3oHC/UNLAQEvo
	 GeAAbd/yyrFGNKxs4QN5gNYLhbKE0cTGRdLB/Xo+jHae0LjHh+vU3MAkUxVysIXQ6G
	 PKPCP4IHJkF7CddtAgzLg9CFuSpxzPPH7n60I+ww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 117/392] scsi: mpi3mr: Fix controller init failure on fault during queue creation
Date: Wed,  3 Dec 2025 16:24:27 +0100
Message-ID: <20251203152418.401830138@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 356e0b99a12fc..939c3509b316a 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -1770,6 +1770,8 @@ static int mpi3mr_create_op_queues(struct mpi3mr_ioc *mrioc)
 {
 	int retval = 0;
 	u16 num_queues = 0, i = 0, msix_count_op_q = 1;
+	u32 ioc_status;
+	enum mpi3mr_iocstate ioc_state;
 
 	num_queues = min_t(int, mrioc->facts.max_op_reply_q,
 	    mrioc->facts.max_op_req_q);
@@ -1820,6 +1822,14 @@ static int mpi3mr_create_op_queues(struct mpi3mr_ioc *mrioc)
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
 	ioc_info(mrioc, "Successfully created %d Operational Q pairs\n",
 	    mrioc->num_op_reply_q);
-- 
2.51.0



