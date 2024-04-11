Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC332EAE5;
	Thu, 11 Apr 2024 10:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829938; cv=none; b=d0utLn6Z/aoAjWXQIVnFutf0P6pGNlExrsY9UZe6ITmwh83ChG9mFS8u3q5PYRLbHcrI/95bfFf7FEaiQoexLKk0LDZmz1GIT/Uga/DdnmlDw1DADpWkmcxJR0mvYejh37dXhqvX110y03DUHJEXfN9xyYO4tX+HaercsNo9Gh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829938; c=relaxed/simple;
	bh=b1RcDeVVB/q7Fmp2livCobzMKbQSm3bcIhNQu4IgSDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XdjpsPDqpkyP7LV9ovHMk5yNvN9rSA/N9XQp85nY4rwPBi2vSpS/Q8IcZSqUmOg0iLs7P/A93ectYiD33zM/yRzcSVhWXJPzOVGu7vl/ES9UPE5/8YA7qG2KDuvGAt0uY01Y95EsNEEzDZZZDoL85EZpBWP66SHT6OHiVUk0O/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AVZdiJNR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AVZdiJNR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24528C433F1;
	Thu, 11 Apr 2024 10:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829938;
	bh=b1RcDeVVB/q7Fmp2livCobzMKbQSm3bcIhNQu4IgSDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AVZdiJNR6XPfwO0giqZj0pH+pD3WVkzOFRbj2OO0YTpgymSWC8D/B+JQdidilG3JM
	 kpjnuykOcg6M7IJYTS/mrpv1zRpcDbzbAqWK2cF5EaU9BqAOQydcpxKfDyFGABBbFY
	 bcZgXUOZVWV7XnGxJ21Z9UzxpVrLODdO4ocXy0/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 155/175] scsi: lpfc: Fix possible memory leak in lpfc_rcv_padisc()
Date: Thu, 11 Apr 2024 11:56:18 +0200
Message-ID: <20240411095424.232760137@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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
index f666518d84b0a..0890c2e38eeca 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -601,8 +601,10 @@ lpfc_rcv_padisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
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



