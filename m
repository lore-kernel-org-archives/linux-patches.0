Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C595B6BB39;
	Tue, 14 May 2024 11:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685056; cv=none; b=JPIAkfiPmyRMMC/PVXzChhdqsOcB1uc6mhsfJqo4y1w3fI64i1XBuyAZQ1F6gv0fi+gIZcZhk4hF40hog2wwimFWI855qm9Vcta5X+LTv8LI12rXx17oJzB85Do97vFgqI3HgQuqkNsiwXBtiNjWyCgegMupiQH3w2ddd25/Wuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685056; c=relaxed/simple;
	bh=DQDomxYBp6Je3bwv1njHfIZBqo/e2aI9TTO1O0Rm1NQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EQhbit8RdWkshvECVhB953zy/OHocxqR5RcpwnYB3OfpnKmdq7yoXizzMNXE0sLEqILdkcOCdkW3fmS15EQUN0+e0D6GP2isRuTuAccIwd26N4TuGuEyPHQd98kima9v03xaxjMdx95z3nwfADlvpZJ2gL9ngD06ovnA6kQ+SGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hZD4mIiS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hZD4mIiS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1838FC2BD10;
	Tue, 14 May 2024 11:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685056;
	bh=DQDomxYBp6Je3bwv1njHfIZBqo/e2aI9TTO1O0Rm1NQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hZD4mIiStDPDj/7NOL+Sre76DKgU9xMCXEL0q18GM2J+64W12L1s6FwaR5WbHWEC8
	 uwDBNS5Vqo3j/ULgrB9fj36OYvz44JKfa4nWmIKn5MRrZkFVmpUhzQS+55YzmkDnoH
	 3de85Pmb7bdYhjVAkQ9cWrNtVonuXdm5nOp/oUhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 097/301] scsi: lpfc: Move NPIVs transport unregistration to after resource clean up
Date: Tue, 14 May 2024 12:16:08 +0200
Message-ID: <20240514101035.914546982@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit 4ddf01f2f1504fa08b766e8cfeec558e9f8eef6c ]

There are cases after NPIV deletion where the fabric switch still believes
the NPIV is logged into the fabric.  This occurs when a vport is
unregistered before the Remove All DA_ID CT and LOGO ELS are sent to the
fabric.

Currently fc_remove_host(), which calls dev_loss_tmo for all D_IDs including
the fabric D_ID, removes the last ndlp reference and frees the ndlp rport
object.  This sometimes causes the race condition where the final DA_ID and
LOGO are skipped from being sent to the fabric switch.

Fix by moving the fc_remove_host() and scsi_remove_host() calls after DA_ID
and LOGO are sent.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20240305200503.57317-3-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_vport.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
index 6c7559cf1a4b6..9e0e9e02d2c47 100644
--- a/drivers/scsi/lpfc/lpfc_vport.c
+++ b/drivers/scsi/lpfc/lpfc_vport.c
@@ -683,10 +683,6 @@ lpfc_vport_delete(struct fc_vport *fc_vport)
 	lpfc_free_sysfs_attr(vport);
 	lpfc_debugfs_terminate(vport);
 
-	/* Remove FC host to break driver binding. */
-	fc_remove_host(shost);
-	scsi_remove_host(shost);
-
 	/* Send the DA_ID and Fabric LOGO to cleanup Nameserver entries. */
 	ndlp = lpfc_findnode_did(vport, Fabric_DID);
 	if (!ndlp)
@@ -730,6 +726,10 @@ lpfc_vport_delete(struct fc_vport *fc_vport)
 
 skip_logo:
 
+	/* Remove FC host to break driver binding. */
+	fc_remove_host(shost);
+	scsi_remove_host(shost);
+
 	lpfc_cleanup(vport);
 
 	/* Remove scsi host now.  The nodes are cleaned up. */
-- 
2.43.0



