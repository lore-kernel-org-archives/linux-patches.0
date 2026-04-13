Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D4F1D5AD4;
	Mon, 13 Apr 2026 16:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098591; cv=none; b=UMTHoFYg8a8ltbxCTC8oeFKxZeJQBE0fOAejG4A1bcIMaMpwirbFV4t+buJsJ/iFrNeNcKGOE4Kd6FDbfbAyiheOWRqk+7nCHfrATFgn2dzOUJ7KlAuYamQS0ZA5PQpumk2S+DzQRqeZXTxZZU1z/Kr/RF9S/0I/XAdhS3NQtAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098591; c=relaxed/simple;
	bh=fxoKLMTqTmlhz6qxDQFdZGS6XqgKFG+uXM59t+LlzHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N/xwKy0atmjzOBO7bWIVmpDK5isMglhuEsx9GPjgXLayTUG12w/DloId2EzqApUddtUH13vS354DYsRV5daXChXa79OMRsZvE7fvj2vlL5EGYIumAF5ynw2eueruQWfHtdlhim/CpG5TkahxHOvHHLvE4pHzvZzzbh5j2bjfK5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ddVU+1jx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ddVU+1jx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1027C2BCAF;
	Mon, 13 Apr 2026 16:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098591;
	bh=fxoKLMTqTmlhz6qxDQFdZGS6XqgKFG+uXM59t+LlzHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ddVU+1jx+tgIxYGYu2C9tv3NCYd30vDVlthy0rcIxcLv6p3hFUP6vxaDIdOtvcj1C
	 S9B7ZE4S/a1d7fqMRLuFA0cifv5vKQf892tyJnOx0NTFFz7e/LXaomui87w5V5aknN
	 avQYNaLBY63tLZQuUZH5dYYsH4hx/V0eh1x5qZ4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Kevin Hilman <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 013/491] bus: omap-ocp2scp: fix OF populate on driver rebind
Date: Mon, 13 Apr 2026 17:54:18 +0200
Message-ID: <20260413155819.548608323@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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



