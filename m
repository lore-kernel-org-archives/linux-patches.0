Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09391FC08
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FFF5C433D2;
	Mon, 15 May 2023 17:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684172414;
	bh=DyG4DGvXl5x2kdCGk41xAZDPzJygjmMm6pEHgex+9v4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0s5uPdjgBIeDo2wpL38ekAhDFDWL5EUyMBEDsVL++n3IeZbnGwb/5UAhk4PBqiaLj
	 ojgQ+9ADgSmLvI8h8W60VWyN8whGLKKK4WyrLhGsLvrFolKDb332mTKS2V0Ry3opOG
	 /fZBiSVRO6kGmSF1QXeInENxMQh7OI6Yw6g6KRp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Christie <michael.christie@oracle.com>,
	David Disseldorp <ddiss@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 146/381] scsi: target: Rename cmd.bad_sector to cmd.sense_info
Date: Mon, 15 May 2023 18:26:37 +0200
Message-Id: <20230515161743.447934128@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>
References: <20230515161736.775969473@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: David Disseldorp <ddiss@suse.de>

[ Upstream commit 8dd992fb67f33a0777fb4bee1e22a5ee5530f024 ]

cmd.bad_sector currently gets packed into the sense INFORMATION field for
TCM_LOGICAL_BLOCK_{GUARD,APP_TAG,REF_TAG}_CHECK_FAILED errors, which carry
an .add_sector_info flag in the sense_detail_table to ensure this.

In preparation for propagating a byte offset on COMPARE AND WRITE
TCM_MISCOMPARE_VERIFY error, rename cmd.bad_sector to cmd.sense_info and
sense_detail.add_sector_info to sense_detail.add_sense_info so that it
better reflects the sense INFORMATION field destination.

[ddiss: update previously overlooked ib_isert]

Link: https://lore.kernel.org/r/20201031233211.5207-3-ddiss@suse.de
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: David Disseldorp <ddiss@suse.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 673db054d7a2 ("scsi: target: Fix multiple LUN_RESET handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c |  4 ++--
 drivers/target/target_core_sbc.c        |  2 +-
 drivers/target/target_core_transport.c  | 12 ++++++------
 include/target/target_core_base.h       |  2 +-
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index edea37da8a5bd..2d0d966fba2c8 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1553,12 +1553,12 @@ isert_check_pi_status(struct se_cmd *se_cmd, struct ib_mr *sig_mr)
 		}
 		sec_offset_err = mr_status.sig_err.sig_err_offset;
 		do_div(sec_offset_err, block_size);
-		se_cmd->bad_sector = sec_offset_err + se_cmd->t_task_lba;
+		se_cmd->sense_info = sec_offset_err + se_cmd->t_task_lba;
 
 		isert_err("PI error found type %d at sector 0x%llx "
 			  "expected 0x%x vs actual 0x%x\n",
 			  mr_status.sig_err.err_type,
-			  (unsigned long long)se_cmd->bad_sector,
+			  (unsigned long long)se_cmd->sense_info,
 			  mr_status.sig_err.expected,
 			  mr_status.sig_err.actual);
 		ret = 1;
diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index eaf8551ebc612..47c5f26e6012d 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -1438,7 +1438,7 @@ sbc_dif_verify(struct se_cmd *cmd, sector_t start, unsigned int sectors,
 			if (rc) {
 				kunmap_atomic(daddr - dsg->offset);
 				kunmap_atomic(paddr - psg->offset);
-				cmd->bad_sector = sector;
+				cmd->sense_info = sector;
 				return rc;
 			}
 next:
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index ce521d3d30470..84d654c14917c 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3135,7 +3135,7 @@ struct sense_detail {
 	u8 key;
 	u8 asc;
 	u8 ascq;
-	bool add_sector_info;
+	bool add_sense_info;
 };
 
 static const struct sense_detail sense_detail_table[] = {
@@ -3238,19 +3238,19 @@ static const struct sense_detail sense_detail_table[] = {
 		.key = ABORTED_COMMAND,
 		.asc = 0x10,
 		.ascq = 0x01, /* LOGICAL BLOCK GUARD CHECK FAILED */
-		.add_sector_info = true,
+		.add_sense_info = true,
 	},
 	[TCM_LOGICAL_BLOCK_APP_TAG_CHECK_FAILED] = {
 		.key = ABORTED_COMMAND,
 		.asc = 0x10,
 		.ascq = 0x02, /* LOGICAL BLOCK APPLICATION TAG CHECK FAILED */
-		.add_sector_info = true,
+		.add_sense_info = true,
 	},
 	[TCM_LOGICAL_BLOCK_REF_TAG_CHECK_FAILED] = {
 		.key = ABORTED_COMMAND,
 		.asc = 0x10,
 		.ascq = 0x03, /* LOGICAL BLOCK REFERENCE TAG CHECK FAILED */
-		.add_sector_info = true,
+		.add_sense_info = true,
 	},
 	[TCM_COPY_TARGET_DEVICE_NOT_REACHABLE] = {
 		.key = COPY_ABORTED,
@@ -3330,10 +3330,10 @@ static void translate_sense_reason(struct se_cmd *cmd, sense_reason_t reason)
 	cmd->scsi_status = SAM_STAT_CHECK_CONDITION;
 	cmd->scsi_sense_length  = TRANSPORT_SENSE_BUFFER;
 	scsi_build_sense_buffer(desc_format, buffer, key, asc, ascq);
-	if (sd->add_sector_info)
+	if (sd->add_sense_info)
 		WARN_ON_ONCE(scsi_set_sense_information(buffer,
 							cmd->scsi_sense_length,
-							cmd->bad_sector) < 0);
+							cmd->sense_info) < 0);
 }
 
 int
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 18a5dcd275f88..16992ba455deb 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -540,7 +540,7 @@ struct se_cmd {
 	struct scatterlist	*t_prot_sg;
 	unsigned int		t_prot_nents;
 	sense_reason_t		pi_err;
-	sector_t		bad_sector;
+	u64			sense_info;
 	int			cpuid;
 };
 
-- 
2.39.2



