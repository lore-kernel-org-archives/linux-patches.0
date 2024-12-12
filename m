Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FADE2153DF;
	Thu, 12 Dec 2024 15:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017489; cv=none; b=KcQz9ERqVwZprLt/lFyfjcBjAdInCLxtgnJGwQpn8C1vfIGx4n632gD1DBICrMUAyKMmHsNQmam1xvN0cQtJI0IHiwe1neImSAGnnZ9iTyJAbCUuqKbpNBruqhmOYYl282PdUXP9nWh+iH2T3Au7FhFvX5FXwQIk0Zoe2q/lyB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017489; c=relaxed/simple;
	bh=QnMfSGPOP8JWL9c4vxV8x+F1CqHtyctGbTPFXlV7TAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gNJdSicAnTrug2UpSH0ZXlsyhLZhObe2ROPRrYxnM+qX5Uaca15Rlg0TlOzVIHBMeVyEm6msKjetZJ/Oz0UtJdJyI0f7lZcIzDqQ3MOGJ/Fc3doxCG1QSv9dvObo4X8jy4Us+NYxN4ZXpBtfMnHPG+7hsatHrdQbyTbdver/SzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I70Y9hjN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I70Y9hjN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF476C4CECE;
	Thu, 12 Dec 2024 15:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017489;
	bh=QnMfSGPOP8JWL9c4vxV8x+F1CqHtyctGbTPFXlV7TAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I70Y9hjNhnoBgEZiRs9ihJWZhvBncfJhWgIeXqS4m+mcShHiQ9gSczq0AwT3Zvsb6
	 cljf+nTs40eHcPEp3o9S9Pr31H7Vs54rZIadYyxF0CkjZbnSAK+Gpedz1AVhfoEyvZ
	 AuVOSYodQUWqZIgsTpZQROWoYoopaMkikWsFrhv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yassine Oudjana <y.oudjana@protonmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 004/356] watchdog: mediatek: Make sure system reset gets asserted in mtk_wdt_restart()
Date: Thu, 12 Dec 2024 15:55:23 +0100
Message-ID: <20241212144244.789393515@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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
index b2330b16b497a..0559d9f2d97b3 100644
--- a/drivers/watchdog/mtk_wdt.c
+++ b/drivers/watchdog/mtk_wdt.c
@@ -186,9 +186,15 @@ static int mtk_wdt_restart(struct watchdog_device *wdt_dev,
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



