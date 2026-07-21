Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E3937E310;
	Tue, 21 Jul 2026 22:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673639; cv=none; b=LuUK8GkAKsZXvPnD2TcXzQ65UjVFGX1m6xLmMXf2M9pJJ2VF47XJsCoSgbJimTwtYo/ei16prsW/nMxmdcivz0ZrluHiKlmm1XeSYbQ67GqpA5JeIzx1cQsv4N/VDbX/FnituMer58K5TUdB5PC3ZvuoH5YptFiJtb0XCZf9exk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673639; c=relaxed/simple;
	bh=O70sRnLJuKw0p6T5hmUiqzg/UT1ZyR70DorbLA3M0ts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aldeFTgbEJEBxbvINwi2/dsmvXKj2MK9c68xrappPjofk2mRnchdb+L55ViFpOFmFtnObHf1avKQrtLfa1DojU/fftcmAXyRgSq8S5vHBVjPZjQnpfnu8PmfVAP0ZV3rH6RtZGjmLQgdGeiQXgei01AFyGRGykBk/4Cp6NZetls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VVN1G0CN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VVN1G0CN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5386C1F000E9;
	Tue, 21 Jul 2026 22:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673637;
	bh=te2c6rhVmzY2O7cZYNuhBHK9pX1MM7FrpnzC4TIayIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VVN1G0CNwTnAIDjB2ImOajU0IXs42sfXYArEaR3hFkRr4dvCdzGt4CtvznjsdL1m4
	 qol+MR/CCCgMDPmgC10bEgOXgVhf50IMkNuhsxUTx7h9V5PvPyK3p/Zcw+s07TUTr3
	 Jf1AgZjwdrzW7HST3GckFYt1IHlh2CcARJ9OrriU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Wilck <martin.wilck@suse.com>,
	Don Brace <don.brace@microchip.com>,
	storagedev@microchip.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	MPT-FusionLinux.pdl@broadcom.com,
	Yihang Li <liyihang9@h-partners.c>,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 221/699] scsi: Revert "scsi: Fix sas_user_scan() to handle wildcard and multi-channel scans"
Date: Tue, 21 Jul 2026 17:19:40 +0200
Message-ID: <20260721152400.686267695@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Wilck <martin.wilck@suse.com>

[ Upstream commit 8c292e89bd831c8a13e92f3429ef66bbe0b83677 ]

This reverts commit 37c4e72b0651e7697eb338cd1fb09feef472cc1a.

Said commit causes excessive resource usage and even system freeze with
some controllers, e.g. smartpqi and hisi_sas. The justification provided
by the patch authors [1] was supporting a special mode of the mpi3mr and
mpt3sas, so-called "Tri-mode", in which NVMe drives are exposed as SCSI
devices on a separate channel. While that's useful for these drivers, it
seems wrong to cause major breakage for other drivers for the sake of
this feature.

[1] https://lore.kernel.org/linux-scsi/CAFdVvOwjy+2ORJ6uJkspiLTPF05481U7gcS4QohFOFGPqAs8ig@mail.gmail.com/

Fixes: 37c4e72b0651 ("scsi: Fix sas_user_scan() to handle wildcard and multi-channel scans")
Signed-off-by: Martin Wilck <martin.wilck@suse.com>
Cc: Don Brace <don.brace@microchip.com>
Cc: storagedev@microchip.com
Cc: Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: mpi3mr-linuxdrv.pdl@broadcom.com
Cc: MPT-FusionLinux.pdl@broadcom.com
Cc: Yihang Li <liyihang9@h-partners.c>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260513174236.430465-3-mwilck@suse.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_scan.c          |  2 +-
 drivers/scsi/scsi_transport_sas.c | 60 +++++++------------------------
 2 files changed, 13 insertions(+), 49 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 1dea44c1c568d3..e8703b043805e5 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1686,7 +1686,7 @@ int scsi_scan_host_selected(struct Scsi_Host *shost, unsigned int channel,
 
 	return 0;
 }
-EXPORT_SYMBOL(scsi_scan_host_selected);
+
 static void scsi_sysfs_add_devices(struct Scsi_Host *shost)
 {
 	struct scsi_device *sdev;
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 8766ec93652ca0..c6256fdc24b10c 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -41,8 +41,6 @@
 #include <scsi/scsi_transport_sas.h>
 
 #include "scsi_sas_internal.h"
-#include "scsi_priv.h"
-
 struct sas_host_attrs {
 	struct list_head rphy_list;
 	struct mutex lock;
@@ -1654,22 +1652,6 @@ int scsi_is_sas_rphy(const struct device *dev)
 }
 EXPORT_SYMBOL(scsi_is_sas_rphy);
 
-static void scan_channel_zero(struct Scsi_Host *shost, uint id, u64 lun)
-{
-	struct sas_host_attrs *sas_host = to_sas_host_attrs(shost);
-	struct sas_rphy *rphy;
-
-	list_for_each_entry(rphy, &sas_host->rphy_list, list) {
-		if (rphy->identify.device_type != SAS_END_DEVICE ||
-		    rphy->scsi_target_id == -1)
-			continue;
-
-		if (id == SCAN_WILD_CARD || id == rphy->scsi_target_id) {
-			scsi_scan_target(&rphy->dev, 0, rphy->scsi_target_id,
-					 lun, SCSI_SCAN_MANUAL);
-		}
-	}
-}
 
 /*
  * SCSI scan helper
@@ -1679,41 +1661,23 @@ static int sas_user_scan(struct Scsi_Host *shost, uint channel,
 		uint id, u64 lun)
 {
 	struct sas_host_attrs *sas_host = to_sas_host_attrs(shost);
-	int res = 0;
-	int i;
-
-	switch (channel) {
-	case 0:
-		mutex_lock(&sas_host->lock);
-		scan_channel_zero(shost, id, lun);
-		mutex_unlock(&sas_host->lock);
-		break;
-
-	case SCAN_WILD_CARD:
-		mutex_lock(&sas_host->lock);
-		scan_channel_zero(shost, id, lun);
-		mutex_unlock(&sas_host->lock);
+	struct sas_rphy *rphy;
 
-		for (i = 1; i <= shost->max_channel; i++) {
-			res = scsi_scan_host_selected(shost, i, id, lun,
-						      SCSI_SCAN_MANUAL);
-			if (res)
-				goto exit_scan;
-		}
-		break;
+	mutex_lock(&sas_host->lock);
+	list_for_each_entry(rphy, &sas_host->rphy_list, list) {
+		if (rphy->identify.device_type != SAS_END_DEVICE ||
+		    rphy->scsi_target_id == -1)
+			continue;
 
-	default:
-		if (channel <= shost->max_channel) {
-			res = scsi_scan_host_selected(shost, channel, id, lun,
-						      SCSI_SCAN_MANUAL);
-		} else {
-			res = -EINVAL;
+		if ((channel == SCAN_WILD_CARD || channel == 0) &&
+		    (id == SCAN_WILD_CARD || id == rphy->scsi_target_id)) {
+			scsi_scan_target(&rphy->dev, 0, rphy->scsi_target_id,
+					 lun, SCSI_SCAN_MANUAL);
 		}
-		break;
 	}
+	mutex_unlock(&sas_host->lock);
 
-exit_scan:
-	return res;
+	return 0;
 }
 
 
-- 
2.53.0



