Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF7DC63D5;
	Thu, 15 Aug 2024 14:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732462; cv=none; b=gQwDu2rqztwhPmjpepICfglbk95tu4hZ/SRm0rcHeYfkPPLuKekYmKvPZttNHuFgMTUeiR2ajrKY+w8CvetULx8cfnlLi9V0k1Qfda8yHr3v/pwehmTYFxPG+/2S8Q/t/KJKcWs1HdoZZChYkseBRq9YgwvdCnNthkXQL0Fjh18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732462; c=relaxed/simple;
	bh=6KceMxnhRZI+NAr0ovey+/9QPaTgQxBm+A/yutiifcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WoOTLKmjBmqaX1rWJ6kZkap8Ke/8D9OjJHcldeCfQffgbIBwJLLtkR1t8TuBOgiAEz5aG9bItYOVzGEE0gA9EjKCdZGZ+jzBv+FXlzxNCARmQkVaYlQbRMBHFijI5iEps3PXQOXsKp786bFzlbyTWrPN6h7ckEhO10W6FsQB9as=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bQzqgq2+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bQzqgq2+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBFA5C32786;
	Thu, 15 Aug 2024 14:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732462;
	bh=6KceMxnhRZI+NAr0ovey+/9QPaTgQxBm+A/yutiifcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bQzqgq2+YTC3J1lIdhDUfTaGYgSb60kNF2Bu++5KBbsgrYa4dAfNpjTDbUzTZb1l0
	 BIRcJzV3nrZj4E58vGWnNevfXB3hOouNIr+aUAucbgYPQuNKD4Oh259GHtGoBQMaLn
	 Y7yZGbfKa6CciopIlq+ZxvnGw4bAgwQTwa321jNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saurav Kashyap <skashyap@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 156/352] scsi: qla2xxx: Return ENOBUFS if sg_cnt is more than one for ELS cmds
Date: Thu, 15 Aug 2024 15:23:42 +0200
Message-ID: <20240815131925.298941408@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

commit ce2065c4cc4f05635413f63f6dc038d7d4842e31 upstream.

Firmware only supports single DSDs in ELS Pass-through IOCB (0x53h), sg cnt
is decided by the SCSI ML. User is not aware of the cause of an acutal
error.

Return the appropriate return code that will be decoded by API and
application and proper error message will be displayed to user.

Fixes: 6e98016ca077 ("[SCSI] qla2xxx: Re-organized BSG interface specific code.")
Cc: stable@vger.kernel.org
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://lore.kernel.org/r/20240710171057.35066-5-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_bsg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -306,7 +306,7 @@ qla2x00_process_els(struct bsg_job *bsg_
 		    "request_sg_cnt=%x reply_sg_cnt=%x.\n",
 		    bsg_job->request_payload.sg_cnt,
 		    bsg_job->reply_payload.sg_cnt);
-		rval = -EPERM;
+		rval = -ENOBUFS;
 		goto done;
 	}
 


