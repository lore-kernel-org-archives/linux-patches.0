Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50A02EAE5;
	Thu, 12 Dec 2024 15:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015722; cv=none; b=EyTlkXrEV9OvVFPr5RLZOci9fhX9B108c2RDXOnTpQVmiuearJmK2VkropPrvvhdm8cFcG7trP4b2O6Xm7K4jb6k44ErU2JOIugyOSRhotPlEdYhrgNbgsVvPu6RJvHgg7GKghLY8CzB1F5jeAF+Ayvo3L0IOl71I5+i4544NHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015722; c=relaxed/simple;
	bh=iChowekVdJyLBbnoTVeEcq1l2nTB+lgMbayFBFwPmyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l9GYfcCfs5JxFr655t8PC0eW8FymS1q71SZpRp0Z896PLCWp70q3SDhbfl5jRAQYCXxyL+a8r6lHjiAYyY/8NiPa4a+RXRNmjH6Fux7RTm7P239Cvr3Us1XiGn+HfeKq9a+DqOrehGkB/ZdxTbxNTNdJMo9yxWvcb64LC969h+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rmgp1LGE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rmgp1LGE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5041AC4CECE;
	Thu, 12 Dec 2024 15:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734015721;
	bh=iChowekVdJyLBbnoTVeEcq1l2nTB+lgMbayFBFwPmyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rmgp1LGEo855fdmQpObIVe5TiK7idhA/KHVvGYdw0r83WLd7Z1mdGtY/PdAsUk2E/
	 CbUockFSQ8UtpL/70dz8gZKZcjRklJOmWR5to+kKXrrV2iQGph7hJfiRvFYhSaEKFj
	 YB+wPB05YgPmVEBUpCT9CnVotLpX7UEzgEVVGYic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yassine Oudjana <y.oudjana@protonmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 004/466] watchdog: mediatek: Make sure system reset gets asserted in mtk_wdt_restart()
Date: Thu, 12 Dec 2024 15:52:53 +0100
Message-ID: <20241212144306.838345797@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c35f85ce8d69c..e2d7a57d6ea2e 100644
--- a/drivers/watchdog/mtk_wdt.c
+++ b/drivers/watchdog/mtk_wdt.c
@@ -225,9 +225,15 @@ static int mtk_wdt_restart(struct watchdog_device *wdt_dev,
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



