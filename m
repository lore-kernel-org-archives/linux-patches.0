Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 240A113475E;
	Tue, 23 Jan 2024 00:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969333; cv=none; b=gy2R49h3vgL5vMXxSgtqHF1i/2Jo0TogwzIOLAsDYvD4Mc758grifApH9WUMrTWVeB5zVfzbk3de9o6D1vS8mwU1GrgX6Il0p8yuktVqOrWtmRBtkfgCWOt/Jow2zyNTUO11lfUOaG7fRHwep5Ku1j4mO4dR6s08l3jIcP0csME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969333; c=relaxed/simple;
	bh=PxPPxopy+AFdCTehzY9wXbgutfX9H4QBfWHgY7izvWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CMeLNUrnGVwUH0SJNX03bD55voGpz0+0TzUdvEx4vz+XjACFNx8pus34VXGz24sXRNbP433dcWklnewVpgvDGkHycSqnRARuwtCpqCuxDj8Oo6r0TolVvGkmUi+28E8gcIGFLEI3hNChbaEPV0lmBTwHJJFGAHYmHnZdwI9DyEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yXEHGOh8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yXEHGOh8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84C1BC433F1;
	Tue, 23 Jan 2024 00:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969333;
	bh=PxPPxopy+AFdCTehzY9wXbgutfX9H4QBfWHgY7izvWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yXEHGOh84QBg+OWwhgSsQUCVO7oSNIPb901raa8tQ5qygoCERl78Q0n33LoDpDsF6
	 s7l+YDgU7sc4BB+uvISvh3CVjUi4AGEIwvPVrT+EuZ5M++++QOpZnjLp9BpPMZsO5R
	 wX1rALMMfdU8xbsBLeW7sqJY/yUcWAZqAzBN5MYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yihang Li <liyihang9@huawei.com>,
	Xiang Chen <chenxiang66@hisilicon.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 177/641] scsi: hisi_sas: Replace with standard error code return value
Date: Mon, 22 Jan 2024 15:51:21 -0800
Message-ID: <20240122235823.538474851@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yihang Li <liyihang9@huawei.com>

[ Upstream commit d34ee535705eb43885bc0f561c63046f697355ad ]

In function hisi_sas_controller_prereset(), -ENOSYS (Function not
implemented) should be returned if the driver does not support .soft_reset.
Returns -EPERM (Operation not permitted) if HISI_SAS_RESETTING_BIT is
already be set.

In function _suspend_v3_hw(), returns -EPERM (Operation not permitted) if
HISI_SAS_RESETTING_BIT is already be set.

Fixes: 4522204ab218 ("scsi: hisi_sas: tidy host controller reset function a bit")
Signed-off-by: Yihang Li <liyihang9@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Link: https://lore.kernel.org/r/1702525516-51258-3-git-send-email-chenxiang66@hisilicon.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 4 ++--
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index d50058b41409..16017064e96a 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1565,12 +1565,12 @@ EXPORT_SYMBOL_GPL(hisi_sas_controller_reset_done);
 static int hisi_sas_controller_prereset(struct hisi_hba *hisi_hba)
 {
 	if (!hisi_hba->hw->soft_reset)
-		return -1;
+		return -ENOENT;
 
 	down(&hisi_hba->sem);
 	if (test_and_set_bit(HISI_SAS_RESETTING_BIT, &hisi_hba->flags)) {
 		up(&hisi_hba->sem);
-		return -1;
+		return -EPERM;
 	}
 
 	if (hisi_sas_debugfs_enable && hisi_hba->debugfs_itct[0].itct)
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index d8437a98037b..b8ee374fe6ca 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -5018,7 +5018,7 @@ static int _suspend_v3_hw(struct device *device)
 	}
 
 	if (test_and_set_bit(HISI_SAS_RESETTING_BIT, &hisi_hba->flags))
-		return -1;
+		return -EPERM;
 
 	dev_warn(dev, "entering suspend state\n");
 
-- 
2.43.0



