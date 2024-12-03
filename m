Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B451EF0AE;
	Tue,  3 Dec 2024 15:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239346; cv=none; b=cX0qiP7c2Utz/y/3ye6NXRGiZGixCdFbrxZ7VeHogKJwVZiTPtuS/ANGqs1dDTEdzjhenH9C48DZl+v8q1s/YdWRnB3Cq4odlqsU3TnOzjBara3mUsCEd2c0Ln3VpBDBDWoRmoY3wrsG2EhxP99bihUTNMxEyjIafL7UlOUkiyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239346; c=relaxed/simple;
	bh=drmQEq1YzuAfmNPnLPE97JETLZHHDnrnwvS3AwvQvN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JF0z7bEuHro8Lb+4pq77SUVeEifM7yx50SAmW+2hTLJ6IACbAPDZoxOsxdXCoR+OORx2w+rbd42/vm4IrYPRpYe1B1NzoJGwOOvjY1w4UjagP4aLazY6VKWF+erC2yLnWq7Xos6HIJw0iZDbxm/TY7twLMRh9rQXpwvUl9Zj3ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sIvTqjbo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sIvTqjbo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39A31C4CECF;
	Tue,  3 Dec 2024 15:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239346;
	bh=drmQEq1YzuAfmNPnLPE97JETLZHHDnrnwvS3AwvQvN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sIvTqjbo1EI+tFXZC2+s507JO0ZVU0ugW3FyF30bSeaweqf2vERjCPme2gXjJEUGc
	 oiTpSdpS82pmicIj+cpPGrSgJXjOmz1HxwPh1y5n2+riuJVMxo+0SEgr6qJKfkh4UU
	 fqt26qqjXxA5eEEE/Zl/0DUYTMuRRraB/1GvSDIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 575/817] net: mdio-ipq4019: add missing error check
Date: Tue,  3 Dec 2024 15:42:27 +0100
Message-ID: <20241203144018.358282494@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



