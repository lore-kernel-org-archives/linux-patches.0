Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03ED9168A7
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:34:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 780C0C4339B;
	Mon,  8 May 2023 10:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542066;
	bh=rKxa6za2E3Ax6EuEdZlSGaFfMGzEoKJwAYaUArXmzAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MkNhMj5Te6/myth2khKAQ9BOIjzC8I7ELBcs/TPhJAoK1SLcURV6zdUwNp6VpidUr
	 qi8vImh929RuSko2EPLOucw3zHb7DTFB8u1hLOzSy01/1uoR8Bcy0z+KZnpCyHsBCI
	 j0/VB7lfVG3PYBf4oUeQmuPwQY0KdpLjB+rkipxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 283/663] wifi: ath5k: Use platform_get_irq() to get the interrupt
Date: Mon,  8 May 2023 11:41:49 +0200
Message-Id: <20230508094437.403272339@linuxfoundation.org>
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

[ Upstream commit 95c95251d0547b46d6571e4fbd51b42865c15a4a ]

As of commit a1a2b7125e10 ("of/platform: Drop static setup of IRQ
resource from DT core"), we need to use platform_get_irq() instead of
platform_get_resource() to get our IRQs because
platform_get_resource() simply won't get them anymore.

This was already fixed in several other Atheros WiFi drivers,
apparently in response to Zeal Robot reports. An example of another
fix is commit 9503a1fc123d ("ath9k: Use platform_get_irq() to get the
interrupt"). ath5k seems to have been missed in this effort, though.

Fixes: a1a2b7125e10 ("of/platform: Drop static setup of IRQ resource from DT core")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20230201084131.v2.2.Ic4f8542b0588d7eb4bc6e322d4af3d2064e84ff0@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath5k/ahb.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ahb.c b/drivers/net/wireless/ath/ath5k/ahb.c
index 2c9cec8b53d9e..28a1e5eff204e 100644
--- a/drivers/net/wireless/ath/ath5k/ahb.c
+++ b/drivers/net/wireless/ath/ath5k/ahb.c
@@ -113,15 +113,13 @@ static int ath_ahb_probe(struct platform_device *pdev)
 		goto err_out;
 	}
 
-	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
-	if (res == NULL) {
-		dev_err(&pdev->dev, "no IRQ resource found\n");
-		ret = -ENXIO;
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		dev_err(&pdev->dev, "no IRQ resource found: %d\n", irq);
+		ret = irq;
 		goto err_iounmap;
 	}
 
-	irq = res->start;
-
 	hw = ieee80211_alloc_hw(sizeof(struct ath5k_hw), &ath5k_hw_ops);
 	if (hw == NULL) {
 		dev_err(&pdev->dev, "no memory for ieee80211_hw\n");
-- 
2.39.2



