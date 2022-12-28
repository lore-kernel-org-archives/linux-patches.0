Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDEEC1C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:09:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41077C433EF;
	Wed, 28 Dec 2022 16:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243768;
	bh=rgDDXvLmK/pigaz2RKJ6fZoY3tnXuj3SIImzHUOvatU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ID4OLpz9MmH/Eh+TwyulpafFRU7wmDbICWBjUC5pzS/ev9gDLrflkWJ51qTkaLUcy
	 Kt/EK+KVoS8n4mbyExtLGGbyD+vqrzZtDL+SJU7cWn0HrZtnMdbGuZyUyph6J3h+E1
	 pY6GmcmsvVa/Z9BNf7UPsnPhZdkYtphfcYGu4aDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arun Easi <arun.easi@qlogic.com>,
	Giridhar Malavali <giridhar.malavali@qlogic.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0585/1073] scsi: qla2xxx: Fix set-but-not-used variable warnings
Date: Wed, 28 Dec 2022 15:36:13 +0100
Message-Id: <20221228144343.936303585@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 4fb2169d66b837a2986f569f5d5b81f79e6e4a4c ]

Fix the following two compiler warnings:

drivers/scsi/qla2xxx/qla_init.c: In function ‘qla24xx_async_abort_cmd’:
drivers/scsi/qla2xxx/qla_init.c:171:17: warning: variable ‘bail’ set but not used [-Wunused-but-set-variable]
  171 |         uint8_t bail;
      |                 ^~~~
drivers/scsi/qla2xxx/qla_init.c: In function ‘qla2x00_async_tm_cmd’:
drivers/scsi/qla2xxx/qla_init.c:2023:17: warning: variable ‘bail’ set but not used [-Wunused-but-set-variable]
 2023 |         uint8_t bail;
      |                 ^~~~

Cc: Arun Easi <arun.easi@qlogic.com>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>
Fixes: feafb7b1714c ("[SCSI] qla2xxx: Fix vport delete issues")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20221031224818.2607882-1-bvanassche@acm.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_def.h    | 22 +++++++++++-----------
 drivers/scsi/qla2xxx/qla_init.c   |  6 ++----
 drivers/scsi/qla2xxx/qla_inline.h |  4 +---
 drivers/scsi/qla2xxx/qla_os.c     |  4 +---
 4 files changed, 15 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 3ec6a200942e..01ca440ce620 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -5129,17 +5129,17 @@ struct secure_flash_update_block_pk {
 		(test_bit(ISP_ABORT_NEEDED, &ha->dpc_flags) || \
 			 test_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags))
 
-#define QLA_VHA_MARK_BUSY(__vha, __bail) do {		\
-	atomic_inc(&__vha->vref_count);			\
-	mb();						\
-	if (__vha->flags.delete_progress) {		\
-		atomic_dec(&__vha->vref_count);		\
-		wake_up(&__vha->vref_waitq);		\
-		__bail = 1;				\
-	} else {					\
-		__bail = 0;				\
-	}						\
-} while (0)
+static inline bool qla_vha_mark_busy(scsi_qla_host_t *vha)
+{
+	atomic_inc(&vha->vref_count);
+	mb();
+	if (vha->flags.delete_progress) {
+		atomic_dec(&vha->vref_count);
+		wake_up(&vha->vref_waitq);
+		return true;
+	}
+	return false;
+}
 
 #define QLA_VHA_MARK_NOT_BUSY(__vha) do {		\
 	atomic_dec(&__vha->vref_count);			\
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index e7fe0e52c11d..11598edfb39b 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -168,7 +168,6 @@ int qla24xx_async_abort_cmd(srb_t *cmd_sp, bool wait)
 	struct srb_iocb *abt_iocb;
 	srb_t *sp;
 	int rval = QLA_FUNCTION_FAILED;
-	uint8_t bail;
 
 	/* ref: INIT for ABTS command */
 	sp = qla2xxx_get_qpair_sp(cmd_sp->vha, cmd_sp->qpair, cmd_sp->fcport,
@@ -176,7 +175,7 @@ int qla24xx_async_abort_cmd(srb_t *cmd_sp, bool wait)
 	if (!sp)
 		return QLA_MEMORY_ALLOC_FAILED;
 
-	QLA_VHA_MARK_BUSY(vha, bail);
+	qla_vha_mark_busy(vha);
 	abt_iocb = &sp->u.iocb_cmd;
 	sp->type = SRB_ABT_CMD;
 	sp->name = "abort";
@@ -2020,14 +2019,13 @@ qla2x00_async_tm_cmd(fc_port_t *fcport, uint32_t flags, uint32_t lun,
 	struct srb_iocb *tm_iocb;
 	srb_t *sp;
 	int rval = QLA_FUNCTION_FAILED;
-	uint8_t bail;
 
 	/* ref: INIT */
 	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
 	if (!sp)
 		goto done;
 
-	QLA_VHA_MARK_BUSY(vha, bail);
+	qla_vha_mark_busy(vha);
 	sp->type = SRB_TM_CMD;
 	sp->name = "tmf";
 	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha),
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index db17f7f410cd..5185dc5daf80 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -225,11 +225,9 @@ static inline srb_t *
 qla2x00_get_sp(scsi_qla_host_t *vha, fc_port_t *fcport, gfp_t flag)
 {
 	srb_t *sp = NULL;
-	uint8_t bail;
 	struct qla_qpair *qpair;
 
-	QLA_VHA_MARK_BUSY(vha, bail);
-	if (unlikely(bail))
+	if (unlikely(qla_vha_mark_busy(vha)))
 		return NULL;
 
 	qpair = vha->hw->base_qpair;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 1c7fb6484db2..5e5d1a6c51d5 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -5039,13 +5039,11 @@ struct qla_work_evt *
 qla2x00_alloc_work(struct scsi_qla_host *vha, enum qla_work_type type)
 {
 	struct qla_work_evt *e;
-	uint8_t bail;
 
 	if (test_bit(UNLOADING, &vha->dpc_flags))
 		return NULL;
 
-	QLA_VHA_MARK_BUSY(vha, bail);
-	if (bail)
+	if (qla_vha_mark_busy(vha))
 		return NULL;
 
 	e = kzalloc(sizeof(struct qla_work_evt), GFP_ATOMIC);
-- 
2.35.1



