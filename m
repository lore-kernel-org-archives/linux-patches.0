Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 264B3D512
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:50:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F8F6C433EF;
	Mon, 12 Jun 2023 10:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686567048;
	bh=O0NTmoZlatiOQUnIUnwwXiKjSNvgqAmwntSqfmf7JPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UWBx6CkU0otKxeN3Q4CEwMQeiND3++xtixaB6vsaebn7o1+mVRpmO8E08LPb6qqvH
	 V333E4m/MJVlmiPPf6ZFcqyjobGfg3qkF0p27uMoxKDcbUgbbuo4IaMJT4I03L9SAn
	 ZG1wCIi92qJSiOGTdr3toqyuGBXcYoO1nVYwcggs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 130/160] ASoC: amd: ps: fix for acp_lock access in pdm driver
Date: Mon, 12 Jun 2023 12:27:42 +0200
Message-ID: <20230612101721.014708802@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101715.129581706@linuxfoundation.org>
References: <20230612101715.129581706@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

[ Upstream commit b6b5c6426efe27cbd954409a50604d99c79bd42b ]

Sending the mutex address(acp_lock) as platform
data during ACP PDM platform driver register sequence,
its creating copy of the platform data.
Referencing this platform data in ACP PDM driver results
incorrect reference to the common lock usage.

Instead of directly passing the lock address as platform
data, retrieve it from parent driver data structure
and use the same lock reference in ACP PDM driver.

Fixes: 45aa83cb9388 ("ASoC: amd: ps: use acp_lock to protect common registers in pdm driver")

Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://lore.kernel.org/r/20230525113000.1290758-1-Vijendar.Mukunda@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/ps/pci-ps.c     |  3 +--
 sound/soc/amd/ps/ps-pdm-dma.c | 10 +++++-----
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/sound/soc/amd/ps/pci-ps.c b/sound/soc/amd/ps/pci-ps.c
index afddb9a77ba49..b1337b96ea8d6 100644
--- a/sound/soc/amd/ps/pci-ps.c
+++ b/sound/soc/amd/ps/pci-ps.c
@@ -211,8 +211,7 @@ static int create_acp63_platform_devs(struct pci_dev *pci, struct acp63_dev_data
 	case ACP63_PDM_DEV_MASK:
 		adata->pdm_dev_index  = 0;
 		acp63_fill_platform_dev_info(&pdevinfo[0], parent, NULL, "acp_ps_pdm_dma",
-					     0, adata->res, 1, &adata->acp_lock,
-					     sizeof(adata->acp_lock));
+					     0, adata->res, 1, NULL, 0);
 		acp63_fill_platform_dev_info(&pdevinfo[1], parent, NULL, "dmic-codec",
 					     0, NULL, 0, NULL, 0);
 		acp63_fill_platform_dev_info(&pdevinfo[2], parent, NULL, "acp_ps_mach",
diff --git a/sound/soc/amd/ps/ps-pdm-dma.c b/sound/soc/amd/ps/ps-pdm-dma.c
index 454dab062e4f5..527594aa9c113 100644
--- a/sound/soc/amd/ps/ps-pdm-dma.c
+++ b/sound/soc/amd/ps/ps-pdm-dma.c
@@ -361,12 +361,12 @@ static int acp63_pdm_audio_probe(struct platform_device *pdev)
 {
 	struct resource *res;
 	struct pdm_dev_data *adata;
+	struct acp63_dev_data *acp_data;
+	struct device *parent;
 	int status;
 
-	if (!pdev->dev.platform_data) {
-		dev_err(&pdev->dev, "platform_data not retrieved\n");
-		return -ENODEV;
-	}
+	parent = pdev->dev.parent;
+	acp_data = dev_get_drvdata(parent);
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
 		dev_err(&pdev->dev, "IORESOURCE_MEM FAILED\n");
@@ -382,7 +382,7 @@ static int acp63_pdm_audio_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	adata->capture_stream = NULL;
-	adata->acp_lock = pdev->dev.platform_data;
+	adata->acp_lock = &acp_data->acp_lock;
 	dev_set_drvdata(&pdev->dev, adata);
 	status = devm_snd_soc_register_component(&pdev->dev,
 						 &acp63_pdm_component,
-- 
2.39.2



