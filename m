Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A713168A7
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:34:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BEF3C433EF;
	Mon,  8 May 2023 10:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542063;
	bh=myw4EHW4yCxzBkNrdHkKyaH5ZEzxx8B/PaJDYMdMtoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2R1/Ka2u1aeEM0Hys1UAKnbMWE+NwpfCf2VT9Yl2z2DUJ/09KUStqvlHTSHoCQMNn
	 namumZEF9wRBQuHq+Mj9t/B9ExTywK6r6tsXxl6wFWO7DBmmCknLP9T3CppwHAcCrY
	 j9IeXab7t3NaFHzzqenfA60dQErU8JQra7dG9QDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Jun Yu <junyuu@chromium.org>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 282/663] wifi: ath11k: Use platform_get_irq() to get the interrupt
Date: Mon,  8 May 2023 11:41:48 +0200
Message-Id: <20230508094437.374213733@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit f117276638b7600b981b3fe28550823cfbe1ef23 ]

As of commit a1a2b7125e10 ("of/platform: Drop static setup of IRQ
resource from DT core"), we need to use platform_get_irq() instead of
platform_get_resource() to get our IRQs because
platform_get_resource() simply won't get them anymore.

This was already fixed in several other Atheros WiFi drivers,
apparently in response to Zeal Robot reports. An example of another
fix is commit 9503a1fc123d ("ath9k: Use platform_get_irq() to get the
interrupt"). ath11k seems to have been missed in this effort, though.

Without this change, WiFi wasn't coming up on my Qualcomm sc7280-based
hardware. Specifically, "platform_get_resource(pdev, IORESOURCE_IRQ,
i)" was failing even for i=0.

Tested-on: WCN6750 hw1.0 AHB WLAN.MSL.1.0.1-00887-QCAMSLSWPLZ-1

Fixes: a1a2b7125e10 ("of/platform: Drop static setup of IRQ resource from DT core")
Fixes: 00402f49d26f ("ath11k: Add support for WCN6750 device")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Tested-by: Jun Yu <junyuu@chromium.org>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20230201084131.v2.1.I69cf3d56c97098287fe3a70084ee515098390b70@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/ahb.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/ahb.c b/drivers/net/wireless/ath/ath11k/ahb.c
index d34a4d6325b2b..f70a119bb5c87 100644
--- a/drivers/net/wireless/ath/ath11k/ahb.c
+++ b/drivers/net/wireless/ath/ath11k/ahb.c
@@ -859,11 +859,11 @@ static int ath11k_ahb_setup_msi_resources(struct ath11k_base *ab)
 	ab->pci.msi.ep_base_data = int_prop + 32;
 
 	for (i = 0; i < ab->pci.msi.config->total_vectors; i++) {
-		res = platform_get_resource(pdev, IORESOURCE_IRQ, i);
-		if (!res)
-			return -ENODEV;
+		ret = platform_get_irq(pdev, i);
+		if (ret < 0)
+			return ret;
 
-		ab->pci.msi.irqs[i] = res->start;
+		ab->pci.msi.irqs[i] = ret;
 	}
 
 	set_bit(ATH11K_FLAG_MULTI_MSI_VECTORS, &ab->dev_flags);
-- 
2.39.2



