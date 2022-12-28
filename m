Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9A41875
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:07:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A03BC433F2;
	Wed, 28 Dec 2022 16:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243648;
	bh=Qd2m5/xRBeimlslnLbLYJmHKbk8+HjjwVBuPxQIu2No=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C2wZKV+SNAPytSoG94wVQU85E6HqAD8PA6N+fc43t5GtEghR5fxZcKmkCmAGlOw2g
	 wB77/iMFerYdvnjO0YBySQL0FYthV0yJ8/oRorIMrlX49Czjb0W7cmWOde9Tld0cQ8
	 38MplCvTM/cnxxYvkprZIhh+oWqbIo9Xyg+Lkw/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Christie <michael.christie@oracle.com>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Ming Lei <ming.lei@redhat.com>,
	John Garry <john.garry@huawei.com>,
	Hannes Reinecke <hare@suse.de>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0563/1073] scsi: core: Fix a race between scsi_done() and scsi_timeout()
Date: Wed, 28 Dec 2022 15:35:51 +0100
Message-Id: <20221228144343.349213519@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 978b7922d3dca672b41bb4b8ce6c06ab77112741 ]

If there is a race between scsi_done() and scsi_timeout() and if
scsi_timeout() loses the race, scsi_timeout() should not reset the request
timer. Hence change the return value for this case from BLK_EH_RESET_TIMER
into BLK_EH_DONE.

Although the block layer holds a reference on a request (req->ref) while
calling a timeout handler, restarting the timer (blk_add_timer()) while a
request is being completed is racy.

Reviewed-by: Mike Christie <michael.christie@oracle.com>
Cc: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: John Garry <john.garry@huawei.com>
Cc: Hannes Reinecke <hare@suse.de>
Reported-by: Adrian Hunter <adrian.hunter@intel.com>
Fixes: 15f73f5b3e59 ("blk-mq: move failure injection out of blk_mq_complete_request")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20221018202958.1902564-2-bvanassche@acm.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_error.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 448748e3fba5..f00212777f82 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -342,19 +342,11 @@ enum blk_eh_timer_return scsi_timeout(struct request *req)
 
 	if (rtn == BLK_EH_DONE) {
 		/*
-		 * Set the command to complete first in order to prevent a real
-		 * completion from releasing the command while error handling
-		 * is using it. If the command was already completed, then the
-		 * lower level driver beat the timeout handler, and it is safe
-		 * to return without escalating error recovery.
-		 *
-		 * If timeout handling lost the race to a real completion, the
-		 * block layer may ignore that due to a fake timeout injection,
-		 * so return RESET_TIMER to allow error handling another shot
-		 * at this command.
+		 * If scsi_done() has already set SCMD_STATE_COMPLETE, do not
+		 * modify *scmd.
 		 */
 		if (test_and_set_bit(SCMD_STATE_COMPLETE, &scmd->state))
-			return BLK_EH_RESET_TIMER;
+			return BLK_EH_DONE;
 		if (scsi_abort_command(scmd) != SUCCESS) {
 			set_host_byte(scmd, DID_TIME_OUT);
 			scsi_eh_scmd_add(scmd);
-- 
2.35.1



