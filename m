Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98DDF3BBE1;
	Mon, 15 Apr 2024 14:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713192053; cv=none; b=se/EO4Zj8nBdCT3FntZhvlQ9Oy/iYdfNMJS3npLddk2NXjVAM235Awi5tg/dzNDNJCgeHi9fGMD/wXGlT0FdWfc778FXFsllnP4ZWVUl/eohVSGTAkBrgFURInrpANZu/XIewJ2vV8duJwrH/6QQXzXlG9Ho5BuSo/ZoYmYoDjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713192053; c=relaxed/simple;
	bh=wCRCMwRUSC4Fw91ywbooTmiXIL2cmn2xyCltNsDGbAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hPGBU16BuMHeHO4OSl+jmuAF2k0hSo16ZYOgkNv7ic1/2S7kx2rLJVCkGG7/mO7eRNLR019h2XjDTDiAfuhKLjlzQUhoib2nYvO79o9+DVK0++durYplV/wl1xR8aGYwTceCYVjB7gh1mHIQ6HYSEz1tpiSJlkwOq2bKheDrz+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PN40ykR9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PN40ykR9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4287C2BD11;
	Mon, 15 Apr 2024 14:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713192053;
	bh=wCRCMwRUSC4Fw91ywbooTmiXIL2cmn2xyCltNsDGbAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PN40ykR9JAL0eHFY0miZuij7OdZpfzoMO9whJynIWX6Mrjw73vIKZR7xIWDSE7YXk
	 LHqV+OTGA+pgirAL5iXQ1LP8s31nE+BkImT0dkBUzQ1JQfMCPP4vER/m7RHvMyL2U2
	 njNg9MJgIU1nvY1xa6yCOtqhfNGDIfoYSHpFN2eU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	xiabing <xiabing12@h-partners.com>,
	Yihang Li <liyihang9@huawei.com>,
	Xiang Chen <chenxiang66@hisilicon.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 12/69] scsi: hisi_sas: Modify the deadline for ata_wait_after_reset()
Date: Mon, 15 Apr 2024 16:20:43 +0200
Message-ID: <20240415141946.541277375@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141946.165870434@linuxfoundation.org>
References: <20240415141946.165870434@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang Chen <chenxiang66@hisilicon.com>

[ Upstream commit 0098c55e0881f0b32591f2110410d5c8b7f9bd5a ]

We found that the second parameter of function ata_wait_after_reset() is
incorrectly used. We call smp_ata_check_ready_type() to poll the device
type until the 30s timeout, so the correct deadline should be (jiffies +
30000).

Fixes: 3c2673a09cf1 ("scsi: hisi_sas: Fix SATA devices missing issue during I_T nexus reset")
Co-developed-by: xiabing <xiabing12@h-partners.com>
Signed-off-by: xiabing <xiabing12@h-partners.com>
Co-developed-by: Yihang Li <liyihang9@huawei.com>
Signed-off-by: Yihang Li <liyihang9@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Link: https://lore.kernel.org/r/20240402035513.2024241-3-chenxiang66@hisilicon.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 450a8578157cb..2116f5ee36e20 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1715,7 +1715,7 @@ static int hisi_sas_debug_I_T_nexus_reset(struct domain_device *device)
 	if (dev_is_sata(device)) {
 		struct ata_link *link = &device->sata_dev.ap->link;
 
-		rc = ata_wait_after_reset(link, HISI_SAS_WAIT_PHYUP_TIMEOUT,
+		rc = ata_wait_after_reset(link, jiffies + HISI_SAS_WAIT_PHYUP_TIMEOUT,
 					  smp_ata_check_ready_type);
 	} else {
 		msleep(2000);
-- 
2.43.0



