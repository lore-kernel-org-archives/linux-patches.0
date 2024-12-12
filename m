Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 767382153EC;
	Thu, 12 Dec 2024 17:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025698; cv=none; b=eXjw5bsKMdok3KoNiQi1H8loOFxmJV7IqgvE0kP+FdqCix7/+9PuX9ZC0uuN6VV/N7wNomwQ2icQ2xZdQeTSL4mwc4l8j9MbVqsKsic3NkDp4un+Fm2A4fuhSG/Nf2Omg+0YEWBPEK529aZaBaKQQcqvxQMa8ZeEaXrKsIPBKA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025698; c=relaxed/simple;
	bh=FeSpDvAcljI+gjk3UYIvU2mmMNNCrrbRUvxqKvlnaDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ijo4UtTB4gC/mispKS48Ok5lfXO5Qy2u7iW6QGmF9yRI8hT1rdZgChmXSNPpCLXmSyTUgBIVFp+caata4J6HPxSUADDyOjrn987ozElY0CxfDwroTyBruRj2D+SChZdlE5uzYANk5wV8nEgmXLytXijnIBpAWY+1blliEgZ4TPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vVkUcvaK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vVkUcvaK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04EE6C4CED1;
	Thu, 12 Dec 2024 17:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025698;
	bh=FeSpDvAcljI+gjk3UYIvU2mmMNNCrrbRUvxqKvlnaDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vVkUcvaKx+5E8eTkmWgrDmIc2fN777PthyjPZah/ZdXXkl+44KnAFH7JSyMmA2hxv
	 bKnL2BLsMmyEcn144s/e7I8z+xAhKorVySOMVIICfIiE8/MN4xvOhp1SV2KWL//UJr
	 5rC5Ym8bxgS3ZGnYkSCDncY/sdqAOmOXuqmYAfns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saurav Kashyap <skashyap@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 258/321] scsi: qla2xxx: Remove check req_sg_cnt should be equal to rsp_sg_cnt
Date: Thu, 12 Dec 2024 16:02:56 +0100
Message-ID: <20241212144240.159308483@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

From: Saurav Kashyap <skashyap@marvell.com>

commit 833c70e212fc40d3e98da941796f4c7bcaecdf58 upstream.

Firmware supports multiple sg_cnt for request and response for CT
commands, so remove the redundant check. A check is there where sg_cnt
for request and response should be same. This is not required as driver
and FW have code to handle multiple and different sg_cnt on request and
response.

Cc: stable@vger.kernel.org
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://lore.kernel.org/r/20241115130313.46826-5-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_bsg.c |   10 ----------
 1 file changed, 10 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -462,16 +462,6 @@ qla2x00_process_ct(struct bsg_job *bsg_j
 		goto done;
 	}
 
-	if ((req_sg_cnt !=  bsg_job->request_payload.sg_cnt) ||
-	    (rsp_sg_cnt != bsg_job->reply_payload.sg_cnt)) {
-		ql_log(ql_log_warn, vha, 0x7011,
-		    "request_sg_cnt: %x dma_request_sg_cnt: %x reply_sg_cnt:%x "
-		    "dma_reply_sg_cnt: %x\n", bsg_job->request_payload.sg_cnt,
-		    req_sg_cnt, bsg_job->reply_payload.sg_cnt, rsp_sg_cnt);
-		rval = -EAGAIN;
-		goto done_unmap_sg;
-	}
-
 	if (!vha->flags.online) {
 		ql_log(ql_log_warn, vha, 0x7012,
 		    "Host is not online.\n");


