Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5468B346AD3
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302075; cv=none; b=tHm6sg2WAGEggywE99gXb8CsCp15SnI2q7ULcY6sah3qzMjN1I2JpMrjJq/Gz5qMvub1NVQHZtilQaIVrRIpZZRK1LNSjbLkVuaWLFE5Msx+7Si3aeU12+fH7TTinIIGPHIQLdmF6IJOGX5DIlU0eOR1RkbvC1o6Q6qlDN1d6eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302075; c=relaxed/simple;
	bh=dRLhpepTXNwFk1pQVeRp1JsaIP6PeI4quhvOVy3MNU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jI+6Slh+blGcIl6YKChnnQvZufT/R3lydUhmaLnAYqHgaPqXhO0zoIojWoD3zOoEzCesBysyIUTVOBZH7MYfGebWhQ9MqltIGryVlgmY+T2LU2LCP3hUE9yeC68+Fb7tdi2BJIDF4D8mPDA+WGIWCGuepHI0CAi+1ipf6jgqwBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dK3pFW1O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dK3pFW1O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A3C8C116D0;
	Sat, 28 Feb 2026 18:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302074;
	bh=dRLhpepTXNwFk1pQVeRp1JsaIP6PeI4quhvOVy3MNU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dK3pFW1OAZH8lIGVVl4IjVQ1Iku4qGfCCS1LoMNVlbfVj6FCHX6r1tW/Z/dyW4flP
	 y8gL511yHN52HqIFeeAHNILwEtfLCTXfMV/+310MOnUG7Wm8+mBFIhKfD3PIzDP8Pj
	 gmCCmmPGqLEvYzdnTgkJ4KVuWIaLM6JZbeb0smFvu1qJEVUFrqoGsr6KqzSx/LgvbF
	 PfWO1cvIN5ndFI3ETE6GeLE3/nfcQYP4CMMRks6ZTrsus7X11dw1SxyNuTTcDAY93A
	 xjHCNOuPryVhwSCgBI2jJPc3HHcSxdLX1xfC+O1wL7cduVFOpeLujuK8+AvRUrp5Cd
	 DJSh/kbWiye3g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 055/283] mfd: wm8350-core: Use IRQF_ONESHOT
Date: Sat, 28 Feb 2026 13:03:17 -0500
Message-ID: <20260228180709.1583486-55-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 553b4999cbe231b5011cb8db05a3092dec168aca ]

Using a threaded interrupt without a dedicated primary handler mandates
the IRQF_ONESHOT flag to mask the interrupt source while the threaded
handler is active. Otherwise the interrupt can fire again before the
threaded handler had a chance to run.

Mark explained that this should not happen with this hardware since it
is a slow irqchip which is behind an I2C/ SPI bus but the IRQ-core will
refuse to accept such a handler.

Set IRQF_ONESHOT so the interrupt source is masked until the secondary
handler is done.

Fixes: 1c6c69525b40e ("genirq: Reject bogus threaded irq requests")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/20260128095540.863589-16-bigeasy@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mfd/wm8350/core.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mfd/wm8350/core.h b/include/linux/mfd/wm8350/core.h
index a3241e4d75486..4816d4f472101 100644
--- a/include/linux/mfd/wm8350/core.h
+++ b/include/linux/mfd/wm8350/core.h
@@ -663,7 +663,7 @@ static inline int wm8350_register_irq(struct wm8350 *wm8350, int irq,
 		return -ENODEV;
 
 	return request_threaded_irq(irq + wm8350->irq_base, NULL,
-				    handler, flags, name, data);
+				    handler, flags | IRQF_ONESHOT, name, data);
 }
 
 static inline void wm8350_free_irq(struct wm8350 *wm8350, int irq, void *data)
-- 
2.51.0

