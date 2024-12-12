Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C0620A5EE;
	Thu, 12 Dec 2024 17:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024660; cv=none; b=PKycOqROuW8LQigOK8Hd2Lw1Grl9H5544C9qM4iPciiIVmQOlEAxd+cJW9vNYmjO06j8nkPpu9cUhcctCetlZWtOL3Yel93T8yfozty5En7SO55On3jmPwLnsLEHYQ3EJOMR6UwpCKM90obCy8AivutZCku8UqaxFHM48yBbhU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024660; c=relaxed/simple;
	bh=1UDDcBI2d0M2ulsfyAEtbtj4f+MlxsXnV7jTGCp2RBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qgX+1yG6x3AVaZJbjFOzk66Pizbn0yLq2ZOe7H8Fl2qnkmX1OVCHWs38ruCpka6+t+lAjpQa/ov2ThY+4nzc+wzxmaEj4+upZjXZqt9TcLqI+ju06PTeHgtAjko5e4GjollM8pEIcJZaLZGez1TbG0RwgKvbDgn9Pr9/EsJHJNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XRAusD1a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XRAusD1a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 946B2C4CECE;
	Thu, 12 Dec 2024 17:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024660;
	bh=1UDDcBI2d0M2ulsfyAEtbtj4f+MlxsXnV7jTGCp2RBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XRAusD1am6QTChQLUPaOTP2+ZKlLIpzQWZ0vkIPayCQKBJx012nFfSd62Ukmem1Ek
	 6yhaUQ7PKxh1lFtP3b6m1hMSJcTgSta3oYvnuLShxBI+J5QPUoPWKZx9LwVGxgAWKd
	 hta4+p3hHRvClGvaza/3dONFwZXfELAnlRYJy6hk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saurav Kashyap <skashyap@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 369/459] scsi: qla2xxx: Remove check req_sg_cnt should be equal to rsp_sg_cnt
Date: Thu, 12 Dec 2024 16:01:47 +0100
Message-ID: <20241212144308.247062862@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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
@@ -471,16 +471,6 @@ qla2x00_process_ct(struct bsg_job *bsg_j
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


