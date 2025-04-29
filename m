Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 410FC24A06A;
	Tue, 29 Apr 2025 17:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946298; cv=none; b=R3FK7AHujpAl0OO3gPvT9yLUzS/QAduscj6qqCXS0jVwBryoYtl7F8bY0kiSEMHL1KdsTQTOMPRbmZPEb1RLLIw1FZzgSdaI+RgeiPjxWiy12vbxm5U83tcW1L5HKZzqa4ZdE4eBsGeY/kvONK5beKWk9AZwm34cAdAteAIPEoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946298; c=relaxed/simple;
	bh=UBK8FsxVoePSP0WKteXtFu4TvppBt5nrZImkMinv5YA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V9o/GcD6YYfdWmi+IKPof+R0m8RVFwE/peB72x3RcZY9+SMSSGs6vUO1e/loX09+BuyizgaHa0u82GqM3hXhJMJjRN8k6Az+vB+2a79AgqrxK2xnSQcI9W2XJrUGS1gyhyLm9tBy623hPdhFdIj+vcc2uyRW3tYBKQ6ZwW2a68I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CJdnQ5Xd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CJdnQ5Xd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC985C4CEE3;
	Tue, 29 Apr 2025 17:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946298;
	bh=UBK8FsxVoePSP0WKteXtFu4TvppBt5nrZImkMinv5YA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CJdnQ5XdF096yUWqP6HzMi7aAnhZfDm12q97LVVvLk4Thz64I0tYy6OsFua+c2AUr
	 FLgzeoEyLNxTjSqfiPdYOc4aaaMm/7S5pntbShbpbKUXe7UaRyiAMs2pq+rMHGgdfv
	 XM/E1o+ezyr07nhfwihBZvV2lQ4N93FpKqlCgJn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Mastykin <mastichi@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 180/311] pinctrl: mcp23s08: Get rid of spurious level interrupts
Date: Tue, 29 Apr 2025 18:40:17 +0200
Message-ID: <20250429161128.397274459@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Mastykin <mastichi@gmail.com>

[ Upstream commit 7b0671b97f0872d6950ccc925e210cb3f67721bf ]

irq_mask()/irq_unmask() are not called for nested interrupts. So level
interrupts are never masked, chip's interrupt output is not cleared on
INTCAP or GPIO read, the irq handler is uselessly called again. Nested
irq handler is not called again, because interrupt reason is cleared by
its first call.
/proc/interrupts shows that number of chip's irqs is greater than
number of nested irqs.

This patch adds masking and unmasking level interrupts inside irq handler.

Signed-off-by: Dmitry Mastykin <mastichi@gmail.com>
Link: https://lore.kernel.org/20250122120504.1279790-1-mastichi@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-mcp23s08.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-mcp23s08.c b/drivers/pinctrl/pinctrl-mcp23s08.c
index b96e6368a9568..4d1f41488017e 100644
--- a/drivers/pinctrl/pinctrl-mcp23s08.c
+++ b/drivers/pinctrl/pinctrl-mcp23s08.c
@@ -382,6 +382,7 @@ static irqreturn_t mcp23s08_irq(int irq, void *data)
 {
 	struct mcp23s08 *mcp = data;
 	int intcap, intcon, intf, i, gpio, gpio_orig, intcap_mask, defval, gpinten;
+	bool need_unmask = false;
 	unsigned long int enabled_interrupts;
 	unsigned int child_irq;
 	bool intf_set, intcap_changed, gpio_bit_changed,
@@ -396,9 +397,6 @@ static irqreturn_t mcp23s08_irq(int irq, void *data)
 		goto unlock;
 	}
 
-	if (mcp_read(mcp, MCP_INTCAP, &intcap))
-		goto unlock;
-
 	if (mcp_read(mcp, MCP_INTCON, &intcon))
 		goto unlock;
 
@@ -408,6 +406,16 @@ static irqreturn_t mcp23s08_irq(int irq, void *data)
 	if (mcp_read(mcp, MCP_DEFVAL, &defval))
 		goto unlock;
 
+	/* Mask level interrupts to avoid their immediate reactivation after clearing */
+	if (intcon) {
+		need_unmask = true;
+		if (mcp_write(mcp, MCP_GPINTEN, gpinten & ~intcon))
+			goto unlock;
+	}
+
+	if (mcp_read(mcp, MCP_INTCAP, &intcap))
+		goto unlock;
+
 	/* This clears the interrupt(configurable on S18) */
 	if (mcp_read(mcp, MCP_GPIO, &gpio))
 		goto unlock;
@@ -470,9 +478,18 @@ static irqreturn_t mcp23s08_irq(int irq, void *data)
 		}
 	}
 
+	if (need_unmask) {
+		mutex_lock(&mcp->lock);
+		goto unlock;
+	}
+
 	return IRQ_HANDLED;
 
 unlock:
+	if (need_unmask)
+		if (mcp_write(mcp, MCP_GPINTEN, gpinten))
+			dev_err(mcp->chip.parent, "can't unmask GPINTEN\n");
+
 	mutex_unlock(&mcp->lock);
 	return IRQ_HANDLED;
 }
-- 
2.39.5



