Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FDA01A619E;
	Tue, 30 Jul 2024 16:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357809; cv=none; b=ZCiJ+VEPpCu4cdNkRudkYSqzT1gbHrTq5zwQ0OcDd6vGLMPkmpVldXfIVJbWurCvgM9CmqY2z980oEbBNLf7oTRfivVOC1ZibgjIVOPKOGYGKZSxSchpEjiFL+7NLVkBDNzclNMEEDIPhvuq9q4MQQzcOc5RBD77Ojnz9vRNL9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357809; c=relaxed/simple;
	bh=SFtIKmLOYfLsgP02N3EtBFY+8pgi2zWRqrh/l7VvvrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DVIZUFlDje+Cw8ojIwVYfJnEks/5pLnw6sv4TgJDMwKPMW7U9GB5AHAiMjD3btcVMWaaW2+lDSPhM8eOlLnhB2IOXxxEd/hL6xRtFyPtA8E1H2ls51wKAZwrS8HbwXBHMRMLWaoo0jYUXKV4ZN8i1kf4shpkZuooSfDb7ce92d8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fGsCOPnX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fGsCOPnX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C010FC4AF0A;
	Tue, 30 Jul 2024 16:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357809;
	bh=SFtIKmLOYfLsgP02N3EtBFY+8pgi2zWRqrh/l7VvvrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fGsCOPnXykNWkQnFLO2jvM8cnbAoKEXdC+CRen156L1Lk2NkwNP4UjOjHcQZBQSKf
	 oINDHW0Qte1Nirx1LbdrjWhGmRXwEA6DvwKW4DYVJZgTW7fC7lFcOfRitI8VvoFMfK
	 ay0ye6YqGQSDsn3erMojGp1vzdhPKn+Sy4mDKg/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saurav Kashyap <skashyap@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 329/440] scsi: qla2xxx: Return ENOBUFS if sg_cnt is more than one for ELS cmds
Date: Tue, 30 Jul 2024 17:49:22 +0200
Message-ID: <20240730151628.668331035@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


