Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F460352096;
	Tue, 26 Aug 2025 14:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216842; cv=none; b=ifZUVAxnJ32/0DKhckD/cIsgez9EtFmoYtrhEpc/BYzU8Aik1tcA4OfSuLgA909Bl5RbLny4wlnHxVfU6CHAJhSwP0dHUrYrw87V41biNp+DOJ5OZ2STn1pwXf7R6Tvsdf78ZrNL8pvq8lqY5G8+oXIsi+QlSHD2fXUl9BL4YSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216842; c=relaxed/simple;
	bh=SHFGwEaY2gdCOsq3D0O3M5LxsO0sdcjlNBU9lxmD4ao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ya+oFzQoTihjo/ML6OOONogfvd1Kp0OA/ghWvFBllhseQAFUSq9wazPFEbzF0CUPnQNJaFnhGHFoVg364dtwQ7GoC/LwBmFtrdVvHtrHSZvN7Ofp2a/dhZ1tu0qT6aozM4dvQMx0Y0AD1EhZAAIkR4QvruZX0cT0Vb9N+hLMQFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=meLMyd9S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="meLMyd9S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 256C7C4CEF1;
	Tue, 26 Aug 2025 14:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216842;
	bh=SHFGwEaY2gdCOsq3D0O3M5LxsO0sdcjlNBU9lxmD4ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=meLMyd9StUYHMaj7OyDu/9MsqxyV3hnGhG7qLL5DppcEs6EuEUhxgt55P/D8sOTP7
	 6G0WC/PZxQilDRSCDvm3aokQRn5eQG6TMVfQWvTBiSc8txbxV79fu/2aowUGQAEWsS
	 g3wUqwPwLheh8cc/TUxKy8O8RAz/d5erNAIBJBpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Jun <jun.li@nxp.com>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 536/644] usb: dwc3: imx8mp: fix device leak at unbind
Date: Tue, 26 Aug 2025 13:10:27 +0200
Message-ID: <20250826110959.797233447@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit 086a0e516f7b3844e6328a5c69e2708b66b0ce18 ]

Make sure to drop the reference to the dwc3 device taken by
of_find_device_by_node() on probe errors and on driver unbind.

Fixes: 6dd2565989b4 ("usb: dwc3: add imx8mp dwc3 glue layer driver")
Cc: stable@vger.kernel.org	# 5.12
Cc: Li Jun <jun.li@nxp.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20250724091910.21092-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-imx8mp.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/usb/dwc3/dwc3-imx8mp.c
+++ b/drivers/usb/dwc3/dwc3-imx8mp.c
@@ -183,7 +183,7 @@ static int dwc3_imx8mp_probe(struct plat
 					IRQF_ONESHOT, dev_name(dev), dwc3_imx);
 	if (err) {
 		dev_err(dev, "failed to request IRQ #%d --> %d\n", irq, err);
-		goto depopulate;
+		goto put_dwc3;
 	}
 
 	device_set_wakeup_capable(dev, true);
@@ -191,6 +191,8 @@ static int dwc3_imx8mp_probe(struct plat
 
 	return 0;
 
+put_dwc3:
+	put_device(&dwc3_imx->dwc3->dev);
 depopulate:
 	of_platform_depopulate(dev);
 err_node_put:
@@ -211,6 +213,8 @@ static int dwc3_imx8mp_remove(struct pla
 	struct dwc3_imx8mp *dwc3_imx = platform_get_drvdata(pdev);
 	struct device *dev = &pdev->dev;
 
+	put_device(&dwc3_imx->dwc3->dev);
+
 	pm_runtime_get_sync(dev);
 	of_platform_depopulate(dev);
 


