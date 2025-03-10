Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53BBE23099F;
	Mon, 10 Mar 2025 17:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627674; cv=none; b=ohFnnZXz4/gS2tnDSHVT0xgRCk5P9/ugsXrPE8TXbG0zWy5tLclc/l3tcCaWslBvR/oWMSpOBWkOs1ZodQDCfhqdxMjEKDU0+9gjrYCT4bp9gvPelWoao1hq0IfYTWw6WYvkkkUOIRaOIoY3pXAzKiZEVv5fpHYVFb44mzKNmWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627674; c=relaxed/simple;
	bh=IQpvhF6RO95FGGL2sE1VpFsyl4O7IependeAO0oHSWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UdID+qBVtNfdIbitJKbveHNU38JVxv/NuG0yZCJmOtzFHJm8QbfI4Qf0hEyKhe2Y/y2ZDyUqMGJILcjKScSHBV48Oy81tSGw/0DjAGRxYp53dGVSGg3E1ae9l4AYWV/S8cAAEoGN56hC57zpRb2KI5VV0Dm8RAZP9FHrZ4kvQt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bZ7dWfeb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bZ7dWfeb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAFE7C4CEE5;
	Mon, 10 Mar 2025 17:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627674;
	bh=IQpvhF6RO95FGGL2sE1VpFsyl4O7IependeAO0oHSWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bZ7dWfebaLOp7GH/aBswwSvahiYiRZIA3NqEuM2VT5LtCMXOp+orMir0ZTBRrk82u
	 7NIRAPZUwvHO+FpCYd2ROVuqQEPTDWdIsBRnExHPPQUMc6twohlBa6d5kOdwlde63W
	 rUCsTe9O0b+s7knzG5rbY0eMAKdKHaMCBWEcLzCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Subject: [PATCH 6.12 209/269] usb: renesas_usbhs: Use devm_usb_get_phy()
Date: Mon, 10 Mar 2025 18:06:02 +0100
Message-ID: <20250310170506.026524796@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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
 


