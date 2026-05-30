Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E6A34A3C4;
	Sat, 30 May 2026 17:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162580; cv=none; b=RIis/S/csDDR/dwzEcfYxvnNWNnNJTIvK15fSUMiYPwIrqpDDlsYDhMQdAO6wwXc2rIf9oGJK6e3DtOLDpXULCCfUiw7IHKxtR88THWOS/T9caWysZx2Y307HIEPUkFEmFXXyVdUaCdHRYVgYWBVkct+PZgCALdezzkhIsW+yLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162580; c=relaxed/simple;
	bh=1Fr1S4EtGfH6zfSRivrioSw5rszcspkDG77xekpsNy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WM8romyDloX1FFmIg6jVCxKZ+PUag3GWZdisyrzqfKj3ftfOyrCpR4Y7RdisCcjAAnEgFTrG1RzukbARTuuX8CdfQxC7OFU/nQtzasbjueXmGQUcbYP8OkbE8lYEbcwXJVxZZ42ilP7o+XQRd3yESnowWTXoa8crJddVKzEv2BE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n7py3I4G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n7py3I4G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 032931F00893;
	Sat, 30 May 2026 17:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162576;
	bh=FCGZX21cAW17zIPbLGqrshqtOEB3fkIWAHJoLuzAVZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n7py3I4GFB5it1iifd4PG2f+LxsGgdAtzbJ0ZW+Xc0rBwELq4GnkZF47cnb9RKUKE
	 Vrw+OlwAwpV1EiGnEq+r2NvMEmpeVi66lOc3G5V4/QsbieSfGhZHfBX1S9v2VGSNHZ
	 4otg15+lIl/acqEfPxpBpLZXFUFUHFeZKyhGcEVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 964/969] net: ag71xx: check error for platform_get_irq
Date: Sat, 30 May 2026 18:08:08 +0200
Message-ID: <20260530160327.393720365@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ff93b00dcd613..c7b5b87362546 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -1880,6 +1880,9 @@ static int ag71xx_probe(struct platform_device *pdev)
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



