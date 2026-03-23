Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C249B3AEF4E;
	Mon, 23 Mar 2026 14:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275112; cv=none; b=ShJLe423XS6BTkpYObceuDtnBAXbb2CSmA5oItqVi6JayhVHZ8jHt2hLl4cF6GlFDk72GLyvfg1nWhJH0Yn1HvemvCr0YndXUndzGcec30/SvBY22hmM1PlgCHEcUiTawQLUEfuAiib88pFysjOTgXQBSEAYmpK1ohkYibUYYXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275112; c=relaxed/simple;
	bh=RT3FbR1wjWaP8kJ8B9lNAdCQlr1hj40MtT9Xha7KtUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jAbNiEMsKMIvoclLVsG5CLIW8M7euFDvrvIcVGe2aar8Z2QsrfMyntzmyp+wCjMctm+gtkCnjtxi9IaaSSXaw4g2DsrU1kx+0Vv8579Q89dFDh9TpnrRsq0jzPhbSUoJtmCKkoM0f80gzbIO4gNWKzdaMJZpXUXJh8atr7dTSP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kHE64WRf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kHE64WRf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D10FC4CEF7;
	Mon, 23 Mar 2026 14:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275112;
	bh=RT3FbR1wjWaP8kJ8B9lNAdCQlr1hj40MtT9Xha7KtUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kHE64WRfqc1pul+OLhwo79lMiPWQoNn08i7rdPMpgyGWjuBWMgFwDbzGVs9+noaUD
	 4FDQIqJf1FbPG+IFmbeXw2y575vfylVJdOl3U/k+G0uCFS3+Z+wfgCyC6dVS4VR8WK
	 f/auop1vdAx1o3ECyHvc3d4AEgiqJ8BFvHJCm/q4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 003/460] scsi: mpi3mr: Add NULL checks when resetting request and reply queues
Date: Mon, 23 Mar 2026 14:39:59 +0100
Message-ID: <20260323134526.734161087@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

From: Ranjan Kumar <ranjan.kumar@broadcom.com>

[ Upstream commit fa96392ebebc8fade2b878acb14cce0f71016503 ]

The driver encountered a crash during resource cleanup when the reply and
request queues were NULL due to freed memory.  This issue occurred when the
creation of reply or request queues failed, and the driver freed the memory
first, but attempted to mem set the content of the freed memory, leading to
a system crash.

Add NULL pointer checks for reply and request queues before accessing the
reply/request memory during cleanup

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Link: https://patch.msgid.link/20260212070026.30263-1-ranjan.kumar@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 34 ++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 4198830bf10b7..3a057a0f0d809 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -4677,21 +4677,25 @@ void mpi3mr_memset_buffers(struct mpi3mr_ioc *mrioc)
 	}
 
 	for (i = 0; i < mrioc->num_queues; i++) {
-		mrioc->op_reply_qinfo[i].qid = 0;
-		mrioc->op_reply_qinfo[i].ci = 0;
-		mrioc->op_reply_qinfo[i].num_replies = 0;
-		mrioc->op_reply_qinfo[i].ephase = 0;
-		atomic_set(&mrioc->op_reply_qinfo[i].pend_ios, 0);
-		atomic_set(&mrioc->op_reply_qinfo[i].in_use, 0);
-		mpi3mr_memset_op_reply_q_buffers(mrioc, i);
-
-		mrioc->req_qinfo[i].ci = 0;
-		mrioc->req_qinfo[i].pi = 0;
-		mrioc->req_qinfo[i].num_requests = 0;
-		mrioc->req_qinfo[i].qid = 0;
-		mrioc->req_qinfo[i].reply_qid = 0;
-		spin_lock_init(&mrioc->req_qinfo[i].q_lock);
-		mpi3mr_memset_op_req_q_buffers(mrioc, i);
+		if (mrioc->op_reply_qinfo) {
+			mrioc->op_reply_qinfo[i].qid = 0;
+			mrioc->op_reply_qinfo[i].ci = 0;
+			mrioc->op_reply_qinfo[i].num_replies = 0;
+			mrioc->op_reply_qinfo[i].ephase = 0;
+			atomic_set(&mrioc->op_reply_qinfo[i].pend_ios, 0);
+			atomic_set(&mrioc->op_reply_qinfo[i].in_use, 0);
+			mpi3mr_memset_op_reply_q_buffers(mrioc, i);
+		}
+
+		if (mrioc->req_qinfo) {
+			mrioc->req_qinfo[i].ci = 0;
+			mrioc->req_qinfo[i].pi = 0;
+			mrioc->req_qinfo[i].num_requests = 0;
+			mrioc->req_qinfo[i].qid = 0;
+			mrioc->req_qinfo[i].reply_qid = 0;
+			spin_lock_init(&mrioc->req_qinfo[i].q_lock);
+			mpi3mr_memset_op_req_q_buffers(mrioc, i);
+		}
 	}
 
 	atomic_set(&mrioc->pend_large_data_sz, 0);
-- 
2.51.0



