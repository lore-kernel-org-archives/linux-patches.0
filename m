Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C68A2F2341;
	Tue, 17 Jun 2025 15:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175533; cv=none; b=gRN71HxbFdnbvcldmDUfMQ54iygzal9rIjs9oeT+QDszCprqsmSO7S75bgojWAdsqIxr6Vf72BrNJfwrKOFaNz6SnaHWlAFXMCZ0E9hPZuTUsOiSR++t9FqB7zK+8CUp+1CCLQCCwqPcZ9AovPuHAb3NBr3Lggq+aYhxpFgylZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175533; c=relaxed/simple;
	bh=p+6YxpTf4zhQmU4Yr0UhCp5kpH42R/KPXfUnNzfdKpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YfOJsBOueakMLSH4IR697iQ8jVbs/8jljlwXtCuOkfDB3C4JMUSOpYVEP/d/XDase+VBy8QOiA7un7q9d0F1vWbMPAmyszMVeiTGcAzZbtcKLjAa2mpkxwfTBJfgaWBvCCjDjRxMG/EIqr1DnhOOFVLcFnNOIy6ZNu6oMyGouq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M3kV91wu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M3kV91wu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F9B2C4CEE7;
	Tue, 17 Jun 2025 15:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175533;
	bh=p+6YxpTf4zhQmU4Yr0UhCp5kpH42R/KPXfUnNzfdKpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M3kV91wufinLgnwBp5x50uJAXJJpDYLkILylL5kUzWEvocfCkdKxY/XU1WN8ReI42
	 KI7poAY17uziacecg4aMMmNhL1aosVPgFuGYCUO4PvnXkbsOYvfgEETsPAIjlodWcO
	 oi3WPO3JpfMxDdLGgJESFJ35OmRJGzXMto9KThBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yihang Li <liyihang9@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 135/512] scsi: hisi_sas: Call I_T_nexus after soft reset for SATA disk
Date: Tue, 17 Jun 2025 17:21:41 +0200
Message-ID: <20250617152425.068413830@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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
index e98e6b2b9f570..d9500b7306905 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1850,33 +1850,14 @@ static int hisi_sas_I_T_nexus_reset(struct domain_device *device)
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



