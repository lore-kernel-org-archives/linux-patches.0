Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB50E2DF3C9;
	Tue, 17 Jun 2025 15:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174637; cv=none; b=szt27n2aFN4Vu8dpulttLQiz+lHWZSIXivNe+d2nXToNRou4I3nfl2f/kxPwj4i9tvlKmTF8yU1WSngZB0/R6+CfrS5j6bIbDgOCNQKA/VA2Uoj8/UCYwS7psYwWgN8j80MtkVZMzuonq2YRh5P84eMy7v13MqT7YyV2AYq6vbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174637; c=relaxed/simple;
	bh=oRpDrBhBKUw8QYSE5hs3GPQqCe4y9UOprZ/Lo07Oy6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CQXuNTBvseEEbjdAreV1VH1oaDdLMtvaG40FXDnPh2PHnT+1YzpRZiuQv3AXLB1aqQfWVvbx/+KN7G9bUBI2GtCqNMKlodDQTd4t7zQE6PdefyuSEtZ65xxi9x5FVqtCi7BGYu3fzyFImHy1L9kapeP3k9RayPQsRk753gZ4yuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=toi2yLil; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="toi2yLil"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AA45C4CEE3;
	Tue, 17 Jun 2025 15:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174636;
	bh=oRpDrBhBKUw8QYSE5hs3GPQqCe4y9UOprZ/Lo07Oy6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=toi2yLild7M1F1jsg23qd02s1vDq044mzHOSQ94wWeazj31tgvVjXEGUtDDJKI5p9
	 aGMxvzWYkR9dKBV6NRfG1lx1aDcsOy9NkzPCoGG63+nP1mMG2n4CbT842Z0FM1xNnM
	 v5IItbq9oiZ18qdVwB+Cw6k/e+uOwu8wwpgt7h0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yihang Li <liyihang9@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 097/356] scsi: hisi_sas: Call I_T_nexus after soft reset for SATA disk
Date: Tue, 17 Jun 2025 17:23:32 +0200
Message-ID: <20250617152342.130673988@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

From: Yihang Li <liyihang9@huawei.com>

[ Upstream commit e4d953ca557e02edd3aed7390043e1b8ad1c9723 ]

In commit 21c7e972475e ("scsi: hisi_sas: Disable SATA disk phy for severe
I_T nexus reset failure"), if the softreset fails upon certain
conditions, the PHY connected to the disk is disabled directly. Manual
recovery is required, which is inconvenient for users in actual use.

In addition, SATA disks do not support simultaneous connection of multiple
hosts. Therefore, when multiple controllers are connected to a SATA disk
at the same time, the controller which is connected later failed to issue
an ATA softreset to the SATA disk. As a result, the PHY associated with
the disk is disabled and cannot be automatically recovered.

Now that, we will not focus on the execution result of softreset. No
matter whether the execution is successful or not, we will directly carry
out I_T_nexus_reset.

Fixes: 21c7e972475e ("scsi: hisi_sas: Disable SATA disk phy for severe I_T nexus reset failure")
Signed-off-by: Yihang Li <liyihang9@huawei.com>
Link: https://lore.kernel.org/r/20250414080845.1220997-4-liyihang9@huawei.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 29 +++++----------------------
 1 file changed, 5 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 7e64661d215bd..3ad58250bf6b2 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1844,33 +1844,14 @@ static int hisi_sas_I_T_nexus_reset(struct domain_device *device)
 	}
 	hisi_sas_dereg_device(hisi_hba, device);
 
-	rc = hisi_sas_debug_I_T_nexus_reset(device);
-	if (rc == TMF_RESP_FUNC_COMPLETE && dev_is_sata(device)) {
-		struct sas_phy *local_phy;
-
+	if (dev_is_sata(device)) {
 		rc = hisi_sas_softreset_ata_disk(device);
-		switch (rc) {
-		case -ECOMM:
-			rc = -ENODEV;
-			break;
-		case TMF_RESP_FUNC_FAILED:
-		case -EMSGSIZE:
-		case -EIO:
-			local_phy = sas_get_local_phy(device);
-			rc = sas_phy_enable(local_phy, 0);
-			if (!rc) {
-				local_phy->enabled = 0;
-				dev_err(dev, "Disabled local phy of ATA disk %016llx due to softreset fail (%d)\n",
-					SAS_ADDR(device->sas_addr), rc);
-				rc = -ENODEV;
-			}
-			sas_put_local_phy(local_phy);
-			break;
-		default:
-			break;
-		}
+		if (rc == TMF_RESP_FUNC_FAILED)
+			dev_err(dev, "ata disk %016llx reset (%d)\n",
+				SAS_ADDR(device->sas_addr), rc);
 	}
 
+	rc = hisi_sas_debug_I_T_nexus_reset(device);
 	if ((rc == TMF_RESP_FUNC_COMPLETE) || (rc == -ENODEV))
 		hisi_sas_release_task(hisi_hba, device);
 
-- 
2.39.5



