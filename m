Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E04141F76D1;
	Tue,  3 Dec 2024 16:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241964; cv=none; b=EKdjrSIAQ+fuDreN4HFyUEnJdEnai4QJr1eQiOEKo8pTVl6Jc9L8HbYH3/P3u8jNRrUAbLK+Z61FVTIylSbbnvCg0v4L2boZtO0VXmumuc6luUbzxhlTqZkg1HyJhix+uwxdyLxZtv5pIx5S6VQHYVMdwKRkPFcQ2GyX9PTe9LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241964; c=relaxed/simple;
	bh=GLp/g5LjPv0HIgs9UTKyDHFN314i1fMP161mGltO6fA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rGMt125+KDip5AyTsc34LCsByli9ZAG2JCMuut60oIzmjVf0gRF7yBrO3XgYlFf0zcyYp0/0Sd4FGx2apJgDpeKD62ITubF20+ePgpr+BgplFsO2dsSZLpGzBvGExdL2MnAbCM8xZvoCgkQt+y1ndoLLz0uak7O/QsM3/90u9lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UYh+2gD0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UYh+2gD0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1173C4CECF;
	Tue,  3 Dec 2024 16:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241963;
	bh=GLp/g5LjPv0HIgs9UTKyDHFN314i1fMP161mGltO6fA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UYh+2gD0T3mu1/I/owc1CpEop2LNDZ6JgBc7HsWXBVQK8Bd9kOHoU82UybYnhXG1q
	 wNUNk70e+eWZqPWFQZasfhSw7FDcXIJ31iH1ajUjMss0+ykcTsGYyQvuGf3VfiJIo5
	 prJeV1yxmHyAiNe4Ug5sDFaje5Ji/QyxGTOOqAo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 567/826] net: mdio-ipq4019: add missing error check
Date: Tue,  3 Dec 2024 15:44:54 +0100
Message-ID: <20241203144805.864286844@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 9d8f43b28aac5..ea1f64596a85c 100644
--- a/drivers/net/mdio/mdio-ipq4019.c
+++ b/drivers/net/mdio/mdio-ipq4019.c
@@ -352,8 +352,11 @@ static int ipq4019_mdio_probe(struct platform_device *pdev)
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



