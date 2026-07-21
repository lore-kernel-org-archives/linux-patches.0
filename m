Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ECE7471252;
	Tue, 21 Jul 2026 19:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660977; cv=none; b=kqDtklg+WR54K5WLYDvmKoHy6L8ibdJI+ZRz/FJuoXazAB2mTsVItDwsqIYERI5ReTXYACmHC0wwDxkNI2zB8Q5FzQvw2rHq5dLsled2eq/YtK0UFbn63gYBy6UUGuu2LEevxe0UBm4+EhBlSsY0dsADX0mFUrK3Cg+pbBX578I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660977; c=relaxed/simple;
	bh=kYoyPXxFIBAD+yJOa5783F5qhLj/0WJ7K3RXrYObLb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OMLTQHUnOAtAYoC5Ok3i0yK+Ld+rhBLuIBrGNIRaJ0+RIZP9jprhMPZdaKWDs7LJG+nillFaytfvj9E3mCd+QTLtFs9hiGf4xElso6KqAZFR+CLxzm/mo3w2gWWYf4ZdCwF55b34PQNvgdJtZQnz66tDWC5NP4zRHf03oO2yBOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SJFzrV75; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SJFzrV75"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9EE71F000E9;
	Tue, 21 Jul 2026 19:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660976;
	bh=PGvuJfDh3k24sHqjLfe5F0pvbfInmixFB6aOdZ6HHJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SJFzrV75twSGJb6tCBlxwiAqkR3A7IsHOZH+MPzz90mCbtWcmQqQEGtT+qWOgceux
	 kHb+JcPFd+1Hn0qPPKBjQuXKWjnjQrPZprgE7wlWFdOlNoMGqXvqSXHc9HHU8QIHrH
	 aJUtgDNzHm7/+wLtX85twj6rc4fQrzb/gGcFSGxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1183/2077] net: emac: Fix NULL pointer dereference in emac_probe
Date: Tue, 21 Jul 2026 17:14:16 +0200
Message-ID: <20260721152620.724271707@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit f623d38fe6c4e8c40b23f42cc6fe6963fa49997b ]

Move devm_request_irq() after devm_platform_ioremap_resource() so that
dev->emacp is mapped before the interrupt handler can fire.  An early
interrupt hitting emac_irq() would dereference the NULL dev->emacp and
crash.

Also remove redundant error message. devm_platform_ioremap_resource()
already returns an error message with dev_err_probe().

Fixes: dcc34ef7c834 ("net: ibm: emac: manage emac_irq with devm")
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20260618023405.415644-1-rosenp@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/emac/core.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/ibm/emac/core.c b/drivers/net/ethernet/ibm/emac/core.c
index 4e503b3d0d2d34..e1047915e101e3 100644
--- a/drivers/net/ethernet/ibm/emac/core.c
+++ b/drivers/net/ethernet/ibm/emac/core.c
@@ -3035,6 +3035,12 @@ static int emac_probe(struct platform_device *ofdev)
 	if (err)
 		goto err_gone;
 
+	dev->emacp = devm_platform_ioremap_resource(ofdev, 0);
+	if (IS_ERR(dev->emacp)) {
+		err = PTR_ERR(dev->emacp);
+		goto err_gone;
+	}
+
 	/* Setup error IRQ handler */
 	dev->emac_irq = platform_get_irq(ofdev, 0);
 	err = devm_request_irq(&ofdev->dev, dev->emac_irq, emac_irq, 0, "EMAC",
@@ -3047,13 +3053,6 @@ static int emac_probe(struct platform_device *ofdev)
 
 	ndev->irq = dev->emac_irq;
 
-	dev->emacp = devm_platform_ioremap_resource(ofdev, 0);
-	if (IS_ERR(dev->emacp)) {
-		dev_err(&ofdev->dev, "can't map device registers");
-		err = PTR_ERR(dev->emacp);
-		goto err_gone;
-	}
-
 	/* Wait for dependent devices */
 	err = emac_wait_deps(dev);
 	if (err)
-- 
2.53.0



