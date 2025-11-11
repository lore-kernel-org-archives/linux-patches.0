Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E62191F874C;
	Tue, 11 Nov 2025 01:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825355; cv=none; b=dhhJNxPJaL72FYirzubug7c/lqxP33QH7TAV46aUcxMzReLrPnqL31lv/vzqWsgnb1YtzC6Lwps091UZivsoIq4ccBl6N855kSKjp5qzAVmKA40ymDQfww7p5yxOrk4NYvW0g4Oe8fJoTGs1Ad90LVoktioHROYZv43t/fnEvnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825355; c=relaxed/simple;
	bh=VZjfb/97u9E6+ILv/NUK5vtggt5DkBjfowBEVx3EqUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R1uUhUcJv8ZjWsonhgx/u2x4OK4x6txxqLC2xDJmh50xgAk7Be/bDOHPIlJIPfzFbQCEXSClXIAsRSAlVikTfTeqXNQ2yLv6Ev38r/UWC2TmhLuANWjtN2GbGXZ/cesJfeE2VJ5gETz2bCiKXHPwL5GiEo7sb5+deG/z/3IykwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G4HA1K0P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G4HA1K0P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F7F9C116D0;
	Tue, 11 Nov 2025 01:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825354;
	bh=VZjfb/97u9E6+ILv/NUK5vtggt5DkBjfowBEVx3EqUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G4HA1K0P/7x3cKCuLeezKiNYdJPiBt0jR9Vr5kUfrX62cGBwD/qlqFBCLQRqaBY/M
	 IVU7S5TOQEUjP3AEBpI46X3REgDROaPuqo2MMA0AqQGZcbuwB46mSCvc6OXs+kuId5
	 N4ChhEfqtystO7K72SC9bhtioWfQEEcsRSqwTj+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 768/849] net: mdio: Check regmap pointer returned by device_node_to_regmap()
Date: Tue, 11 Nov 2025 09:45:38 +0900
Message-ID: <20251111004554.996224176@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit b2b526c2cf57d14ee269e012ed179081871f45a1 ]

The call to device_node_to_regmap() in airoha_mdio_probe() can return
an ERR_PTR() if regmap initialization fails. Currently, the driver
stores the pointer without validation, which could lead to a crash
if it is later dereferenced.

Add an IS_ERR() check and return the corresponding error code to make
the probe path more robust.

Fixes: 67e3ba978361 ("net: mdio: Add MDIO bus controller for Airoha AN7583")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20251031161607.58581-1-alok.a.tiwari@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mdio/mdio-airoha.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/mdio/mdio-airoha.c b/drivers/net/mdio/mdio-airoha.c
index 1dc9939c8d7d4..52e7475121eaf 100644
--- a/drivers/net/mdio/mdio-airoha.c
+++ b/drivers/net/mdio/mdio-airoha.c
@@ -219,6 +219,8 @@ static int airoha_mdio_probe(struct platform_device *pdev)
 	priv = bus->priv;
 	priv->base_addr = addr;
 	priv->regmap = device_node_to_regmap(dev->parent->of_node);
+	if (IS_ERR(priv->regmap))
+		return PTR_ERR(priv->regmap);
 
 	priv->clk = devm_clk_get_enabled(dev, NULL);
 	if (IS_ERR(priv->clk))
-- 
2.51.0



