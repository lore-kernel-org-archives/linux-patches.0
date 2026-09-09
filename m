Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F4D563FA3;
	Wed,  9 Sep 2026 13:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961794; cv=none; b=fuPH/wGktv+grCJSsrke4HrkOxjluIadDuEba9sOMe262EJ09mnIatJI0CDel7rFGjLMX4qqM2sJa7omNzFpCwrmS9wfOLL++y+OgqZIOGX9dzZ9ZRJ5aml/fmgboMkqZd6RRy5ZjPuIp6NLEB8eBSGIgrtjB6h1+eIBmgNlL9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961794; c=relaxed/simple;
	bh=pCwsPCWMqs7WhvxqMoWyCQFtsiDoDoMKgLx7ISaFkQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WFMvbfAMi7E4sj5w9Y/YWl/TDjftgtTZRZXZItOj3a7XOVo0c8LX0hSMYLp8wgD/sEJqt0qMXxpyLERjTOAyzAVocC1Os/EPBIRssgqi7sNj0r0l6CN44TXbqENpHFaKBJbtRMLuGNWPoG+YbKJGpHLaLULdNYPDpbHi/7Ogs8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UatICo3O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UatICo3O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D3691F00A3A;
	Wed,  9 Sep 2026 13:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961792;
	bh=v2eLgdlyCZWLXTaVMN4u9loObxf1barCEIPacUl9SGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UatICo3OQW9aWOd8s7oM9tnRFHeqsNLOg8xT4RzZwS6oTYCLfaXzu1iAgXc6Yr9Uo
	 Js6tYgE3LPB1pQMFWLb9ndVHfFuobFWjGMmqUIHOEbCUvol/agVTM24mhsFoMCYi21
	 PrM3efG/4/Wcxw1nrFnc4Pgqpkfhkx26iQT8wOQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 7.2 068/556] scsi: bsg: Cap io_uring sense copy to max_response_len
Date: Wed,  9 Sep 2026 15:35:48 +0200
Message-ID: <20260909134232.855098277@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Xiuwei <yangxiuwei@kylinos.cn>

commit ece06de726737e887dc0225c8283477624f8ae21 upstream.

Completion copied scmd->sense_len to the user response buffer without
honoring max_response_len. After a valid sense, the midlayer sets
sense_len to the real length (up to SCSI_SENSE_BUFFERSIZE), so a smaller
user buffer was overrun.

Fixes: 7b6d3255e7f8 ("scsi: bsg: add io_uring passthrough handler")
Cc: stable@vger.kernel.org
Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
Link: https://patch.msgid.link/20260817080730.967879-2-yangxiuwei@kylinos.cn
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/scsi_bsg.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/scsi/scsi_bsg.c
+++ b/drivers/scsi/scsi_bsg.c
@@ -18,6 +18,7 @@ struct scsi_bsg_uring_cmd_pdu {
 	struct bio *bio;		/* mapped user buffer, unmap in task work */
 	struct request *req;		/* block request, freed in task work */
 	u64 response_addr;		/* user space response buffer address */
+	u32 max_response_len;		/* user response buffer size */
 };
 static_assert(sizeof(struct scsi_bsg_uring_cmd_pdu) <= sizeof_field(struct io_uring_cmd, pdu));
 
@@ -45,8 +46,8 @@ static void scsi_bsg_uring_task_cb(struc
 	if (scsi_status_is_check_condition(scmd->result)) {
 		driver_status = DRIVER_SENSE;
 		if (pdu->response_addr)
-			sense_len_wr = min_t(u8, scmd->sense_len,
-					     SCSI_SENSE_BUFFERSIZE);
+			sense_len_wr = min_t(unsigned int, pdu->max_response_len,
+					     scmd->sense_len);
 	}
 
 	if (sense_len_wr) {
@@ -155,8 +156,7 @@ static int scsi_bsg_uring_cmd(struct req
 	}
 
 	pdu->response_addr = cmd->response;
-	scmd->sense_len = cmd->max_response_len ?
-		min(cmd->max_response_len, SCSI_SENSE_BUFFERSIZE) : SCSI_SENSE_BUFFERSIZE;
+	pdu->max_response_len = cmd->max_response_len;
 
 	if (cmd->dout_xfer_len || cmd->din_xfer_len) {
 		ret = scsi_bsg_map_user_buffer(req, ioucmd, issue_flags, gfp_mask);


