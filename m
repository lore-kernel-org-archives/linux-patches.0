Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A902144C1;
	Wed,  7 May 2025 19:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746645100; cv=none; b=J4rJpp+g3HRG/wrKt5y3iG+9NdNgNiXtG9PbqZKYm4hMGjXyn8ELDCgHao087gRSgKCqd31R8ktsYX+YSWbiFs1uiVsfteKgSz+g03miuydrWq6yAqbW9Op9ppJ/ewINZ1NPtmGMmfY5ZgajMefPa2FxaoLJA3XUDFE7AJGS87E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746645100; c=relaxed/simple;
	bh=Mo7+7aWOw3MfafX7ra5oPp4pYkswiQVcP6yjts2MVcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gxnJCXeQOTIbwBKbDvrI28oWwZ+vrJMjw9DVe8LrUU/kksd85Le+Xp0T/OwAZyPt4k6YUBSErqUTdfFRZTNSGmtinHeRT0stf68/+0n5Yvdt5mA7myrJMUAgx/fXEEnAb0u/HTGRN1u3VOviUeQhS6o+dshEnlQfNCW8rtDc+Hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VGuwOiTs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VGuwOiTs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB32DC4CEE2;
	Wed,  7 May 2025 19:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746645100;
	bh=Mo7+7aWOw3MfafX7ra5oPp4pYkswiQVcP6yjts2MVcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VGuwOiTswhiqQnp+e52j5tUK5MzjAf8125SRAvSJua137cuddyIeNAG/GquLl3XmK
	 IFD74czazhfyxU93kbLn8kmg77aEOoTtET/yMNf4e9CzWi65KTDiU939EZmNyBcxXF
	 R5oxv/y4GOWzjkEFFNfAP0zUqM2A9rnbJRPC3pD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 094/129] net: vertexcom: mse102x: Add range check for CMD_RTS
Date: Wed,  7 May 2025 20:40:30 +0200
Message-ID: <20250507183817.304108312@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 55f34d9d111c4..2b1aac72601d0 100644
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



