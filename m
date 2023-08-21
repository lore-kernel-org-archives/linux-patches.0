Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3093B11703
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:04:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2418BC433C7;
	Mon, 21 Aug 2023 20:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648292;
	bh=ZG6CXfQVPEcgKf8Q6ZsnrJBeMAokzq6ZEH4Kn6F8oOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sq7ZoD1Zvwh4auczSfhGmpDSx0uljDFOSiSbSNuN/Ht1kCwk6aiU2gz8NiN/aouCG
	 dQu9MORkYboYbb9qhBKtw4BHClXsMwVUUqAu9X5lGP1DCtFmpchg6xRHcvZKDKvotJ
	 DUzzSlsmfsMvbb+s3ruuNGoENEW36tG0vOh3ZKD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Parker Newman <pnewman@connecttech.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Akhil R <akhilrajeev@nvidia.com>,
	Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 6.4 095/234] i2c: tegra: Fix i2c-tegra DMA config option processing
Date: Mon, 21 Aug 2023 21:40:58 +0200
Message-ID: <20230821194133.013057171@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Parker Newman <pnewman@connecttech.com>

commit 27ec43c77b5db780a56fc3a6d6de6bf2f74614f7 upstream.

Tegra processors prior to Tegra186 used APB DMA for I2C requiring
CONFIG_TEGRA20_APB_DMA=y while Tegra186 and later use GPC DMA requiring
CONFIG_TEGRA186_GPC_DMA=y.

The check for if the processor uses APB DMA is inverted and so the wrong
DMA config options are checked.

This means if CONFIG_TEGRA20_APB_DMA=y but CONFIG_TEGRA186_GPC_DMA=n
with a Tegra186 or later processor the driver will incorrectly think DMA is
enabled and attempt to request DMA channels that will never be availible,
leaving the driver in a perpetual EPROBE_DEFER state.

Fixes: 48cb6356fae1 ("i2c: tegra: Add GPCDMA support")
Signed-off-by: Parker Newman <pnewman@connecttech.com>
Acked-by: Andi Shyti <andi.shyti@kernel.org>
Acked-by: Akhil R <akhilrajeev@nvidia.com>
Link: https://lore.kernel.org/r/fcfcf9b3-c8c4-9b34-2ff8-cd60a3d490bd@connecttech.com
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-tegra.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -449,7 +449,7 @@ static int tegra_i2c_init_dma(struct teg
 	if (i2c_dev->is_vi)
 		return 0;
 
-	if (!i2c_dev->hw->has_apb_dma) {
+	if (i2c_dev->hw->has_apb_dma) {
 		if (!IS_ENABLED(CONFIG_TEGRA20_APB_DMA)) {
 			dev_dbg(i2c_dev->dev, "APB DMA support not enabled\n");
 			return 0;


