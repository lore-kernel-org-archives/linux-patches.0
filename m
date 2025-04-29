Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D72A2517AB;
	Tue, 29 Apr 2025 17:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948024; cv=none; b=W9B3+pe+vVB/g7jhEyiPbVvI1GwEJ0tTJVWxt28wA8QZJc+6LeoTfOOl14UdulV1SX8qn69GNO4vOiy6T5NsD6pVgjVT9hSo/X6v77uuJI/aiBI1d624gWYD07JsbXjfkMxeUfQhUFMJtMLGXs1Gy73vqOmK3uQB577BgoCrVuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948024; c=relaxed/simple;
	bh=uB515YeIVJUzRhImaKnMJ2ggGVqu3UY2EcMkEBOiKHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nlhhQGPq+2rbvUYQYAfnDBdhVXDXEHZ5WXeI3gqf99t6fvkx5egTtMfLxfI9NBrI9EWsvgjkPyiskfD2W/PMG/un2fQzZwlUN5EV82fF/hBhbzhbMhqew5g/3Ql6ZEjz/JWx5KZ1peRe0Lk0xNh/sv2+Ks4VUwsmS4xpAWjSw3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TN3yuwXM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TN3yuwXM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB154C4CEF1;
	Tue, 29 Apr 2025 17:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948024;
	bh=uB515YeIVJUzRhImaKnMJ2ggGVqu3UY2EcMkEBOiKHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TN3yuwXMmGiEu2WhZXA8B181NbK1lBFX265Nty+qa8WCEISkk6iontK8/d9hi83m0
	 tp4fZkHuD11h2fnCzZQkH3Vr0KC7RG9h5SxAc8G5Rb/RbUqVIlbQb/ucpvqkn3vj9t
	 fXuDzb4r6FzdwdF/6yeT8QuJbMH4ST4qbl87TMmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 6.12 141/280] usb: chipidea: ci_hdrc_imx: implement usb_phy_init() error handling
Date: Tue, 29 Apr 2025 18:41:22 +0200
Message-ID: <20250429161120.895571482@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -484,7 +484,11 @@ static int ci_hdrc_imx_probe(struct plat
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
@@ -493,7 +497,7 @@ static int ci_hdrc_imx_probe(struct plat
 	ret = imx_usbmisc_init(data->usbmisc_data);
 	if (ret) {
 		dev_err(dev, "usbmisc init failed, ret=%d\n", ret);
-		goto err_clk;
+		goto phy_shutdown;
 	}
 
 	data->ci_pdev = ci_hdrc_add_device(dev,
@@ -502,7 +506,7 @@ static int ci_hdrc_imx_probe(struct plat
 	if (IS_ERR(data->ci_pdev)) {
 		ret = PTR_ERR(data->ci_pdev);
 		dev_err_probe(dev, ret, "ci_hdrc_add_device failed\n");
-		goto err_clk;
+		goto phy_shutdown;
 	}
 
 	if (data->usbmisc_data) {
@@ -536,6 +540,9 @@ static int ci_hdrc_imx_probe(struct plat
 
 disable_device:
 	ci_hdrc_remove_device(data->ci_pdev);
+phy_shutdown:
+	if (data->override_phy_control)
+		usb_phy_shutdown(data->phy);
 err_clk:
 	clk_disable_unprepare(data->clk_wakeup);
 err_wakeup_clk:


