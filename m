Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3AB1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:06:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31996C433EF;
	Wed, 28 Dec 2022 15:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239978;
	bh=9AtMiHKpoUlY9QO0Us6J1m6vzVBDH68xDzgmgBMi2Qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d2W8zCHpxyB/vIMSXgnXNOz73TcB9WD/McXfQ1GLP4yaAKGTA8npenBhQmJTuTDET
	 ODxyPvJZdH4pfs3mFkwTdz88XObHsUHZcwdOCaRIDixYUIPzzEgpEXP+VBVufkeH82
	 vAj34G9ohA5hiGcZFK3py1VoumLMSjEqZSChte40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 295/731] mmc: rtsx_pci: fix return value check of mmc_add_host()
Date: Wed, 28 Dec 2022 15:36:42 +0100
Message-Id: <20221228144305.124742500@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 0c87db77423a282b3b38b8a6daf057b822680516 ]

mmc_add_host() may return error, if we ignore its return value, the memory
that allocated in mmc_alloc_host() will be leaked and it will lead a kernel
crash because of deleting not added device in the remove path.

So fix this by checking the return value and calling mmc_free_host() in the
error path, beside, runtime PM also needs be disabled.

Fixes: ff984e57d36e ("mmc: Add realtek pcie sdmmc host driver")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221101063023.1664968-6-yangyingliang@huawei.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/rtsx_pci_sdmmc.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c b/drivers/mmc/host/rtsx_pci_sdmmc.c
index e1580f78c6b2..8098726dcc0b 100644
--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -1474,6 +1474,7 @@ static int rtsx_pci_sdmmc_drv_probe(struct platform_device *pdev)
 	struct realtek_pci_sdmmc *host;
 	struct rtsx_pcr *pcr;
 	struct pcr_handle *handle = pdev->dev.platform_data;
+	int ret;
 
 	if (!handle)
 		return -ENXIO;
@@ -1511,7 +1512,13 @@ static int rtsx_pci_sdmmc_drv_probe(struct platform_device *pdev)
 	pm_runtime_mark_last_busy(&pdev->dev);
 	pm_runtime_use_autosuspend(&pdev->dev);
 
-	mmc_add_host(mmc);
+	ret = mmc_add_host(mmc);
+	if (ret) {
+		pm_runtime_dont_use_autosuspend(&pdev->dev);
+		pm_runtime_disable(&pdev->dev);
+		mmc_free_host(mmc);
+		return ret;
+	}
 
 	return 0;
 }
-- 
2.35.1



