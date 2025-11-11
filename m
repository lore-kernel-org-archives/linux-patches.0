Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA29248883;
	Tue, 11 Nov 2025 01:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823452; cv=none; b=YSrCa+7CChy0TtbBGcc5uHTfh9Z+r0JhwuU0GpRbnkxgdRfSHhHt1Dn/2q6UxZxR+X/uR4gzzAPu6pW5YsyZavn6YC+tTz0PobAtMpxFhVY1U1QbXSCw6JM/0+JGOr4CO9f0NyNk9FunvWwOMIpwZO9tgYJYuYmuG+Fg/faqrkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823452; c=relaxed/simple;
	bh=v5x84/pI+pOpqXV9le+fdA6yNOhu2sdNls6sBXTz3IU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mIlW/+z+U8+G9tXuTF4TRW4QnYIobpC7JyDQZNZkqM4e1s8KZqzmmaHjU3OXSlxyLVl7DoDqLZFqLw0wACa+D0PAafFIZOppgIbN9RdtwB4LkgHQwfXyoTfkYtjC2D1pSDrOMoTaQiDgFbBX9Lwi79BLgWoA7gcYSTV9HZS36uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F00v38Ry; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F00v38Ry"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A37BC113D0;
	Tue, 11 Nov 2025 01:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823451;
	bh=v5x84/pI+pOpqXV9le+fdA6yNOhu2sdNls6sBXTz3IU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F00v38RyOAutbpOHA2uiklEF9n4ny7ByvucojLwpoGnW8sERLDl924ZrXFDuy7UnG
	 Q7ZnBrlBZO/4HqBKs73Lr/twfB2MuRznOWOQlTBghWaM/ZY8kEiNtRH0E4k8jGueLG
	 8WmPI6vHSVZY5oK20SVLk9rOSBDQsMC6bb8DJoXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 249/565] scsi: mpi3mr: Fix I/O failures during controller reset
Date: Tue, 11 Nov 2025 09:41:45 +0900
Message-ID: <20251111004532.510765438@linuxfoundation.org>
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

[ Upstream commit b7b2176e30fc8e57664e5a8a23387af66eb7f72b ]

I/Os can race with controller reset and fail.

Block requests at the mid layer when reset starts using
scsi_host_block(), and resume with scsi_host_unblock() after reset
completes.

Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Link: https://lore.kernel.org/r/20250820084138.228471-4-chandrakanth.patil@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 3 +++
 drivers/scsi/mpi3mr/mpi3mr_os.c | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 08c751884b327..82cbe98e8a044 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -5372,6 +5372,7 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
 	    mpi3mr_reset_rc_name(reset_reason));
 
 	mrioc->device_refresh_on = 0;
+	scsi_block_requests(mrioc->shost);
 	mrioc->reset_in_progress = 1;
 	mrioc->stop_bsgs = 1;
 	mrioc->prev_reset_result = -1;
@@ -5480,6 +5481,7 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
 	if (!retval) {
 		mrioc->diagsave_timeout = 0;
 		mrioc->reset_in_progress = 0;
+		scsi_unblock_requests(mrioc->shost);
 		mrioc->pel_abort_requested = 0;
 		if (mrioc->pel_enabled) {
 			mrioc->pel_cmds.retry_count = 0;
@@ -5504,6 +5506,7 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
 		mrioc->device_refresh_on = 0;
 		mrioc->unrecoverable = 1;
 		mrioc->reset_in_progress = 0;
+		scsi_unblock_requests(mrioc->shost);
 		mrioc->stop_bsgs = 0;
 		retval = -1;
 		mpi3mr_flush_cmds_for_unrecovered_controller(mrioc);
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 1930e47cbf7bd..894d358ade75b 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -2839,12 +2839,14 @@ static void mpi3mr_preparereset_evt_th(struct mpi3mr_ioc *mrioc,
 		    "prepare for reset event top half with rc=start\n");
 		if (mrioc->prepare_for_reset)
 			return;
+		scsi_block_requests(mrioc->shost);
 		mrioc->prepare_for_reset = 1;
 		mrioc->prepare_for_reset_timeout_counter = 0;
 	} else if (evtdata->reason_code == MPI3_EVENT_PREPARE_RESET_RC_ABORT) {
 		dprint_event_th(mrioc,
 		    "prepare for reset top half with rc=abort\n");
 		mrioc->prepare_for_reset = 0;
+		scsi_unblock_requests(mrioc->shost);
 		mrioc->prepare_for_reset_timeout_counter = 0;
 	}
 	if ((event_reply->msg_flags & MPI3_EVENT_NOTIFY_MSGFLAGS_ACK_MASK)
-- 
2.51.0



