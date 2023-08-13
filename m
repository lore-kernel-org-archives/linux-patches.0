Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ABA69446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:46:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5B72C433C8;
	Sun, 13 Aug 2023 21:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691963206;
	bh=naWNfAgkRIgdAjdS9Hbe7q9+mIzGfemcRBOzIhrh/M8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0zVGF0M67nzRtatxT87PwXPJVpSY+UiX8spgYhwFjHggtYXkRYIeigmxGVsuIs/67
	 NWcTkwn6h9Zm/YlhZh2NwPBRzpkx3ItubEu9CHJKLOFCj/IYzygl+lJJXECLkar2Em
	 O6G2f1Pepebu47TB8Kp037G6t0DmYhxifV6/bz8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saurav Kashyap <skashyap@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 84/89] scsi: qedf: Fix firmware halt over suspend and resume
Date: Sun, 13 Aug 2023 23:20:15 +0200
Message-ID: <20230813211713.284929710@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211710.787645394@linuxfoundation.org>
References: <20230813211710.787645394@linuxfoundation.org>
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

commit ef222f551e7c4e2008fc442ffc9edcd1a7fd8f63 upstream.

While performing certain power-off sequences, PCI drivers are called to
suspend and resume their underlying devices through PCI PM (power
management) interface. However the hardware does not support PCI PM
suspend/resume operations so system wide suspend/resume leads to bad MFW
(management firmware) state which causes various follow-up errors in driver
when communicating with the device/firmware.

To fix this driver implements PCI PM suspend handler to indicate
unsupported operation to the PCI subsystem explicitly, thus avoiding system
to go into suspended/standby mode.

Fixes: 61d8658b4a43 ("scsi: qedf: Add QLogic FastLinQ offload FCoE driver framework.")
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://lore.kernel.org/r/20230807093725.46829-1-njavali@marvell.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qedf/qedf_main.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -31,6 +31,7 @@ static void qedf_remove(struct pci_dev *
 static void qedf_shutdown(struct pci_dev *pdev);
 static void qedf_schedule_recovery_handler(void *dev);
 static void qedf_recovery_handler(struct work_struct *work);
+static int qedf_suspend(struct pci_dev *pdev, pm_message_t state);
 
 /*
  * Driver module parameters.
@@ -3276,6 +3277,7 @@ static struct pci_driver qedf_pci_driver
 	.probe = qedf_probe,
 	.remove = qedf_remove,
 	.shutdown = qedf_shutdown,
+	.suspend = qedf_suspend,
 };
 
 static int __qedf_probe(struct pci_dev *pdev, int mode)
@@ -4005,6 +4007,22 @@ static void qedf_shutdown(struct pci_dev
 	__qedf_remove(pdev, QEDF_MODE_NORMAL);
 }
 
+static int qedf_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	struct qedf_ctx *qedf;
+
+	if (!pdev) {
+		QEDF_ERR(NULL, "pdev is NULL.\n");
+		return -ENODEV;
+	}
+
+	qedf = pci_get_drvdata(pdev);
+
+	QEDF_ERR(&qedf->dbg_ctx, "%s: Device does not support suspend operation\n", __func__);
+
+	return -EPERM;
+}
+
 /*
  * Recovery handler code
  */


