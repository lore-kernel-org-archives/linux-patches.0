Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CF5682C60;
	Tue, 29 Apr 2025 17:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948234; cv=none; b=AS4HnNCh049j/rgJgzcjWSWhI36LNkS+puJCup9aqq7FoeVDZB7NcPKMALJcjKJe3vJwMJJpd3lwNNlPjfyIG3YEFePNEwkW7t7rJbUTHOBujtbnn1oGI+FdCn9E+CKqhm5Ql6PK2aShfcvgBOwSy5oeqrHBlk50QVMdZ0LVR3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948234; c=relaxed/simple;
	bh=t6TfuI6qowLcdYC142pDZAm6m7UwySmwBDSeVdnsAKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cCkUqIWMm9NNR+69y19qSTIbzj6dGmErgudFZhSZ4GZpPWWy+ms8Lfv3JJvJ2UMrEOEDV1uc5VMGH61uQlkXMf0a+RS0zpvXa8FUI8dxiqJxfK8/zmr75IwCkHwd/PMVXHjHcSxa1n0CMN4a+PUYfJfgF+bi4flfnspR20i+Y1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MmOvzzYK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MmOvzzYK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CE3EC4CEE3;
	Tue, 29 Apr 2025 17:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948234;
	bh=t6TfuI6qowLcdYC142pDZAm6m7UwySmwBDSeVdnsAKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MmOvzzYKW0u9RXaOlpzF6TAaAT+wJX35HdL8Vd0c2yYJcgll314mMvK342brYseGD
	 1EXNfmXbIcaDVDswLbbCtKJ4v9nKaFQCkkql5BMa161AYmIJL5qMIExBfYq/eK4tE2
	 3ZDPgK3ZzgdurYBGqXTz8JalR0Q9IRVihUOf4lJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingui Yang <yangxingui@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 228/280] scsi: hisi_sas: Fix I/O errors caused by hardware port ID changes
Date: Tue, 29 Apr 2025 18:42:49 +0200
Message-ID: <20250429161124.448030060@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ffd15fa4f9e59..e98e6b2b9f570 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -912,8 +912,28 @@ static void hisi_sas_phyup_work_common(struct work_struct *work,
 		container_of(work, typeof(*phy), works[event]);
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



