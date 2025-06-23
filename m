Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2AB81DDC04;
	Mon, 23 Jun 2025 21:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715090; cv=none; b=olo6lJZs423u7nvzeKEpeS+UB45KItO9AUIJ89C+HvhyAAxF7xXN2F8VZvq855hgPiqvgQNQ7e2yLMJTBlmn4H/X4U904kKlF/m5xIAv9OtTztTNRIvWeeK/dVRL2PrHtheowaPrwvD6yR3CZTvGzqvJTaFH4lA0r6ONOt8eJIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715090; c=relaxed/simple;
	bh=M18CLnsiVZUupjjMGtJOsiOoYFoTGeEBcz8klWHCmvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CKgWCIHx7+RjmgbPXdQTIQUsG38XWJPyADZmEWoGbfHebXFep3X38Xu4EMDqOkYGDzTbH8bmef8xFdFWn8ZPaUArKiMmzl5qNCLX+KHTZdl/G+E50K0NyLCW5yVPUjRJGxZqurNjk1lx2ENcgxW7SXE8ZYr4RZjhmGm5SzUl/0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HtHXwQ1m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HtHXwQ1m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CD62C4CEEA;
	Mon, 23 Jun 2025 21:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715089;
	bh=M18CLnsiVZUupjjMGtJOsiOoYFoTGeEBcz8klWHCmvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HtHXwQ1menbizC+6LkwW21k0Fz1nmNfs3vK4NQj5MhXZZei+pmCGLCpg0ZbyV135f
	 ZV+/3rR5hRksr0Shpk8Xm2kO14HngDXowFYBgEHIrRdxE8PeH3iLQsfqOMKFJLSgju
	 MuYzslOHB8D5MrUGZGo64dqv5op0Vt3SMnyGSMms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Looijmans <mike.looijmans@topic.nl>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 179/290] pinctrl: mcp23s08: Reset all pins to input at probe
Date: Mon, 23 Jun 2025 15:07:20 +0200
Message-ID: <20250623130632.262212396@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Mike Looijmans <mike.looijmans@topic.nl>

[ Upstream commit 3ede3f8b4b4b399b0ca41e44959f80d5cf84fc98 ]

At startup, the driver just assumes that all registers have their
default values. But after a soft reset, the chip will just be in the
state it was, and some pins may have been configured as outputs. Any
modification of the output register will cause these pins to be driven
low, which leads to unexpected/unwanted effects. To prevent this from
happening, set the chip's IO configuration register to a known safe
mode (all inputs) before toggling any other bits.

Signed-off-by: Mike Looijmans <mike.looijmans@topic.nl>
Link: https://lore.kernel.org/20250314151803.28903-1-mike.looijmans@topic.nl
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-mcp23s08.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-mcp23s08.c b/drivers/pinctrl/pinctrl-mcp23s08.c
index fd97b6ee2a8d1..ca45c1f36a89b 100644
--- a/drivers/pinctrl/pinctrl-mcp23s08.c
+++ b/drivers/pinctrl/pinctrl-mcp23s08.c
@@ -612,6 +612,14 @@ int mcp23s08_probe_one(struct mcp23s08 *mcp, struct device *dev,
 
 	mcp->reset_gpio = devm_gpiod_get_optional(dev, "reset", GPIOD_OUT_LOW);
 
+	/*
+	 * Reset the chip - we don't really know what state it's in, so reset
+	 * all pins to input first to prevent surprises.
+	 */
+	ret = mcp_write(mcp, MCP_IODIR, mcp->chip.ngpio == 16 ? 0xFFFF : 0xFF);
+	if (ret < 0)
+		return ret;
+
 	/* verify MCP_IOCON.SEQOP = 0, so sequential reads work,
 	 * and MCP_IOCON.HAEN = 1, so we work with all chips.
 	 */
-- 
2.39.5



