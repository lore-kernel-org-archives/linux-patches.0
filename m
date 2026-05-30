Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7554D26FA60;
	Sat, 30 May 2026 18:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780167174; cv=none; b=CX4vszND7Hk+3EGbJUv3B7Gk8FLbvC0hkbSwTblCFodso1ysnTfEe0wlQAHAVG7BYCx23NdgDYaWEZhBVLJ/kEWDmGiU0DxvDlZPufcmKPv2ln6DnUPbO72SW7kdsA1omayjhhb80DrYyAllB5GmhBtM1Cqwlq9B5FzWlAxSBdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780167174; c=relaxed/simple;
	bh=Hu2+bRf5cQMOcRvDIf49+LCjnB0k2qxYc7up5R4j0NM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mvWmM5buL/7LMGsDnOcNrD2FQLElSBwi3X+g/WUpH9f1Ijntd9gm1JnrnannOGjnvAoafUgoH0B3PI9DtvwbQrl7ZzP02h/T3Z7sFkXO+aZmNK5UFvTICCIwu6IYfvaSzTt4PtYVhEWFB4+46M8rUhPEAoTsAtHdDHOUQa7Hwj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k5tCCzkC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k5tCCzkC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B6B1F00893;
	Sat, 30 May 2026 18:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780167172;
	bh=7AsbRhi2hQ3JWbCVdNCwqL5Al721Y0Z3U+N/CLitTOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k5tCCzkCGPYsGN9bBv8G6OdKg+S0srAHCAt4ThhbNGnDYhet7wpjEJc+IgS0HCmsD
	 kIRFsw6dftw/vrXQq9PrMVvwea0D+a5n2y4esVoH2RQa/pIl5rjnL6TteaCnTeMiw8
	 4H9Yb8sHbkEJ4vK5vN8Tf6VaRX7D+eKBw9KvxLC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 585/589] net: ag71xx: check error for platform_get_irq
Date: Sat, 30 May 2026 18:07:46 +0200
Message-ID: <20260530160239.966946513@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 67409a53d5100..a406e8ac2f612 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -1922,6 +1922,9 @@ static int ag71xx_probe(struct platform_device *pdev)
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



