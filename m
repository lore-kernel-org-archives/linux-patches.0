Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E5BE43C7DA;
	Tue, 21 Jul 2026 22:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671248; cv=none; b=ZZFveEmDmrnEe0/krnYcCp4ED2bJgvoJ2vDTBfNidYsOsyRf3MDSzmeYNYYGCnln2zDnjen78Fgge9ekOTQ4A+tfLTxjqH15S4NmPgJcNsS9Phv7fSk79+UowymTwcW12gHSTeaSHn83sfedJ9CFnqbyjLRs+te98/NVU9E6IIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671248; c=relaxed/simple;
	bh=ZYol0lYhPeCHJ9bnBKewpz8OoKJO1e8z9kTBGUG4olU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=epkelur/aarurq2Gygj2chc4uWw1sHBSgvnfNO3Rko9tuULrOVKNbuqfU3eD5yKl/QvQNtNiHwcN34CTFDGi3+dRB7eLfAkibZcptK8Nj1reuXld+dZmgcbf1iXtbktU+iQXuR39Fc6WsSMvu6vIWKNhQt0azzes2CLTO+36yls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dxgd/lAK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dxgd/lAK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1F2A1F00A3D;
	Tue, 21 Jul 2026 22:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671247;
	bh=8gBAnIrSlkI5DlJMkXFIleI2zW7mk97qvAG1oHAOrD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dxgd/lAKU1IbEEne8KLfjuKbJ4rolE1NUMXX6TbsBirQw2lpm7NWCAFaOguIf08dN
	 I9CCV3DvLTxjHfIgaUTpwHzvFDi3xwcEitrY/zM0gm8y0jKyBB/NRpSoO7S8BTLF3W
	 xIc9mKzRwgvN4bFxk1qPW+Xs0USke0xq9dKY5HCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	WenTao Liang <vulab@iscas.ac.cn>
Subject: [PATCH 5.15 131/843] usb: dwc3: meson-g12a: fix refcount leak in dwc3_meson_g12a_resume()
Date: Tue, 21 Jul 2026 17:16:06 +0200
Message-ID: <20260721152408.958180112@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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


