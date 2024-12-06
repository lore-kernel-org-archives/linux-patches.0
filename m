Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D0453A7;
	Fri,  6 Dec 2024 15:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497335; cv=none; b=tgZQoQcHij4JIpgQYC3ilrCH8GWyrx6APh5oraaUO/SicEGgGQQhJ+lrye6ciTWJ89WNJChWEEYxUiSFlhlf763r80tsyrtqYRnVPs7kc+2sSIbMULYSxXet5rJrfT6wahFHoWU59h2w/cYicPoY3zseih74qiGwemYkxPLdbvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497335; c=relaxed/simple;
	bh=1UusoUtOAacGvAQ9QlZHQivJUr6tsVGxmBabOwYTJCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E4uDE7cENzSW4VIZd+3JUEsbF0BauqIl0oAD4LNpWQ7Bzka8Jt2YX9JZhfwEzcQVm2eY8tdWYUpcFceLJPk4tne7tTwOn5dF72vivpnTc/X3DA2AWoaM5yTTuY9ZgZa6/qMzvgltl5FiKf0ioMDQfB3tsfYMVL11QcaAsOzTvEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OGx8INqZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OGx8INqZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85E44C4CED1;
	Fri,  6 Dec 2024 15:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497335;
	bh=1UusoUtOAacGvAQ9QlZHQivJUr6tsVGxmBabOwYTJCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OGx8INqZIEcuTHVrJJtjgoClvaDFmWMqylwEkr5WJd54CV2glZiLepLzv3TZAGfQB
	 GQojToWifFodZ7iHh8/eOg/Ryz7juru7CAO3Z4oVRh7pAxbh5EdaxeppX1hQe8R7Ji
	 t9ZgqTNMHg0CxWMCvstCqyIKEuU5i0lHrkXu1MCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yihang Li <liyihang9@huawei.com>,
	Xiang Chen <chenxiang66@hisilicon.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 263/676] scsi: hisi_sas: Enable all PHYs that are not disabled by user during controller reset
Date: Fri,  6 Dec 2024 15:31:22 +0100
Message-ID: <20241206143703.605535893@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e4363b8c6ad26..db9ae206974c2 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1539,10 +1539,16 @@ void hisi_sas_controller_reset_done(struct hisi_hba *hisi_hba)
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



