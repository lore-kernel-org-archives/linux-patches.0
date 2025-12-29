Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703B9327BF3;
	Mon, 29 Dec 2025 16:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025506; cv=none; b=nQf46wgLdJxDma8NCh0N1bMA5tI6rxvVIsZPMuURIGabQEZjJm9aNyqqsakt/1UTXyH9zGCXJkf+uVRexbQclq5KDxxSTB6dK+B6f9mptEeibibnC2w96OhVnp7wGBNRBX5ZSsoE4R8aPmMtkiFrLkq0vkPbJQbHMyjUTYcY7Vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025506; c=relaxed/simple;
	bh=qJkZ5yRuEjAbXYXzFl7359hty8At24kFsetBejzpLqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=txwg6q4WFLhHFShxiyRoQ1zBj285rmA0bvMQ5zO7DP1nJ38BSrieqSuPvpIs3Yd45ACB+fik+4d8n1NiYANVITWgUu1A0RwmosevLPtPzmS7iEaMEbY1XM/awyzhpdITg5IMZldABrPs/6F0QnJ5UcdIlV3Sgdubaj62MUcdY9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oYO3iAP+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oYO3iAP+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C19F2C4CEF7;
	Mon, 29 Dec 2025 16:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025506;
	bh=qJkZ5yRuEjAbXYXzFl7359hty8At24kFsetBejzpLqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oYO3iAP+ZzD6QWlUNKLwwxICW6rpxr3pnTsA5Jowan4hSxYvyQuE8iI/GdAx213dR
	 0SIJUwsHjUrXNplbk/RilrIUkpLQzFHedUwl3lbCfNvd+MYShJb1peholF/EJ3M+6l
	 T/j/tY4YVPMm+uYiXDlrqfZMVy2DAAgSRWWOJVj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinhui Guo <guojinhui.liam@bytedance.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 205/430] i2c: designware: Disable SMBus interrupts to prevent storms from mis-configured firmware
Date: Mon, 29 Dec 2025 17:10:07 +0100
Message-ID: <20251229160731.898799356@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinhui Guo <guojinhui.liam@bytedance.com>

[ Upstream commit d3429178ee51dd7155445d15a5ab87a45fae3c73 ]

When probing the I2C master, disable SMBus interrupts to prevent
storms caused by broken firmware mis-configuring IC_SMBUS=1; the
handler never services them and a mis-configured SMBUS Master
extend-clock timeout or SMBUS Slave extend-clock timeout can
flood the CPU.

Signed-off-by: Jinhui Guo <guojinhui.liam@bytedance.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20251021075714.3712-2-guojinhui.liam@bytedance.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-designware-core.h   | 1 +
 drivers/i2c/busses/i2c-designware-master.c | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/i2c/busses/i2c-designware-core.h b/drivers/i2c/busses/i2c-designware-core.h
index 347843b4f5dd..436555543c79 100644
--- a/drivers/i2c/busses/i2c-designware-core.h
+++ b/drivers/i2c/busses/i2c-designware-core.h
@@ -78,6 +78,7 @@
 #define DW_IC_TX_ABRT_SOURCE			0x80
 #define DW_IC_ENABLE_STATUS			0x9c
 #define DW_IC_CLR_RESTART_DET			0xa8
+#define DW_IC_SMBUS_INTR_MASK			0xcc
 #define DW_IC_COMP_PARAM_1			0xf4
 #define DW_IC_COMP_VERSION			0xf8
 #define DW_IC_SDA_HOLD_MIN_VERS			0x3131312A /* "111*" == v1.11* */
diff --git a/drivers/i2c/busses/i2c-designware-master.c b/drivers/i2c/busses/i2c-designware-master.c
index 41e9b5ecad20..45bfca05bb30 100644
--- a/drivers/i2c/busses/i2c-designware-master.c
+++ b/drivers/i2c/busses/i2c-designware-master.c
@@ -220,6 +220,13 @@ static int i2c_dw_init_master(struct dw_i2c_dev *dev)
 	/* Disable the adapter */
 	__i2c_dw_disable(dev);
 
+	/*
+	 * Mask SMBus interrupts to block storms from broken
+	 * firmware that leaves IC_SMBUS=1; the handler never
+	 * services them.
+	 */
+	regmap_write(dev->map, DW_IC_SMBUS_INTR_MASK, 0);
+
 	/* Write standard speed timing parameters */
 	regmap_write(dev->map, DW_IC_SS_SCL_HCNT, dev->ss_hcnt);
 	regmap_write(dev->map, DW_IC_SS_SCL_LCNT, dev->ss_lcnt);
-- 
2.51.0



