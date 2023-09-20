Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F0AB168A9
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:46:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4F5AC433C8;
	Wed, 20 Sep 2023 12:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695214011;
	bh=PRHMJHZ2EyKLUZvGL19+QlMx+1508MkQLzSvbwEZMpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LCGfc68f+VKZa9poO2EVnIq1cSmZvrvSMc9XDKVH+sImKjKZC1iCeg6MmTuO2eEva
	 Uxyj78Oud/XbpM63gNQdzuRZfSSazwqtKOfT+zX+CGxiKAszMZtMZY34N5dYq7886s
	 DzA21REQUge5eJTd0CRz4CZAAV+5DLb+f+N5w6AE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 079/110] scsi: lpfc: Fix the NULL vs IS_ERR() bug for debugfs_create_file()
Date: Wed, 20 Sep 2023 13:32:17 +0200
Message-ID: <20230920112833.377391313@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112830.377666128@linuxfoundation.org>
References: <20230920112830.377666128@linuxfoundation.org>
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

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 7dcc683db3639eadd11bf0d59a09088a43de5e22 ]

Since debugfs_create_file() returns ERR_PTR and never NULL, use IS_ERR() to
check the return value.

Fixes: 2fcbc569b9f5 ("scsi: lpfc: Make debugfs ktime stats generic for NVME and SCSI")
Fixes: 4c47efc140fa ("scsi: lpfc: Move SCSI and NVME Stats to hardware queue structures")
Fixes: 6a828b0f6192 ("scsi: lpfc: Support non-uniform allocation of MSIX vectors to hardware queues")
Fixes: 95bfc6d8ad86 ("scsi: lpfc: Make FW logging dynamically configurable")
Fixes: 9f77870870d8 ("scsi: lpfc: Add debugfs support for cm framework buffers")
Fixes: c490850a0947 ("scsi: lpfc: Adapt partitioned XRI lists to efficient sharing")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Link: https://lore.kernel.org/r/20230906030809.2847970-1-ruanjinjie@huawei.com
Reviewed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_debugfs.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 560b2504e674d..a15ad76aee211 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -6058,7 +6058,7 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 					    phba->hba_debugfs_root,
 					    phba,
 					    &lpfc_debugfs_op_multixripools);
-		if (!phba->debug_multixri_pools) {
+		if (IS_ERR(phba->debug_multixri_pools)) {
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
 					 "0527 Cannot create debugfs multixripools\n");
 			goto debug_failed;
@@ -6070,7 +6070,7 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 			debugfs_create_file(name, S_IFREG | 0644,
 					    phba->hba_debugfs_root,
 					    phba, &lpfc_cgn_buffer_op);
-		if (!phba->debug_cgn_buffer) {
+		if (IS_ERR(phba->debug_cgn_buffer)) {
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
 					 "6527 Cannot create debugfs "
 					 "cgn_buffer\n");
@@ -6083,7 +6083,7 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 			debugfs_create_file(name, S_IFREG | 0644,
 					    phba->hba_debugfs_root,
 					    phba, &lpfc_rx_monitor_op);
-		if (!phba->debug_rx_monitor) {
+		if (IS_ERR(phba->debug_rx_monitor)) {
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
 					 "6528 Cannot create debugfs "
 					 "rx_monitor\n");
@@ -6096,7 +6096,7 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 			debugfs_create_file(name, 0644,
 					    phba->hba_debugfs_root,
 					    phba, &lpfc_debugfs_ras_log);
-		if (!phba->debug_ras_log) {
+		if (IS_ERR(phba->debug_ras_log)) {
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
 					 "6148 Cannot create debugfs"
 					 " ras_log\n");
@@ -6117,7 +6117,7 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 			debugfs_create_file(name, S_IFREG | 0644,
 					    phba->hba_debugfs_root,
 					    phba, &lpfc_debugfs_op_lockstat);
-		if (!phba->debug_lockstat) {
+		if (IS_ERR(phba->debug_lockstat)) {
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
 					 "4610 Can't create debugfs lockstat\n");
 			goto debug_failed;
@@ -6346,7 +6346,7 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 		debugfs_create_file(name, 0644,
 				    vport->vport_debugfs_root,
 				    vport, &lpfc_debugfs_op_scsistat);
-	if (!vport->debug_scsistat) {
+	if (IS_ERR(vport->debug_scsistat)) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
 				 "4611 Cannot create debugfs scsistat\n");
 		goto debug_failed;
@@ -6357,7 +6357,7 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 		debugfs_create_file(name, 0644,
 				    vport->vport_debugfs_root,
 				    vport, &lpfc_debugfs_op_ioktime);
-	if (!vport->debug_ioktime) {
+	if (IS_ERR(vport->debug_ioktime)) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
 				 "0815 Cannot create debugfs ioktime\n");
 		goto debug_failed;
-- 
2.40.1



