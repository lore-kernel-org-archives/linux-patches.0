Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB60E1170E
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 19:51:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1C11C433C8;
	Mon, 21 Aug 2023 19:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692647460;
	bh=MKqgisjxGHNLTOWD5WRTTpyoXsI2cg8WwtGfsQvazVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=enPdRYBypGhFgw22t0AAZDa92cmGkZNUICu8qPjiO/Z57GhUScI389C0Ftpwn/QpF
	 GKpijaEd7PlceI41V3icM66w4/zDMvDjZctMwkZxvEhJop7L2esAD7oIwyFQEXD3Ug
	 O+EsSLKl2IdUK8tPUt5XByEqS3H/6A1ylVebfs6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venkata Prasad Potturu <venkataprasad.potturu@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 021/194] ASoC: amd: vangogh: Add check for acp config flags in vangogh platform
Date: Mon, 21 Aug 2023 21:40:00 +0200
Message-ID: <20230821194123.712203964@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194122.695845670@linuxfoundation.org>
References: <20230821194122.695845670@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Venkata Prasad Potturu <venkataprasad.potturu@amd.com>

[ Upstream commit e89f45edb747ed88e97a5771dd6d3dd1eb517873 ]

We have SOF and generic ACP support enabled for Vangogh platform
on some machines. Since we have same PCI id used for probing,
add check for machine configuration flag to avoid conflict with
newer pci drivers. Such machine flag has been initialized via
dmi match on few Vangogh based machines. If no flag is
specified probe and register older platform device.

Signed-off-by: Venkata Prasad Potturu <venkataprasad.potturu@amd.com>
Link: https://lore.kernel.org/r/20230530110802.674939-1-venkataprasad.potturu@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/vangogh/acp5x.h     | 2 ++
 sound/soc/amd/vangogh/pci-acp5x.c | 7 ++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/sound/soc/amd/vangogh/acp5x.h b/sound/soc/amd/vangogh/acp5x.h
index bd9f1c5684d17..ac1936a8c43ff 100644
--- a/sound/soc/amd/vangogh/acp5x.h
+++ b/sound/soc/amd/vangogh/acp5x.h
@@ -147,6 +147,8 @@ static inline void acp_writel(u32 val, void __iomem *base_addr)
 	writel(val, base_addr - ACP5x_PHY_BASE_ADDRESS);
 }
 
+int snd_amd_acp_find_config(struct pci_dev *pci);
+
 static inline u64 acp_get_byte_count(struct i2s_stream_instance *rtd,
 				     int direction)
 {
diff --git a/sound/soc/amd/vangogh/pci-acp5x.c b/sound/soc/amd/vangogh/pci-acp5x.c
index e0df17c88e8e0..c4634a8a17cdc 100644
--- a/sound/soc/amd/vangogh/pci-acp5x.c
+++ b/sound/soc/amd/vangogh/pci-acp5x.c
@@ -125,10 +125,15 @@ static int snd_acp5x_probe(struct pci_dev *pci,
 {
 	struct acp5x_dev_data *adata;
 	struct platform_device_info pdevinfo[ACP5x_DEVS];
-	unsigned int irqflags;
+	unsigned int irqflags, flag;
 	int ret, i;
 	u32 addr, val;
 
+	/* Return if acp config flag is defined */
+	flag = snd_amd_acp_find_config(pci);
+	if (flag)
+		return -ENODEV;
+
 	irqflags = IRQF_SHARED;
 	if (pci->revision != 0x50)
 		return -ENODEV;
-- 
2.40.1



