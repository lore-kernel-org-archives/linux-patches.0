Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C3846EF88;
	Tue, 21 Jul 2026 20:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665282; cv=none; b=XVl01EoiWl6veZnldy/QaGaRzrJBe2dMXE9WBc3Sbg5Pbg8GliV3+T8hg7+zVJMQwHaatE9BLMpmwH1fgRZEiXYmJtk4D+t+MeVbWc94Un8RROJ2MEmJaJHfgeVmy6CK6A854KnaI4m5flapnmOfaQpIANX6f7NggJ0DIJmho+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665282; c=relaxed/simple;
	bh=BNX7sIUWYtqC9R4zmJnHq0Hb4fwUn5TE/APyBWFXQ9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SF3mo1la57TkITispdnyxZQ3nnNPumXiJt13fsJEYWeBUDKuA7NGc9D6aq30S86ywnXrpB0JYu8NsUX/tFn1jgxz/r6fDnuNATX3lnDev04QklGgFq8Cpx8DTHPDvgw5fp9zQziiSPNF5N3XwkskLR0PabpPj6JWflvNBaMt8v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1FiIQsqI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1FiIQsqI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E529C1F000E9;
	Tue, 21 Jul 2026 20:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665281;
	bh=/9+o4ZXAcYPh015X9hg9lC7MBfoG7AeeTilkdiO0cb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1FiIQsqILGIjTLaV2JXLO+OEn2LqnygBmrNW6q9AuA2ifWWutHX4uNC+gXg/BhVip
	 JsWAcvASP1OcvnHBUj8XUFNZO51IR1/YmyLG/eVhEFg+QrueemcmhJ+IElCAvscl1Y
	 WARXbMuJWa/8Sn1igQoGQKDkKF2DCnhu6oAh6jhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	WenTao Liang <vulab@iscas.ac.cn>
Subject: [PATCH 6.6 0228/1266] usb: dwc3: meson-g12a: fix refcount leak in dwc3_meson_g12a_resume()
Date: Tue, 21 Jul 2026 17:11:05 +0200
Message-ID: <20260721152446.919400344@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
@@ -907,35 +907,39 @@ static int __maybe_unused dwc3_meson_g12
 
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


