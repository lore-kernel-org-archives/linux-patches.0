Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76BF168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:05:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C93EC433D2;
	Mon,  8 May 2023 10:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540318;
	bh=OhNI5HEa+rGIUEheh2coeEnfiuQZ0gvqR6VgGIFhOtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=csAuQ6dqe4PP+N8f1K3Mzl0f8bhdtVsYT0zNPMkV/ZHQZO62zlsT5yOc95Ddt7uR+
	 TknVRQqmQiT3z/t13QwZuDxtq4/Vsrg7lKO8nWMb6Z611/FlJ7IV4oVRLSA3F5QXkj
	 XfSckJj69omMV3O+sBU5MQtUKMa1qQiV+tS+33F0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Niklas Cassel <niklas.cassel@wdc.com>,
	John Garry <john.garry@huawei.com>,
	Jason Yan <yanaijie@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 312/611] scsi: libsas: Add sas_ata_device_link_abort()
Date: Mon,  8 May 2023 11:42:34 +0200
Message-Id: <20230508094432.575868945@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: John Garry <john.garry@huawei.com>

[ Upstream commit 44112922674b94a7d699dfff6307fc830018df7c ]

Similar to how AHCI handles NCQ errors in ahci_error_intr() ->
ata_port_abort() -> ata_do_link_abort(), add an NCQ error handler for LLDDs
to call to initiate a link abort.

This will mark all outstanding QCs as failed and kick-off EH.

Note:

A "force reset" argument is added for drivers which require the ATA error
handling to always reset the device.

A driver may require this feature for when SATA device per-SCSI cmnd
resources are only released during reset for ATA EH. As such, we need an
option to force reset to be done, regardless of what any EH autopsy
decides.

The SATA device FIS fields are set to indicate a device error from
ata_eh_analyze_tf().

Suggested-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Suggested-by: Niklas Cassel <niklas.cassel@wdc.com>
Signed-off-by: John Garry <john.garry@huawei.com>
Link: https://lore.kernel.org/r/1665998435-199946-2-git-send-email-john.garry@huawei.com
Tested-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Tested-by: Niklas Cassel <niklas.cassel@wdc.com> # pm80xx
Reviewed-by: Jason Yan <yanaijie@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: bb544224da77 ("scsi: hisi_sas: Handle NCQ error when IPTT is valid")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libsas/sas_ata.c | 15 +++++++++++++++
 include/scsi/sas_ata.h        |  6 ++++++
 2 files changed, 21 insertions(+)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 2fd55ef9ffca5..a34d06fd47f06 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -886,6 +886,21 @@ void sas_ata_wait_eh(struct domain_device *dev)
 	ata_port_wait_eh(ap);
 }
 
+void sas_ata_device_link_abort(struct domain_device *device, bool force_reset)
+{
+	struct ata_port *ap = device->sata_dev.ap;
+	struct ata_link *link = &ap->link;
+
+	device->sata_dev.fis[2] = ATA_ERR | ATA_DRDY; /* tf status */
+	device->sata_dev.fis[3] = ATA_ABORTED; /* tf error */
+
+	link->eh_info.err_mask |= AC_ERR_DEV;
+	if (force_reset)
+		link->eh_info.action |= ATA_EH_RESET;
+	ata_link_abort(link);
+}
+EXPORT_SYMBOL_GPL(sas_ata_device_link_abort);
+
 int sas_execute_ata_cmd(struct domain_device *device, u8 *fis, int force_phy_id)
 {
 	struct sas_tmf_task tmf_task = {};
diff --git a/include/scsi/sas_ata.h b/include/scsi/sas_ata.h
index ec646217e7f6e..e7d466df81576 100644
--- a/include/scsi/sas_ata.h
+++ b/include/scsi/sas_ata.h
@@ -32,6 +32,7 @@ void sas_probe_sata(struct asd_sas_port *port);
 void sas_suspend_sata(struct asd_sas_port *port);
 void sas_resume_sata(struct asd_sas_port *port);
 void sas_ata_end_eh(struct ata_port *ap);
+void sas_ata_device_link_abort(struct domain_device *dev, bool force_reset);
 int sas_execute_ata_cmd(struct domain_device *device, u8 *fis,
 			int force_phy_id);
 int sas_ata_wait_after_reset(struct domain_device *dev, unsigned long deadline);
@@ -88,6 +89,11 @@ static inline void sas_ata_end_eh(struct ata_port *ap)
 {
 }
 
+static inline void sas_ata_device_link_abort(struct domain_device *dev,
+					     bool force_reset)
+{
+}
+
 static inline int sas_execute_ata_cmd(struct domain_device *device, u8 *fis,
 				      int force_phy_id)
 {
-- 
2.39.2



