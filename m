Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CBA0302146;
	Mon, 13 Apr 2026 16:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097154; cv=none; b=eQRo1gvI5DrXfYuaOxANjIy4IJVdH+kKCUuwRIZzVAhvn8ptqA974KU8E0MMuzQTKdbT68EdeFJmMhAyQUjJpTq9cOB4TnL43YQ8KYzu16g6RAmArAJKR3JqOfU2b/eXR2tGDLQfZTfS8ZeEakW5n3vcg23jD9j+tn90YO1zFnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097154; c=relaxed/simple;
	bh=VEG3Vtu/agrmzaKxUnifzj/13d5Ccl/IJu8MH1WPC74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OAnNv4i8oaz6NNs+TnIgV0hkg4ajjn0Zd2TTrAV45CmZQM/wahG0nn6UFZoqLj73Qjg4/jQfLeOyw9LVLqkRtDaAE9l5WwaBsuW+IFchjLnCmr+MLSBEOhAvyHh26RaggrQUKHrBI2gXt8xlFFJ43tlbDH+1J1J8w7MA7wv7/E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xpaBw0kk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xpaBw0kk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0CC9C2BCB0;
	Mon, 13 Apr 2026 16:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097154;
	bh=VEG3Vtu/agrmzaKxUnifzj/13d5Ccl/IJu8MH1WPC74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xpaBw0kkSR++SrXA6C3dZPzIYHuzoav/Y/N/kfCKDWZCkw0kq2SkjNGKdyMJrY2UZ
	 wF1gUzoHExMM5mntX/cjd4c+1N/bKUsETQpYATjKEI26cvfxVpYDu5BmnM87TZk9nA
	 PCRmQ5I8J1EUHfNpSM3kPQFaSnxAyzmddxuwrk0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Andreas Kemnade <andreas@kemnade.info>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 027/570] mfd: omap-usb-host: Fix OF populate on driver rebind
Date: Mon, 13 Apr 2026 17:52:38 +0200
Message-ID: <20260413155831.439368142@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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



