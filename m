Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3019919E7FA;
	Thu, 15 Aug 2024 13:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728793; cv=none; b=a8dO5NMufv2QcPAW+UffpSUp2T7/TSIJaYvddejs3jZUh70VRqHIQtoxA+bENEhqCvX6lfXr+mP8Ttjr9e66OWrc1CtjOREBEmPwQtVCkORsoyH1QzIS6LcowvFnd3R8GmlvHbsjJLNCvaseICmbaS+YO9CQ1m3T8YNjmd8nrZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728793; c=relaxed/simple;
	bh=TRslK+USR1uVIjq9+65XrZkRn55nq3AB2NfQmt+OLck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rSJtQKdFMIcUhU3qgl0ESaeFKoGGx11NcvXRuc9oxol05TvS+nCcTp46ikUSu0r5b62rFG2htsKYbMR8LOQCKJWh1JDZZRHQgMqwj089y/52xd2gPVKywze7Pw0U5ym+7QEppIBDmrJUcZG2U3+kTaNZ0ZQxUSLPVLS2kQeunDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f9wAABje; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f9wAABje"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3056C32786;
	Thu, 15 Aug 2024 13:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728793;
	bh=TRslK+USR1uVIjq9+65XrZkRn55nq3AB2NfQmt+OLck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f9wAABje+vamgU0LHKHSZjtcEei2IwSi0xES7ieaY2gujNWzgOX/SxZjQwk2L/9p9
	 +IkVA3e8+lGGKDYjdj6bfaJbv2N6ioyNUb7gqiydgODqbEgD5mOUAReYz1H3/XaWlG
	 60iCAlI3HkN1yPCgsj6qbenzHCr1zCI8kM2WYKRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saurav Kashyap <skashyap@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.19 080/196] scsi: qla2xxx: Return ENOBUFS if sg_cnt is more than one for ELS cmds
Date: Thu, 15 Aug 2024 15:23:17 +0200
Message-ID: <20240815131855.136919306@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -302,7 +302,7 @@ qla2x00_process_els(struct bsg_job *bsg_
 		    "request_sg_cnt=%x reply_sg_cnt=%x.\n",
 		    bsg_job->request_payload.sg_cnt,
 		    bsg_job->reply_payload.sg_cnt);
-		rval = -EPERM;
+		rval = -ENOBUFS;
 		goto done;
 	}
 


