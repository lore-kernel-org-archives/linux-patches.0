Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 989FE262FEC;
	Tue, 11 Nov 2025 01:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824804; cv=none; b=amxHj6V8zLBK9T2/M08P7uCgr56ZAW/Uxaw0DwPwdttVItSeD0A5gwR5Ge4EviA7efkI61uFMSk24xWUzZ/VitRUhBSSMSCgcNIBFOdAFB37BjZrEPxLT4Ve9eifTcavTtZq30dv7oxXRhMh3hE0kDD29q3kZdeoF9+OQ03oyfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824804; c=relaxed/simple;
	bh=Omnva8yei8b0gQISdXgIiXHtfBIPZr0KpUw3MMMSIc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X1C3oNBr9hG3a+2kcJJha7efb+sO1py7y8jvv58V4XCW2QDLwMkfuZ+Fk3f+OLm+7CmeuBlSIGV4d129Ml38Stx3UL/sxc39fM/dILba+47cShI9/EllmgTkvw/wvBxvCUxLUGlHVZhRv18DYKNyki9obDdw0/AlMIgwGogdGsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EDq374Ue; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EDq374Ue"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36E08C4CEFB;
	Tue, 11 Nov 2025 01:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824804;
	bh=Omnva8yei8b0gQISdXgIiXHtfBIPZr0KpUw3MMMSIc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EDq374UezJMk7XiJYjZFGE5Ubypu9ID22aKuqzCRut4rS7ILwHeSH335alWLUmTDV
	 jAztEA5zK4G84Ypv0pcMeU05oSLBA7d7/ScDGvXoY8mxeqvHDY0JftQplDDHZ6VGJr
	 SQYq3odkYSlde2ji++nQVnHc5iRSyTxmBmKeWRhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 573/849] scsi: lpfc: Decrement ndlp kref after FDISC retries exhausted
Date: Tue, 11 Nov 2025 09:42:23 +0900
Message-ID: <20251111004550.273093363@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit b5bf6d681fce69cd1a57bfc0f1bdbbb348035117 ]

The kref for Fabric_DID ndlps is not decremented after repeated FDISC
failures and exhausting maximum allowed retries.  This can leave the
ndlp lingering unnecessarily.  Add a test and set bit operation for the
NLP_DROPPED flag. If not previously set, then a kref is decremented. The
ndlp is freed when the remaining reference for the completing ELS is
put.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Message-ID: <20250915180811.137530-6-justintee8345@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_els.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index fca81e0c7c2e1..4c405bade4f34 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -11259,6 +11259,11 @@ lpfc_cmpl_els_fdisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		lpfc_vlog_msg(vport, KERN_WARNING, LOG_ELS,
 			      "0126 FDISC cmpl status: x%x/x%x)\n",
 			      ulp_status, ulp_word4);
+
+		/* drop initial reference */
+		if (!test_and_set_bit(NLP_DROPPED, &ndlp->nlp_flag))
+			lpfc_nlp_put(ndlp);
+
 		goto fdisc_failed;
 	}
 
-- 
2.51.0



