Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C741D18DB24;
	Mon, 10 Mar 2025 17:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628456; cv=none; b=VpgGmtspKpAGvVFgeky0bNTPSjERhwOgWXIQR6Jo6QdCUJ8k/4DB1Tsrw5FC1qN6gZ1CDBgeWbGSYkgu0rxmQpZ/LP1dfHbD3TiWXGJ7u/CZjiltPy8d5iqKnAMowN1ReApjBlz4itTOfxHJUPtywDCp7c3tfnDWQZ7Lufastag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628456; c=relaxed/simple;
	bh=EzOANUGSVafhl7dy97YAohBGb9SSub9FxZ5eTdPCasI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SKC89u3CN7ZBPuxCqmTIAkeSrjoXyhcoQ4KoNH4OMH/sbhGG7vG2GmZyfrDcs8BLcY70IHIzgqzxIPohCeI24CD9ElO2hUR9jUO9L+2Bbh2aQml/uFNFZ6e+exwhmPqJ/WlGTmGcARoBzAiJC0TJOwhk2KrGpks7AlSbT9fjdLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jp5A05NM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jp5A05NM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E4F3C4CEE5;
	Mon, 10 Mar 2025 17:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628456;
	bh=EzOANUGSVafhl7dy97YAohBGb9SSub9FxZ5eTdPCasI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jp5A05NMbOeeyEUltrvMG/TqfRNJwXf9cOA7TJfByukBvqQTCMDL2kBADbWKtDKot
	 zX8XQW9bmwRj7kkQEKUTViOZvsCxWGA4zdTg6gBqbfNUQs5uy41JDAxBEH9Fkjbebd
	 VfK7jrBm+42QONX7wAJYSzE0KQY+aX+dKSxRxyBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Subject: [PATCH 6.1 065/109] usb: renesas_usbhs: Use devm_usb_get_phy()
Date: Mon, 10 Mar 2025 18:06:49 +0100
Message-ID: <20250310170430.150600241@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
References: <20250310170427.529761261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


