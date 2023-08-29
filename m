Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A117128E7
	for <patches@lists.linux.dev>; Tue, 29 Aug 2023 14:35:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03FA4C433C7;
	Tue, 29 Aug 2023 14:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1693319713;
	bh=j8pYqlZwUNuo65/dF3fFiMQs7PZWSYLwDSTEEVX7aNo=;
	h=From:Date:Subject:To:Cc:From;
	b=Xz9/nfYjENbQgSTnF+WYLlg+Q5+VWrTYtpyW1TSVZNv63IRsaWGjyyDjwNADefLb6
	 Goul/cWlAAEc+RAo0Xp7XoYhfJTRgutR7pNMLw3QIg5lz1cec81nFivXgXM+7kkeqc
	 95ED3TWTRpX47r+x9ZY6Y62P2Hpd/quKDKJWBYg3QARf4uH8z3ZOuzofSWDf+tECpz
	 VPX74kx5PFVRUC2GoB31vrt1dVQA+V7WvVAWIU9u9LDdPkHG2cq9FqH3ccTR/peQiC
	 P7ouN38N4H/WUEd0nVhYDnoQ8ngaYh36Zb3Qu8vr5Q3Hqth8SiMUiucPad6DuFO41q
	 p4ixmBCxer0QA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Tue, 29 Aug 2023 07:35:06 -0700
Subject: [PATCH] scsi: qla2xxx: Fix unused variable warning in
 qla2xxx_process_purls_pkt()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230829-qla_nvme-fix-unused-fcport-v1-1-51c7560ecaee@kernel.org>
X-B4-Tracking: v=1; b=H4sIABkC7mQC/x3MUQqDMBBF0a3IfDsQo0J1KyISzUs70EZNVARx7
 4Z+HrjciyKCIFKbXRRwSJTZJxR5RtPH+DdYbDJppUv10g2vXzP44wd2cvLu9wjLblrmsHFtDKq
 mhh2dojRYAlL0n3f9fT8orraNbAAAAA==
To: njavali@marvell.com, GR-QLogic-Storage-Upstream@marvell.com, 
 martin.petersen@oracle.com
Cc: jejb@linux.ibm.com, linux-scsi@vger.kernel.org, patches@lists.linux.dev, 
 Stephen Rothwell <sfr@canb.auug.org.au>, kernel test robot <lkp@intel.com>, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1931; i=nathan@kernel.org;
 h=from:subject:message-id; bh=j8pYqlZwUNuo65/dF3fFiMQs7PZWSYLwDSTEEVX7aNo=;
 b=owGbwMvMwCEmm602sfCA1DTG02pJDCnvmBQUa//ovDE8GzKb2fb2zhYzm1MmvZcnt65LuXtBY
 1Ox/prdHaUsDGIcDLJiiizVj1WPGxrOOct449QkmDmsTCBDGLg4BWAiHksYGfYZmXTU5RxM5tBe
 ucjolEGL+uuPDHf9WGfFdE6VWflOaSnDf99fXuKy6wrl2goPZMjuc7OXDv506lHskm22nvuCVcw
 1+AA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

When CONFIG_NVME_FC is not set, fcport is unused:

  drivers/scsi/qla2xxx/qla_nvme.c: In function 'qla2xxx_process_purls_pkt':
  drivers/scsi/qla2xxx/qla_nvme.c:1183:20: warning: unused variable 'fcport' [-Wunused-variable]
   1183 |         fc_port_t *fcport = uctx->fcport;
        |                    ^~~~~~

While this preprocessor usage could be converted to a normal if
statement to allow the compiler to always see fcport as used, it is
equally easy to just eliminate the fcport variable and use uctx->fcport
directly.

Fixes: 27177862de96 ("scsi: qla2xxx: Fix nvme_fc_rcv_ls_req() undefined error")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes: https://lore.kernel.org/linux-next/20230828131304.269a2a40@canb.auug.org.au/
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202308290833.sKkoSSeO-lkp@intel.com/
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/scsi/qla2xxx/qla_nvme.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 62a67662cbf3..f9f4a7da2ed6 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -1180,12 +1180,11 @@ static void
 qla2xxx_process_purls_pkt(struct scsi_qla_host *vha, struct purex_item *item)
 {
 	struct qla_nvme_unsol_ctx *uctx = item->purls_context;
-	fc_port_t *fcport = uctx->fcport;
 	struct qla_nvme_lsrjt_pt_arg a;
 	int ret = 1;
 
 #if (IS_ENABLED(CONFIG_NVME_FC))
-	ret = nvme_fc_rcv_ls_req(fcport->nvme_remote_port, &uctx->lsrsp,
+	ret = nvme_fc_rcv_ls_req(uctx->fcport->nvme_remote_port, &uctx->lsrsp,
 				 &item->iocb, item->size);
 #endif
 	if (ret) {

---
base-commit: 15924b0503630016dee4dbb945a8df4df659070b
change-id: 20230829-qla_nvme-fix-unused-fcport-5aae495edbf0

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

