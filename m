Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C162833C511;
	Fri,  9 Jan 2026 11:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959445; cv=none; b=fyxOH+u2TNxQPtBpFIIp0zy1wYqj2tGuA6qJWavqXQQWUapQbf4d7z8w5Du1wuF8OsWg4dYtnbCilGwlyRaTf6JgNCQybbrylc3i82PUnJ8sYIyB9FTkryXosGRW7mHuURPRYDPnHbRd0itfbNd2X5/iL+0vQ0IBarGazSxGbNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959445; c=relaxed/simple;
	bh=6FWEsecBrlucanM+mf+hMULc0Q02rnyFkMyqP0XHbDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ocOJtLdFFDolTM6Yo52blhunD31ycKSa+OmKaQbZzAeQ8ho6ZoQtB5MgksN9HiVR4yL667xjJsw7QtjHEXiKruWknSOWVJnsQBFKCMNuJpERLY+1ScEWkRAQ6xlRFI6vBGXKrnBBb4RCiuLOiNSvvjVJG7ZuXK55zLgofxQBHlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CSLdNrIr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CSLdNrIr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 144BEC4CEF1;
	Fri,  9 Jan 2026 11:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959445;
	bh=6FWEsecBrlucanM+mf+hMULc0Q02rnyFkMyqP0XHbDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CSLdNrIrM8DHPpcfuxl8wlSRsCHCHI3XPJH94aTRsuaxlghISTu+sdQ1JpKQM+ZrP
	 P52GXNif+73jWz6m9J8AqJuvDN7GL/ZL9tKhpcUSOqfAjwG6NZccRzlX/Ms9M+//6N
	 F/St15q8TFbK/39LMtaLUjNJ5W//+M/5QwhDaZu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 054/737] clk: renesas: rzg2l: Remove critical area
Date: Fri,  9 Jan 2026 12:33:13 +0100
Message-ID: <20260109112136.026081958@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

[ Upstream commit 5f710e3bc5987373737470f98798bbd49134a2e0 ]

The spinlock in rzg2l_mod_clock_endisable() is intended to protect
RMW-accesses to the hardware register.  There is no need to protect
instructions that set temporary variables which will be written
afterwards to a hardware register.  With this only one write to one
clock register is executed thus locking/unlocking rmw_lock is removed.

Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20230929053915.1530607-7-claudiu.beznea@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Stable-dep-of: b91401af6c00 ("clk: renesas: cpg-mssr: Read back reset registers to assure values latched")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/rzg2l-cpg.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/clk/renesas/rzg2l-cpg.c b/drivers/clk/renesas/rzg2l-cpg.c
index 0b3b6097b33a0..b7fa4c7eb8016 100644
--- a/drivers/clk/renesas/rzg2l-cpg.c
+++ b/drivers/clk/renesas/rzg2l-cpg.c
@@ -978,7 +978,6 @@ static int rzg2l_mod_clock_endisable(struct clk_hw *hw, bool enable)
 	struct rzg2l_cpg_priv *priv = clock->priv;
 	unsigned int reg = clock->off;
 	struct device *dev = priv->dev;
-	unsigned long flags;
 	u32 bitmask = BIT(clock->bit);
 	u32 value;
 	int error;
@@ -990,14 +989,12 @@ static int rzg2l_mod_clock_endisable(struct clk_hw *hw, bool enable)
 
 	dev_dbg(dev, "CLK_ON %u/%pC %s\n", CLK_ON_R(reg), hw->clk,
 		enable ? "ON" : "OFF");
-	spin_lock_irqsave(&priv->rmw_lock, flags);
 
 	value = bitmask << 16;
 	if (enable)
 		value |= bitmask;
-	writel(value, priv->base + CLK_ON_R(reg));
 
-	spin_unlock_irqrestore(&priv->rmw_lock, flags);
+	writel(value, priv->base + CLK_ON_R(reg));
 
 	if (!enable)
 		return 0;
-- 
2.51.0



