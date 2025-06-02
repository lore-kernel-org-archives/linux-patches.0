Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A507226CF0;
	Mon,  2 Jun 2025 14:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875134; cv=none; b=uadGIV6JKlfaQ3cTYcqfzcJbojmjvClxbGuerZd3eUUB61jpC8X6NejLp8pxFJh98ITnBn4XOiVXTvgwAmXeoOKoImpJwSMImlb6A6+NfrL0Fh9OlXtEH39XX4BdV7JAfJg9xwFFjBtXTNaUQ2ru/NjQaKQbN2Oc0yABHQKUAiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875134; c=relaxed/simple;
	bh=LHbpd2W7AOTcqh9z3M28gg89e964uDDHrNN+v/VuaMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MNBZwNB2mqhvX4UiTeCWnyan3yoo9Wp8BrkvUAtj/NBiQipjgygzCqje8h1Rc5WyhHCqfUEbBZE2vJYWeCmLDpLTf+Dz52bfNWC0MbbrEy+8Wts5xw4w1Vl++gB7EX+aHUbtV5nKRHUcLocKi9dCFlajJt/JdiZ5txf+5Tp3e8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O1zIqn17; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O1zIqn17"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17EB5C4CEEB;
	Mon,  2 Jun 2025 14:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875133;
	bh=LHbpd2W7AOTcqh9z3M28gg89e964uDDHrNN+v/VuaMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O1zIqn17NlAC1S+58nNxcRMe+e1oWzGNci96kkpuH/n1xEEVCZgMrz+5GstAHvzwg
	 IrhNR9q3kREak3Z8NKWeNylhginTUktZgPPo64DWRUkVWsS5tgop7NIPbeJ+BTnYDf
	 0a76+x9b+qg+HfqGdhiRv0kMXZoH8HMeRCuSFUZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Peter Chen <peter.chen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 039/270] usb: chipidea: ci_hdrc_imx: implement usb_phy_init() error handling
Date: Mon,  2 Jun 2025 15:45:24 +0200
Message-ID: <20250602134308.785976794@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <pchelkin@ispras.ru>

[ Upstream commit 8c531e0a8c2d82509ad97c6d3a1e6217c7ed136d ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/chipidea/ci_hdrc_imx.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/chipidea/ci_hdrc_imx.c b/drivers/usb/chipidea/ci_hdrc_imx.c
index abe162cd729e9..03d883f5a4cc7 100644
--- a/drivers/usb/chipidea/ci_hdrc_imx.c
+++ b/drivers/usb/chipidea/ci_hdrc_imx.c
@@ -446,7 +446,11 @@ static int ci_hdrc_imx_probe(struct platform_device *pdev)
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
@@ -455,7 +459,7 @@ static int ci_hdrc_imx_probe(struct platform_device *pdev)
 	ret = imx_usbmisc_init(data->usbmisc_data);
 	if (ret) {
 		dev_err(dev, "usbmisc init failed, ret=%d\n", ret);
-		goto err_clk;
+		goto phy_shutdown;
 	}
 
 	data->ci_pdev = ci_hdrc_add_device(dev,
@@ -464,7 +468,7 @@ static int ci_hdrc_imx_probe(struct platform_device *pdev)
 	if (IS_ERR(data->ci_pdev)) {
 		ret = PTR_ERR(data->ci_pdev);
 		dev_err_probe(dev, ret, "ci_hdrc_add_device failed\n");
-		goto err_clk;
+		goto phy_shutdown;
 	}
 
 	if (data->usbmisc_data) {
@@ -498,6 +502,9 @@ static int ci_hdrc_imx_probe(struct platform_device *pdev)
 
 disable_device:
 	ci_hdrc_remove_device(data->ci_pdev);
+phy_shutdown:
+	if (data->override_phy_control)
+		usb_phy_shutdown(data->phy);
 err_clk:
 	imx_disable_unprepare_clks(dev);
 disable_hsic_regulator:
-- 
2.39.5



