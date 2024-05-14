Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0786513A3F4;
	Tue, 14 May 2024 11:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686307; cv=none; b=NTy3CuRGuh93Z2VfLK2AlQiN0UTHXURQyHx+wVURyC8vCYVJRAVk6rcY4VDa+7LQtEQWdoLK4NckxQwVVndMGeuVhwMH9wbxRqT6ARmlrLyg8QQdyA0AH1sscTNuFK4XTIXkBhey5O6pI+ZPjlyhXzlrlZ2iBKSFrKTGkYLKuDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686307; c=relaxed/simple;
	bh=SQUwkpZNbvmJhz5FwSED+OvJIQiQnWNuVsVMvZUkTzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ua4ecOzTnRESehYTWxYk0Y3Cin2UmzpDrgZnVsFnkyk3Zcr70lAZSideYs2V7GQYdbD3dBNEEqi9k6pCoJvcuOdB2TyQKJUgTty4mwPKYV3lgFp0LDw3pGJr3vR3JyS5O7dHS85LwjaZpaEbf2RN+CLmId5FC/5vzfpSqX+C0AI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V/oy0s9k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V/oy0s9k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84346C2BD10;
	Tue, 14 May 2024 11:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686306;
	bh=SQUwkpZNbvmJhz5FwSED+OvJIQiQnWNuVsVMvZUkTzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V/oy0s9kd3If+mPuoEqATCw3KAymOFOIT/oaysrjbjrqpk0eC8CIU7lmoJE6MLtGi
	 fN8pS+oqdeuyTDsUUjP8e3afd8+gx36dr2P3NqwGPDBw/e1lhqJ3DfO2FSFJBzmNuT
	 1qCAh2sKyuIlEJcW08YYyLJYdbQL2GSis2G7BHbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 093/236] scsi: lpfc: Move NPIVs transport unregistration to after resource clean up
Date: Tue, 14 May 2024 12:17:35 +0200
Message-ID: <20240514101023.902295561@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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
index 4d171f5c213f7..6b4259894584f 100644
--- a/drivers/scsi/lpfc/lpfc_vport.c
+++ b/drivers/scsi/lpfc/lpfc_vport.c
@@ -693,10 +693,6 @@ lpfc_vport_delete(struct fc_vport *fc_vport)
 	lpfc_free_sysfs_attr(vport);
 	lpfc_debugfs_terminate(vport);
 
-	/* Remove FC host to break driver binding. */
-	fc_remove_host(shost);
-	scsi_remove_host(shost);
-
 	/* Send the DA_ID and Fabric LOGO to cleanup Nameserver entries. */
 	ndlp = lpfc_findnode_did(vport, Fabric_DID);
 	if (!ndlp)
@@ -740,6 +736,10 @@ lpfc_vport_delete(struct fc_vport *fc_vport)
 
 skip_logo:
 
+	/* Remove FC host to break driver binding. */
+	fc_remove_host(shost);
+	scsi_remove_host(shost);
+
 	lpfc_cleanup(vport);
 
 	/* Remove scsi host now.  The nodes are cleaned up. */
-- 
2.43.0



