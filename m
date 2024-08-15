Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45FA21A706F;
	Thu, 15 Aug 2024 14:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731373; cv=none; b=TcH0pjnoeVgRddVZakrInK6b1efpkh7KbfCkdat+zyR3VZYxl7AXAbtG877kJZ7TxbHTcaLkb/j52+JNjAXR6ElHwHxjGM9h9iRrrWuBp47ElFp9ipS2a4NjU71WbPINi/6EPXoGjNUrJ5zaT3SuxqxT9RMk+vpOUMQpP7Grm/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731373; c=relaxed/simple;
	bh=+Q5vrW/vXQkLpHuHgQ39uG1Yv9mwsIA7Eg+yxE9Gwas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EBqlMLnR9PO743Skx2XCjcTAh7jQ2Urfr2wsXHnSdJz720Q/ZIFMwYptbt5W1hH/0eiuQfrG/VwGrQq4j/DWQbBhPOLkCu4UG48cflfshU33PEFSCUJWZmg7dqJxK5cuZr8e+WT1EPhsElz7DrAK9z7qDVROxrLaWX41cmX75rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W42/Syde; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W42/Syde"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BE60C4AF0E;
	Thu, 15 Aug 2024 14:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731372;
	bh=+Q5vrW/vXQkLpHuHgQ39uG1Yv9mwsIA7Eg+yxE9Gwas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W42/SydeSt8bkzdvC9OchJ6npV9W28GeRjlMAXCCwqLmewo5TrrzA/N9UwccyGG5h
	 XQShAv/lMZi6B6S1IGM/miS5ehqCTNY2m1bRrHlJ9vIKEM1kUyd7MnU93n41D5gePP
	 K3YcsL8t/P19RvbNyJy4kGO0QaCp5wiV+NJcLUZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saurav Kashyap <skashyap@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 109/259] scsi: qla2xxx: Return ENOBUFS if sg_cnt is more than one for ELS cmds
Date: Thu, 15 Aug 2024 15:24:02 +0200
Message-ID: <20240815131907.013353067@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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
@@ -297,7 +297,7 @@ qla2x00_process_els(struct bsg_job *bsg_
 		    "request_sg_cnt=%x reply_sg_cnt=%x.\n",
 		    bsg_job->request_payload.sg_cnt,
 		    bsg_job->reply_payload.sg_cnt);
-		rval = -EPERM;
+		rval = -ENOBUFS;
 		goto done;
 	}
 


