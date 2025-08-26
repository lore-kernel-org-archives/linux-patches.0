Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE667101F2;
	Tue, 26 Aug 2025 13:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213251; cv=none; b=iRfBk6Zb25+abrTvwXBF6oovj4/qHpDAXteqMlS7YZHEhIfMtcjkPUBvkr0gFFofphZF4UH/i2KYwS5QI6C5s5yQAlSEXjzpiWKx9HWxih5BnJe2P0ZIdwuqE/Foxpd/UwWxltr/On6Ldmadi5hx8x9r2ZPy+eRfeAkdvWnRxiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213251; c=relaxed/simple;
	bh=/Oa6cqiqFtNWWE3f4QMsYOnzHYcEaeBMxRqNNcz9/ko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FEWqT2veZyR/v5dl48IAiHHfyQwStR2S13/Ax2QGs68BwHvEXbVqUngHI2HUqE6yUrwKnuAnWjBAG2Gj1FugoA8ItVuPqWzIHP+K4kPNejb+2iCEyUudF3v3W3VziQ2E26xAKK5kElz7J6H6xGmDX/nsiyfM1ZlNDeF4xq5WhS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=psWW+cUf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="psWW+cUf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8100C4CEF1;
	Tue, 26 Aug 2025 13:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213251;
	bh=/Oa6cqiqFtNWWE3f4QMsYOnzHYcEaeBMxRqNNcz9/ko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=psWW+cUfBVG6oPh5PD8531nft6LecuhimJTfse2IOEAQ6uDs+mvzXpKQR1piFjzKO
	 a+bAk5r3tmpC7eVHTBdibQzvXx/y7aV/PnfvmflPhqUGxTqxjN3CS3rPqjZANPr+zo
	 YChgHZSEbvIGrOLwsgI6dqnUMh8Il8YHAHoUULIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 277/587] scsi: Fix sas_user_scan() to handle wildcard and multi-channel scans
Date: Tue, 26 Aug 2025 13:07:06 +0200
Message-ID: <20250826110959.974125782@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ranjan Kumar <ranjan.kumar@broadcom.com>

[ Upstream commit 37c4e72b0651e7697eb338cd1fb09feef472cc1a ]

sas_user_scan() did not fully process wildcard channel scans
(SCAN_WILD_CARD) when a transport-specific user_scan() callback was
present. Only channel 0 would be scanned via user_scan(), while the
remaining channels were skipped, potentially missing devices.

user_scan() invokes updated sas_user_scan() for channel 0, and if
successful, iteratively scans remaining channels (1 to
shost->max_channel) via scsi_scan_host_selected().  This ensures complete
wildcard scanning without affecting transport-specific scanning behavior.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Link: https://lore.kernel.org/r/20250624061649.17990-1-ranjan.kumar@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_scan.c          |  2 +-
 drivers/scsi/scsi_transport_sas.c | 60 ++++++++++++++++++++++++-------
 2 files changed, 49 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index cead0fbbe5db..8ee74dddef16 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1851,7 +1851,7 @@ int scsi_scan_host_selected(struct Scsi_Host *shost, unsigned int channel,
 
 	return 0;
 }
-
+EXPORT_SYMBOL(scsi_scan_host_selected);
 static void scsi_sysfs_add_devices(struct Scsi_Host *shost)
 {
 	struct scsi_device *sdev;
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 7fdd2b61fe85..7b4c4752e216 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -40,6 +40,8 @@
 #include <scsi/scsi_transport_sas.h>
 
 #include "scsi_sas_internal.h"
+#include "scsi_priv.h"
+
 struct sas_host_attrs {
 	struct list_head rphy_list;
 	struct mutex lock;
@@ -1681,32 +1683,66 @@ int scsi_is_sas_rphy(const struct device *dev)
 }
 EXPORT_SYMBOL(scsi_is_sas_rphy);
 
-
-/*
- * SCSI scan helper
- */
-
-static int sas_user_scan(struct Scsi_Host *shost, uint channel,
-		uint id, u64 lun)
+static void scan_channel_zero(struct Scsi_Host *shost, uint id, u64 lun)
 {
 	struct sas_host_attrs *sas_host = to_sas_host_attrs(shost);
 	struct sas_rphy *rphy;
 
-	mutex_lock(&sas_host->lock);
 	list_for_each_entry(rphy, &sas_host->rphy_list, list) {
 		if (rphy->identify.device_type != SAS_END_DEVICE ||
 		    rphy->scsi_target_id == -1)
 			continue;
 
-		if ((channel == SCAN_WILD_CARD || channel == 0) &&
-		    (id == SCAN_WILD_CARD || id == rphy->scsi_target_id)) {
+		if (id == SCAN_WILD_CARD || id == rphy->scsi_target_id) {
 			scsi_scan_target(&rphy->dev, 0, rphy->scsi_target_id,
 					 lun, SCSI_SCAN_MANUAL);
 		}
 	}
-	mutex_unlock(&sas_host->lock);
+}
 
-	return 0;
+/*
+ * SCSI scan helper
+ */
+
+static int sas_user_scan(struct Scsi_Host *shost, uint channel,
+		uint id, u64 lun)
+{
+	struct sas_host_attrs *sas_host = to_sas_host_attrs(shost);
+	int res = 0;
+	int i;
+
+	switch (channel) {
+	case 0:
+		mutex_lock(&sas_host->lock);
+		scan_channel_zero(shost, id, lun);
+		mutex_unlock(&sas_host->lock);
+		break;
+
+	case SCAN_WILD_CARD:
+		mutex_lock(&sas_host->lock);
+		scan_channel_zero(shost, id, lun);
+		mutex_unlock(&sas_host->lock);
+
+		for (i = 1; i <= shost->max_channel; i++) {
+			res = scsi_scan_host_selected(shost, i, id, lun,
+						      SCSI_SCAN_MANUAL);
+			if (res)
+				goto exit_scan;
+		}
+		break;
+
+	default:
+		if (channel < shost->max_channel) {
+			res = scsi_scan_host_selected(shost, channel, id, lun,
+						      SCSI_SCAN_MANUAL);
+		} else {
+			res = -EINVAL;
+		}
+		break;
+	}
+
+exit_scan:
+	return res;
 }
 
 
-- 
2.39.5



