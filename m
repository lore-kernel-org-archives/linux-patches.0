Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4457DFC11;
	Sat,  3 Feb 2024 04:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933373; cv=none; b=NkbygWsQZJq0aEEfSn3sVr1RGa0z4DeznS3ze3D5twIpMB6fYJx/Xz+1qFKdtpdobQRZwr8rWlFZTogJOM+ZjZ/WBC2E+i523eAvxSW9wBywMY6HY6n8EEADzSV6nMkou/taHr0QjZDVXRdAu2vYQ7z47iyyclo2B5IjPU48Z+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933373; c=relaxed/simple;
	bh=wboH2sXpbOnCauBy53/UB2S5C5QZUhAk+b/IxIg9Y98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JC8QRIymWxNhEIbQygwYXT7U95qRA4uoLuAROufZX+tzO2y1wz/4DPAffTrohSYgHPeM1KMGD98PxPNL/USB3o5mqhNVhBa1G+7kEgMdlOL6YN8344Os8rAXZVZ3iaSbT30UDvNQnuE4GdWHhDc73oDoUHPJCxlGDbY23eMLbTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dCfpSkW/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dCfpSkW/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BBEDC433F1;
	Sat,  3 Feb 2024 04:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933373;
	bh=wboH2sXpbOnCauBy53/UB2S5C5QZUhAk+b/IxIg9Y98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dCfpSkW/rzjMxO7tIsIiuvgSRbVAC4P8ABVNmM4elXEa3Rn78ToiCtAIxuOFW8Nuf
	 F0vAMqNtAFVc01o3TRxGAJzAgGpU0AS3emNL5gKBYqvSdh1ulu9dQnpeQOkMiePqIN
	 uVd/XCjRBXx53CcBnKJOWxwSKCwX5gjnj7/hLhC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yihang Li <liyihang9@huawei.com>,
	Xiang Chen <chenxiang66@hisilicon.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 082/219] scsi: hisi_sas: Set .phy_attached before notifing phyup event HISI_PHYE_PHY_UP_PM
Date: Fri,  2 Feb 2024 20:04:15 -0800
Message-ID: <20240203035328.720067811@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

From: Yihang Li <liyihang9@huawei.com>

[ Upstream commit ce26497c745d0541aec930d5211b431a1c26af97 ]

Currently in directly attached scenario, the phyup event
HISI_PHYE_PHY_UP_PM is notified before .phy_attached is set - this may
cause the phyup work hisi_sas_bytes_dmaed() execution failed and the
attached device will not be found.

To fix it, set .phy_attached before notifing phyup event.

Signed-off-by: Yihang Li <liyihang9@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Link: https://lore.kernel.org/r/1702525516-51258-2-git-send-email-chenxiang66@hisilicon.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 0c80ff9affa3..7ae56a2fe232 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -1565,6 +1565,11 @@ static irqreturn_t phy_up_v3_hw(int phy_no, struct hisi_hba *hisi_hba)
 	}
 
 	phy->port_id = port_id;
+	spin_lock(&phy->lock);
+	/* Delete timer and set phy_attached atomically */
+	del_timer(&phy->timer);
+	phy->phy_attached = 1;
+	spin_unlock(&phy->lock);
 
 	/*
 	 * Call pm_runtime_get_noresume() which pairs with
@@ -1578,11 +1583,6 @@ static irqreturn_t phy_up_v3_hw(int phy_no, struct hisi_hba *hisi_hba)
 
 	res = IRQ_HANDLED;
 
-	spin_lock(&phy->lock);
-	/* Delete timer and set phy_attached atomically */
-	del_timer(&phy->timer);
-	phy->phy_attached = 1;
-	spin_unlock(&phy->lock);
 end:
 	if (phy->reset_completion)
 		complete(phy->reset_completion);
-- 
2.43.0



