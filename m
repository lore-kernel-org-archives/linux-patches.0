Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C022132ABC0;
	Thu, 28 May 2026 20:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999161; cv=none; b=K3dLqe4jdNcdIsiaP//v+S00yDNxvIuawS4C4B3LJMg5C9qvR9TlWpEhfNYRMTp55og1UOm8PRK7JLq3scBEQEvwkQee1/4DrHHkweofu69ZLfOoexS5sqo/owC6uxjwfnCv84adtf9WvDCnR2lKSWEDLLCkzMp6PPby7kTF6+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999161; c=relaxed/simple;
	bh=LwYwzTtuZscKK8tS0rqvlf6te6mryVL8J/+wryjA/0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OQQPp0zYHLNUalWuGhcIwL6byTVySdId9M2U83aMvphUTCT9yw+bx994hkD8e9PbdDqDOk2axLTitRrRnEH4U1m24lpz/PtUvxUjrtpTgZ0X/yha/x7QCTobz05cjREqqEmhHRXB/cx6gJrgrUgGIje/e524OItwzBmGHM8iQ/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NQDsoBv6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NQDsoBv6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A97D1F000E9;
	Thu, 28 May 2026 20:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999160;
	bh=H7ENhhrbyZxLlQ7d6g+ByjtfB2HdnYHgJuaW8R3FWec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NQDsoBv6JDBtA0ftUm5EcWWgEnS0fi0ueHxEd5c8nSbS+jELgHpbbPLvE3/NnPr/O
	 hOnPCidNMdUInThtplVnYSwRN6Rxq7uIXqTQ8p1Hl1F7AFsKXLCWpWmv7s71BrCjff
	 HE3QWEe4Kz9spBU9BHPOXYOa7CPbPfDuf+smq2kI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 429/461] net: ag71xx: check error for platform_get_irq
Date: Thu, 28 May 2026 21:49:18 +0200
Message-ID: <20260528194659.938356712@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit e7c70bf97e90d974cd575e4c90f8f9b07d056da3 ]

Complete error handling for a failed platform_get_irq() call

Fixes: d51b6ce441d3 ("net: ethernet: add ag71xx driver")
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Reviewed-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://patch.msgid.link/20260516212616.11758-1-rosenp@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/atheros/ag71xx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
index a5ab994741790..4e4794c4dfdce 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -1856,6 +1856,9 @@ static int ag71xx_probe(struct platform_device *pdev)
 	ag71xx_int_disable(ag, AG71XX_INT_POLL);
 
 	ndev->irq = platform_get_irq(pdev, 0);
+	if (ndev->irq < 0)
+		return ndev->irq;
+
 	err = devm_request_irq(&pdev->dev, ndev->irq, ag71xx_interrupt,
 			       0x0, dev_name(&pdev->dev), ndev);
 	if (err) {
-- 
2.53.0



