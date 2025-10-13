Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53065309F13;
	Mon, 13 Oct 2025 15:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369447; cv=none; b=LpM6bPS8OCZr9KYQD+V/XAkZVaJP4EI+S8F4CsJPY0iRy+Mue3y1YnpEvksj0nsBOwos6QNfST3JNUtRpiPomUSnm4dCodN8CsAqdnY7FNrxSkb8bToVdJC7wtqFpVb7QvkMncSlh2iTZy0fG+GuLB8EZnnanLlZLN62/uuhohM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369447; c=relaxed/simple;
	bh=RKa8CLSZKk2pZT86N7pW3UgFbwZn7FzuIm5Wi2ml9dU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JgSl9vA5VW5Pl5r+iYVL5viBVgNB3P3w6wc19CQjeDeqJb4XQtmtNsj+SgfUc2MxoGpmo4wDJio5xStDXjCRSSRu0uCcVERajZVTsBExTPaqaL3iMvH9KChGVOT01oSQtGepeNaZub4MyGDcRYk9uiSGztJG+/vabfudPajodNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ONfzddgt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ONfzddgt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B62C4CEE7;
	Mon, 13 Oct 2025 15:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369447;
	bh=RKa8CLSZKk2pZT86N7pW3UgFbwZn7FzuIm5Wi2ml9dU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ONfzddgtOnLShhIiEk2DNgvpJkXqoc5c4lr5SoPBGc+xBgl/Ci611t4UHoiIP5TmT
	 Xj4Ea4hlFrwcfWWkElcEuNn3UrdBqZ7GzLmfTgOGGV8jqtOPFC8lmdPgTR/1EAHFLY
	 7/fLHWPjKj6dlBn/bU0Vz+aTTbTLXU9cEo6564BM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Pylypiv <ipylypiv@google.com>,
	Niklas Cassel <cassel@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 250/563] scsi: pm80xx: Fix pm8001_abort_task() for chip_8006 when using an expander
Date: Mon, 13 Oct 2025 16:41:51 +0200
Message-ID: <20251013144420.338316519@linuxfoundation.org>
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

[ Upstream commit ad70c6bc776b53e61c8db6533c833aff0ff5da8b ]

For a direct attached device, attached_phy contains the local phy id.
For a device behind an expander, attached_phy contains the remote phy
id, not the local phy id.

The pm8001_ha->phy array only contains the phys of the HBA.  It does not
contain the phys of the expander.

Thus, you cannot use attached_phy to index the pm8001_ha->phy array,
without first verifying that the device is directly attached.

Use the pm80xx_get_local_phy_id() helper to make sure that we use the
local phy id to index the array, regardless if the device is directly
attached or not.

Fixes: 869ddbdcae3b ("scsi: pm80xx: corrected SATA abort handling sequence.")
Reviewed-by: Igor Pylypiv <ipylypiv@google.com>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Link: https://lore.kernel.org/r/20250814173215.1765055-21-cassel@kernel.org
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm8001_sas.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 5595913eb7fc1..c5354263b45e8 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -1063,7 +1063,7 @@ int pm8001_abort_task(struct sas_task *task)
 	struct pm8001_hba_info *pm8001_ha;
 	struct pm8001_device *pm8001_dev;
 	int rc = TMF_RESP_FUNC_FAILED, ret;
-	u32 phy_id, port_id;
+	u32 port_id;
 	struct sas_task_slow slow_task;
 
 	if (!task->lldd_task || !task->dev)
@@ -1072,7 +1072,6 @@ int pm8001_abort_task(struct sas_task *task)
 	dev = task->dev;
 	pm8001_dev = dev->lldd_dev;
 	pm8001_ha = pm8001_find_ha_by_dev(dev);
-	phy_id = pm8001_dev->attached_phy;
 
 	if (PM8001_CHIP_DISP->fatal_errors(pm8001_ha)) {
 		// If the controller is seeing fatal errors
@@ -1104,7 +1103,8 @@ int pm8001_abort_task(struct sas_task *task)
 		if (pm8001_ha->chip_id == chip_8006) {
 			DECLARE_COMPLETION_ONSTACK(completion_reset);
 			DECLARE_COMPLETION_ONSTACK(completion);
-			struct pm8001_phy *phy = pm8001_ha->phy + phy_id;
+			u32 phy_id = pm80xx_get_local_phy_id(dev);
+			struct pm8001_phy *phy = &pm8001_ha->phy[phy_id];
 			port_id = phy->port->port_id;
 
 			/* 1. Set Device state as Recovery */
-- 
2.51.0



