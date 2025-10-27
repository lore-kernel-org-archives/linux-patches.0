Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D346A2EDD62;
	Mon, 27 Oct 2025 19:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593319; cv=none; b=VPuEU/2/YZJUnkqfePR39S2TtJDZIVFCR2/1E2sH6NkWeqAIwKPJ/eouhGNdrZX3okLqAaBmUAw+cVabAfq5DpoKZFbs2SiUN4GZ9d/h2cxlZkjAIYbBEPOqB7e2WYR2a7diqN6guk3vucurKVUXYK02iR8lT9zJFEG9bCQvLMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593319; c=relaxed/simple;
	bh=m8Rn3bo/CGI2Ucmlsy7AcInbtEXAWmOp6IKXZeNk968=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FHSaAmN9PMdtfabgDXpc0D28JiQJ7PdOGBrt7zLgBdyOS1CE2rfnBwz89Lp2WdjBQVzJ5V1gHJFETC0X4mVBqrHCDYTHDfkjZnQJBe4OqEFGh3LBJc9MVIFo9NV2QQI6apx8yxurjcZu38Ta2MdJUr7x1xxCiAB1y1n27GalW6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xvOoTNbs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xvOoTNbs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31DEAC4CEF1;
	Mon, 27 Oct 2025 19:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593319;
	bh=m8Rn3bo/CGI2Ucmlsy7AcInbtEXAWmOp6IKXZeNk968=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xvOoTNbsGueM/DtTaxHJ3wLO+DUZf3dwVhtogu3/nFXt04kxa8wPhFmXGUeuZSQp/
	 0mskjoLuskU64n9F4xtsoVEJY6OlyO9t6nlHkN42znyUqvCfnGAVOiY06RIyYZd71i
	 hH+MSE7FP/LOpwK1uAm+3m4qNTr9sqrQmyKE/MpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.17 097/184] net: stmmac: dwmac-rk: Fix disabling set_clock_selection
Date: Mon, 27 Oct 2025 19:36:19 +0100
Message-ID: <20251027183517.519732916@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Reichel <sebastian.reichel@collabora.com>

commit 7f864458e9a6d2000b726d14b3d3a706ac92a3b0 upstream.

On all platforms set_clock_selection() writes to a GRF register. This
requires certain clocks running and thus should happen before the
clocks are disabled.

This has been noticed on RK3576 Sige5, which hangs during system suspend
when trying to suspend the second network interface. Note, that
suspending the first interface works, because the second device ensures
that the necessary clocks for the GRF are enabled.

Cc: stable@vger.kernel.org
Fixes: 2f2b60a0ec28 ("net: ethernet: stmmac: dwmac-rk: Add gmac support for rk3588")
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20251014-rockchip-network-clock-fix-v1-1-c257b4afdf75@collabora.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
@@ -1448,14 +1448,15 @@ static int gmac_clk_enable(struct rk_pri
 		}
 	} else {
 		if (bsp_priv->clk_enabled) {
+			if (bsp_priv->ops && bsp_priv->ops->set_clock_selection) {
+				bsp_priv->ops->set_clock_selection(bsp_priv,
+					      bsp_priv->clock_input, false);
+			}
+
 			clk_bulk_disable_unprepare(bsp_priv->num_clks,
 						   bsp_priv->clks);
 			clk_disable_unprepare(bsp_priv->clk_phy);
 
-			if (bsp_priv->ops && bsp_priv->ops->set_clock_selection)
-				bsp_priv->ops->set_clock_selection(bsp_priv,
-					      bsp_priv->clock_input, false);
-
 			bsp_priv->clk_enabled = false;
 		}
 	}


