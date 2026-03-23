Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E57F3AF649;
	Mon, 23 Mar 2026 16:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282413; cv=none; b=OUFzQv/cWpU3BYMeEhwWSVO9ST10wd/TqumE6uw7lzLXN8igHTJP0ILDk7H3Qxuk66bzuST9RPFgzDn0q5dyNYaPNH5wF/tRjNSSml9/pN3Oh6c34ISPeYnv6o9VlN9JFwP8Cmok9q+Sl1Vi7j68unqD8psXb+F543Dl9+Oa3OQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282413; c=relaxed/simple;
	bh=tTCpGaBp70b5RUnKM673BPFzYEUreLusNHi4U/tiEbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tkyyawvQHxCpZAwzjIE3bmTum5LlVVhW2PC/CC++6rUIs91tojHz0bJuiFSsIcQv/eAEFJn8FyZ81aU8fs/xeYs86uYcDdE+d/fbCEKbgu9WIVR67CNrOTJjeiICcEfMyuukEpRoornnsdVVInqVmSNcUvXl5KifoGoseSqiWDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=efc3tvMm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="efc3tvMm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71DCDC2BC9E;
	Mon, 23 Mar 2026 16:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282412;
	bh=tTCpGaBp70b5RUnKM673BPFzYEUreLusNHi4U/tiEbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=efc3tvMmbCNIHuZtG0sFs2wkiU03tbvaw2zVsjGf3UqVwnwmzTe2XzgvDDryhS16S
	 Nrfrd0nrA5MsvXmlZn5zZFNp49pLyD/EYvuB9oYozB12K+rwRM9bOSUWT5qpwDZxd7
	 qW9QU8l76auaWTByhaBjXQAL1ocSSOJHp6LbjZ+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 148/481] scsi: mpi3mr: Add NULL checks when resetting request and reply queues
Date: Mon, 23 Mar 2026 14:42:10 +0100
Message-ID: <20260323134528.856381232@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9d8f5a4794666..d4747ff4d800a 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -4246,21 +4246,25 @@ void mpi3mr_memset_buffers(struct mpi3mr_ioc *mrioc)
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



