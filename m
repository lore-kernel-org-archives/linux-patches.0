Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7328C249F9;
	Tue, 11 Mar 2025 15:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706307; cv=none; b=n1whPJI01eD95Yhh8k+7hUEwTSLuADiyp2QMYGlXzayWj3bC0qRAV6umXcrhFfjg2L2R5UaE121ObjH5eTfQusowOy4HCOBGHwB3lKhPxdMi85/fNv5F2d9MIi2UatSHUALBXbC0zIoHHbMYZajw4kYa/Aqkt9500/Zkjr/uuuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706307; c=relaxed/simple;
	bh=8+kRcTrDFASu313IgSCmxeEvbizZlb/I/FFxPAkQ3GM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XEItHcCTnrcloIfSu+Omuzd0jTmWQ7SzShYjSjJfqgsYQOY5Ej+UZPD+BHl0XBesQP13PGtbLkjmXnnSll6ViLGwBS8bgySO4JrXHwlaLpK9FV93IHd74YqhD7nI5Khm4M0qM4oJ/0PSgBHnIIbtmwzrqDqO+GlukuCFV1M5dj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2ukkYiK0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ukkYiK0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 891E2C4CEE9;
	Tue, 11 Mar 2025 15:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706306;
	bh=8+kRcTrDFASu313IgSCmxeEvbizZlb/I/FFxPAkQ3GM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2ukkYiK0QbYq4McgcsZYWMrjrbEQ+2lgC1Kp9ayDHqIlXz00yTbJ8E1WAVeCycJ8N
	 dR2BU8sdlzkVFSUs+AgM5Re1qQRy/YGg4szz6oRmZXaAlZFgaOvdGfI37JnxlKfK+n
	 Itnqs0X279DPsLepEdu/Tzq6EgIMq+ZG+FynnA/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Subject: [PATCH 5.4 313/328] usb: renesas_usbhs: Use devm_usb_get_phy()
Date: Tue, 11 Mar 2025 16:01:23 +0100
Message-ID: <20250311145727.345834216@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

commit e0c92440938930e7fa7aa6362780d39cdea34449 upstream.

The gpriv->transceiver is retrieved in probe() through usb_get_phy() but
never released. Use devm_usb_get_phy() to handle this scenario.

This issue was identified through code investigation. No issue was found
without this change.

Fixes: b5a2875605ca ("usb: renesas_usbhs: Allow an OTG PHY driver to provide VBUS")
Cc: stable <stable@kernel.org>
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Tested-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Link: https://lore.kernel.org/r/20250225110248.870417-3-claudiu.beznea.uj@bp.renesas.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/renesas_usbhs/mod_gadget.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/renesas_usbhs/mod_gadget.c
+++ b/drivers/usb/renesas_usbhs/mod_gadget.c
@@ -1094,7 +1094,7 @@ int usbhs_mod_gadget_probe(struct usbhs_
 		goto usbhs_mod_gadget_probe_err_gpriv;
 	}
 
-	gpriv->transceiver = usb_get_phy(USB_PHY_TYPE_UNDEFINED);
+	gpriv->transceiver = devm_usb_get_phy(dev, USB_PHY_TYPE_UNDEFINED);
 	dev_info(dev, "%stransceiver found\n",
 		 !IS_ERR(gpriv->transceiver) ? "" : "no ");
 


