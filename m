Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FFEF28E00
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:57:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E47BC433C8;
	Wed, 20 Sep 2023 11:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211073;
	bh=wtp7m1tIqYg5rtYum8HRT9sExXFJNcO+tLJM4fFuy5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fS65QK2NY3Nqq3k+gQLlpPywG1nBhSRbTooHiiP8EbrThPEua00kvXKHX00ftRJx0
	 AbiEk+UqPSEZqYBekguKIU4EZ4uM/92aQPP4vE2SG7yVs3Ti1/I/39swVAhDZW18Qg
	 xXRaFE2i+cFgmDPk0vU5Es/8yuJdMEnJr3Cq7Av4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 098/139] scsi: qla2xxx: Fix NULL vs IS_ERR() bug for debugfs_create_dir()
Date: Wed, 20 Sep 2023 13:30:32 +0200
Message-ID: <20230920112839.237227508@linuxfoundation.org>
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

[ Upstream commit d0b0822e32dbae80bbcb3cc86f34d28539d913df ]

Since both debugfs_create_dir() and debugfs_create_file() return ERR_PTR
and never NULL, use IS_ERR() instead of checking for NULL.

Fixes: 1e98fb0f9208 ("scsi: qla2xxx: Setup debugfs entries for remote ports")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Link: https://lore.kernel.org/r/20230831140930.3166359-1-ruanjinjie@huawei.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_dfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index f060e593685de..a7a364760b800 100644
--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -116,7 +116,7 @@ qla2x00_dfs_create_rport(scsi_qla_host_t *vha, struct fc_port *fp)
 
 	sprintf(wwn, "pn-%016llx", wwn_to_u64(fp->port_name));
 	fp->dfs_rport_dir = debugfs_create_dir(wwn, vha->dfs_rport_root);
-	if (!fp->dfs_rport_dir)
+	if (IS_ERR(fp->dfs_rport_dir))
 		return;
 	if (NVME_TARGET(vha->hw, fp))
 		debugfs_create_file("dev_loss_tmo", 0600, fp->dfs_rport_dir,
@@ -708,14 +708,14 @@ qla2x00_dfs_setup(scsi_qla_host_t *vha)
 	if (IS_QLA27XX(ha) || IS_QLA83XX(ha) || IS_QLA28XX(ha)) {
 		ha->tgt.dfs_naqp = debugfs_create_file("naqp",
 		    0400, ha->dfs_dir, vha, &dfs_naqp_ops);
-		if (!ha->tgt.dfs_naqp) {
+		if (IS_ERR(ha->tgt.dfs_naqp)) {
 			ql_log(ql_log_warn, vha, 0xd011,
 			       "Unable to create debugFS naqp node.\n");
 			goto out;
 		}
 	}
 	vha->dfs_rport_root = debugfs_create_dir("rports", ha->dfs_dir);
-	if (!vha->dfs_rport_root) {
+	if (IS_ERR(vha->dfs_rport_root)) {
 		ql_log(ql_log_warn, vha, 0xd012,
 		       "Unable to create debugFS rports node.\n");
 		goto out;
-- 
2.40.1



