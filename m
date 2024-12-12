Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F7B453365;
	Thu, 12 Dec 2024 16:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022575; cv=none; b=SPCf4XN4mniJAV6+UZGyMNDzUG3DBnLQV9qKFooBxG0UEsYeovabXzqgsakC0P3tZwjVcZDmIm513AucLYOjtalH8HA9U3BWzv7hbyJbdbvabol9eL3u+fBtc+/mRaDZfxdmyHSyKnRarvxCvYMwse9r8dXCWp+nOe8TgRN5ndY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022575; c=relaxed/simple;
	bh=SEkrKTDDTtWByBt2SdPH52iXsXan90C7sWAUcSHZnPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fkDTP7SzIjY0qp/IuaPlvIa5NgffZECeUPyuqCfSMrGXDlfa7QHgZLlltUlZAEuJHiTGHROB9uo646xClqdaSTqCn3XqgGK5NhSunoa2FfTLVvHCaWNuEVUO7Wx7tqw6TnNO+gt5drpaJJ/dNNaTZzElbQjagdu1ffq14oiHuKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RCzRinb6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RCzRinb6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85C37C4CECE;
	Thu, 12 Dec 2024 16:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022575;
	bh=SEkrKTDDTtWByBt2SdPH52iXsXan90C7sWAUcSHZnPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RCzRinb6jnmaYGdbb/Lec2hm6VWjbhlnpQugCCX9legZBEKMGfFPonCom7E+bLvqM
	 juM6fPPL26FxDDurgl56fz3LbyfyA/HqkvsjkpX7yQgTbkkc2BItsgumezkfdNFpLe
	 iAsv6kzIuPsF7z8O2cLihENKcKKLEZeNoPBD9Ifo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 278/565] net: mdio-ipq4019: add missing error check
Date: Thu, 12 Dec 2024 15:57:53 +0100
Message-ID: <20241212144322.445264382@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



