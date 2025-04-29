Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B079521883E;
	Tue, 29 Apr 2025 17:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947957; cv=none; b=BP+YDTLW5GtaJw1KyzOQ/URYHBKXxcpdK3iVNpvmr71psKbZrVqB2CyT2ES1nfZPd9qIcuO4f5Uzf41t2c2NYMmGnke7CMDbgfCX3L9wu8a5qaPEn61zR7d2ZOhG689i3je5sRUBC+yGmCVA6FZPKZpRTDj/wffGGPnZx1qfE2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947957; c=relaxed/simple;
	bh=jwb+n96BlzMW/EVRE8Kxq2GS34zomoftIuUqtfQl0ps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tsxswpd2GcIknk9n9ZOOgr+3FgnoIYzimM90Vim75Ar01efBH9It2W/sDhIF3rtX8rJcRT7GA3k+TD0xZG0kX62bKsxdvdXGwD9UGJS0B8RJQaksghpcZ3tVrbxsaMCIS00onYq/mJOL2mqLBjgfvTsC6urBL8pyyxzUfNdZJpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sWkrhZyy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sWkrhZyy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A11EC4CEE3;
	Tue, 29 Apr 2025 17:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947957;
	bh=jwb+n96BlzMW/EVRE8Kxq2GS34zomoftIuUqtfQl0ps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sWkrhZyyctT8TC44ICr+QbCWjPBGJdmfH3Ok0ATF42nh8/afz2Fyzk6UOfqT+aUQs
	 sF0ICITfXROmyCFLL7xV6Wqwn+hqRup2aW3ASnJlToibNwqENtU+7S1ZsD88TTyIaU
	 QQQTf4Ev/Wd9r0RQSnj9BJTtOumfMu02vgw8hPLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Mastykin <mastichi@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 154/280] pinctrl: mcp23s08: Get rid of spurious level interrupts
Date: Tue, 29 Apr 2025 18:41:35 +0200
Message-ID: <20250429161121.422116357@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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
index f384c72d95545..70d7485ada364 100644
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



