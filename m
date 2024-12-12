Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2FE022652A;
	Thu, 12 Dec 2024 16:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020596; cv=none; b=macgk5w5MAtsv7Dtvtb+gVlN1EkOd73b8Ycy14PoKMSmE6HCT3hSDgZQnQSUk972RcLaSTPn4CCIEh0FDwoI4RL6/WVBF05ge9AQN94iFss2hcU9CMXbkH2vHTzv8jpPdws6uV+uH8COLak3qB0SnOYZCLjHiin44B+TILcrUGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020596; c=relaxed/simple;
	bh=ldKvYzMjHa82Q3UF9LMriaHRVTOrPsxv3OiGiSa/O9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VuRF/CuN0gOHSuACPuGG/O7L+nH4rpkqf/iLu4dE/TMjhFBB4mgzAz0UX9VvIXOq2I6qB3xclurWVuxt35Ah3sa0LV1CPfnTcxi2JxuZbP/iU7cSRQmyctOT0UcrORHzS9DrCr3bRHTYOUgwAOUJ8RkvOv+dGVPxxxI1cGMEBSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lrN5JwNM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lrN5JwNM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E7E4C4CED0;
	Thu, 12 Dec 2024 16:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020596;
	bh=ldKvYzMjHa82Q3UF9LMriaHRVTOrPsxv3OiGiSa/O9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lrN5JwNMr68abFIZx6LrAP/nb0pIC4ot8hyEQWRzkVIutz179jvnJb7jDGpdB3ooq
	 JfwtESHkaG64WdanxrjqT0vdusS+Cd5sRJ/9oxmOTo2mBLsmTePHOFadlIF4ZHPsJB
	 O+jB02RrwGOR19y2q0QOiamFonWt24YcTfoE8oDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yassine Oudjana <y.oudjana@protonmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 509/772] watchdog: mediatek: Make sure system reset gets asserted in mtk_wdt_restart()
Date: Thu, 12 Dec 2024 15:57:34 +0100
Message-ID: <20241212144410.986119242@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Yassine Oudjana <y.oudjana@protonmail.com>

[ Upstream commit a1495a21e0b8aad92132dfcf9c6fffc1bde9d5b2 ]

Clear the IRQ enable bit of WDT_MODE before asserting software reset
in order to make TOPRGU issue a system reset signal instead of an IRQ.

Fixes: a44a45536f7b ("watchdog: Add driver for Mediatek watchdog")
Signed-off-by: Yassine Oudjana <y.oudjana@protonmail.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20241106104738.195968-2-y.oudjana@protonmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/mtk_wdt.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/watchdog/mtk_wdt.c b/drivers/watchdog/mtk_wdt.c
index e977875367926..08763ff950c6d 100644
--- a/drivers/watchdog/mtk_wdt.c
+++ b/drivers/watchdog/mtk_wdt.c
@@ -175,9 +175,15 @@ static int mtk_wdt_restart(struct watchdog_device *wdt_dev,
 {
 	struct mtk_wdt_dev *mtk_wdt = watchdog_get_drvdata(wdt_dev);
 	void __iomem *wdt_base;
+	u32 reg;
 
 	wdt_base = mtk_wdt->wdt_base;
 
+	/* Enable reset in order to issue a system reset instead of an IRQ */
+	reg = readl(wdt_base + WDT_MODE);
+	reg &= ~WDT_MODE_IRQ_EN;
+	writel(reg | WDT_MODE_KEY, wdt_base + WDT_MODE);
+
 	while (1) {
 		writel(WDT_SWRST_KEY, wdt_base + WDT_SWRST);
 		mdelay(5);
-- 
2.43.0



