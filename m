Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC956FC08
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E159C433EF;
	Mon, 15 May 2023 17:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684172411;
	bh=RvlXG4zo72tO2yx09qjT2FJJkZvvhbUh7IUaFIVxGmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UqAQKND5hRBsQcRj7iwxGj78EVSbSTHkX2NMx3aVxno/vFzYuoykRxF4Ox9sXU1AH
	 6WXbucszAE6T0LwT9PHE9wlRKK0nFahINmJ36MEdM8xxj3WT9CfWjw0xBYt+AJdyi6
	 BVOWUBlUwCqXTHMUeDoL7VkELhWXpocDlOUlX9nU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Christie <michael.christie@oracle.com>,
	David Disseldorp <ddiss@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 145/381] scsi: target: Rename struct sense_info to sense_detail
Date: Mon, 15 May 2023 18:26:36 +0200
Message-Id: <20230515161743.398752230@linuxfoundation.org>
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

[ Upstream commit b455233dcc403e3eb955a642dd69b6676e12b245 ]

This helps distinguish it from the SCSI sense INFORMATION field.

Link: https://lore.kernel.org/r/20201031233211.5207-2-ddiss@suse.de
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: David Disseldorp <ddiss@suse.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 673db054d7a2 ("scsi: target: Fix multiple LUN_RESET handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_transport.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index bca3a32a4bfb7..ce521d3d30470 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3131,14 +3131,14 @@ bool transport_wait_for_tasks(struct se_cmd *cmd)
 }
 EXPORT_SYMBOL(transport_wait_for_tasks);
 
-struct sense_info {
+struct sense_detail {
 	u8 key;
 	u8 asc;
 	u8 ascq;
 	bool add_sector_info;
 };
 
-static const struct sense_info sense_info_table[] = {
+static const struct sense_detail sense_detail_table[] = {
 	[TCM_NO_SENSE] = {
 		.key = NOT_READY
 	},
@@ -3298,39 +3298,39 @@ static const struct sense_info sense_info_table[] = {
  */
 static void translate_sense_reason(struct se_cmd *cmd, sense_reason_t reason)
 {
-	const struct sense_info *si;
+	const struct sense_detail *sd;
 	u8 *buffer = cmd->sense_buffer;
 	int r = (__force int)reason;
 	u8 key, asc, ascq;
 	bool desc_format = target_sense_desc_format(cmd->se_dev);
 
-	if (r < ARRAY_SIZE(sense_info_table) && sense_info_table[r].key)
-		si = &sense_info_table[r];
+	if (r < ARRAY_SIZE(sense_detail_table) && sense_detail_table[r].key)
+		sd = &sense_detail_table[r];
 	else
-		si = &sense_info_table[(__force int)
+		sd = &sense_detail_table[(__force int)
 				       TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE];
 
-	key = si->key;
+	key = sd->key;
 	if (reason == TCM_CHECK_CONDITION_UNIT_ATTENTION) {
 		if (!core_scsi3_ua_for_check_condition(cmd, &key, &asc,
 						       &ascq)) {
 			cmd->scsi_status = SAM_STAT_BUSY;
 			return;
 		}
-	} else if (si->asc == 0) {
+	} else if (sd->asc == 0) {
 		WARN_ON_ONCE(cmd->scsi_asc == 0);
 		asc = cmd->scsi_asc;
 		ascq = cmd->scsi_ascq;
 	} else {
-		asc = si->asc;
-		ascq = si->ascq;
+		asc = sd->asc;
+		ascq = sd->ascq;
 	}
 
 	cmd->se_cmd_flags |= SCF_EMULATED_TASK_SENSE;
 	cmd->scsi_status = SAM_STAT_CHECK_CONDITION;
 	cmd->scsi_sense_length  = TRANSPORT_SENSE_BUFFER;
 	scsi_build_sense_buffer(desc_format, buffer, key, asc, ascq);
-	if (si->add_sector_info)
+	if (sd->add_sector_info)
 		WARN_ON_ONCE(scsi_set_sense_information(buffer,
 							cmd->scsi_sense_length,
 							cmd->bad_sector) < 0);
-- 
2.39.2



