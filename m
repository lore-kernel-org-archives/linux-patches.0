Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B20B2D9ECB;
	Mon, 23 Mar 2026 14:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277697; cv=none; b=AcCfHrfCMDNDwWFwyk75vciBc+l0ifK0JRFj3cQt0+CPBHSRzs3HLD9YXHh8Ce/KG8RDYq258zKLh7X9W4tU7K2jgL/XXHvTJmMabtOumyrS6nMW4YjSQGBExjfef2xEc+MG1AcRLf7KwkdNOk251sBNPpUldK+y4vZSOSfPF+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277697; c=relaxed/simple;
	bh=SFbVg+rxA/BVF4kX3itQ7wHB5SU9BaZSFYt78vTo5V0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M7FNKYLWfgk4yKRLxSP0wyiToqmdZX45T3za7KNZ9TmHurSizilBzE0YZm7nVCULNDWzYace0cfcDT2UV9ImIxDILnh4kx9ehyJKBnnJzyHmXwDqXxufXrvc1FjTVDyPg3c5GYWBDUHlhdc+hdj6yaBnZGsc5MpBdXH4KG6Gp5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rfPXOBzj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rfPXOBzj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C493FC4CEF7;
	Mon, 23 Mar 2026 14:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277697;
	bh=SFbVg+rxA/BVF4kX3itQ7wHB5SU9BaZSFYt78vTo5V0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rfPXOBzjWichBY9xr6Kb6kiyoKp/aHpuY+Mx0pd6mn4aKc7P25RmMuex57NFkGFSO
	 jn5auGcqMJ9pASFij+fREoRHtp1M45f5F+E8XxRvTVa5QwxLC+MncLWk/Li7Ngk62d
	 8uueccTvOcxd5afuftX99AZsmbMQF8q3PeZpVNus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Andreas Kemnade <andreas@kemnade.info>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 074/567] mfd: omap-usb-host: Fix OF populate on driver rebind
Date: Mon, 23 Mar 2026 14:39:54 +0100
Message-ID: <20260323134535.660848541@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ebc62033db169..e3aae10295a15 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -820,8 +820,10 @@ static void usbhs_omap_remove(struct platform_device *pdev)
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



