Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9885216E3B;
	Thu, 12 Dec 2024 17:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024526; cv=none; b=gK33gOEn6K3MrIqlT0DlckWnPSC9sSfUZ/y25Opj0PC5xtuys2UuWZ9Lkjle+U6jY/a+BOegPk/OsVvX/UznZKICWk7w55tvBgZp2fFmm6w+jhfvVHQkkAf8nPmI9Y0IlCDMT20xtuyxPYoYyzykxxZjbRxhOiZqUT75hpI9aWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024526; c=relaxed/simple;
	bh=YT79NFKtA0iA5yVXNgqQiVzc1KnkkmQ87esWXBl2WkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sF8lZLwlAnQ0mXAcrdLw4TMiBSathcMh+7+Qg6BIGJvS6H7U28kU7QrMwVQkpPLUCul4LevhDULqaFCLuMw6A9s9g322K22DxNzjofqck2R9vqWF1u9ARmYTPKG+9lBPcAlBHIhcUfaUAQ8WTdpEAla/PV3qltPJ8fVz7qFbJCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jYS/j7+l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jYS/j7+l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E663BC4CED4;
	Thu, 12 Dec 2024 17:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024526;
	bh=YT79NFKtA0iA5yVXNgqQiVzc1KnkkmQ87esWXBl2WkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jYS/j7+lXr5UY5ywe7T1XWerWIhqnqfeF4KQsKV8ILt91MihudeY0fUFhsBPhRB/F
	 v2wPKzABS9Js331aUnLJ5Mji8klA3s7DVWZN6Kc72IGvMK2GLZyQGexCxEzXl978LY
	 MSqydzBGWbwCh+Gg8NZCH1TkS+9CV0DGzv4x2sPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yassine Oudjana <y.oudjana@protonmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 326/459] watchdog: mediatek: Make sure system reset gets asserted in mtk_wdt_restart()
Date: Thu, 12 Dec 2024 16:01:04 +0100
Message-ID: <20241212144306.539446445@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d6a6393f609d1..2cc668b295fd9 100644
--- a/drivers/watchdog/mtk_wdt.c
+++ b/drivers/watchdog/mtk_wdt.c
@@ -153,9 +153,15 @@ static int mtk_wdt_restart(struct watchdog_device *wdt_dev,
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



