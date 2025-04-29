Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7FF215F6C;
	Tue, 29 Apr 2025 18:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950470; cv=none; b=ohtY8+V9NxEXHwf9m5juW+2GdHMPWhanDJ12bSA9qsjHgVDe7acLOXLfbD3cunZWcck1pty+F0tTZ0+h0Wn+fORxaVkYA3WSgJf63xEMhfXl3b36sEDe9v8R+XUqsZQG8maMIpPEiFGdTwKrrNjTmCb0b1Il6aWHaQ5hjfabtvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950470; c=relaxed/simple;
	bh=MSiJsWGOhUfIFOoq7PiRkCW7zQjJfEZSn0tXAHjqA/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SfDzGU0TY7a9/OX5aaQHTkhbCKO6knfZ+kpj7gsiobZUJ9YeGJ8/6MX+H+A5TfWY5XiXR/9SDgOiZNasUsay99t6f+RxexFRWi1EyMJIW19h7puZyB+V+Dq2apxGBp95ig3rEymBt+Bnu8+ToKjop55ozZXhtUIK78T5M2NA09A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=teB9PnFL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="teB9PnFL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4462C4CEE3;
	Tue, 29 Apr 2025 18:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950469;
	bh=MSiJsWGOhUfIFOoq7PiRkCW7zQjJfEZSn0tXAHjqA/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=teB9PnFL2sEQj0CEF6dpL1v2sC90MALxY1giUzmv65b5lVk00RQetyE0TjeDKVMqS
	 UpI3T7ypqMgrJmDFdmkCU+fV/7N3zrzOUIYbP7NWJBZZNhHEZkdYcQnZd3AT5Q8XAh
	 4lUcDt9hiSkM/eKhv1XsfyVx8XgU1/xd5fA/Kv7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 6.6 106/204] usb: chipidea: ci_hdrc_imx: implement usb_phy_init() error handling
Date: Tue, 29 Apr 2025 18:43:14 +0200
Message-ID: <20250429161103.767854763@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <pchelkin@ispras.ru>

commit 8c531e0a8c2d82509ad97c6d3a1e6217c7ed136d upstream.

usb_phy_init() may return an error code if e.g. its implementation fails
to prepare/enable some clocks. And properly rollback on probe error path
by calling the counterpart usb_phy_shutdown().

Found by Linux Verification Center (linuxtesting.org).

Fixes: be9cae2479f4 ("usb: chipidea: imx: Fix ULPI on imx53")
Cc: stable <stable@kernel.org>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Acked-by: Peter Chen <peter.chen@kernel.org>
Link: https://lore.kernel.org/r/20250316102658.490340-4-pchelkin@ispras.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/chipidea/ci_hdrc_imx.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/usb/chipidea/ci_hdrc_imx.c
+++ b/drivers/usb/chipidea/ci_hdrc_imx.c
@@ -472,7 +472,11 @@ static int ci_hdrc_imx_probe(struct plat
 	    of_usb_get_phy_mode(np) == USBPHY_INTERFACE_MODE_ULPI) {
 		pdata.flags |= CI_HDRC_OVERRIDE_PHY_CONTROL;
 		data->override_phy_control = true;
-		usb_phy_init(pdata.usb_phy);
+		ret = usb_phy_init(pdata.usb_phy);
+		if (ret) {
+			dev_err(dev, "Failed to init phy\n");
+			goto err_clk;
+		}
 	}
 
 	if (pdata.flags & CI_HDRC_SUPPORTS_RUNTIME_PM)
@@ -481,7 +485,7 @@ static int ci_hdrc_imx_probe(struct plat
 	ret = imx_usbmisc_init(data->usbmisc_data);
 	if (ret) {
 		dev_err(dev, "usbmisc init failed, ret=%d\n", ret);
-		goto err_clk;
+		goto phy_shutdown;
 	}
 
 	data->ci_pdev = ci_hdrc_add_device(dev,
@@ -490,7 +494,7 @@ static int ci_hdrc_imx_probe(struct plat
 	if (IS_ERR(data->ci_pdev)) {
 		ret = PTR_ERR(data->ci_pdev);
 		dev_err_probe(dev, ret, "ci_hdrc_add_device failed\n");
-		goto err_clk;
+		goto phy_shutdown;
 	}
 
 	if (data->usbmisc_data) {
@@ -524,6 +528,9 @@ static int ci_hdrc_imx_probe(struct plat
 
 disable_device:
 	ci_hdrc_remove_device(data->ci_pdev);
+phy_shutdown:
+	if (data->override_phy_control)
+		usb_phy_shutdown(data->phy);
 err_clk:
 	imx_disable_unprepare_clks(dev);
 qos_remove_request:


