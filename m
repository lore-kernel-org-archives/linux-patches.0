Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46FB113FD94;
	Thu, 11 Apr 2024 10:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830999; cv=none; b=YTq038x6qJbigVYdAt2rj6WJ19FLcjHHxVknlWvQ0bGO49WcBdCFp3nQe73m5g45njXIVawQYsers41MEcIirc2qCJOZqiw/BOaYmqvCduPV18vA9CZ3fEVpKj7saKCQINb5zEfUsas8szmw8IvEkDLsvsdqu3QAcAdH8ouweuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830999; c=relaxed/simple;
	bh=Fo+QAWM3ObBJzZl4gxAIbtgtf2+1lxARBJK0gyPdAag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HcvlqXZTuCy1EYWBY/Wy/ygJouY2EMXC9wr+U8TgcTOEHVnBE5RH/PpNZO6qWRjAUenIPP7pP0ke/7CZRCW/mfAHNkKSC7qLdvJkr8d8epWvz0OikRobdeBFB/2k/Qj+YJGV1WrM89+/0+MmoW6WvLxlj+4iuslr2eQX8T/ybSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qqn6+xBz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qqn6+xBz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA0A6C433C7;
	Thu, 11 Apr 2024 10:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830999;
	bh=Fo+QAWM3ObBJzZl4gxAIbtgtf2+1lxARBJK0gyPdAag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qqn6+xBzh9hAFQ/kX6+HPhFcs/K/ep/BhQ0EiFj4J9Qqp5CspfYt1/r+C7iRPQKTb
	 eqVxxlREpxeKR2Bo3UaLN/1hBMhsggTtI0oW8pxP6Wi7MsMf0wIm9708qE6fmwt+/3
	 eEM135CJWanMf51rzKk5Ii4D7HkImCRrnpB2CCdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 187/215] scsi: lpfc: Fix possible memory leak in lpfc_rcv_padisc()
Date: Thu, 11 Apr 2024 11:56:36 +0200
Message-ID: <20240411095430.486189488@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit 2ae917d4bcab80ab304b774d492e2fcd6c52c06b ]

The call to lpfc_sli4_resume_rpi() in lpfc_rcv_padisc() may return an
unsuccessful status.  In such cases, the elsiocb is not issued, the
completion is not called, and thus the elsiocb resource is leaked.

Check return value after calling lpfc_sli4_resume_rpi() and conditionally
release the elsiocb resource.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20240131185112.149731-3-justintee8345@gmail.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index e6a94f550a572..1ca3179444d23 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -781,8 +781,10 @@ lpfc_rcv_padisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 				/* Save the ELS cmd */
 				elsiocb->drvrTimeout = cmd;
 
-				lpfc_sli4_resume_rpi(ndlp,
-					lpfc_mbx_cmpl_resume_rpi, elsiocb);
+				if (lpfc_sli4_resume_rpi(ndlp,
+						lpfc_mbx_cmpl_resume_rpi,
+						elsiocb))
+					kfree(elsiocb);
 				goto out;
 			}
 		}
-- 
2.43.0



