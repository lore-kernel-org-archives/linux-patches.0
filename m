Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A55E221FF2B;
	Mon, 23 Jun 2025 22:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716512; cv=none; b=QYhgaS42cMrEtlWEvcxe0urfZXITSCwprYp0rVxnyxAkLqzsIsecswzbo6h1vKdfNHviSWnhyu3STq+Ak+o693dGMIBWTS8jjJnMqZSjMCif4sKZ8AJBgYNsWiWXTMC94Ux8qEFCv319mBzV7R5IbypQTYRcuEco+0L7CZeKZa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716512; c=relaxed/simple;
	bh=PrmLdQV6lOq74qzJQxa8Pp2sIoKHLWgPPl1DTB5Aj/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZyphrygFwB+z8otFqRUKh4oa+i6tgeHYxyEW3D3/hv3qDQYS/xs3Qv7MUyvst7OM9Ux9bs2IXZbASbHNGOK+JJg70Pk3d8Q2xuNd0C2vJVcAsBF0YAmfrct4dutatg8bEd4CPzkoWvfw/ExnehU/zgv4DIZ3FaQ7NIrmxyrmVSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xWpPsFPC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xWpPsFPC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DDB7C4CEEA;
	Mon, 23 Jun 2025 22:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716512;
	bh=PrmLdQV6lOq74qzJQxa8Pp2sIoKHLWgPPl1DTB5Aj/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xWpPsFPCMdb8nzWNnsZy6Cvtqdp6vTBNX6NBtu6uG+TOxUJOlqnAmda1SEJLBJfG8
	 EG+ftlukxw5SfPKzFgnoSslBh7qzsuzrfBBQ9rdXJ9TISB5EPdmBfXDKRv8bZ384TT
	 Vo7XLXpogDzQUHNkVj7iTHtniK4sWCBEamJIEvFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Looijmans <mike.looijmans@topic.nl>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 264/414] pinctrl: mcp23s08: Reset all pins to input at probe
Date: Mon, 23 Jun 2025 15:06:41 +0200
Message-ID: <20250623130648.635257158@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 70d7485ada364..60fcd53830a7d 100644
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



