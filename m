Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 006506FA1
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:25:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5359CC433D6;
	Wed, 30 Nov 2022 18:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669832742;
	bh=bzgxtzJg6SklpSstnlHnMYOaH1qdiZgItrc+nr3lWgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C1/hWvUIkqoq950TrhQwQop9yezHv2CktCu0CwsVwXcjZZZwdqC4l4zlQIFciA+i6
	 SFjmUc9+vUq18MaXYKRVgjTU7TBzMBFrn+xOF/oGmf+jC4+sVX4NKw+g9CpPv38sYS
	 ontRElr8y8QCRktPLVeh9nrwSbABKwNrIwNboaU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian King <brking@linux.vnet.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 025/162] scsi: ibmvfc: Avoid path failures during live migration
Date: Wed, 30 Nov 2022 19:21:46 +0100
Message-Id: <20221130180529.183487457@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Brian King <brking@linux.vnet.ibm.com>

[ Upstream commit 62fa3ce05d5d73c5eccc40b2db493f55fecfc446 ]

Fix an issue reported when performing a live migration when multipath is
configured with a short fast fail timeout of 5 seconds and also to have
no_path_retry set to fail. In this scenario, all paths would go into the
devloss state while the ibmvfc driver went through discovery to log back
in. On a loaded system, the discovery might take longer than 5 seconds,
which was resulting in all paths being marked failed, which then resulted
in a read only filesystem.

This patch changes the migration code in ibmvfc to avoid deleting rports at
all in this scenario, so we avoid losing all paths.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
Link: https://lore.kernel.org/r/20221026181356.148517-1-brking@linux.vnet.ibm.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index f6d6539c657f..b793e342ab7c 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -635,8 +635,13 @@ static void ibmvfc_init_host(struct ibmvfc_host *vhost)
 		memset(vhost->async_crq.msgs, 0, PAGE_SIZE);
 		vhost->async_crq.cur = 0;
 
-		list_for_each_entry(tgt, &vhost->targets, queue)
-			ibmvfc_del_tgt(tgt);
+		list_for_each_entry(tgt, &vhost->targets, queue) {
+			if (vhost->client_migrated)
+				tgt->need_login = 1;
+			else
+				ibmvfc_del_tgt(tgt);
+		}
+
 		scsi_block_requests(vhost->host);
 		ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_INIT);
 		vhost->job_step = ibmvfc_npiv_login;
@@ -2822,9 +2827,12 @@ static void ibmvfc_handle_crq(struct ibmvfc_crq *crq, struct ibmvfc_host *vhost)
 			/* We need to re-setup the interpartition connection */
 			dev_info(vhost->dev, "Partition migrated, Re-enabling adapter\n");
 			vhost->client_migrated = 1;
+
+			scsi_block_requests(vhost->host);
 			ibmvfc_purge_requests(vhost, DID_REQUEUE);
-			ibmvfc_link_down(vhost, IBMVFC_LINK_DOWN);
+			ibmvfc_set_host_state(vhost, IBMVFC_LINK_DOWN);
 			ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_REENABLE);
+			wake_up(&vhost->work_wait_q);
 		} else if (crq->format == IBMVFC_PARTNER_FAILED || crq->format == IBMVFC_PARTNER_DEREGISTER) {
 			dev_err(vhost->dev, "Host partner adapter deregistered or failed (rc=%d)\n", crq->format);
 			ibmvfc_purge_requests(vhost, DID_ERROR);
-- 
2.35.1



