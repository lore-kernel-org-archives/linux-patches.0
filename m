Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C36C1FB4
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:15:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A72CDC433D2;
	Fri,  3 Feb 2023 10:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675419357;
	bh=hdaUjU7GJ6ATGvbFasBr8txneDTa8HH0FqNFA5ulQ1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eKhhK1PeRapiHCMVYzPepWqWGOo/d/PzP4+9i16r2qSpCDVamCljO5k+cfcVleM/7
	 qaIM/qMPK84qsIWDK2DnWkNvwstsT9FyKEY5Ylcz7dKivYspZ3PCvg4+iGa2aaGo0y
	 vuWgzprMdZ//M5jpKPQqw/ekQolQWWxN25eqp0mA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <jthumshirn@suse.de>,
	Himanshu Madhani <himanshu.madhani@cavium.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.14 42/62] scsi: qla2xxx: dont break the bsg-lib abstractions
Date: Fri,  3 Feb 2023 11:12:38 +0100
Message-Id: <20230203101014.763575331@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101012.959398849@linuxfoundation.org>
References: <20230203101012.959398849@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

commit 05231a3bb7981b01f6933c0a847fcaac25622bfd upstream.

Always use bsg_job->reply instead of scsi_req(bsg_job->req)->sense), as
they always point to the same memory.

Never set scsi_req(bsg_job->req)->result and we'll set that value
through bsg_job_done.

[mkp: applied by hand, fixed whitespace]

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@cavium.com>
Tested-by: Himanshu Madhani <himanshu.madhani@cavium.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_bsg.c |   10 ++++------
 drivers/scsi/qla2xxx/qla_isr.c |   12 +++---------
 drivers/scsi/qla2xxx/qla_mr.c  |    3 +--
 3 files changed, 8 insertions(+), 17 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -924,9 +924,9 @@ qla2x00_process_loopback(struct bsg_job
 
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply) +
 	    sizeof(response) + sizeof(uint8_t);
-	fw_sts_ptr = ((uint8_t *)scsi_req(bsg_job->req)->sense) +
-	    sizeof(struct fc_bsg_reply);
-	memcpy(fw_sts_ptr, response, sizeof(response));
+	fw_sts_ptr = bsg_job->reply + sizeof(struct fc_bsg_reply);
+	memcpy(bsg_job->reply + sizeof(struct fc_bsg_reply), response,
+			sizeof(response));
 	fw_sts_ptr += sizeof(response);
 	*fw_sts_ptr = command_sent;
 
@@ -2558,13 +2558,11 @@ qla24xx_bsg_timeout(struct bsg_job *bsg_
 						ql_log(ql_log_warn, vha, 0x7089,
 						    "mbx abort_command "
 						    "failed.\n");
-						scsi_req(bsg_job->req)->result =
 						bsg_reply->result = -EIO;
 					} else {
 						ql_dbg(ql_dbg_user, vha, 0x708a,
 						    "mbx abort_command "
 						    "success.\n");
-						scsi_req(bsg_job->req)->result =
 						bsg_reply->result = 0;
 					}
 					spin_lock_irqsave(&ha->hardware_lock, flags);
@@ -2575,7 +2573,7 @@ qla24xx_bsg_timeout(struct bsg_job *bsg_
 	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	ql_log(ql_log_info, vha, 0x708b, "SRB not found to abort.\n");
-	scsi_req(bsg_job->req)->result = bsg_reply->result = -ENXIO;
+	bsg_reply->result = -ENXIO;
 	return 0;
 
 done:
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1540,7 +1540,6 @@ qla24xx_els_ct_entry(scsi_qla_host_t *vh
 	struct fc_bsg_reply *bsg_reply;
 	uint16_t comp_status;
 	uint32_t fw_status[3];
-	uint8_t* fw_sts_ptr;
 	int res;
 
 	sp = qla2x00_get_sp_from_handle(vha, func, req, pkt);
@@ -1601,11 +1600,7 @@ qla24xx_els_ct_entry(scsi_qla_host_t *vh
 			    type, sp->handle, comp_status, fw_status[1], fw_status[2],
 			    le16_to_cpu(((struct els_sts_entry_24xx *)
 				pkt)->total_byte_count));
-			fw_sts_ptr = ((uint8_t*)scsi_req(bsg_job->req)->sense) +
-				sizeof(struct fc_bsg_reply);
-			memcpy( fw_sts_ptr, fw_status, sizeof(fw_status));
-		}
-		else {
+		} else {
 			ql_dbg(ql_dbg_user, vha, 0x5040,
 			    "ELS-CT pass-through-%s error hdl=%x comp_status-status=0x%x "
 			    "error subcode 1=0x%x error subcode 2=0x%x.\n",
@@ -1616,10 +1611,9 @@ qla24xx_els_ct_entry(scsi_qla_host_t *vh
 				    pkt)->error_subcode_2));
 			res = DID_ERROR << 16;
 			bsg_reply->reply_payload_rcv_len = 0;
-			fw_sts_ptr = ((uint8_t*)scsi_req(bsg_job->req)->sense) +
-					sizeof(struct fc_bsg_reply);
-			memcpy( fw_sts_ptr, fw_status, sizeof(fw_status));
 		}
+		memcpy(bsg_job->reply + sizeof(struct fc_bsg_reply),
+		       fw_status, sizeof(fw_status));
 		ql_dump_buffer(ql_dbg_user + ql_dbg_buffer, vha, 0x5056,
 				(uint8_t *)pkt, sizeof(*pkt));
 	}
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -2222,8 +2222,7 @@ qlafx00_ioctl_iosb_entry(scsi_qla_host_t
 		memcpy(fstatus.reserved_3,
 		    pkt->reserved_2, 20 * sizeof(uint8_t));
 
-		fw_sts_ptr = ((uint8_t *)scsi_req(bsg_job->req)->sense) +
-		    sizeof(struct fc_bsg_reply);
+		fw_sts_ptr = bsg_job->reply + sizeof(struct fc_bsg_reply);
 
 		memcpy(fw_sts_ptr, (uint8_t *)&fstatus,
 		    sizeof(struct qla_mt_iocb_rsp_fx00));


