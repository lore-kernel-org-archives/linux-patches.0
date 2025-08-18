Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A9231AF3A;
	Mon, 18 Aug 2025 13:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524201; cv=none; b=AnackRVc7EoWW7DdhzbGEyQDFVCEKrpn630XpQ2I5iL7cjzfbVxj8HT09emKGxZtGImfGfOvEe+oGZTkIqjovl5XX2wizWJCMqpdWpY89xsxYJwCulMDK7kEl0fklhZxA1g0phzlRKgjvCzKGYJDs127zsaX9nZ5lW/WSOE4QB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524201; c=relaxed/simple;
	bh=r1UDslhF8xuuo2lItpJKZhVS3ilvGYFqMuUkZwR4vP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cFWhSszQuhdionPZSt2hMFLiRSlXZOR32agnS1dig2zrJGNZ3nTn9hij0w0ucWQ7HW3NRBmkYvODSEN+l5To17nFH40JVSqrecjGuTYBMl9Ldj3KC9B9yMTJh5EftKZP4+vrog1cxBHL8oWCOmuJxI/QuwtKGfvtlHBOPG71cOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PsB33i9L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PsB33i9L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65C07C4CEEB;
	Mon, 18 Aug 2025 13:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524200;
	bh=r1UDslhF8xuuo2lItpJKZhVS3ilvGYFqMuUkZwR4vP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PsB33i9Ln0yFcDB6ZZ9Ft8eqjpwJur0qN0X5cnX8nW8/zrY51qV4Iz/F6UQZe7iot
	 LTa1boLPFAjHXVAusZ7H2WEFrTXVzwki0Let0UPKv1+Iii4K+1jsnJldTs6QpG4kXU
	 pCjR8gLHAcEqN28ZpOY/c8/cwR3GYAsPACxhWGiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 366/515] scsi: lpfc: Ensure HBA_SETUP flag is used only for SLI4 in dev_loss_tmo_callbk
Date: Mon, 18 Aug 2025 14:45:52 +0200
Message-ID: <20250818124512.498070636@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit 1cced5779e7a3ff7ec025fc47c76a7bd3bb38877 ]

For SLI3, the HBA_SETUP flag is never set so the lpfc_dev_loss_tmo_callbk
always early returns.  Add a phba->sli_rev check for SLI4 mode so that
the SLI3 path can flow through the original dev_loss_tmo worker thread
design to lpfc_dev_loss_tmo_handler instead of early return.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20250618192138.124116-9-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index c256c3edd663..97263b8e1bf8 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -183,7 +183,8 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 
 	/* Don't schedule a worker thread event if the vport is going down. */
 	if (test_bit(FC_UNLOADING, &vport->load_flag) ||
-	    !test_bit(HBA_SETUP, &phba->hba_flag)) {
+	    (phba->sli_rev == LPFC_SLI_REV4 &&
+	    !test_bit(HBA_SETUP, &phba->hba_flag))) {
 
 		spin_lock_irqsave(&ndlp->lock, iflags);
 		ndlp->rport = NULL;
-- 
2.39.5



