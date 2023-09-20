Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E9A2AB21
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:58:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C18A5C433C8;
	Wed, 20 Sep 2023 11:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211087;
	bh=C8bMD5TgL2hLEnRIUTvOED+NlPgp3n8P3NWqDrazR6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mISZ6N+H2PYJErTrWMH32luM7XIUxNK3T9FykL6uRg1r4+Qeb1HMEcmYMVgfbaQxU
	 oDA8wr73Vxsb622n/HnzZOyDZ6RmiJDHiypvmHLv9AxzwQx+BfjLSbY3bsxFe4fJ1u
	 Jq5ky97636GmNEP+OKgoY3qKuWXZ8wvOi5ADX0c4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 103/139] scsi: lpfc: Fix the NULL vs IS_ERR() bug for debugfs_create_file()
Date: Wed, 20 Sep 2023 13:30:37 +0200
Message-ID: <20230920112839.409554434@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112835.549467415@linuxfoundation.org>
References: <20230920112835.549467415@linuxfoundation.org>
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
index 3e365e5e194a2..250d423710ca4 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -6069,7 +6069,7 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 					    phba->hba_debugfs_root,
 					    phba,
 					    &lpfc_debugfs_op_multixripools);
-		if (!phba->debug_multixri_pools) {
+		if (IS_ERR(phba->debug_multixri_pools)) {
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
 					 "0527 Cannot create debugfs multixripools\n");
 			goto debug_failed;
@@ -6081,7 +6081,7 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 			debugfs_create_file(name, S_IFREG | 0644,
 					    phba->hba_debugfs_root,
 					    phba, &lpfc_cgn_buffer_op);
-		if (!phba->debug_cgn_buffer) {
+		if (IS_ERR(phba->debug_cgn_buffer)) {
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
 					 "6527 Cannot create debugfs "
 					 "cgn_buffer\n");
@@ -6094,7 +6094,7 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 			debugfs_create_file(name, S_IFREG | 0644,
 					    phba->hba_debugfs_root,
 					    phba, &lpfc_rx_monitor_op);
-		if (!phba->debug_rx_monitor) {
+		if (IS_ERR(phba->debug_rx_monitor)) {
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
 					 "6528 Cannot create debugfs "
 					 "rx_monitor\n");
@@ -6107,7 +6107,7 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 			debugfs_create_file(name, 0644,
 					    phba->hba_debugfs_root,
 					    phba, &lpfc_debugfs_ras_log);
-		if (!phba->debug_ras_log) {
+		if (IS_ERR(phba->debug_ras_log)) {
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
 					 "6148 Cannot create debugfs"
 					 " ras_log\n");
@@ -6128,7 +6128,7 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 			debugfs_create_file(name, S_IFREG | 0644,
 					    phba->hba_debugfs_root,
 					    phba, &lpfc_debugfs_op_lockstat);
-		if (!phba->debug_lockstat) {
+		if (IS_ERR(phba->debug_lockstat)) {
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
 					 "4610 Can't create debugfs lockstat\n");
 			goto debug_failed;
@@ -6354,7 +6354,7 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 		debugfs_create_file(name, 0644,
 				    vport->vport_debugfs_root,
 				    vport, &lpfc_debugfs_op_scsistat);
-	if (!vport->debug_scsistat) {
+	if (IS_ERR(vport->debug_scsistat)) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
 				 "4611 Cannot create debugfs scsistat\n");
 		goto debug_failed;
@@ -6365,7 +6365,7 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
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



