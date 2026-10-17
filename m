Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E65C202F70;
	Sat, 17 Oct 2026 16:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254686; cv=none; b=DLWN0wnkNw85jkxx7Ucoe0H0KL5Jo6wwlMpNDfJw9fCw8MVNSgbLxa0gDTUTIwKL7Z5k9mAIip94jkKxlJMZjGekQw8GUQfsFlchAPuiOAaXZi35OdTPRWk0rfCkpQ+FOy0CQU9y5VphojoY8R2qhy9jw5PniCaMgR49bBsAuhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254686; c=relaxed/simple;
	bh=MXKhNZp/M4L825ZHsEPQqToMlA6KhsWXGJcxGkCuauo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cHG+e/LSU2+nqiEFsOdeJtljwxmVxaIWBtvbYxvpGL0/v6QOUWBbDbwNx/kJOXzjuY8xagxGI6rSknLE9yrU4rrgfnRs59SKxwJHXyPMAxKfwmsykQaSdn9Lzd8SodAKKx4bMgy0Ogis8h7Qittznf7EBPPjmHL3xbyeuLf7NHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BO3z1KeT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BO3z1KeT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B94AC1F000C4;
	Sat, 17 Oct 2026 16:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254685;
	bh=vOtFlQ0tw0UjLIiIkcGVnyATVPO2RC51HI5zQVFPZmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BO3z1KeT8DiIv95dwU9LVv6CHSAA0xQHu8GPfruG0CxpPx0xoEcGorXnGRR2qGKdM
	 UB5n/9HTtbSWEo/Q4NJ+0Qxg55HoJa8JkwBc5MIWOykXR3pam8WXLCV/XI/8MmEIPN
	 j3P76PwoHVr0FfGLRSKTxMPgRMR85s92LEIleFKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 529/869] net: emac: Fix NULL pointer dereference in emac_probe
Date: Sat, 17 Oct 2026 17:56:10 +0200
Message-ID: <20261017160050.672627502@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7999d0b8caaeb..e88117add9129 100644
--- a/drivers/net/ethernet/ibm/emac/core.c
+++ b/drivers/net/ethernet/ibm/emac/core.c
@@ -3030,6 +3030,12 @@ static int emac_probe(struct platform_device *ofdev)
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
@@ -3042,13 +3048,6 @@ static int emac_probe(struct platform_device *ofdev)
 
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



