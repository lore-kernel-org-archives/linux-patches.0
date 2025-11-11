Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771E4340290;
	Tue, 11 Nov 2025 01:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824036; cv=none; b=o1nTs2qqv+Ppp2IF8NjRfrrH6h4fA6v6VjEmRPh5kdCSYMe03wvkU38//eYHu0SJVe1XUVPgfs/Z8921wz48LcyFl9aHkGyBT7jsGNqS+ibb9aDDS8IQC1Urgfsy1wMP86TcSpBClLl39EkXUj8zrY/JolLV8LMPT3HitH9k1nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824036; c=relaxed/simple;
	bh=eyiq5I8p45ojDycI743jtZ8nMq4oqIyn6DWZOZG/VS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iyVrIbY6pEEtNkw5RWObApZaWvuktSv7giiw7E5w/kxG5uhMs/rirM1Ogb37NaxjT8kdZouGolG/Bl5QE3QX4X+ay+1pFs5vnABhyAbbPg80zaPfuHbS4YX154QPL9ONF81+WSFEtPR5PyNFqHW4VWM8WPSEnv+hI5rJtidNuNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FOWpFrDG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FOWpFrDG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14AC7C16AAE;
	Tue, 11 Nov 2025 01:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824036;
	bh=eyiq5I8p45ojDycI743jtZ8nMq4oqIyn6DWZOZG/VS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FOWpFrDGdLi1LMdCJ8vMkAulEH+SodMoLJPgc25KerPvCdAc2Fd/+v4cAh2xcqPDb
	 iDKICk3zguKW8m8xOy/+3T7aA3886S6rf4lQuRiS++9GVKr0N4R8TV2/V0GwUqnG5d
	 2L+rkKDh5FJzNRJEqZhbrAAi+7E2LGzwTMoSvO3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 375/565] scsi: lpfc: Decrement ndlp kref after FDISC retries exhausted
Date: Tue, 11 Nov 2025 09:43:51 +0900
Message-ID: <20251111004535.306731288@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b5fa5054e952e..ac2fa05cc89c1 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -11237,6 +11237,11 @@ lpfc_cmpl_els_fdisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
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



