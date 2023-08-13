Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AABDC9446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:42:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28961C433C8;
	Sun, 13 Aug 2023 21:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962944;
	bh=dgAvIXWN+aovnXwN1twj9rbo4W3bNSYMoqi0/VGLDS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rNwqxbSaylWtgsBBQp5+/xXkg9scUbkClJ6Dc02NOh9J5+6KvVpI1/N6jiDqnaRgQ
	 MArDroNQuf1w+ABAuODDgu9zGS2w2xJf/mjTEXaBSEnK63hk2nho4KXGC47UXLw9yD
	 NnKLs8I97K5bOtZqCZG/LGWg9t2RjKw+tBTCT3Y0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 65/68] scsi: qedi: Fix firmware halt over suspend and resume
Date: Sun, 13 Aug 2023 23:20:06 +0200
Message-ID: <20230813211710.120080028@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211708.149630011@linuxfoundation.org>
References: <20230813211708.149630011@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nilesh Javali <njavali@marvell.com>

commit 1516ee035df32115197cd93ae3619dba7b020986 upstream.

While performing certain power-off sequences, PCI drivers are called to
suspend and resume their underlying devices through PCI PM (power
management) interface. However the hardware does not support PCI PM
suspend/resume operations so system wide suspend/resume leads to bad MFW
(management firmware) state which causes various follow-up errors in driver
when communicating with the device/firmware.

To fix this driver implements PCI PM suspend handler to indicate
unsupported operation to the PCI subsystem explicitly, thus avoiding system
to go into suspended/standby mode.

Fixes: ace7f46ba5fd ("scsi: qedi: Add QLogic FastLinQ offload iSCSI driver framework.")
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://lore.kernel.org/r/20230807093725.46829-2-njavali@marvell.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qedi/qedi_main.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -69,6 +69,7 @@ static struct nvm_iscsi_block *qedi_get_
 static void qedi_recovery_handler(struct work_struct *work);
 static void qedi_schedule_hw_err_handler(void *dev,
 					 enum qed_hw_err_type err_type);
+static int qedi_suspend(struct pci_dev *pdev, pm_message_t state);
 
 static int qedi_iscsi_event_cb(void *context, u8 fw_event_code, void *fw_handle)
 {
@@ -2517,6 +2518,22 @@ static void qedi_shutdown(struct pci_dev
 	__qedi_remove(pdev, QEDI_MODE_SHUTDOWN);
 }
 
+static int qedi_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	struct qedi_ctx *qedi;
+
+	if (!pdev) {
+		QEDI_ERR(NULL, "pdev is NULL.\n");
+		return -ENODEV;
+	}
+
+	qedi = pci_get_drvdata(pdev);
+
+	QEDI_ERR(&qedi->dbg_ctx, "%s: Device does not support suspend operation\n", __func__);
+
+	return -EPERM;
+}
+
 static int __qedi_probe(struct pci_dev *pdev, int mode)
 {
 	struct qedi_ctx *qedi;
@@ -2875,6 +2892,7 @@ static struct pci_driver qedi_pci_driver
 	.remove = qedi_remove,
 	.shutdown = qedi_shutdown,
 	.err_handler = &qedi_err_handler,
+	.suspend = qedi_suspend,
 };
 
 static int __init qedi_init(void)


