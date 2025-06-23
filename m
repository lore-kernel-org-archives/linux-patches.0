Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 670752153C1;
	Mon, 23 Jun 2025 21:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750712844; cv=none; b=VmvulArbOeZKfcwg4vdSQqTovOQxqeV25fR01gx94pNc/676M7/ly9s4M7H0V2vsQ9AZO6yEJOXFrpR2USF268IXfonpMC7IaU/lnVUlr2uQ3BERdHnZcKfsrWI13cAHuxF1lmnUPQBP2rzflqmXpnMHibMb/JoHlBChQAbR500=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750712844; c=relaxed/simple;
	bh=SuJ87xGSGAEPCoPesJ3rMMZm7KvxGH9laeOtKW5lF1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EoDTVbtLpQsN0C8ZxsfCJrsEIjjtczaE/LiTtBjcpm7fBLjL0yX1wT8NNDAK/II4Vik5OwKS7YX7T0Jh2L+HI/ALa96dAGcW3zyM1S+Lo9z8JXloz45qEWxqK3Brk2WL/mvB7A/Sw96kZfEgGVCE4KkYoHJWcm/hOMYRnM8wxlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iQYMukpk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iQYMukpk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 006A2C4CEEA;
	Mon, 23 Jun 2025 21:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750712844;
	bh=SuJ87xGSGAEPCoPesJ3rMMZm7KvxGH9laeOtKW5lF1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iQYMukpkyombOAbvRqGwgeNFQw2Bpd9wPdZd2TkLFflFYlRWGdLsDo6+qliT5O9+7
	 ArdpNwMu5aN9eSDFBbqhtFedlWgL94+09PWcA2OoF25RokSg7A47STzspF2o05NADZ
	 FbJW4kUp05Pvy8WUwAFvjGh+trsGokl2ofKNdf8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yihang Li <liyihang9@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 063/508] scsi: hisi_sas: Call I_T_nexus after soft reset for SATA disk
Date: Mon, 23 Jun 2025 15:01:48 +0200
Message-ID: <20250623130646.794152392@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 02855164bf28d..360f2799f2a13 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1758,33 +1758,14 @@ static int hisi_sas_I_T_nexus_reset(struct domain_device *device)
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



