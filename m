Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538B72F0C62;
	Wed, 20 May 2026 16:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295158; cv=none; b=ab6WG1kZsyJcH7J0bKx54zPRnrT4Vbs+Qztv9yAwHv4Se58bIyckjG7qQwxgyjMoRjLkXf/7gh5hC6AYC2x4gbdoSzD+6fo/PNjxrsvleGq0/3q3LqVegbYpxKaqiMC5/Y7Rgeng+BXP/Do/IFb2BjOdkhZ+TVh186CILQJEakY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295158; c=relaxed/simple;
	bh=21LFA4N0bLhquncGKqOyWUA0mC+3rjr1/EJhZrNowsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qjdOTZHq3i0MhbYVjicrnYW/+HAuW53Q2V3fvREIv4YI62YU6nOiLugIxrMf4Egx7D210oiSOIhHLDeKVxzq5SyekmKf281a7mMOcMek43R0/N4wJPI+j5AY3xuNgcUx4n9X+I0Tc4ytUMLQGil7lMJao5LVQVbCYeVY2B2MVes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mo02Ikuy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mo02Ikuy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B1641F000E9;
	Wed, 20 May 2026 16:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295155;
	bh=zVVAbieBd3i2M+B5nhdom9oBNLtPV2ctwOB32xmij7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mo02Ikuyh3sPuiHSSqlGJKAhgctK+GTEuW/gp0TzVc0ZiitPW9lX+eoo5ZoG4ywgb
	 bKQB5BmaRdK2c7fINMCjg56rDL9eGg9VuR5vHd7GyXgRjkTdDgbTpanfo3NrGX7K6a
	 SiDIDRdNCFSkQTUhRD+ka+D22HhuL4flTC+NRBp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0313/1146] spi: hisi-kunpeng: prevent infinite while() loop in hisi_spi_flush_fifo
Date: Wed, 20 May 2026 18:09:23 +0200
Message-ID: <20260520162155.283586564@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pei Xiao <xiaopei01@kylinos.cn>

[ Upstream commit 9f61daf2c2debe9f5cf4e1a4471e56a89a6fe45a ]

The hisi_spi_flush_fifo()'s inner while loop that lacks any timeout
mechanism. Maybe the hardware never becomes empty, the loop will spin
forever, causing the CPU to hang.

Fix this by adding a inner_limit based on loops_per_jiffy. The inner loop
now exits after approximately one jiffy if the FIFO remains non-empty, logs
a ratelimited warning, and breaks out of the outer loop. Additionally, add
a cpu_relax() inside the busy loop to improve power efficiency.

Fixes: c770d8631e18 ("spi: Add HiSilicon SPI Controller Driver for Kunpeng SoCs")
Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Link: https://patch.msgid.link/d834ce28172886bfaeb9c8ca00cfd9bf1c65d5a1.1773889292.git.xiaopei01@kylinos.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-hisi-kunpeng.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-hisi-kunpeng.c b/drivers/spi/spi-hisi-kunpeng.c
index 216a0a91fc47d..c42d2a2cdf1e4 100644
--- a/drivers/spi/spi-hisi-kunpeng.c
+++ b/drivers/spi/spi-hisi-kunpeng.c
@@ -196,8 +196,18 @@ static void hisi_spi_flush_fifo(struct hisi_spi *hs)
 	unsigned long limit = loops_per_jiffy << 1;
 
 	do {
-		while (hisi_spi_rx_not_empty(hs))
+		unsigned long inner_limit = loops_per_jiffy;
+
+		while (hisi_spi_rx_not_empty(hs) && --inner_limit) {
 			readl(hs->regs + HISI_SPI_DOUT);
+			cpu_relax();
+		}
+
+		if (!inner_limit) {
+			dev_warn_ratelimited(hs->dev, "RX FIFO flush timeout\n");
+			break;
+		}
+
 	} while (hisi_spi_busy(hs) && limit--);
 }
 
-- 
2.53.0



