Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A612535C694;
	Tue, 21 Jul 2026 21:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668422; cv=none; b=i6hmJnQhZO2/c1uKn8GwLxZrSgwTDOSmldRWivA1EBOZr5D/Y2KrppnSV4iatZSW3k1bBSo9PWn7hlCEoRB4RPjzVoq3AYAF7YRXIRBFIyzNQwlTWgQaFJJbrbBfx6THncukxEoFkrTaGbx/xi9lnA9IHiUxwwPmH2MIA/543hI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668422; c=relaxed/simple;
	bh=FBV63JtxGoLtc1vEwdf8sk48dbjyD9gFdV8q8gdA+SA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CE0ZJkVB+ZF3MujFGrHV3bAmCcHS88JLTzeA3flJdGrvGqCjg5pt9Tl0JArExj/EIeIhtTsV2YKmr2rWPnYcnIv3AVwmxUmr6Qt0mLys3xRkGQi+qE5Lllg34VfhyIcgo27epmJJPkqWkbij50zjj4rtmuWB3KzVFq9T1rnHBSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NvnlLih2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NvnlLih2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D12471F00A3A;
	Tue, 21 Jul 2026 21:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668420;
	bh=qljvmsT4mH4c9fVhwQBn9i01mtTadP17i4VClR7G6eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NvnlLih23rksygTqEAHPExbQnWh80kK8RXI+wF4oalZGliB7dNgWPv569cyWfs0RA
	 o4XN3Wi1GSQ8ROf0ENpFKmmBmPA33KIEyg1eCtX9PWO/JUAEX5D+UqxzXg5KV/GA5u
	 vyhGMCs4uOEMttYfzL687xw+B0hBvU8iZP2nanbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	WenTao Liang <vulab@iscas.ac.cn>
Subject: [PATCH 6.1 0169/1067] usb: dwc3: meson-g12a: fix refcount leak in dwc3_meson_g12a_resume()
Date: Tue, 21 Jul 2026 17:12:50 +0200
Message-ID: <20260721152428.370566296@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: WenTao Liang <vulab@iscas.ac.cn>

commit 692c354bef03b77b30e57e61934da502c8a12d45 upstream.

If dwc3_meson_g12a_resume() succeeds in calling
reset_control_reset(), an internal triggered_count reference is
acquired. If any later step fails (usb_init, phy_init,
phy_power_on, regulator_enable, or usb_post_init), the function
returns the error without rearming the reset control. This leaks
the reference and leaves the reset control in a triggered state,
causing future reset_control_reset() calls to incorrectly return
early as if already reset.

Add an error path that calls reset_control_rearm() to balance
the reference before returning the error.

Cc: stable <stable@kernel.org>
Fixes: 5b0ba0caaf3a ("usb: dwc3: meson-g12a: refactor usb init")
Signed-off-by: WenTao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260611131121.81784-1-vulab@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-meson-g12a.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/drivers/usb/dwc3/dwc3-meson-g12a.c
+++ b/drivers/usb/dwc3/dwc3-meson-g12a.c
@@ -919,35 +919,39 @@ static int __maybe_unused dwc3_meson_g12
 
 	ret = priv->drvdata->usb_init(priv);
 	if (ret)
-		return ret;
+		goto err_rearm;
 
 	/* Init PHYs */
 	for (i = 0 ; i < PHY_COUNT ; ++i) {
 		ret = phy_init(priv->phys[i]);
 		if (ret)
-			return ret;
+			goto err_rearm;
 	}
 
 	/* Set PHY Power */
 	for (i = 0 ; i < PHY_COUNT ; ++i) {
 		ret = phy_power_on(priv->phys[i]);
 		if (ret)
-			return ret;
+			goto err_rearm;
 	}
 
 	if (priv->vbus && priv->otg_phy_mode == PHY_MODE_USB_HOST) {
 		ret = regulator_enable(priv->vbus);
 		if (ret)
-			return ret;
+			goto err_rearm;
 	}
 
 	if (priv->drvdata->usb_post_init) {
 		ret = priv->drvdata->usb_post_init(priv);
 		if (ret)
-			return ret;
+			goto err_rearm;
 	}
 
 	return 0;
+
+err_rearm:
+	reset_control_rearm(priv->reset);
+	return ret;
 }
 
 static const struct dev_pm_ops dwc3_meson_g12a_dev_pm_ops = {


