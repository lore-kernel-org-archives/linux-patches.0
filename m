Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6FB2EAE5;
	Thu, 11 Apr 2024 10:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832198; cv=none; b=H6Nbx/6RQ+EFEl5UemKW6HaOAiVVx37i9x5sRQgrPhVrZwtmWeT3R+FQyp1a3RpUIOukZ3Id+m0ljfYJMMa62+qpTWgCgZaYIR9a66c0v7hH9Pk9n1bFoAgPSG3eWYvGR9mL63xZdmr9jo6cySCFMW/I/PX6NagHgjaP2LmVI3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832198; c=relaxed/simple;
	bh=E4QDoxWKSFKDYHgcVWRRWYRx2li0r4Otq2xOOVHbDF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qpn14wDcEjTzWaL4O1/axvdSPY/wagQ8S3UwYmfTVGnqIUXznFbaM2GcJySZwSWvIZh114Fn6Ue6kbz4jgsV2YYIGWW21nXa+Awb83meCvdIXOAQiOQtL7R7MqOZXP2n5V6MT2d0f//lmTS2UR6IOxKW6dKtjaK/fkz8NdM50bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GBG1TFX1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GBG1TFX1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6984C433F1;
	Thu, 11 Apr 2024 10:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832198;
	bh=E4QDoxWKSFKDYHgcVWRRWYRx2li0r4Otq2xOOVHbDF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GBG1TFX1329mbrZ00nvjXgsib3w3ZgsUxFaNSdXAuIV3wWMvpJTk4sRULEh6oSc4V
	 YYhJhk7qdQSRmCEjxhCDkiaqvUaHfMwOGSKwkzQxtHtwhzj7ShtNpjWPuH3raAQXtj
	 kp9SvwXlB3pjpfUfiF16fHSuxJVS57urNIKbmxCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 261/294] scsi: lpfc: Fix possible memory leak in lpfc_rcv_padisc()
Date: Thu, 11 Apr 2024 11:57:04 +0200
Message-ID: <20240411095443.417846992@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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
index 1e22364a31fcf..d6287c58d5045 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -784,8 +784,10 @@ lpfc_rcv_padisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
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



