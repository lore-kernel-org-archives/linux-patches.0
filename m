Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC13B2F2346;
	Tue, 17 Jun 2025 16:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176350; cv=none; b=arrNmZMcESkyjScSi9kNx6Vi+OYJCKYHBaFT7DlMIak4isQ/Q0PjBWhz3JUKxKw4X0EUn/elwiI7omzvgmfnbGON/e7SlxpReSkgmKHGuIrzEA4QkGD+AbrtUbEmUajzYcq7RXMXH87iUbXiDmlzrRgjNU62d5SpN7FzWJrzQuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176350; c=relaxed/simple;
	bh=mCoBrb/T9jtGCKBEeguUmse4J+/yam4yuvbVh0X76uU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RrH00aLvPNYP8B+LMW00cfDr2CcypAM07RENGdRsw2+31VSB2w8JyfPhr6LzhgaDnaqs+BuRVItcVi/TjrtcPd90P9piTCWSb/lH6HbOBq9urNJe4qmB/Vfv68Y0MQKZLEaDYVwPuZ24y4x+FWiuGPpd83WxqMRIZm35WFliM8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Y8i2GxG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Y8i2GxG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA56C4CEE3;
	Tue, 17 Jun 2025 16:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176350;
	bh=mCoBrb/T9jtGCKBEeguUmse4J+/yam4yuvbVh0X76uU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Y8i2GxGtiQP3uFbTtQ2FlR8bbc/w3d+ahefYhfMFbor0MIH2CjBqUADwEC34Zsh/
	 cP79CkT9LMc4ZS4FUC8ylvP+raQpEq8FlU+NoqZAYOxrJFYGNGOv39/76HU3MyPzPi
	 HUqhFIwUsQPz4Sl5uvXINAEJEsPWy0J/LUKMBj1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nitin Rawat <quic_nitirawa@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 269/356] scsi: ufs: qcom: Prevent calling phy_exit() before phy_init()
Date: Tue, 17 Jun 2025 17:26:24 +0200
Message-ID: <20250617152349.031709777@linuxfoundation.org>
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

From: Nitin Rawat <quic_nitirawa@quicinc.com>

[ Upstream commit 7831003165d37ecb7b33843fcee05cada0359a82 ]

Prevent calling phy_exit() before phy_init() to avoid abnormal power
count and the following warning during boot up.

[5.146763] phy phy-1d80000.phy.0: phy_power_on was called before phy_init

Fixes: 7bac65687510 ("scsi: ufs: qcom: Power off the PHY if it was already powered on in ufs_qcom_power_up_sequence()")
Signed-off-by: Nitin Rawat <quic_nitirawa@quicinc.com>
Link: https://lore.kernel.org/r/20250526153821.7918-2-quic_nitirawa@quicinc.com
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/ufs-qcom.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index c6417ef074a47..c94824c999ccd 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -453,10 +453,9 @@ static int ufs_qcom_power_up_sequence(struct ufs_hba *hba)
 		dev_warn(hba->dev, "%s: host reset returned %d\n",
 				  __func__, ret);
 
-	if (phy->power_count) {
+	if (phy->power_count)
 		phy_power_off(phy);
-		phy_exit(phy);
-	}
+
 
 	/* phy initialization - calibrate the phy */
 	ret = phy_init(phy);
-- 
2.39.5



