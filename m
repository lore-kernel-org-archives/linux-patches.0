Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FEE319DFAE;
	Thu, 15 Aug 2024 13:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729801; cv=none; b=blHs5UW4ANZpj4kn7Fr22KGNk2j5u6nKor+cWgMflLN1aJUmokAF/mERLpTqHvBVtw1kAvQY91yu+8FWW+UbE+PLklvUwB4htoMd7b/F9Hx1ZLPVbz4Ktio15K0JVxB1Q+bPQlbyN4AKuS1NtburwXG4cjYkmD3S32ePIHnqz6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729801; c=relaxed/simple;
	bh=92xs46+fCvlK0mbJBOHXmF9xXqSzU+SMFIetFJem1Xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qz8tdXqoJD1U2bYRfS2dASuBKm+JfPhQ08LoYx4Jt+Vi54aouv3eu9L4G9zaWUPsQmY/VK6j4AoYRTWOVsSrtvL6VFU1pjVwmkK8qnLpyVBNnIpHEPd7VCVtvmMhi1MT0+V3lIjnHEBzZIUxldMVuyAYzDMbD0WadY2KdihNfgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NdLPpePU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NdLPpePU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C653C32786;
	Thu, 15 Aug 2024 13:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729801;
	bh=92xs46+fCvlK0mbJBOHXmF9xXqSzU+SMFIetFJem1Xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NdLPpePUBrV4ObYiTUD9pT+oPkn4a0ORZvQc2BtXPBFLRv0vuv8iBUlgltd5HG6gA
	 BzZBE4Nt5Oh447i4BQsX8CFnpdzluDlwH5vcs+CNymTQJURyTr2O/26YVKCmaivvP5
	 F6nwsa4lzUk42A/UtSve+yAlBbAIKMXK1+bOOCeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saurav Kashyap <skashyap@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 212/484] scsi: qla2xxx: Return ENOBUFS if sg_cnt is more than one for ELS cmds
Date: Thu, 15 Aug 2024 15:21:10 +0200
Message-ID: <20240815131949.599706568@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -324,7 +324,7 @@ qla2x00_process_els(struct bsg_job *bsg_
 		    "request_sg_cnt=%x reply_sg_cnt=%x.\n",
 		    bsg_job->request_payload.sg_cnt,
 		    bsg_job->reply_payload.sg_cnt);
-		rval = -EPERM;
+		rval = -ENOBUFS;
 		goto done;
 	}
 


