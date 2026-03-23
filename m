Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 782C4282F35;
	Mon, 23 Mar 2026 15:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774279441; cv=none; b=KYx44J8EhkOgpD+HieOIyoAEMWg6nTUmdCNY9B35FGf9RJftx9pf1A9gyW/LVpYFV/KSXikKlMxeeLdGjdVdj0RQJPyb7XUKPhpCOSdOBKD1Ir7akWTlAgYhXz9TnajhYdRwk+tC9OY7C3n1CyxRZCv9LPuj/FDqzRrK5nzsBvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774279441; c=relaxed/simple;
	bh=idCi6IcErsNwZxJmtewD7xWULV0vxi1eh7zU5qNo78U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HZS9xrePl3OrJ+yQJi6M3GMa3GijqAnIWXchwjLPQYlaXEAeW5ghqOkeGItX9xvvT4DzYraDcnaEPFkKT1HnRHl73mGddzQ6ohG4QvJRaNcVxhetApOWBFvAn4tbMyJqCwYiASb+T/AhY/I6hUZ0B8U/iGo9g/isYfzpFNMygeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NHz42L9i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NHz42L9i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 007EEC4CEF7;
	Mon, 23 Mar 2026 15:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774279441;
	bh=idCi6IcErsNwZxJmtewD7xWULV0vxi1eh7zU5qNo78U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NHz42L9ilYdKQci+Z0fxeas02x1jfvZQhZHOAY8jzvGknpdiL4WwvQoTYTAd9zpLP
	 sFaJECHvmpKmBKZajlOSzO6LjCnKc1/Aly/x3Xlz7HBke2mNRYcXpuIu8K/S3i6WmB
	 DislA+bYD/UQraTEpCeio3a5cZrQLyTqPxapWBQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Kevin Hilman <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 038/481] bus: omap-ocp2scp: fix OF populate on driver rebind
Date: Mon, 23 Mar 2026 14:40:20 +0100
Message-ID: <20260323134526.163550938@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 5eb63e9bb65d88abde647ced50fe6ad40c11de1a ]

Since commit c6e126de43e7 ("of: Keep track of populated platform
devices") child devices will not be created by of_platform_populate()
if the devices had previously been deregistered individually so that the
OF_POPULATED flag is still set in the corresponding OF nodes.

Switch to using of_platform_depopulate() instead of open coding so that
the child devices are created if the driver is rebound.

Fixes: c6e126de43e7 ("of: Keep track of populated platform devices")
Cc: stable@vger.kernel.org      # 3.16
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20251219110119.23507-1-johan@kernel.org
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/omap-ocp2scp.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/bus/omap-ocp2scp.c b/drivers/bus/omap-ocp2scp.c
index 7d7479ba0a759..87e290a3dc817 100644
--- a/drivers/bus/omap-ocp2scp.c
+++ b/drivers/bus/omap-ocp2scp.c
@@ -17,15 +17,6 @@
 #define OCP2SCP_TIMING 0x18
 #define SYNC2_MASK 0xf
 
-static int ocp2scp_remove_devices(struct device *dev, void *c)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-
-	platform_device_unregister(pdev);
-
-	return 0;
-}
-
 static int omap_ocp2scp_probe(struct platform_device *pdev)
 {
 	int ret;
@@ -79,7 +70,7 @@ static int omap_ocp2scp_probe(struct platform_device *pdev)
 	pm_runtime_disable(&pdev->dev);
 
 err0:
-	device_for_each_child(&pdev->dev, NULL, ocp2scp_remove_devices);
+	of_platform_depopulate(&pdev->dev);
 
 	return ret;
 }
@@ -87,7 +78,7 @@ static int omap_ocp2scp_probe(struct platform_device *pdev)
 static void omap_ocp2scp_remove(struct platform_device *pdev)
 {
 	pm_runtime_disable(&pdev->dev);
-	device_for_each_child(&pdev->dev, NULL, ocp2scp_remove_devices);
+	of_platform_depopulate(&pdev->dev);
 }
 
 #ifdef CONFIG_OF
-- 
2.51.0



