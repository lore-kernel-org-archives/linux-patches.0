Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE8A309F14;
	Mon, 13 Oct 2025 15:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369444; cv=none; b=PSxoS5UawAxKZkTwVjMho8goax4CbjgquJ/cUCI1Gu3B7PtU5s1Aj1yDhw2u/6Hi8NJt3DWYyScDBld35y+mi7uTvAHrZGQ55NiaGtEnLVmylUeD3F/R2Syhi8X1pVlntR2yFQEbprH2LvdGqqCmreKSwjevL6IZi6skytmPM9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369444; c=relaxed/simple;
	bh=rKPOsOoso5kdXLWCoG5jgdxitTU+IZjgsdWp6xqCzTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jFP6+StTdmCn9soXco/Ue1d+tAU01YU0BJOxRDwjYzecgtWcisgFfembRSlg53Q+4Ui/ldIqcklFgxsVWvUhQoM3mVOyYUv2w2/ImVmqHGUrSj5Rr9jp4mKVTAw+UCXLeSeoZDT30w7mbAnpHcl5GXkxMKpjUq3O09RbEyXworI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CStMfVLr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CStMfVLr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AB21C4CEFE;
	Mon, 13 Oct 2025 15:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369444;
	bh=rKPOsOoso5kdXLWCoG5jgdxitTU+IZjgsdWp6xqCzTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CStMfVLrwOk0iosolkuNQ6Q8JRt8f+Z5UAiNu/CYgj9G9ZHNdOpVYM0kZrsfL9rAN
	 9LViuHf4ZEI3PWkSkoUsfSFftY9rCSkxEdLc7oLGFVPL1gcu7mqknwCVWowj0srDol
	 jFe+B0k3AMsEyGLKDG8+2j6/5Fox/yRAP46Vmn6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 249/563] scsi: pm80xx: Add helper function to get the local phy id
Date: Mon, 13 Oct 2025 16:41:50 +0200
Message-ID: <20251013144420.302909985@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit b4ec98303f9fc9b1da0053106716db6a7e002d8b ]

Avoid duplicated code by adding a helper to get the local phy id.

No functional changes intended.

Signed-off-by: Niklas Cassel <cassel@kernel.org>
Link: https://lore.kernel.org/r/20250814173215.1765055-20-cassel@kernel.org
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: ad70c6bc776b ("scsi: pm80xx: Fix pm8001_abort_task() for chip_8006 when using an expander")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm8001_hwi.c |  7 +++----
 drivers/scsi/pm8001/pm8001_sas.c | 10 ++++++++++
 drivers/scsi/pm8001/pm8001_sas.h |  1 +
 drivers/scsi/pm8001/pm80xx_hwi.c |  6 ++----
 4 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index fb4913547b00f..8005995a317c1 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -4184,10 +4184,9 @@ static int pm8001_chip_reg_dev_req(struct pm8001_hba_info *pm8001_ha,
 			dev_is_expander(pm8001_dev->dev_type))
 			stp_sspsmp_sata = 0x01; /*ssp or smp*/
 	}
-	if (dev_parent_is_expander(dev))
-		phy_id = dev->parent->ex_dev.ex_phy->phy_id;
-	else
-		phy_id = pm8001_dev->attached_phy;
+
+	phy_id = pm80xx_get_local_phy_id(dev);
+
 	opc = OPC_INB_REG_DEV;
 	linkrate = (pm8001_dev->sas_device->linkrate < dev->port->linkrate) ?
 			pm8001_dev->sas_device->linkrate : dev->port->linkrate;
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 2bdeace6c6bfe..5595913eb7fc1 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -130,6 +130,16 @@ static void pm80xx_get_tag_opcodes(struct sas_task *task, int *ata_op,
 	}
 }
 
+u32 pm80xx_get_local_phy_id(struct domain_device *dev)
+{
+	struct pm8001_device *pm8001_dev = dev->lldd_dev;
+
+	if (dev_parent_is_expander(dev))
+		return dev->parent->ex_dev.ex_phy->phy_id;
+
+	return pm8001_dev->attached_phy;
+}
+
 void pm80xx_show_pending_commands(struct pm8001_hba_info *pm8001_ha,
 				  struct pm8001_device *target_pm8001_dev)
 {
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index 334485bb2c12d..91b2cdf3535cd 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -798,6 +798,7 @@ void pm8001_setds_completion(struct domain_device *dev);
 void pm8001_tmf_aborted(struct sas_task *task);
 void pm80xx_show_pending_commands(struct pm8001_hba_info *pm8001_ha,
 				  struct pm8001_device *dev);
+u32 pm80xx_get_local_phy_id(struct domain_device *dev);
 
 #endif
 
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 546d0d26f7a17..31960b72c1e92 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -4797,10 +4797,8 @@ static int pm80xx_chip_reg_dev_req(struct pm8001_hba_info *pm8001_ha,
 			dev_is_expander(pm8001_dev->dev_type))
 			stp_sspsmp_sata = 0x01; /*ssp or smp*/
 	}
-	if (dev_parent_is_expander(dev))
-		phy_id = dev->parent->ex_dev.ex_phy->phy_id;
-	else
-		phy_id = pm8001_dev->attached_phy;
+
+	phy_id = pm80xx_get_local_phy_id(dev);
 
 	opc = OPC_INB_REG_DEV;
 
-- 
2.51.0



