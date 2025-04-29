Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A57EC2AE96;
	Tue, 29 Apr 2025 17:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949550; cv=none; b=WV+VMVD7A7aTbBJzeSYcYnaF/uUO+WRzGhoHQu/x/5F+mR2/SqkYSrHR9b7+2bFdKbToXXbiq0u3Ejg23mFFk2x50tplrTL/+ucbJVULEtB3Qn/ruhWbkjUFWqEGAh8D7b0blk3OtmiEszcy+MTUjhU69MXkmrNppEFCfNu7/+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949550; c=relaxed/simple;
	bh=kPaEglc3HRrzHbGyqFQFb7tTNp4uDh+lB0r8cccdh8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s5LDfiiqedaaLaibqHAX1Xo83NXQh2vgDc69uRIqgo4EYlp11olSc0u9SUxzHhaSQ5mToV5+iGMaWodzmObvUMnWMZ8gXSd0s/dQrSBTMGCSVSMfc+ibzojrakP1IztwPaR9FN/ZMpn6vyUYHO8I6KHJDkByrxblpfEHh1C0xPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E4dSgwAc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E4dSgwAc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E7DCC4CEE3;
	Tue, 29 Apr 2025 17:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949550;
	bh=kPaEglc3HRrzHbGyqFQFb7tTNp4uDh+lB0r8cccdh8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E4dSgwAcc7GLr87rMgE48CLu8EMQMmrGmgzhQf2ZJcBAERFo5dKaeexcZCQSHusI5
	 kjoXFgU5xHNbQGpXUWZawMZvWg5dn/qn2Xkw8M5Q1Syb6EEdWmQEy87kNNnm8KA4j9
	 USMyq2lztYJo/6ZHmFO+g0pPUHmBKNl/4Cqlh4ZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingui Yang <yangxingui@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 355/373] scsi: hisi_sas: Fix I/O errors caused by hardware port ID changes
Date: Tue, 29 Apr 2025 18:43:52 +0200
Message-ID: <20250429161137.733230408@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xingui Yang <yangxingui@huawei.com>

[ Upstream commit daff37f00c7506ca322ccfce95d342022f06ec58 ]

The hw port ID of phy may change when inserting disks in batches, causing
the port ID in hisi_sas_port and itct to be inconsistent with the hardware,
resulting in I/O errors. The solution is to set the device state to gone to
intercept I/O sent to the device, and then execute linkreset to discard and
find the disk to re-update its information.

Signed-off-by: Xingui Yang <yangxingui@huawei.com>
Link: https://lore.kernel.org/r/20250312095135.3048379-3-yangxingui@huawei.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 0ca80e00835cb..8c32f815a968a 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -852,8 +852,28 @@ static void hisi_sas_phyup_work(struct work_struct *work)
 		container_of(work, typeof(*phy), works[HISI_PHYE_PHY_UP]);
 	struct hisi_hba *hisi_hba = phy->hisi_hba;
 	struct asd_sas_phy *sas_phy = &phy->sas_phy;
+	struct asd_sas_port *sas_port = sas_phy->port;
+	struct hisi_sas_port *port = phy->port;
+	struct device *dev = hisi_hba->dev;
+	struct domain_device *port_dev;
 	int phy_no = sas_phy->id;
 
+	if (!test_bit(HISI_SAS_RESETTING_BIT, &hisi_hba->flags) &&
+	    sas_port && port && (port->id != phy->port_id)) {
+		dev_info(dev, "phy%d's hw port id changed from %d to %llu\n",
+				phy_no, port->id, phy->port_id);
+		port_dev = sas_port->port_dev;
+		if (port_dev && !dev_is_expander(port_dev->dev_type)) {
+			/*
+			 * Set the device state to gone to block
+			 * sending IO to the device.
+			 */
+			set_bit(SAS_DEV_GONE, &port_dev->state);
+			hisi_sas_notify_phy_event(phy, HISI_PHYE_LINK_RESET);
+			return;
+		}
+	}
+
 	phy->wait_phyup_cnt = 0;
 	if (phy->identify.target_port_protocols == SAS_PROTOCOL_SSP)
 		hisi_hba->hw->sl_notify_ssp(hisi_hba, phy_no);
-- 
2.39.5



