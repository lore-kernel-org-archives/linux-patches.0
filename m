Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5DF217F35;
	Tue, 12 Aug 2025 19:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026794; cv=none; b=DjL+2CsSVJcwt27WvE8ejVOqvANFcD7rW2MmM7yr+0GPuZfVGdmyp5cUL17oUd0q57k5HwpKsCLi+91SU2X+JqcKE/TQjoo1WPQwSaWcXD2DRuNl17NO3py2Ot+4xAD3ItABvUFE0TFsQAnE20Lx68uuG4kB7Iz4zk7rGivmbUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026794; c=relaxed/simple;
	bh=1LLKemOqK+SAeVLrlwsYYbGoFF+JS/ZjNBgLnoXE/Wk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xvdu+oIaaaWeRM2nZciqEEsXUPgkRAF9+tGKHrWojFegPPy0XIOBm+BCoKMzYtAjmX8Cl6QrowW2TZfDvaZg87zgekPch8mfiMIGPBd2cfShLkYbflOewfCRP6czxZZWj3ZCinjsYJI1VA+l3p7M2rpNK5ZTHXUev7PFxuNRXd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m2WPfPGe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m2WPfPGe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EEE2C4CEF0;
	Tue, 12 Aug 2025 19:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026793;
	bh=1LLKemOqK+SAeVLrlwsYYbGoFF+JS/ZjNBgLnoXE/Wk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m2WPfPGe9tOZdV3zwouqPlTrUwPvTmAlLVQpEYRxl2ZmaAHFogCwRuZQjnllq6Gf/
	 GTwDUOzHAT+NIxk6wLtQ+GpB6Qe5PjiHCh/iv2UuL9/ZuYgSaD8wLHxG7X2HIXDYtU
	 CDvkYPg/NUGYheJvrYIxKsQYGs9gpAuizI3v8Nms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 400/480] net: mdio: mdio-bcm-unimac: Correct rate fallback logic
Date: Tue, 12 Aug 2025 19:50:08 +0200
Message-ID: <20250812174413.932311830@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fainelli <florian.fainelli@broadcom.com>

[ Upstream commit a81649a4efd382497bf3d34a623360263adc6993 ]

When the parent clock is a gated clock which has multiple parents, the
clock provider (clk-scmi typically) might return a rate of 0 since there
is not one of those particular parent clocks that should be chosen for
returning a rate. Prior to ee975351cf0c ("net: mdio: mdio-bcm-unimac:
Manage clock around I/O accesses"), we would not always be passing a
clock reference depending upon how mdio-bcm-unimac was instantiated. In
that case, we would take the fallback path where the rate is hard coded
to 250MHz.

Make sure that we still fallback to using a fixed rate for the divider
calculation, otherwise we simply ignore the desired MDIO bus clock
frequency which can prevent us from interfacing with Ethernet PHYs
properly.

Fixes: ee975351cf0c ("net: mdio: mdio-bcm-unimac: Manage clock around I/O accesses")
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250730202533.3463529-1-florian.fainelli@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mdio/mdio-bcm-unimac.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/mdio/mdio-bcm-unimac.c b/drivers/net/mdio/mdio-bcm-unimac.c
index 074d96328f41..60565e7c88bd 100644
--- a/drivers/net/mdio/mdio-bcm-unimac.c
+++ b/drivers/net/mdio/mdio-bcm-unimac.c
@@ -209,10 +209,9 @@ static int unimac_mdio_clk_set(struct unimac_mdio_priv *priv)
 	if (ret)
 		return ret;
 
-	if (!priv->clk)
+	rate = clk_get_rate(priv->clk);
+	if (!rate)
 		rate = 250000000;
-	else
-		rate = clk_get_rate(priv->clk);
 
 	div = (rate / (2 * priv->clk_freq)) - 1;
 	if (div & ~MDIO_CLK_DIV_MASK) {
-- 
2.39.5



