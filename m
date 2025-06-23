Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29797221734;
	Mon, 23 Jun 2025 21:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714583; cv=none; b=RHkvK1BKLXYu3KDIgqCEe+/Jl0gbw8Jz+Y74RASLP8RFXflskEze/LQiGyL8Ek4cRtJePkV7a9/LKxDAw0ol+EmbV0DE6lLh5hwv8GbLIudDUqHh0mK1OPyjmdy9A8UFn1ROUPI9FwDTE50v+5tqWLwUoTmJ9cww0F5jeYPV0KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714583; c=relaxed/simple;
	bh=segoUwQoDf2HcHC53esITE73Cl7efff4pq/gKMhL3hU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sZFLD9rkGJeEf7MelTngOHSDTxJH3RiK9Jp2xK7cK1TYHYCB0gfYu85RxUcKitFEOP3d2piV32KlF13wAi0D5zY3+qrBDA5YAuNRLEu6gTERtbq6KjBjeTY7A5TA2gYd9WYNgNIO6RqHE3L/8sW3NT97Ul73AO4Ex/XaPJMXth8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ruty5hl5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ruty5hl5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6602C4CEEA;
	Mon, 23 Jun 2025 21:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714583;
	bh=segoUwQoDf2HcHC53esITE73Cl7efff4pq/gKMhL3hU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ruty5hl5imrZ0nL5YdzbWuY8N/34Bc5fH3GCTCPJqF4hNLIyCJ7+brfpXq9dm0o4U
	 PWjUtRWhp7cPk5vkeVoB00tGbZDLK9i+WmSxxRqzQKLA9dIjPUxqAqh62qHz046cm6
	 XmH/wuc40IWDpCj4Vz/beO0QPwXNO6f4BOZN+eWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Looijmans <mike.looijmans@topic.nl>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 403/592] pinctrl: mcp23s08: Reset all pins to input at probe
Date: Mon, 23 Jun 2025 15:06:01 +0200
Message-ID: <20250623130710.026912817@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4d1f41488017e..c2f4b16f42d20 100644
--- a/drivers/pinctrl/pinctrl-mcp23s08.c
+++ b/drivers/pinctrl/pinctrl-mcp23s08.c
@@ -636,6 +636,14 @@ int mcp23s08_probe_one(struct mcp23s08 *mcp, struct device *dev,
 
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



