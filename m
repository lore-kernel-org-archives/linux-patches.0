Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C98B215799;
	Thu, 12 Dec 2024 15:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018096; cv=none; b=Il+DXnfXqp4CAPqa/p8GvsgEbhrTEiYwq7GdYWI/aUvu5+TU/F8Lgr8OUlp57wimGhraGHovkMWkP9/jj56TTibCwuFG7zIKdYYZoO5ixtffYbLuvl10XzlQv696LnTAvgAdo3fB7+ONKyig/GHmZLw8Z/vcObeIL9WAmmQkriw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018096; c=relaxed/simple;
	bh=DfO83Np6x/cqKOHZsajcwhaaggW61KyZ+zmK5M+mSGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=alod30lZyfZMrCMbCxfVeYaXW0iRiqq3P1mwoMCsevx8Qd9mUZNuMrmZsyzDY/0Nz8BOUw8tPtnSX/ySsyy5RVqFibVsZ2u1pGYXW9tfNYdnUsXDXHlvwTJUJ2ZVs0eDfnZzoeuAnk3wb8VTOqVSgq9oRAJOsw/Y12zv9iOKVfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zGdhdz/T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zGdhdz/T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DB3BC4CECE;
	Thu, 12 Dec 2024 15:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018096;
	bh=DfO83Np6x/cqKOHZsajcwhaaggW61KyZ+zmK5M+mSGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zGdhdz/TbQTZaKMKqR7yw8pO/Z6iK9f1WauPF5ePTdI8B/iTMrjOlW0Dr/UaJaNnA
	 4GTKhGE/UBEJ6NbWclz314g/IyqJOh1HlWCqxH6EnRNR+0NS0MVH4DnE2a1oFQFgvb
	 vp5tjhhEkmegwefK/ROt3xM+G7ADb6o20ja8S4oA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saurav Kashyap <skashyap@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 156/356] scsi: qla2xxx: Remove check req_sg_cnt should be equal to rsp_sg_cnt
Date: Thu, 12 Dec 2024 15:57:55 +0100
Message-ID: <20241212144250.803458814@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -494,16 +494,6 @@ qla2x00_process_ct(struct bsg_job *bsg_j
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


