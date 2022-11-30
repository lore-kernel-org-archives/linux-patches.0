Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244A76FA1
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:25:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92F03C433D6;
	Wed, 30 Nov 2022 18:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669832700;
	bh=/LU7KhhLGCBwYlV1athXwzYO16Y9i5WAWlBi4A+vZns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TBd1H3ckmuKekghkCS1eC6TnvRvyt4Ss/r5+4ajt1u2/XWdYtbt/HLeENsGk7cs8c
	 5H82mwsVNjjExoNpAyrHr/pbVUOAX5VuhN6wGrrNcPdtWyUdkYTi/rpHvy5xo1SjOc
	 Swh6M57S/RQPl1efjQBi5/4VcaheCTvfXMbvmEwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenchao Hao <haowenchao@huawei.com>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 002/162] ata: libata-scsi: simplify __ata_scsi_queuecmd()
Date: Wed, 30 Nov 2022 19:21:23 +0100
Message-Id: <20221130180528.539515175@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wenchao Hao <haowenchao@huawei.com>

[ Upstream commit 84eac327af543f03172085d5ef9f98ea25a51191 ]

This patch cleans up the code of __ata_scsi_queuecmd(). Since each
branch of the "if" condition check that scmd->cmd_len is not zero, move
this check out of the "if" to simplify the conditions being checked in
the "else" branch.

While at it, avoid the if-else-if-else structure using if-else if
structure and remove the redundant rc local variable.

This patch does not change the function logic.

Signed-off-by: Wenchao Hao <haowenchao@huawei.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Stable-dep-of: e20e81a24a4d ("ata: libata-core: do not issue non-internal commands once EH is pending")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-scsi.c | 45 ++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 24 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 459ece666c62..70744439359d 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -4034,42 +4034,39 @@ int __ata_scsi_queuecmd(struct scsi_cmnd *scmd, struct ata_device *dev)
 {
 	u8 scsi_op = scmd->cmnd[0];
 	ata_xlat_func_t xlat_func;
-	int rc = 0;
+
+	if (unlikely(!scmd->cmd_len))
+		goto bad_cdb_len;
 
 	if (dev->class == ATA_DEV_ATA || dev->class == ATA_DEV_ZAC) {
-		if (unlikely(!scmd->cmd_len || scmd->cmd_len > dev->cdb_len))
+		if (unlikely(scmd->cmd_len > dev->cdb_len))
 			goto bad_cdb_len;
 
 		xlat_func = ata_get_xlat_func(dev, scsi_op);
-	} else {
-		if (unlikely(!scmd->cmd_len))
-			goto bad_cdb_len;
+	} else if (likely((scsi_op != ATA_16) || !atapi_passthru16)) {
+		/* relay SCSI command to ATAPI device */
+		int len = COMMAND_SIZE(scsi_op);
 
-		xlat_func = NULL;
-		if (likely((scsi_op != ATA_16) || !atapi_passthru16)) {
-			/* relay SCSI command to ATAPI device */
-			int len = COMMAND_SIZE(scsi_op);
-			if (unlikely(len > scmd->cmd_len ||
-				     len > dev->cdb_len ||
-				     scmd->cmd_len > ATAPI_CDB_LEN))
-				goto bad_cdb_len;
+		if (unlikely(len > scmd->cmd_len ||
+			     len > dev->cdb_len ||
+			     scmd->cmd_len > ATAPI_CDB_LEN))
+			goto bad_cdb_len;
 
-			xlat_func = atapi_xlat;
-		} else {
-			/* ATA_16 passthru, treat as an ATA command */
-			if (unlikely(scmd->cmd_len > 16))
-				goto bad_cdb_len;
+		xlat_func = atapi_xlat;
+	} else {
+		/* ATA_16 passthru, treat as an ATA command */
+		if (unlikely(scmd->cmd_len > 16))
+			goto bad_cdb_len;
 
-			xlat_func = ata_get_xlat_func(dev, scsi_op);
-		}
+		xlat_func = ata_get_xlat_func(dev, scsi_op);
 	}
 
 	if (xlat_func)
-		rc = ata_scsi_translate(dev, scmd, xlat_func);
-	else
-		ata_scsi_simulate(dev, scmd);
+		return ata_scsi_translate(dev, scmd, xlat_func);
 
-	return rc;
+	ata_scsi_simulate(dev, scmd);
+
+	return 0;
 
  bad_cdb_len:
 	DPRINTK("bad CDB len=%u, scsi_op=0x%02x, max=%u\n",
-- 
2.35.1



