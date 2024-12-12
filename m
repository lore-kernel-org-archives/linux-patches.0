Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44839236F9F;
	Thu, 12 Dec 2024 16:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019839; cv=none; b=DU/hQsQlkW/DWh+EXiLPEJtknxSscWl50MBca0/UHySucSSTet8kopaSk5Yq0qOLHENpfEyBFYPe+BjE2xhx8c7rOswOBpIcG/MfttYF4GeXxuN7qLJLBnuFeElbwoYtlVvZ8+eg+8jCg9fSe2rGjmYjGUf0uVdlKN3NlgvOVG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019839; c=relaxed/simple;
	bh=IK08f0/h4AWk78a68L4Nr8HBH6zxSh2ocxmP/7vZyJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pXoagZ+UvRvso6Zvzie6NNFSAGUk7RBbM0NBNWSnRV9aXWFqynu450RBM9i+XTPXv7lsSprGMXr4Nrd9ieThyl/VnAGdCLknf1F0OCQsX2QfUWnPiu49pJ71tbTPcmcBmw0BN7OEq4uKSQDcgCh9JsTUXMlwcYJsx38ycp/ZFaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DwgFRXfN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DwgFRXfN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7C8CC4CECE;
	Thu, 12 Dec 2024 16:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019839;
	bh=IK08f0/h4AWk78a68L4Nr8HBH6zxSh2ocxmP/7vZyJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DwgFRXfNTYY1H5q3wX8/pdZAFxOXjQcf7Tm4gseWjMt/brq5DRnQ+vtIVqiJ+heWt
	 vZlZE4fB2bdJyMqwqJVDyaFpZKT0bBq8R6aSxTVbVWHUg3VclAwK8wvm6tqw8zgPod
	 8iEP55f10gmfrH9pp6kM63sUh9jaFAo7FMdYBk5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 311/772] net: mdio-ipq4019: add missing error check
Date: Thu, 12 Dec 2024 15:54:16 +0100
Message-ID: <20241212144402.747209190@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4eba5a91075c0..da5dc854b6ca6 100644
--- a/drivers/net/mdio/mdio-ipq4019.c
+++ b/drivers/net/mdio/mdio-ipq4019.c
@@ -231,8 +231,11 @@ static int ipq4019_mdio_probe(struct platform_device *pdev)
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
 	bus->read = ipq4019_mdio_read;
-- 
2.43.0



