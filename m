Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA27932ED5C;
	Thu, 28 May 2026 20:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000330; cv=none; b=Y1zENWLXkJvSp3VWTkuZZlVi2gMNCG5aQkCfLLuQwA01SyWFO/3wIiU/GwsnmYwUemzTw/jOoWSjJq8m0qPNpL/d52+ZFweAs1dh8mveR2mPrpde0OsT65zhQQcWc3hnTWbxneuHR0AdDnnvuzEppn7cxcNqfwzez+vh1NIxkk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000330; c=relaxed/simple;
	bh=X+wI6lLdrAJJ04GpNdtaJVgCE6+breN9X84Ljrsbmmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gmsxtSqz2GlZZUTxVZq6O9EfMaHcnRTNUBme+g+oLcrqG9Ks9WgCLzA4Eluj72VfdgTgBsZrxXpR3YtC6zVWDiUdlYTA/tRgwxqpcNEfUBjvfLL436ZP1+rc5ujspKsjEd0nhGkwGKb7H5mjVWXJo2j0E9U3Qe6ZDDpUvHJ139I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mpOXhfOB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mpOXhfOB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3424B1F000E9;
	Thu, 28 May 2026 20:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000329;
	bh=3uRVX6r5zTN8trQuwiAqtW6sX7GDdWQ6ziWhKNJEsMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mpOXhfOBmhbaqtz4ora6EISyxt/7WXTmsaMIAX/uIEqdp8FddHc2xb+4oENvWvM/I
	 NyraqZTi5IPQMIDvTeBxV46M+fHULHppX6rj7i4etDFjAzHW7IlMdO2Bg5vwCD8xRz
	 vyN+w7ecd4GupkywgkSQSnd1TBwEeYKGouRVmjwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 358/377] net: ag71xx: check error for platform_get_irq
Date: Thu, 28 May 2026 21:49:56 +0200
Message-ID: <20260528194648.795884977@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index cbc730c7cff29..8e6bd99b22d72 100644
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



