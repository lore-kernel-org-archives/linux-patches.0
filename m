Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78EB38BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:50:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0B08C433D2;
	Tue, 28 Mar 2023 14:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015035;
	bh=xCEbASVz9ERubhK9s6aihYSBS048JPjV01c8dLkUWwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BorsMOjUM1aW7ZABp8fgZuGBqU5eKZocElVrM488apa/RVj3ZpmcFp8k7nbwPRltj
	 jpsJPkuwEkYezMcgjKCAMsh3C1u70zgdEqYdKXniiKN9KP4Usz2Cy4P02fwH1M1kw/
	 ByL60mnJBUr0OnAKY3ZildVGX4x7No3r9sas1QaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wagner <dwagner@suse.de>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 143/240] scsi: qla2xxx: Add option to disable FC2 Target support
Date: Tue, 28 Mar 2023 16:41:46 +0200
Message-Id: <20230328142625.689139272@linuxfoundation.org>
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

From: Daniel Wagner <dwagner@suse.de>

[ Upstream commit 877b03795fcf29ff2e2351f7e574ecc9b9c51732 ]

Commit 44c57f205876 ("scsi: qla2xxx: Changes to support FCP2 Target") added
support for FC2 Targets. Unfortunately, there are older setups which break
with this new feature enabled.

Allow to disable it via module option.

Link: https://lore.kernel.org/r/20230208152014.109214-1-dwagner@suse.de
Signed-off-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_gbl.h  |  1 +
 drivers/scsi/qla2xxx/qla_init.c |  3 ++-
 drivers/scsi/qla2xxx/qla_os.c   | 10 +++++++++-
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index e3256e721be14..ee54207fc5319 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -192,6 +192,7 @@ extern int ql2xsecenable;
 extern int ql2xenforce_iocb_limit;
 extern int ql2xabts_wait_nvme;
 extern u32 ql2xnvme_queues;
+extern int ql2xfc2target;
 
 extern int qla2x00_loop_reset(scsi_qla_host_t *);
 extern void qla2x00_abort_all_cmds(scsi_qla_host_t *, int);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 8f2a968793913..d506eb3a9b639 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1841,7 +1841,8 @@ void qla2x00_handle_rscn(scsi_qla_host_t *vha, struct event_arg *ea)
 	case RSCN_PORT_ADDR:
 		fcport = qla2x00_find_fcport_by_nportid(vha, &ea->id, 1);
 		if (fcport) {
-			if (fcport->flags & FCF_FCP2_DEVICE &&
+			if (ql2xfc2target &&
+			    fcport->flags & FCF_FCP2_DEVICE &&
 			    atomic_read(&fcport->state) == FCS_ONLINE) {
 				ql_dbg(ql_dbg_disc, vha, 0x2115,
 				       "Delaying session delete for FCP2 portid=%06x %8phC ",
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 37eb235fa308a..02913cc75195b 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -360,6 +360,13 @@ MODULE_PARM_DESC(ql2xnvme_queues,
 	"1 - Minimum number of queues supported\n"
 	"8 - Default value");
 
+int ql2xfc2target = 1;
+module_param(ql2xfc2target, int, 0444);
+MODULE_PARM_DESC(qla2xfc2target,
+		  "Enables FC2 Target support. "
+		  "0 - FC2 Target support is disabled. "
+		  "1 - FC2 Target support is enabled (default).");
+
 static struct scsi_transport_template *qla2xxx_transport_template = NULL;
 struct scsi_transport_template *qla2xxx_transport_vport_template = NULL;
 
@@ -4086,7 +4093,8 @@ qla2x00_mark_all_devices_lost(scsi_qla_host_t *vha)
 	    "Mark all dev lost\n");
 
 	list_for_each_entry(fcport, &vha->vp_fcports, list) {
-		if (fcport->loop_id != FC_NO_LOOP_ID &&
+		if (ql2xfc2target &&
+		    fcport->loop_id != FC_NO_LOOP_ID &&
 		    (fcport->flags & FCF_FCP2_DEVICE) &&
 		    fcport->port_type == FCT_TARGET &&
 		    !qla2x00_reset_active(vha)) {
-- 
2.39.2



