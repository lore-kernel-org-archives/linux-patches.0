Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5033921FB;
	Sat, 17 Oct 2026 17:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258290; cv=none; b=k9KFMx/UgRo7yDXaUNZqmU+wqvwBrpF50K48DL8QKFUxiXMid/J46y9RMrAAvSxzs2mRhuLKnd4ewN4zHBA2JAjcjXb0pWiTmmqxlCfJ4vriPmp8WZvVnITLXJTduej8jQEGVJ6Vxm+1jgytL7elGiYSxLI2jZnj8WyTDc1mL+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258290; c=relaxed/simple;
	bh=zwfq0Gw8Uj8sWhi81CKg2QIU2ec1elubRSAddqAcvqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s0p5QpID35/PiU65Ikms/fWvISpxXYEVguKOfJ2e4/jbEWEsRcJ2cTZcAwa5iKDFx1HB+nCfvKtl8qhd+kwD5kWla9agsltRGtkXTLQGm0OY9lORnyAQPVsEcjUm82NGHaMaMH8B5q99npPWs3/sUZgJtjJQR+hKxXhpHVz1o6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O7zJjrrh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O7zJjrrh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E43CF1F000C4;
	Sat, 17 Oct 2026 17:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258289;
	bh=R0pLg8RMDarmXUllQKwV0tRD+u086bGUJmXPZ+C09+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O7zJjrrhbk0XHQ7j4Pu0gEdhGA9IamzkyqvNg9sQ5fMuguLZex2jLMy/73vQE3k5/
	 qyDqRNUuugVHEfa/EvG0aEVQdEFb6AWPGInrAi5zAosPB2E2PulZMPLm7gp2hkfZf1
	 7jHK4SZWsTU6ZKLq4AseiQ+qxm+xw+PdxV5NgYWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Duoming Zhou <duoming@zju.edu.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0834/1674] usb: phy: fsl-usb: Fix use-after-free in delayed work during device removal
Date: Sat, 17 Oct 2026 17:51:46 +0200
Message-ID: <20261017160452.537018889@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit 41ca62e3e21e48c2903b3b45e232cf4f2ff7434f ]

The delayed work item otg_event is initialized in fsl_otg_conf() and
scheduled under two conditions:
1. When a host controller binds to the OTG controller.
2. When the USB ID pin state changes (cable insertion/removal).

A race condition occurs when the device is removed via fsl_otg_remove():
the fsl_otg instance may be freed while the delayed work is still pending
or executing. This leads to use-after-free when the work function
fsl_otg_event() accesses the already freed memory.

The problematic scenario:

(detach thread)            | (delayed work)
fsl_otg_remove()           |
  kfree(fsl_otg_dev) //FREE| fsl_otg_event()
                           |   og = container_of(...) //USE
                           |   og-> //USE

Fix this by calling disable_delayed_work_sync() in fsl_otg_remove()
before deallocating the fsl_otg structure. This ensures the delayed work
is properly canceled and completes execution prior to memory deallocation.

This bug was identified through static analysis.

Fixes: 0807c500a1a6 ("USB: add Freescale USB OTG Transceiver driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Link: https://patch.msgid.link/20251205034831.12846-1-duoming@zju.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/phy/phy-fsl-usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/phy/phy-fsl-usb.c b/drivers/usb/phy/phy-fsl-usb.c
index b4984a24a7e0e..b60f70aa54a63 100644
--- a/drivers/usb/phy/phy-fsl-usb.c
+++ b/drivers/usb/phy/phy-fsl-usb.c
@@ -987,6 +987,7 @@ static void fsl_otg_remove(struct platform_device *pdev)
 {
 	struct fsl_usb2_platform_data *pdata = dev_get_platdata(&pdev->dev);
 
+	disable_delayed_work_sync(&fsl_otg_dev->otg_event);
 	usb_remove_phy(&fsl_otg_dev->phy);
 	free_irq(fsl_otg_dev->irq, fsl_otg_dev);
 
-- 
2.53.0



