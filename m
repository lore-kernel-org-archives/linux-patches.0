Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B64671A9FB0;
	Wed, 21 Jan 2026 18:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020155; cv=none; b=Y7/bPTeYha0fAmCNkWtLkw0Vd/+iQqX8Urm09s6KjGp7XXV0zpyX79gycoc3PQH1UOVQ8F5bExSOGk81V6u/JyTdZBRPvutHSjiPmSSGZTLMp9/jN8WMy4hYsvbtuQKTg4Ts+9ZYxkLUpA457xWLCQUHX9mGUs/1dlyvlGvOJBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020155; c=relaxed/simple;
	bh=sTv2lI7i+MPPd3Ot7W2jjGUSJ2bA0PL6vwqkYG7TPKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t6Hx/N1EokEZRTwqmH9xZ43SEbdrCEJIrXNE4c33OMudKJRfSGTUZnsfUyJrnVF9256K5LkVQUnEGogtflAssiPsFc544e3ch+KOr6iEIaikAZfSheS/mVPoaxOQ5dqglrFb4c+QPmDQsLxbnfrDNAXXmZts6uVyAX2jy8aBnWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RrD9zUUt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RrD9zUUt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2814DC4CEF1;
	Wed, 21 Jan 2026 18:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020155;
	bh=sTv2lI7i+MPPd3Ot7W2jjGUSJ2bA0PL6vwqkYG7TPKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RrD9zUUtRZnX420hCQuEs8L8auFxCEI5cAQ70Xj9+Kw/JM6AFfB4P/uH/CxokllGj
	 FHGDs8kpv0wT55I3X1IDRAT4ZRfxnigxVvn9Ie6dAxQt5IrwSRt415meIPqiGkPCm7
	 le3TbpRiriUA3z5pt/7KI/J/1GGDBlnXEV7DOK9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 076/198] phy: ti: da8xx-usb: Handle devm_pm_runtime_enable() errors
Date: Wed, 21 Jan 2026 19:15:04 +0100
Message-ID: <20260121181421.297003107@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 08aa19de72110df8ac10c9e67349dd884eeed41d ]

devm_pm_runtime_enable() can fail due to memory allocation. The current
code ignores its return value after calling pm_runtime_set_active(),
leaving the device in an inconsistent state if runtime PM initialization
fails.

Check the return value of devm_pm_runtime_enable() and return on
failure. Also move the declaration of 'ret' to the function scope
to support this check.

Fixes: ee8e41b5044f ("phy: ti: phy-da8xx-usb: Add runtime PM support")
Suggested-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20251124105734.1027-1-vulab@iscas.ac.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/ti/phy-da8xx-usb.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/phy/ti/phy-da8xx-usb.c b/drivers/phy/ti/phy-da8xx-usb.c
index 1d81a1e6ec6b6..62fa6f89c0e61 100644
--- a/drivers/phy/ti/phy-da8xx-usb.c
+++ b/drivers/phy/ti/phy-da8xx-usb.c
@@ -180,6 +180,7 @@ static int da8xx_usb_phy_probe(struct platform_device *pdev)
 	struct da8xx_usb_phy_platform_data *pdata = dev->platform_data;
 	struct device_node	*node = dev->of_node;
 	struct da8xx_usb_phy	*d_phy;
+	int ret;
 
 	d_phy = devm_kzalloc(dev, sizeof(*d_phy), GFP_KERNEL);
 	if (!d_phy)
@@ -233,8 +234,6 @@ static int da8xx_usb_phy_probe(struct platform_device *pdev)
 			return PTR_ERR(d_phy->phy_provider);
 		}
 	} else {
-		int ret;
-
 		ret = phy_create_lookup(d_phy->usb11_phy, "usb-phy",
 					"ohci-da8xx");
 		if (ret)
@@ -249,7 +248,9 @@ static int da8xx_usb_phy_probe(struct platform_device *pdev)
 			  PHY_INIT_BITS, PHY_INIT_BITS);
 
 	pm_runtime_set_active(dev);
-	devm_pm_runtime_enable(dev);
+	ret = devm_pm_runtime_enable(dev);
+	if (ret)
+		return ret;
 	/*
 	 * Prevent runtime pm from being ON by default. Users can enable
 	 * it using power/control in sysfs.
-- 
2.51.0



