Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D7A0284B48;
	Wed, 23 Apr 2025 15:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421674; cv=none; b=Rer+j1KkdqFNFUjninGrR8+Ts9Mzdzjed1l71IPCyOOSgtS8sA8NdrP/aHFBm7UeMutADNWvoVhn87oj8P1rnaEqiBaIVMXuDbCz67CyvaW7NaeGh5CzsTXo3AOtKoNJVFyGTlu+VRgUdGMQSEHvDk/MC4oOZCndBj9Y620t8Dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421674; c=relaxed/simple;
	bh=5zQsvFksd49Ocq1CjRJgD7lyEDYlMIOTQSWju5zr4QE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PHPBLnUGeeGphXPt3RLF3fvHp9kz6K7brKotssDvk/jT+2+Nh4RKkH5Xrw/ulVxIjw/j1Lmk3h6sdB7wpOnFLgzn96Pr5DPLm9nU0qrh4QxaJJCuP4Ke71n3gLCAXdnaCfupAZppPGqAvgyka9KNxgNRq7q9lhP4emB5OFZfGAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H0Y0iuJy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H0Y0iuJy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0289C4CEE8;
	Wed, 23 Apr 2025 15:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421674;
	bh=5zQsvFksd49Ocq1CjRJgD7lyEDYlMIOTQSWju5zr4QE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H0Y0iuJyMI5WGMmPEe9T7rhJKEvQE5/A/ew4RFIY+2xwGRHbGkIHmZIes7cM9xKZo
	 PjyuhvLoQ9BfwiVaUGBTTa7teZHjocACL4Tc/Zj07vFgRzNtJXFxY6ip5OaEDB1sDl
	 TeXQ/vQQ3bpGvaLJiNAsW3DWuZ9+uEBHuB0+tViY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingui Yang <yangxingui@huawei.com>,
	Yihang Li <liyihang9@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 165/291] scsi: hisi_sas: Enable force phy when SATA disk directly connected
Date: Wed, 23 Apr 2025 16:42:34 +0200
Message-ID: <20250423142631.134360550@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Xingui Yang <yangxingui@huawei.com>

[ Upstream commit 8aa580cd92843b60d4d6331f3b0a9e8409bb70eb ]

when a SATA disk is directly connected the SAS controller determines the
disk to which I/Os are delivered based on the port ID in the DQ entry.

When many phys are disconnected and reconnect, the port ID of phys were
changed and used by other link, resulting in I/O being sent to incorrect
disk. Data inconsistency on the SATA disk may occur during I/O retries
using the old port ID. So enable force phy, then force the command to be
executed in a certain phy, and if the actual phy ID of the port does not
match the phy configured in the command, the chip will stop delivering the
I/O to disk.

Fixes: ce60689e12dd ("scsi: hisi_sas: add v3 code to send ATA frame")
Signed-off-by: Xingui Yang <yangxingui@huawei.com>
Link: https://lore.kernel.org/r/20250312095135.3048379-2-yangxingui@huawei.com
Reviewed-by: Yihang Li <liyihang9@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  9 +++++++--
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 14 ++++++++++++--
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 50697672146ad..ae39f6b5dc9a8 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -2502,6 +2502,7 @@ static void prep_ata_v2_hw(struct hisi_hba *hisi_hba,
 	struct hisi_sas_port *port = to_hisi_sas_port(sas_port);
 	struct sas_ata_task *ata_task = &task->ata_task;
 	struct sas_tmf_task *tmf = slot->tmf;
+	int phy_id;
 	u8 *buf_cmd;
 	int has_data = 0, hdr_tag = 0;
 	u32 dw0, dw1 = 0, dw2 = 0;
@@ -2509,10 +2510,14 @@ static void prep_ata_v2_hw(struct hisi_hba *hisi_hba,
 	/* create header */
 	/* dw0 */
 	dw0 = port->id << CMD_HDR_PORT_OFF;
-	if (parent_dev && dev_is_expander(parent_dev->dev_type))
+	if (parent_dev && dev_is_expander(parent_dev->dev_type)) {
 		dw0 |= 3 << CMD_HDR_CMD_OFF;
-	else
+	} else {
+		phy_id = device->phy->identify.phy_identifier;
+		dw0 |= (1U << phy_id) << CMD_HDR_PHY_ID_OFF;
+		dw0 |= CMD_HDR_FORCE_PHY_MSK;
 		dw0 |= 4 << CMD_HDR_CMD_OFF;
+	}
 
 	if (tmf && ata_task->force_phy) {
 		dw0 |= CMD_HDR_FORCE_PHY_MSK;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 05dcd925a3fab..20b4d76e07149 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -357,6 +357,10 @@
 #define CMD_HDR_RESP_REPORT_MSK		(0x1 << CMD_HDR_RESP_REPORT_OFF)
 #define CMD_HDR_TLR_CTRL_OFF		6
 #define CMD_HDR_TLR_CTRL_MSK		(0x3 << CMD_HDR_TLR_CTRL_OFF)
+#define CMD_HDR_PHY_ID_OFF		8
+#define CMD_HDR_PHY_ID_MSK		(0x1ff << CMD_HDR_PHY_ID_OFF)
+#define CMD_HDR_FORCE_PHY_OFF		17
+#define CMD_HDR_FORCE_PHY_MSK		(0x1U << CMD_HDR_FORCE_PHY_OFF)
 #define CMD_HDR_PORT_OFF		18
 #define CMD_HDR_PORT_MSK		(0xf << CMD_HDR_PORT_OFF)
 #define CMD_HDR_PRIORITY_OFF		27
@@ -1385,15 +1389,21 @@ static void prep_ata_v3_hw(struct hisi_hba *hisi_hba,
 	struct hisi_sas_cmd_hdr *hdr = slot->cmd_hdr;
 	struct asd_sas_port *sas_port = device->port;
 	struct hisi_sas_port *port = to_hisi_sas_port(sas_port);
+	int phy_id;
 	u8 *buf_cmd;
 	int has_data = 0, hdr_tag = 0;
 	u32 dw1 = 0, dw2 = 0;
 
 	hdr->dw0 = cpu_to_le32(port->id << CMD_HDR_PORT_OFF);
-	if (parent_dev && dev_is_expander(parent_dev->dev_type))
+	if (parent_dev && dev_is_expander(parent_dev->dev_type)) {
 		hdr->dw0 |= cpu_to_le32(3 << CMD_HDR_CMD_OFF);
-	else
+	} else {
+		phy_id = device->phy->identify.phy_identifier;
+		hdr->dw0 |= cpu_to_le32((1U << phy_id)
+				<< CMD_HDR_PHY_ID_OFF);
+		hdr->dw0 |= CMD_HDR_FORCE_PHY_MSK;
 		hdr->dw0 |= cpu_to_le32(4U << CMD_HDR_CMD_OFF);
+	}
 
 	switch (task->data_dir) {
 	case DMA_TO_DEVICE:
-- 
2.39.5



