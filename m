Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C597416405
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0NPE9O/m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 131DDC433CC;
	Mon, 23 Oct 2023 11:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061325;
	bh=dgauo/7yKoDXSh6OYZRO9zZF+3Mwgwi2dgHUCfJyVZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0NPE9O/mZBawrvjbCdixeu76+QuX/G4GWAVv7PfaybD5xIJmbalhCKNKmz6pc2jAV
	 i7o2m/baF8c24TW0I43d/0gAdAt6o+grbXr/KW7c88JRUm3tTwB97gGPR0wT1i6Yvw
	 LNq/iQHTVDPr8scFrsTjZdPNs/lOzkqmQ4x4mRy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Pearson <rpearsonhpe@gmail.com>,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 002/202] RDMA/srp: Do not call scsi_done() from srp_abort()
Date: Mon, 23 Oct 2023 12:55:09 +0200
Message-ID: <20231023104826.639859777@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104826.569169691@linuxfoundation.org>
References: <20231023104826.569169691@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit e193b7955dfad68035b983a0011f4ef3590c85eb ]

After scmd_eh_abort_handler() has called the SCSI LLD eh_abort_handler
callback, it performs one of the following actions:
* Call scsi_queue_insert().
* Call scsi_finish_command().
* Call scsi_eh_scmd_add().
Hence, SCSI abort handlers must not call scsi_done(). Otherwise all
the above actions would trigger a use-after-free. Hence remove the
scsi_done() call from srp_abort(). Keep the srp_free_req() call
before returning SUCCESS because we may not see the command again if
SUCCESS is returned.

Cc: Bob Pearson <rpearsonhpe@gmail.com>
Cc: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Fixes: d8536670916a ("IB/srp: Avoid having aborted requests hang")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20230823205727.505681-1-bvanassche@acm.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index f47d104e6c9d7..12bc24ee2d131 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -2781,7 +2781,6 @@ static int srp_abort(struct scsi_cmnd *scmnd)
 	u32 tag;
 	u16 ch_idx;
 	struct srp_rdma_ch *ch;
-	int ret;
 
 	shost_printk(KERN_ERR, target->scsi_host, "SRP abort called\n");
 
@@ -2797,19 +2796,14 @@ static int srp_abort(struct scsi_cmnd *scmnd)
 	shost_printk(KERN_ERR, target->scsi_host,
 		     "Sending SRP abort for tag %#x\n", tag);
 	if (srp_send_tsk_mgmt(ch, tag, scmnd->device->lun,
-			      SRP_TSK_ABORT_TASK, NULL) == 0)
-		ret = SUCCESS;
-	else if (target->rport->state == SRP_RPORT_LOST)
-		ret = FAST_IO_FAIL;
-	else
-		ret = FAILED;
-	if (ret == SUCCESS) {
+			      SRP_TSK_ABORT_TASK, NULL) == 0) {
 		srp_free_req(ch, req, scmnd, 0);
-		scmnd->result = DID_ABORT << 16;
-		scmnd->scsi_done(scmnd);
+		return SUCCESS;
 	}
+	if (target->rport->state == SRP_RPORT_LOST)
+		return FAST_IO_FAIL;
 
-	return ret;
+	return FAILED;
 }
 
 static int srp_reset_device(struct scsi_cmnd *scmnd)
-- 
2.40.1



