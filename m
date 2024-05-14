Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9723D0D1;
	Tue, 14 May 2024 11:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687664; cv=none; b=ojHJNG4qSpDvHdCplExO2lYKTf3Fd/0sWDikMAm7DJg4g2+Wk6qYkIkh9QQUEQP9/vu+Q10Gon+Bnp2oUKFRa0KRPok8iFxMHlG4E01rh+r4uzv0Tw2X8v2YV6CS3kjTrEDj1Li99oD4GAxWZj5mggdRhzMK4yfmHV8SGSoraW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687664; c=relaxed/simple;
	bh=TVEGiEsHddPVRwkohZyHgRrPjcxXQyhZDH5DrJ+f+fQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EUMs3hvuXzcWTqWzEPux3ICb5PZWHXLpLqq5bOX08dwB15EOPb/m1sAhhpdyapIa/q5A7xE2/H+xoC3Bkxnz42G/oE3agDhtHm9ps6Sf0CiyFG5jIziCe3IT0A8AFtEGgXltuLZIWsl1+x3t3+1CQ/PtjudODqwJZs7nahYxdCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mUNITRBz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mUNITRBz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40CD6C2BD10;
	Tue, 14 May 2024 11:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687664;
	bh=TVEGiEsHddPVRwkohZyHgRrPjcxXQyhZDH5DrJ+f+fQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mUNITRBzHjInalZqo8Pds3MCo3WUCjtwiDX6Ve2t4xsG5BUlfRMBfKSzORSN1yxht
	 zTNvAl/ddO05zOyGwcZt0ouA9lmboLZwU8Z7Ie9LXZHsVbQeE2q0jrfung9wRQTil2
	 jEzH3uWhn23Oif8SZSnDpOZXFARVbOxEDV8mWTEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 062/168] scsi: lpfc: Move NPIVs transport unregistration to after resource clean up
Date: Tue, 14 May 2024 12:19:20 +0200
Message-ID: <20240514101009.039815838@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index da9a1f72d9383..b1071226e27fb 100644
--- a/drivers/scsi/lpfc/lpfc_vport.c
+++ b/drivers/scsi/lpfc/lpfc_vport.c
@@ -651,10 +651,6 @@ lpfc_vport_delete(struct fc_vport *fc_vport)
 	lpfc_free_sysfs_attr(vport);
 	lpfc_debugfs_terminate(vport);
 
-	/* Remove FC host to break driver binding. */
-	fc_remove_host(shost);
-	scsi_remove_host(shost);
-
 	/* Send the DA_ID and Fabric LOGO to cleanup Nameserver entries. */
 	ndlp = lpfc_findnode_did(vport, Fabric_DID);
 	if (!ndlp)
@@ -700,6 +696,10 @@ lpfc_vport_delete(struct fc_vport *fc_vport)
 
 skip_logo:
 
+	/* Remove FC host to break driver binding. */
+	fc_remove_host(shost);
+	scsi_remove_host(shost);
+
 	lpfc_cleanup(vport);
 
 	/* Remove scsi host now.  The nodes are cleaned up. */
-- 
2.43.0



