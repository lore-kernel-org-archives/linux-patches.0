Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8058B6FB0;
	Tue,  5 Dec 2023 03:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tM6NoJfi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10444C433C8;
	Tue,  5 Dec 2023 03:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701748030;
	bh=vi4oxmR5lx8uMMLtTsPVLIB6n1mFIf9aK/TPxlPVNE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tM6NoJfiu9ZA4jURR6zcQjTSrJXViTMkhE0d/2u6yM7oLMYlOh9M6FhJrW1T9MuMp
	 3O1Je+N5VzYMAdvLZBKjZgmZUUsOhpEUZ/Chz1hwRmhPNGqehleRdjtfHeW64jz0xn
	 N2W2TzAmitcibAwTNTJSujz9GryD7oLrS/s25l1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 86/94] scsi: qla2xxx: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date: Tue,  5 Dec 2023 12:17:54 +0900
Message-ID: <20231205031527.604321565@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031522.815119918@linuxfoundation.org>
References: <20231205031522.815119918@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit c7d6b2c2cd5656b05849afb0de3f422da1742d0f ]

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Link: https://lore.kernel.org/r/20210809230355.8186-39-bvanassche@acm.org
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 19597cad64d6 ("scsi: qla2xxx: Fix system crash due to bad pointer access")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_os.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 8329b80c41eb7..eb6fb78ebefde 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -814,7 +814,7 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 		uint16_t hwq;
 		struct qla_qpair *qpair = NULL;
 
-		tag = blk_mq_unique_tag(cmd->request);
+		tag = blk_mq_unique_tag(scsi_cmd_to_rq(cmd));
 		hwq = blk_mq_unique_tag_to_hwq(tag);
 		qpair = ha->queue_pair_map[hwq];
 
@@ -1705,7 +1705,7 @@ static void qla2x00_abort_srb(struct qla_qpair *qp, srb_t *sp, const int res,
 		}
 
 		spin_lock_irqsave(qp->qp_lock_ptr, *flags);
-		if (ret_cmd && blk_mq_request_started(cmd->request))
+		if (ret_cmd && blk_mq_request_started(scsi_cmd_to_rq(cmd)))
 			sp->done(sp, res);
 	} else {
 		sp->done(sp, res);
-- 
2.42.0



