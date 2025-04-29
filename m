Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D11EB216605;
	Tue, 29 Apr 2025 17:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949506; cv=none; b=FAyoivcYuxTzCheQeS+suqE+969MVLwZ5e8f371j1BtlTmnW3Qsa+nVujGbnqqFAaPVeceCrTE60a+I0GpZYI0qBJFeXU9ZRlbaISYe+EhG/QCkoODyiG7UgohtQbJ3wZi78B9QkJ2nvpm3KhqaQIauau8jGan445ycHiTZ3HgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949506; c=relaxed/simple;
	bh=h6AXX1zofSaBzuQPqFjJVSUV3T246lIKx+UIme0KeGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qEuLH5olcnHO2dUoHF6BZFOFFWeOIFsTF4RrpXQmAyY8oKQLBI+MTpRJBHXZUE8f6oTXuieJETznEdu2RnwEESKgB3jZFw/hFUjqMi3/1PrdpJ87LPu1ayimK1fd3yRinYDZmUdvtTldb+XN9raQlQaUwx7F7FWKnZUB7c1djeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=er+m39SZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="er+m39SZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EE2FC4CEE3;
	Tue, 29 Apr 2025 17:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949506;
	bh=h6AXX1zofSaBzuQPqFjJVSUV3T246lIKx+UIme0KeGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=er+m39SZDG1MG5DbGKXAjm3bLZjDKZuiHkUOGpZ4fhwGrkLLeYhx+BT9zboXs9ksu
	 m7trj45UYk8CgI8dbAh51UfhKs/JzG2kCzZrsgCSb3EETBE6HO69aoHqMcnn/+bQXU
	 X8rg47kmBZ0zaY9YlyKi3ccEPRonzt66nNPtjNl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 5.15 313/373] usb: chipidea: ci_hdrc_imx: implement usb_phy_init() error handling
Date: Tue, 29 Apr 2025 18:43:10 +0200
Message-ID: <20250429161135.983596332@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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
@@ -461,7 +461,11 @@ static int ci_hdrc_imx_probe(struct plat
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
@@ -470,7 +474,7 @@ static int ci_hdrc_imx_probe(struct plat
 	ret = imx_usbmisc_init(data->usbmisc_data);
 	if (ret) {
 		dev_err(dev, "usbmisc init failed, ret=%d\n", ret);
-		goto err_clk;
+		goto phy_shutdown;
 	}
 
 	data->ci_pdev = ci_hdrc_add_device(dev,
@@ -479,7 +483,7 @@ static int ci_hdrc_imx_probe(struct plat
 	if (IS_ERR(data->ci_pdev)) {
 		ret = PTR_ERR(data->ci_pdev);
 		dev_err_probe(dev, ret, "ci_hdrc_add_device failed\n");
-		goto err_clk;
+		goto phy_shutdown;
 	}
 
 	if (data->usbmisc_data) {
@@ -513,6 +517,9 @@ static int ci_hdrc_imx_probe(struct plat
 
 disable_device:
 	ci_hdrc_remove_device(data->ci_pdev);
+phy_shutdown:
+	if (data->override_phy_control)
+		usb_phy_shutdown(data->phy);
 err_clk:
 	imx_disable_unprepare_clks(dev);
 qos_remove_request:


