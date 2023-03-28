Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC488BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:50:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4803FC433D2;
	Tue, 28 Mar 2023 14:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015051;
	bh=BTGPNRJFm+RzoGMerEPnGxXC0CPJ8lzG9XJAwYTgFEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jfz6Auy+r57qJ4etOnnBT+Scu9kOKaivS/ZEOtm6XHJdjituxllidUVebc43tzZcJ
	 9W9+AVvG0/pGmx+FqGucE+G4JkiYGK8RR/N16W0cWn1EgsGLagPHcAiY05Jus6o+iz
	 2JPnEGvMoUqaxoDpQC2yAu+0NAF/zVN+9b+q9K1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 149/240] scsi: mpi3mr: Wait for diagnostic save during controller init
Date: Tue, 28 Mar 2023 16:41:52 +0200
Message-Id: <20230328142625.918307232@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ranjan Kumar <ranjan.kumar@broadcom.com>

[ Upstream commit 0a319f1629495d27879b7ebf6eee62b8cf6e4c37 ]

If a controller reset operation is triggered to recover the controller from
a fault state, then wait for the snapdump to be saved in the firmware
region before proceeding to reset the controller.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Link: https://lore.kernel.org/r/20230228140835.4075-4-ranjan.kumar@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 28fd90c4b62d0..a565817aa56d4 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -1198,7 +1198,7 @@ mpi3mr_revalidate_factsdata(struct mpi3mr_ioc *mrioc)
  */
 static int mpi3mr_bring_ioc_ready(struct mpi3mr_ioc *mrioc)
 {
-	u32 ioc_config, ioc_status, timeout;
+	u32 ioc_config, ioc_status, timeout, host_diagnostic;
 	int retval = 0;
 	enum mpi3mr_iocstate ioc_state;
 	u64 base_info;
@@ -1252,6 +1252,23 @@ static int mpi3mr_bring_ioc_ready(struct mpi3mr_ioc *mrioc)
 			    retval, mpi3mr_iocstate_name(ioc_state));
 	}
 	if (ioc_state != MRIOC_STATE_RESET) {
+		if (ioc_state == MRIOC_STATE_FAULT) {
+			timeout = MPI3_SYSIF_DIAG_SAVE_TIMEOUT * 10;
+			mpi3mr_print_fault_info(mrioc);
+			do {
+				host_diagnostic =
+					readl(&mrioc->sysif_regs->host_diagnostic);
+				if (!(host_diagnostic &
+				      MPI3_SYSIF_HOST_DIAG_SAVE_IN_PROGRESS))
+					break;
+				if (!pci_device_is_present(mrioc->pdev)) {
+					mrioc->unrecoverable = 1;
+					ioc_err(mrioc, "controller is not present at the bringup\n");
+					goto out_device_not_present;
+				}
+				msleep(100);
+			} while (--timeout);
+		}
 		mpi3mr_print_fault_info(mrioc);
 		ioc_info(mrioc, "issuing soft reset to bring to reset state\n");
 		retval = mpi3mr_issue_reset(mrioc,
-- 
2.39.2



