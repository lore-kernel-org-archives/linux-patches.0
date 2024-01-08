Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1CD6D6DC;
	Mon,  8 Jan 2024 15:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yj9bKvtj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEDD0C433CA;
	Mon,  8 Jan 2024 15:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726860;
	bh=35tXPO8nrEixk3mtVFC89UFfdtxMbCboYFcx9J4A+Hc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yj9bKvtjBZO6G/9Y66a+VqU/ug9wY73JRxWH81nt6J883V7dDpx8oxEtEy2yW01Y6
	 ZgDnzmNQ87Pit77yM+HJx0iXM5HgD/wZ5QepnYHpXaaCxo24IiOhS1vIHSwu9BYFyW
	 nDtOpuBC0tmX6haLdgUP9xUPHcz+VTgMhNG/MH3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 102/124] dmaengine: fsl-edma: fix wrong pointer check in fsl_edma3_attach_pd()
Date: Mon,  8 Jan 2024 16:08:48 +0100
Message-ID: <20240108150607.653150050@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit bffa7218dcddb80e7f18dfa545dd4b359b11dd93 ]

device_link_add() returns NULL pointer not PTR_ERR() when it fails,
so replace the IS_ERR() check with NULL pointer check.

Fixes: 72f5801a4e2b ("dmaengine: fsl-edma: integrate v3 support")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20231129090000.841440-1-yangyingliang@huaweicloud.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/fsl-edma-main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/fsl-edma-main.c b/drivers/dma/fsl-edma-main.c
index db6cd8431f30a..00cb70aca34a3 100644
--- a/drivers/dma/fsl-edma-main.c
+++ b/drivers/dma/fsl-edma-main.c
@@ -400,9 +400,8 @@ static int fsl_edma3_attach_pd(struct platform_device *pdev, struct fsl_edma_eng
 		link = device_link_add(dev, pd_chan, DL_FLAG_STATELESS |
 					     DL_FLAG_PM_RUNTIME |
 					     DL_FLAG_RPM_ACTIVE);
-		if (IS_ERR(link)) {
-			dev_err(dev, "Failed to add device_link to %d: %ld\n", i,
-				PTR_ERR(link));
+		if (!link) {
+			dev_err(dev, "Failed to add device_link to %d\n", i);
 			return -EINVAL;
 		}
 
-- 
2.43.0



