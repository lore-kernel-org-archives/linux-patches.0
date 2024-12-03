Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8FF1DE8A5;
	Tue,  3 Dec 2024 15:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241254; cv=none; b=QNF708bbent1barv7zPRH93O+6mynnj1/gkrJ3S4a/S6P7xba448zy1qvRRLYQctCBrFAAthtpetZLenprNafHKceD9/dEs1KU4LZQU39qrDBbP41LN1eWakAq+MV1q8/QsFfBlGFn5fFoQkBEFMuL/GZjQvuj3kL62Te3ocJ/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241254; c=relaxed/simple;
	bh=sCgKF1giCkT8Yb5426MscmAxUmpNRHyl3yihG80FvfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yt3U8yoLAIo5wWCtDIKogPAGjLlr1+wfjEFsKVunE80sP85DhahPqmY2eqM8NGhtdZn3x/8qdjQToSYja/z0AaYvA1kBpgwemnlhfLfoCdeR6humPZJgaTxosyxSQQDT9Xxa57VhnK9J2Nt2Qxt8hF85r2U8x7uzCpUXyrI9ibs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bO8yIaHA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bO8yIaHA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A165AC4CECF;
	Tue,  3 Dec 2024 15:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241254;
	bh=sCgKF1giCkT8Yb5426MscmAxUmpNRHyl3yihG80FvfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bO8yIaHADxR+SWs69JLFtycu00ku+5W/GzFMqK4nrrIt3T2b/PB8kZ8CHDNLC4WOa
	 GV82oxqVIh4MfKb72Ci6OYCYGnYvtsGWGccJjyaQo3uubpcrRvpcug0Fc/TuM9iWy1
	 CAxH8XM45LSrKiBJ+8HKuBISdm4RUZp9R1CKPs2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yihang Li <liyihang9@huawei.com>,
	Xiang Chen <chenxiang66@hisilicon.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 368/826] scsi: hisi_sas: Enable all PHYs that are not disabled by user during controller reset
Date: Tue,  3 Dec 2024 15:41:35 +0100
Message-ID: <20241203144758.119326525@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yihang Li <liyihang9@huawei.com>

[ Upstream commit 08a07dc71d7fc6f58c35c4fc0bcede2811c5aa4c ]

For the controller reset operation(such as FLR or clear nexus ha in SCSI
EH), we will disable all PHYs and then enable PHY based on the
hisi_hba->phy_state obtained in hisi_sas_controller_reset_prepare(). If
the device is removed before controller reset or the PHY is not attached
to any device in directly attached scenario, the corresponding bit of
phy_state is not set. After controller reset done, the PHY is disabled.
The device cannot be identified even if user reconnect the disk.

Therefore, for PHYs that are not disabled by user, hisi_sas_phy_enable()
needs to be executed even if the corresponding bit of phy_state is not
set.

Fixes: 89954f024c3a ("scsi: hisi_sas: Ensure all enabled PHYs up during controller reset")
Signed-off-by: Yihang Li <liyihang9@huawei.com>
Link: https://lore.kernel.org/r/20241008021822.2617339-5-liyihang9@huawei.com
Reviewed-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 6219807ce3b9e..ffd15fa4f9e59 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1545,10 +1545,16 @@ void hisi_sas_controller_reset_done(struct hisi_hba *hisi_hba)
 	/* Init and wait for PHYs to come up and all libsas event finished. */
 	for (phy_no = 0; phy_no < hisi_hba->n_phy; phy_no++) {
 		struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
+		struct asd_sas_phy *sas_phy = &phy->sas_phy;
 
-		if (!(hisi_hba->phy_state & BIT(phy_no)))
+		if (!sas_phy->phy->enabled)
 			continue;
 
+		if (!(hisi_hba->phy_state & BIT(phy_no))) {
+			hisi_sas_phy_enable(hisi_hba, phy_no, 1);
+			continue;
+		}
+
 		async_schedule_domain(hisi_sas_async_init_wait_phyup,
 				      phy, &async);
 	}
-- 
2.43.0



