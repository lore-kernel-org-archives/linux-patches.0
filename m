Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43380242D70;
	Mon, 23 Mar 2026 15:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774279721; cv=none; b=c9nG1RDxIDKBeOlR3GG1FBRFFLPuK4kuLvDI3IESRUTK+tMQyDMkTOqt6Pdj8otbsdekeeaV9/ufaNR3M3q53wv4WqNcsnFoW3y0rZf9mraf+koLpt3QVPAwCPLGdtqfIpXsURmVL59cPObIWZWZvzlzOz+pw2SDsss7gXhD+bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774279721; c=relaxed/simple;
	bh=Gt3/1E6/ucbcPbHCYkylBpcmrI5zXtjfQSj1FODnBGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l3PqqsNLRmOm+v3TNMp9qRQabHGaZTGsY6UESr7DtPl4Uoc2o8zbJmtZR2b/IXqn3hkYEs35OIrnOTPrABxRj7mT25D9pSH41yM5G0va8BMl6z29frb7l8q1Xol+udy2MF6hU5/lkAO4D/264e/ZjoMsd5Lu3w9fvtEm9RGBPWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=laYRINop; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="laYRINop"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DFD1C4CEF7;
	Mon, 23 Mar 2026 15:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774279720;
	bh=Gt3/1E6/ucbcPbHCYkylBpcmrI5zXtjfQSj1FODnBGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=laYRINoplwTod12jG5VmUFT9Cl9idXLJY+s9jXdRpirO7UeTR5rIgIG5/Y9CERey5
	 rOIBJWE76M1veYV/ZQ6+a+Kn/MD7k0f/nEzBcrycQYortEjeI32f2Pv0NvXITeX0dc
	 ra4gJyT3WODil01vO+tMFwL6n2QlS0Pj1b65IJgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Andreas Kemnade <andreas@kemnade.info>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 057/481] mfd: omap-usb-host: Fix OF populate on driver rebind
Date: Mon, 23 Mar 2026 14:40:39 +0100
Message-ID: <20260323134526.611801319@linuxfoundation.org>
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

[ Upstream commit 24804ba508a3e240501c521685a1c4eb9f574f8e ]

Since commit c6e126de43e7 ("of: Keep track of populated platform
devices") child devices will not be created by of_platform_populate()
if the devices had previously been deregistered individually so that the
OF_POPULATED flag is still set in the corresponding OF nodes.

Switch to using of_platform_depopulate() instead of open coding so that
the child devices are created if the driver is rebound.

Fixes: c6e126de43e7 ("of: Keep track of populated platform devices")
Cc: stable@vger.kernel.org	# 3.16
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Andreas Kemnade <andreas@kemnade.info>
Link: https://patch.msgid.link/20251219110714.23919-1-johan@kernel.org
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/omap-usb-host.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index b61fb9933aa85..936faa0c26e09 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -822,8 +822,10 @@ static void usbhs_omap_remove(struct platform_device *pdev)
 {
 	pm_runtime_disable(&pdev->dev);
 
-	/* remove children */
-	device_for_each_child(&pdev->dev, NULL, usbhs_omap_remove_child);
+	if (pdev->dev.of_node)
+		of_platform_depopulate(&pdev->dev);
+	else
+		device_for_each_child(&pdev->dev, NULL, usbhs_omap_remove_child);
 }
 
 static const struct dev_pm_ops usbhsomap_dev_pm_ops = {
-- 
2.51.0



