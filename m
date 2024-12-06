Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88DBC1FCCFB;
	Fri,  6 Dec 2024 15:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497829; cv=none; b=r1Vyx+N+QaMOilkFSNFFwFE1fAZzLnCNJQNgwIZQ3+QG2XXOJrTCHydyGUjLxfvkUkmWkIUPAGr8xHHVMvXPI8JD9+bXl1jT1Y2DqbMApnWhKxt3/7HORgvIC70fnUFXKC30ZJfLJbZRT8hOri6tMzdUrOZIQ6JGRYB+siQ36/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497829; c=relaxed/simple;
	bh=AdHxP35k0lppStz8xU6DR2u1L2SrgV7mmhunPeKW6iQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eU0GI1b0P54Q1jeZ3dmbPRm9j1xT2ujcN8bW8GQleA0TJymxjetB3igeNmijSw1wGn3X/JoDm9i4gBjHxLIcWbuCTRmzmm2OuZpGWn+NrGFbi4Taa/vrFiP1jRssJ/DK1qWJ+31/gNZHf4d7CKpel5R6bQnWMzvLPSqNxCUfHnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dR8kr/eR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dR8kr/eR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB48FC4CEEE;
	Fri,  6 Dec 2024 15:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497829;
	bh=AdHxP35k0lppStz8xU6DR2u1L2SrgV7mmhunPeKW6iQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dR8kr/eRUx6hsrUa2KslYbO9/rZ7w/4yI7Sb/GWN8jHlwiZxtPbAKJyQrRwrrtQws
	 2F+fXhkIjSa9o6bwv13Llq3izcC3309w0Ax3nsJUYT9RdP04/AjOGBRyIYsCfPJSBa
	 WCKzpsXXYUCz0p8JFzDwBevbNK1eRc6l4Owevotw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 405/676] net: mdio-ipq4019: add missing error check
Date: Fri,  6 Dec 2024 15:33:44 +0100
Message-ID: <20241206143709.167958041@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 9cc8d0ecdd2aad42e377e971e3bb114339df609e ]

If an optional resource is found but fails to remap, return on failure.
Avoids any potential problems when using the iomapped resource as the
assumption is that it's available.

Fixes: 23a890d493e3 ("net: mdio: Add the reset function for IPQ MDIO driver")
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20241121193152.8966-1-rosenp@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mdio/mdio-ipq4019.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/mdio/mdio-ipq4019.c b/drivers/net/mdio/mdio-ipq4019.c
index 78b93de636f57..0e13fca8731ab 100644
--- a/drivers/net/mdio/mdio-ipq4019.c
+++ b/drivers/net/mdio/mdio-ipq4019.c
@@ -255,8 +255,11 @@ static int ipq4019_mdio_probe(struct platform_device *pdev)
 	/* The platform resource is provided on the chipset IPQ5018 */
 	/* This resource is optional */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	if (res)
+	if (res) {
 		priv->eth_ldo_rdy = devm_ioremap_resource(&pdev->dev, res);
+		if (IS_ERR(priv->eth_ldo_rdy))
+			return PTR_ERR(priv->eth_ldo_rdy);
+	}
 
 	bus->name = "ipq4019_mdio";
 	bus->read = ipq4019_mdio_read_c22;
-- 
2.43.0



