Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B8921CFF0;
	Thu, 12 Dec 2024 17:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023020; cv=none; b=ZLtICrwEe0sNOrjL/irsPtJI5Op12DidR54qooPy6g8GXhG4X1SHuGF4RBg6lt2aTrg92oyd5UAvfF1PSOzh8f2d6wqaDy4ARa/xPLLoeWcJZdNs6+nvUAADxS9RsFbkd41lulp9fKrdJy0Hqfeq4j2nroOP6mBPK2X2Eezr7mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023020; c=relaxed/simple;
	bh=5kONmg/bP/iRuGYnA4EFDiWRXWMppEwsAyDCdTgTrEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t34t7mBuzoe2lkZftOcKQgQ7kh1DnudfPG0DCdMIzkLQ43KrIS8PnzSeYDEYmdnYYcbqZVU0j0zC1uJAp3XvRuJWuGJsqUbS9qiYoTY4tQsukV6iNJNQXt3LYCPXgS8d96cKSluzO3mk/Z6H04zf4MFih0BLyjLkAVnhe9u0sWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YcgzU8gN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YcgzU8gN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2AF0C4CECE;
	Thu, 12 Dec 2024 17:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023020;
	bh=5kONmg/bP/iRuGYnA4EFDiWRXWMppEwsAyDCdTgTrEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YcgzU8gNlSQCF+oYAuaUiG0mBFfqH9HB4Iu03Ucp7nyg6+EbuawyfIrpV2CK3K529
	 v7JRQMKEYhhM8FPGMbivAWZNkH/Pb3Awd3iswb2AyCTySLoSILkRDzBDRa8ALkpkO+
	 tjGeu/mQXJAHjiL/XIsQ4VNLLFCk6d40VHjFnLaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yassine Oudjana <y.oudjana@protonmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 399/565] watchdog: mediatek: Make sure system reset gets asserted in mtk_wdt_restart()
Date: Thu, 12 Dec 2024 15:59:54 +0100
Message-ID: <20241212144327.422408737@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 796fbb048cbea..a9d67ead94838 100644
--- a/drivers/watchdog/mtk_wdt.c
+++ b/drivers/watchdog/mtk_wdt.c
@@ -164,9 +164,15 @@ static int mtk_wdt_restart(struct watchdog_device *wdt_dev,
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



