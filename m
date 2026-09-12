Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1DA34389C;
	Sat, 12 Sep 2026 09:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204595; cv=none; b=iylZfYorxXRyCgAw+6zoFRcw0AtnejFUX7smumBmWsSaXoEkkKxqRkzf10xah72XMo+/J/9NsPc/f+U9VKjO/YM5yYVk+vYSnURKGOU57mc9XSjuoYXTpiZd6aMGnGFTvEoe/Y/AyEKcqJz/eJxr+nJFRK1XqSPPS+urK/182Ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204595; c=relaxed/simple;
	bh=dl2fOKongEYnDBiEspq2D/19CDgRu5ejWcieYSNAPeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aleXt1iDdmQAYOSdKdXS7AK5B/ZPXS1M82TW+WD8cx+LpzE+6/nYgbm0NTQxHGH+NBsCrUH3PdeGpuL6fjPvSUN02JQYL2cduwdZ4UZGYh6JZTRXILa/A7lzJDduPAbTScwAKFU96faiGk2wmIukAe2laTpX420SZmIIofyW0CY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xv2gbKZ8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xv2gbKZ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D21621F000FF;
	Sat, 12 Sep 2026 09:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204593;
	bh=liG+ikgydsKV0zmFUqiYEaDJUYK6YL61p0O7S5kv2Ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xv2gbKZ8evx1puvRyZ1Pcl4bYi4/L7FMqme/1My8nGmzeau5MeCiKQT2cOd/+ZcbH
	 bY2o07RLzd9c02G59wvRVbYDUuEdTDEEJX+nT/NntLvYqdWp6xYWWzQHegc3QiAuEt
	 HMZlWo+pFmjEEgxwVQcKDhITwRkaNwAp/GbO4gaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Pesa <michael.pesa@icloud.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1643/1815] irqchip/ast2700-intc: Disable all interrupt merge banks on probe
Date: Sat, 12 Sep 2026 08:56:33 +0200
Message-ID: <20260912065727.564127589@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Pesa <michael.pesa@icloud.com>

[ Upstream commit 34b7e953d19a39515f8fc6c0820ebf243ea6b026 ]

The INTC0 interrupt-merge (INTM) space has 50 sources at 10 per bank, i.e.
INTC0_INTM_NUM / INTM_IRQS_PER_BANK = 5 banks. This is reflected everywhere
the banks are indexed: the aspeed_intc0_intm_routes[] table has 5 valid
entries, and the mask/unmask/eoi paths compute the bank as (hwirq -
INTM_BASE) / INTM_IRQS_PER_BANK, spanning banks 0-4.

However, INTC0_INTM_BANK_NUM is hardcoded to 3, so
aspeed_intc0_disable_intm() only clears IER for banks 0-2 at probe. Banks 3
and 4 are left in whatever state the firmware configured them , which can
leave interrupts enabled before a handler is installed.

Derive the bank count from the source count so the probe-time disable
covers every bank.

Fixes: 07825e41519a ("irqchip/ast2700-intc: Add AST2700-A2 support")
Signed-off-by: Michael Pesa <michael.pesa@icloud.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260722050243.298355-1-michael.pesa@icloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-ast2700-intc0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-ast2700-intc0.c b/drivers/irqchip/irq-ast2700-intc0.c
index c85b98a19bd41..1e375e9dffae1 100644
--- a/drivers/irqchip/irq-ast2700-intc0.c
+++ b/drivers/irqchip/irq-ast2700-intc0.c
@@ -48,9 +48,9 @@
 #define INTC0_INTMX_IER		0x1b00
 #define INTC0_INTMX_ISR		0x1b04
 #define INTC0_INTMX_BANK_SIZE	0x10
-#define INTC0_INTM_BANK_NUM	3
 #define INTC0_IRQS_PER_BANK	32
 #define INTM_IRQS_PER_BANK	10
+#define INTC0_INTM_BANK_NUM	(INTC0_INTM_NUM / INTM_IRQS_PER_BANK)
 #define INTC0_SEL_BASE			0x200
 #define INTC0_SEL_BANK_SIZE		0x4
 #define INTC0_SEL_ROUTE_SIZE	0x100
-- 
2.53.0



