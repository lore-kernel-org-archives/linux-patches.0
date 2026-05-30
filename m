Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4802233D9E;
	Sat, 30 May 2026 18:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165180; cv=none; b=SL2VS0igFqVGChnlY0xznAK5X6H1M40mAtLsrAnvKOaE0FG8EUWDhnDQTR9gvAoR1KOGwYs8Eq2YMpxGTDjjdL2sFx2XDXUjJnFjfEFmwn+wtNHxdfcxzbatIqReIPMHQLLGrZEdQRYjWx7ucTlQZrRzFzdwgVZK1gW0ftiIAjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165180; c=relaxed/simple;
	bh=G1oSoEGVs7zWpQnupGVkdTWHr6eVOvNW9TJAv4G0gxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SFY8l2RLwYaetTDrNLdDgeFsO3eqSWv9MiP25VUjWY56Q7MpjyGApYKvEF6OJYREkJR1Ek0nXqwkek/NH9e2xQBnv9D/Vut5SObQTy0/P+NrPwiQ0K1M18+SxO1DS7X1mEcWrXxbElZWSC+dN2kxWcWc/Zrrs4hBvPfGQbe5swE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vogT7V8q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vogT7V8q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E837E1F00893;
	Sat, 30 May 2026 18:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165179;
	bh=v7b5T6ifJCKSQJk6uMk6XdjE5bkECw2kZn6Gfm6H7M4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vogT7V8q9FI+iOYwzZjMuVz7Qxzwk+QNBJ73HRoXPZH7C6jQ6xy5pThN02PhxJjag
	 Z3TZOtqupViJFiuGB8CQXyfU9ij+uxrG6wZKYaAVPxqbEnGSlXxpJ9lq1WkYl+Oycs
	 0z7x/8A1oT12oJaew+PlT4wTVelzjBYXAIsW78Ds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 772/776] net: ag71xx: check error for platform_get_irq
Date: Sat, 30 May 2026 18:08:06 +0200
Message-ID: <20260530160259.662169731@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d5be9ca4d4fed..411f94e95291c 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -1933,6 +1933,9 @@ static int ag71xx_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	ndev->irq = platform_get_irq(pdev, 0);
+	if (ndev->irq < 0)
+		return ndev->irq;
+
 	err = devm_request_irq(&pdev->dev, ndev->irq, ag71xx_interrupt,
 			       0x0, dev_name(&pdev->dev), ndev);
 	if (err) {
-- 
2.53.0



