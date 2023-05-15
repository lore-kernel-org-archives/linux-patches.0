Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA88FBF3
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:03:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6E34C433EF;
	Mon, 15 May 2023 17:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170196;
	bh=XcddAwIZZOax9ORc0ZUH0QwO7cooyu+6ToCAIe0GRm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fV5gRwe//EVcguR1r0CQT3yJQVEDJzq2m9MdvLqPFd06ALIji2mYdwVUyw6mHEtwu
	 78qjuoLUrKnIyBMWJKIDyPUCLUNgYpWOojtaZHI1PcaLAdyHg6DumtwxlvaWMHj/eW
	 RALBGs09YcSQx2w7oV4nZUZ3Ggq7V/eHSKsL6WCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Wang <zyytlz.wz@163.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 026/239] scsi: qedi: Fix use after free bug in qedi_remove()
Date: Mon, 15 May 2023 18:24:49 +0200
Message-Id: <20230515161722.478235615@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>
References: <20230515161721.545370111@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zheng Wang <zyytlz.wz@163.com>

[ Upstream commit c5749639f2d0a1f6cbe187d05f70c2e7c544d748 ]

In qedi_probe() we call __qedi_probe() which initializes
&qedi->recovery_work with qedi_recovery_handler() and
&qedi->board_disable_work with qedi_board_disable_work().

When qedi_schedule_recovery_handler() is called, schedule_delayed_work()
will finally start the work.

In qedi_remove(), which is called to remove the driver, the following
sequence may be observed:

Fix this by finishing the work before cleanup in qedi_remove().

CPU0                  CPU1

                     |qedi_recovery_handler
qedi_remove          |
  __qedi_remove      |
iscsi_host_free      |
scsi_host_put        |
//free shost         |
                     |iscsi_host_for_each_session
                     |//use qedi->shost

Cancel recovery_work and board_disable_work in __qedi_remove().

Fixes: 4b1068f5d74b ("scsi: qedi: Add MFW error recovery process")
Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
Link: https://lore.kernel.org/r/20230413033422.28003-1-zyytlz.wz@163.com
Acked-by: Manish Rangankar <mrangankar@marvell.com>
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedi/qedi_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index df2fe7bd26d1b..f530bb0364939 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -2450,6 +2450,9 @@ static void __qedi_remove(struct pci_dev *pdev, int mode)
 		qedi_ops->ll2->stop(qedi->cdev);
 	}
 
+	cancel_delayed_work_sync(&qedi->recovery_work);
+	cancel_delayed_work_sync(&qedi->board_disable_work);
+
 	qedi_free_iscsi_pf_param(qedi);
 
 	rval = qedi_ops->common->update_drv_state(qedi->cdev, false);
-- 
2.39.2



