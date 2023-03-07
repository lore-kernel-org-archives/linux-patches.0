Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B85BA3E
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:45:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADF09C433D2;
	Tue,  7 Mar 2023 17:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678211126;
	bh=yoipyHVEPDxw1ufUp3RcguQ373RLewN0ZSsGTysPq+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AxdhWqHssDounqHAkQ0QCcjtloFC7peSAR/vw/uygWST42PDC1hAkZwq+ctdJAFxK
	 5JI8rv8dJ1aEaVH2KBFYNg6dB75CzzfqRHfwFdLcAsA5y1aCvSu2n8LIKtIYf2SAWA
	 Cl/AUn6b8fB5EpvoSz18tlNTCeGxn4t9y2PwvxBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mason Zhang <Mason.Zhang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0730/1001] scsi: ufs: core: Fix device management cmd timeout flow
Date: Tue,  7 Mar 2023 17:58:22 +0100
Message-Id: <20230307170053.378515767@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mason Zhang <Mason.Zhang@mediatek.com>

[ Upstream commit 36822124f9de200cedc2f42516301b50d386a6cd ]

In the UFS error handling flow, the host will send a device management cmd
(NOP OUT) to the device for link recovery. If this cmd times out and
clearing the doorbell fails, ufshcd_wait_for_dev_cmd() will do nothing and
return. hba->dev_cmd.complete struct is not set to NULL.

When this happens, if cmd has been completed by device, then we will call
complete() in __ufshcd_transfer_req_compl(). Because the complete struct is
allocated on the stack, the following crash will occur:

  ipanic_die+0x24/0x38 [mrdump]
  die+0x344/0x748
  arm64_notify_die+0x44/0x104
  do_debug_exception+0x104/0x1e0
  el1_dbg+0x38/0x54
  el1_sync_handler+0x40/0x88
  el1_sync+0x8c/0x140
  queued_spin_lock_slowpath+0x2e4/0x3c0
  __ufshcd_transfer_req_compl+0x3b0/0x1164
  ufshcd_trc_handler+0x15c/0x308
  ufshcd_host_reset_and_restore+0x54/0x260
  ufshcd_reset_and_restore+0x28c/0x57c
  ufshcd_err_handler+0xeb8/0x1b6c
  process_one_work+0x288/0x964
  worker_thread+0x4bc/0xc7c
  kthread+0x15c/0x264
  ret_from_fork+0x10/0x30

Link: https://lore.kernel.org/r/20221216032532.1280-1-mason.zhang@mediatek.com
Signed-off-by: Mason Zhang <Mason.Zhang@mediatek.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index fd6f421ff4a46..2ddc1aba0ad75 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3008,6 +3008,22 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba *hba,
 		} else {
 			dev_err(hba->dev, "%s: failed to clear tag %d\n",
 				__func__, lrbp->task_tag);
+
+			spin_lock_irqsave(&hba->outstanding_lock, flags);
+			pending = test_bit(lrbp->task_tag,
+					   &hba->outstanding_reqs);
+			if (pending)
+				hba->dev_cmd.complete = NULL;
+			spin_unlock_irqrestore(&hba->outstanding_lock, flags);
+
+			if (!pending) {
+				/*
+				 * The completion handler ran while we tried to
+				 * clear the command.
+				 */
+				time_left = 1;
+				goto retry;
+			}
 		}
 	}
 
-- 
2.39.2



