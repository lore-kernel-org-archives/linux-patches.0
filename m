Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE16221543;
	Mon, 23 Jun 2025 22:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717426; cv=none; b=d83au1dhfecB7mEAs1yZQHvrA7k6FeD0vywLm7MJyXOgCvli2wjGqg9otpCCxgUtiS6fLpckYin5XrJ05JpYkfqs8G9naDU4sifSUWD3awNiXviWvOiSHObU4HkdnXHWWW0natu0uVAfLP8cSvNNWJB4Vx62E4MLTcrJSFmM17Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717426; c=relaxed/simple;
	bh=LQXrO6350BxTNLnIHfdMH0I7TrdUeA1KAQmTYlLXBU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ya9mc+S1ZeWvZKNJZLArcDvjHd6q12eaXbnKC/JqUqF4TEmWqijEECYbxUG0syatRYCOubyClZwgIRCwuIOVrBWfcoX35MXRWoa5il2+wJal8yJTlbpcPurMB4xhCNRGC3rYz0fjjtUTj28pETBMVdPmMWEMeUOP5ZQhlH/vvjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f4sfzv2f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f4sfzv2f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA048C4CEEA;
	Mon, 23 Jun 2025 22:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717426;
	bh=LQXrO6350BxTNLnIHfdMH0I7TrdUeA1KAQmTYlLXBU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f4sfzv2faoXQz8yYh2afRcQOM+zx/31XEOGGn5G1ZkVwBmz9fhNXgEb8isWJ+T+Ay
	 aYVgRvcMXEyRAzCxpB9sId51RnR8j/wnB79nZN7Y2/gAUzKrqbTJpqCuQMw+iFBSnd
	 sMcO59PaFxJqASdInzRQQCmtTfkJ+P6fduTjdJVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Looijmans <mike.looijmans@topic.nl>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 424/508] pinctrl: mcp23s08: Reset all pins to input at probe
Date: Mon, 23 Jun 2025 15:07:49 +0200
Message-ID: <20250623130655.620143000@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2e8bbef8ca344..ca001fa63ed39 100644
--- a/drivers/pinctrl/pinctrl-mcp23s08.c
+++ b/drivers/pinctrl/pinctrl-mcp23s08.c
@@ -563,6 +563,14 @@ int mcp23s08_probe_one(struct mcp23s08 *mcp, struct device *dev,
 
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



