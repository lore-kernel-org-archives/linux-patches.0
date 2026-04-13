Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57BA328505E;
	Mon, 13 Apr 2026 16:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097407; cv=none; b=byvirkKkfl74u4Ng7UYVFPlDMyotJbwQhTZJN60n2Yldi6qLKrsVQXy4yU8NvCaqsyNsO3sJEP9so81G7dru/v1IiIS8HVlw3TS2zjraMuVxE2N5WvoBi8OgmGrDkaaUbK42QiPUz2rzqAx2EPiQgxvCGyTXDAZsIlTKjKX2Sh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097407; c=relaxed/simple;
	bh=URwWTSmlLpKkKHEstpx6TyRJFMYNs0k0leRD76fjw64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uz2TAicbVLYGAVpHJHP+I3pvgg0rD6uC1WKyUOcktd2K8YTeM2UBCkJX09anRzmTK3snNqwGhG0yEgKFFYG/LIweNweWwck3ycWvYRCPNoqx0DgPvzpfZUOudpvBXBkzSbcATZunLJcClr2vzu0wNj0HE9jCDLms6eXKuN0B3qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oBBLuFdg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oBBLuFdg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64C8EC2BCAF;
	Mon, 13 Apr 2026 16:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097406;
	bh=URwWTSmlLpKkKHEstpx6TyRJFMYNs0k0leRD76fjw64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oBBLuFdgnfFo/0Rw4RhQVVIY2XCV4Di+CkyLMWxvAdKrBfKfostBld6iAmx2daRiY
	 Hs3Emoy3YWH2QhS56vm6T9Lq2uHocCwu6AI070jrLxqoGsiDkwQfvpiuywxteaRewF
	 A0BH5tzHGBh2kAUFPT1NQVui2wn9NdI0RcmLJt58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 092/570] scsi: mpi3mr: Add NULL checks when resetting request and reply queues
Date: Mon, 13 Apr 2026 17:53:43 +0200
Message-ID: <20260413155833.889911986@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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
index 939c3509b316a..9e5e44bc0c88a 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -3534,21 +3534,25 @@ void mpi3mr_memset_buffers(struct mpi3mr_ioc *mrioc)
 	memset(mrioc->devrem_bitmap, 0, mrioc->devrem_bitmap_sz);
 
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
 }
 
-- 
2.51.0



