Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F259828E57B;
	Wed,  7 May 2025 19:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644716; cv=none; b=AnQPwWwkWIXXSPKaRU89dq6T7W37PxM4/l1OeADHECa6dFS0Kq+BkeQC1CdYxSLLeT+EZY2rzgHzvJ4c4lLiFST2yT19Xj1SmxqJ7zzDOI3270kZjCQNCWzsy5F1KG15YGcEyURQMKlJ/9B4Djg8xjSiD7wpQwfizMSPxSx4S0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644716; c=relaxed/simple;
	bh=FxT/MWIfdlo6PF13jGkUVUrNjL0YCfvINRIoBazPH4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d5Cl+Leu8+9KWONkDaG65/dAG9a7UX61uA+CNmH/XhClDX2Ph0pNvdivGwPly0q2xSfdZPHB5JkGqb21SSijHcdd8Dj4l4IpI/jreII6Djz6r5FickYqHq1OPm9ZUb65KxrdWp9d6J4rQtCx7VGy5wtw/llZ3j3iBNVlp1O0TaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OH3Of7qc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OH3Of7qc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6500BC4CEEB;
	Wed,  7 May 2025 19:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644715;
	bh=FxT/MWIfdlo6PF13jGkUVUrNjL0YCfvINRIoBazPH4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OH3Of7qcOyZ3ohVvcpfHhH9ap5HKIpRn0uPDd9t7K4cvQrZVxOMwc1HJicXBDqZXU
	 TbpHmyUQ+ZfAuG9Ii9PbOGRfMh2sbiXk49MCUic0BH2BUvq5XXueQk16ca6il764ur
	 FSs4L9OYyn01XdE+LeuceK+ZjJXJMn0hVtYT7kSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 134/164] net: vertexcom: mse102x: Add range check for CMD_RTS
Date: Wed,  7 May 2025 20:40:19 +0200
Message-ID: <20250507183826.400618927@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

From: Stefan Wahren <wahrenst@gmx.net>

[ Upstream commit d4dda902dac194e3231a1ed0f76c6c3b6340ba8a ]

Since there is no protection in the SPI protocol against electrical
interferences, the driver shouldn't blindly trust the length payload
of CMD_RTS. So introduce a bounds check for incoming frames.

Fixes: 2f207cbf0dd4 ("net: vertexcom: Add MSE102x SPI support")
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250430133043.7722-4-wahrenst@gmx.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/vertexcom/mse102x.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/vertexcom/mse102x.c b/drivers/net/ethernet/vertexcom/mse102x.c
index 3edf2c3753f0e..2c06d1d05164f 100644
--- a/drivers/net/ethernet/vertexcom/mse102x.c
+++ b/drivers/net/ethernet/vertexcom/mse102x.c
@@ -6,6 +6,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/if_vlan.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
@@ -337,8 +338,9 @@ static void mse102x_rx_pkt_spi(struct mse102x_net *mse)
 	}
 
 	rxlen = cmd_resp & LEN_MASK;
-	if (!rxlen) {
-		net_dbg_ratelimited("%s: No frame length defined\n", __func__);
+	if (rxlen < ETH_ZLEN || rxlen > VLAN_ETH_FRAME_LEN) {
+		net_dbg_ratelimited("%s: Invalid frame length: %d\n", __func__,
+				    rxlen);
 		mse->stats.invalid_len++;
 		return;
 	}
-- 
2.39.5



