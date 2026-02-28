Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2AD301EFF;
	Sat, 28 Feb 2026 17:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301416; cv=none; b=kh/of59fh9UKi4LKqIx70+7o/53qB0+egAow0cAyoO3EvSXeGRuld+CfjkoR919EJss/JqRN6vhBpve2tpWzVFYGS+HtqUups382Sajx0lVYvB0frsDxjTXXeMK2Ss9K0qo5SQSa0qXubQl0ZHpOErtX/v0H4x9iqSuHp01ps0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301416; c=relaxed/simple;
	bh=IcG3cP6JJLO1/DitGza6K3eA3tb3RpXbCRBy+tjJ8v8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gMtch1iSteYK0oLWHL4mbIAIzyuYjHtx3rn8L0SfrZyeaiMDgyJ/1yLM31LbfaCUTMqyUjWHvpKyvFz2CwvHKfOrBZO9Vlz+EEWfoja7yMPG2IyUa1m4C9vkaL5lVKmGk875k3X9ZjPFC8ppYidigbEAfKTIN58qWWOJ8JkFW9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JGLAS1xh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JGLAS1xh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94EC4C19423;
	Sat, 28 Feb 2026 17:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301416;
	bh=IcG3cP6JJLO1/DitGza6K3eA3tb3RpXbCRBy+tjJ8v8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JGLAS1xh34W3QCv0PBfpGlP1LY3sps0yp9nGDZEeNfetc9C9PwbI1vyjE86DTv5K5
	 iaqVaMsYxChEHaIF9Nw4iqrxGjzHI1ltigdbE9RMTmPRqANIf7ffMJy4gZExM/7RmR
	 5+EoHQ+Yuqtm4GyNHABtHe/5dJbtAxx1BVIzdWxBU6e8pqOsDxrw0BXsZvhE/EeZYu
	 P1qDKYtSYO7xWpLDQHLAPtQ28l+Zzw7MqYvQe6eww4ERDABT2kSJpOfvC7+BhW0kQF
	 ATFIoODv/D8UKvY9mFnCBUW+jB1YOTuI+Pn7KuZ3GmNL+ixA9UpxY65a2qXrOxXX7q
	 mAusXtb4yuNyw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Wayne Chang <waynec@nvidia.com>,
	stable@vger.kernel.org,
	Wei-Cheng Chen <weichengc@nvidia.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 605/752] usb: host: tegra: Remove manual wake IRQ disposal
Date: Sat, 28 Feb 2026 12:45:16 -0500
Message-ID: <20260228174750.1542406-605-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Wayne Chang <waynec@nvidia.com>

[ Upstream commit ef548189fd3f44786fb813af0018cc8b3bbed2b9 ]

We found that calling irq_dispose_mapping() caused a kernel warning
when removing the driver. The IRQs are obtained using
platform_get_irq(), which returns a Linux virtual IRQ number directly
managed by the device core, not by the OF subsystem. Therefore, the
driver should not call irq_dispose_mapping() for these IRQs.

Fixes: 5df186e2ef11 ("usb: xhci: tegra: Support USB wakeup function for Tegra234")
Cc: stable@vger.kernel.org
Signed-off-by: Wayne Chang <waynec@nvidia.com>
Signed-off-by: Wei-Cheng Chen <weichengc@nvidia.com>
Link: https://patch.msgid.link/20260115103621.587366-1-weichengc@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-tegra.c | 21 ++-------------------
 1 file changed, 2 insertions(+), 19 deletions(-)

diff --git a/drivers/usb/host/xhci-tegra.c b/drivers/usb/host/xhci-tegra.c
index c78bed0aa844e..83b1766ff1521 100644
--- a/drivers/usb/host/xhci-tegra.c
+++ b/drivers/usb/host/xhci-tegra.c
@@ -1571,7 +1571,6 @@ static int tegra_xusb_setup_wakeup(struct platform_device *pdev, struct tegra_xu
 		data = irq_get_irq_data(tegra->wake_irqs[i]);
 		if (!data) {
 			dev_warn(tegra->dev, "get wake event %d irq data fail\n", i);
-			irq_dispose_mapping(tegra->wake_irqs[i]);
 			break;
 		}
 
@@ -1584,16 +1583,6 @@ static int tegra_xusb_setup_wakeup(struct platform_device *pdev, struct tegra_xu
 	return 0;
 }
 
-static void tegra_xusb_dispose_wake(struct tegra_xusb *tegra)
-{
-	unsigned int i;
-
-	for (i = 0; i < tegra->num_wakes; i++)
-		irq_dispose_mapping(tegra->wake_irqs[i]);
-
-	tegra->num_wakes = 0;
-}
-
 static int tegra_xusb_probe(struct platform_device *pdev)
 {
 	struct tegra_xusb *tegra;
@@ -1649,10 +1638,8 @@ static int tegra_xusb_probe(struct platform_device *pdev)
 		return err;
 
 	tegra->padctl = tegra_xusb_padctl_get(&pdev->dev);
-	if (IS_ERR(tegra->padctl)) {
-		err = PTR_ERR(tegra->padctl);
-		goto dispose_wake;
-	}
+	if (IS_ERR(tegra->padctl))
+		return PTR_ERR(tegra->padctl);
 
 	np = of_parse_phandle(pdev->dev.of_node, "nvidia,xusb-padctl", 0);
 	if (!np) {
@@ -1976,8 +1963,6 @@ static int tegra_xusb_probe(struct platform_device *pdev)
 put_padctl:
 	of_node_put(np);
 	tegra_xusb_padctl_put(tegra->padctl);
-dispose_wake:
-	tegra_xusb_dispose_wake(tegra);
 	return err;
 }
 
@@ -2010,8 +1995,6 @@ static void tegra_xusb_remove(struct platform_device *pdev)
 	if (tegra->padctl_irq)
 		pm_runtime_disable(&pdev->dev);
 
-	tegra_xusb_dispose_wake(tegra);
-
 	pm_runtime_put(&pdev->dev);
 
 	tegra_xusb_disable(tegra);
-- 
2.51.0

