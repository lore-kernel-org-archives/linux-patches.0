Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64137257C
	for <patches@lists.linux.dev>; Thu, 23 Feb 2023 13:08:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF668C4339B;
	Thu, 23 Feb 2023 13:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677157722;
	bh=+W1Ge8Ze4YYE7880ic/HREieSuP7YSkUNuVa0TfZL1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cvL4cW0M3KbUy+8UZLJdz7/0+Et1MAizzOAx/nUHHc7dVlhugQTIuu7JEJu4e1JSU
	 SCFi8/chnHus0rwfuGlcABYBNloK3d1ZuZnItlCVCapTbohzMvexw9hTZEWsgjWOhK
	 L3wH9eZQlHwg1iaQk1NJOnuidDLLFYMyIZ+GWJm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Zhan <zhanjie9@hisilicon.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 14/46] scsi: hisi_sas: Fix SATA devices missing issue during I_T nexus reset
Date: Thu, 23 Feb 2023 14:06:21 +0100
Message-Id: <20230223130432.208456010@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130431.553657459@linuxfoundation.org>
References: <20230223130431.553657459@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jie Zhan <zhanjie9@hisilicon.com>

[ Upstream commit 3c2673a09cf1181318c07b7dbc1bc532ba3d33e3 ]

SATA devices on an expander may be removed and not be found again when I_T
nexus reset and revalidation are processed simultaneously.

The issue comes from:

 - Revalidation can remove SATA devices in link reset, e.g. in
   hisi_sas_clear_nexus_ha().

 - However, hisi_sas_debug_I_T_nexus_reset() polls the state of a SATA
   device on an expander after sending link_reset, where it calls:
    hisi_sas_debug_I_T_nexus_reset
     sas_ata_wait_after_reset
      ata_wait_after_reset
       ata_wait_ready
        smp_ata_check_ready
         sas_ex_phy_discover
          sas_ex_phy_discover_helper
           sas_set_ex_phy

   The ex_phy's change count is updated in sas_set_ex_phy(), so SATA
   devices after a link reset may not be found later through revalidation.

A similar issue was reported in:
commit 0f3fce5cc77e ("[SCSI] libsas: fix ata_eh clobbering ex_phys via
smp_ata_check_ready")
commit 87c8331fcf72 ("[SCSI] libsas: prevent domain rediscovery competing
with ata error handling").

To address this issue, in hisi_sas_debug_I_T_nexus_reset(), we now call
smp_ata_check_ready_type() that only polls the device type while not
updating the ex_phy's data of libsas.

Fixes: 71453bd9d1bf ("scsi: hisi_sas: Use sas_ata_wait_after_reset() in IT nexus reset")
Signed-off-by: Jie Zhan <zhanjie9@hisilicon.com>
Link: https://lore.kernel.org/r/20221118083714.4034612-5-zhanjie9@hisilicon.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 02fa3c00dcccf..a8142e2b96435 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1708,13 +1708,15 @@ static int hisi_sas_debug_I_T_nexus_reset(struct domain_device *device)
 		return rc;
 	}
 
+	/* Remote phy */
 	if (rc)
 		return rc;
 
-	/* Remote phy */
 	if (dev_is_sata(device)) {
-		rc = sas_ata_wait_after_reset(device,
-					HISI_SAS_WAIT_PHYUP_TIMEOUT);
+		struct ata_link *link = &device->sata_dev.ap->link;
+
+		rc = ata_wait_after_reset(link, HISI_SAS_WAIT_PHYUP_TIMEOUT,
+					  smp_ata_check_ready_type);
 	} else {
 		msleep(2000);
 	}
-- 
2.39.0



