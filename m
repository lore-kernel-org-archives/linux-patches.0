Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A7B18DB24;
	Mon, 10 Mar 2025 17:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626906; cv=none; b=d9XyXyakl9Q7ZLpQMmVNjNnH+ovz4JkG8vTzzyLn3xWh9Qv1wkZywdd7LiMZ1pMyDqV/ImdYVzh5mmHe2QtCcjXKzliAgK6kNoREnotPJLubiYXr1UKiNFlG6Cgvr8vZvvS2PTl0xKA6cFjTUZNqg8To/YTQqiUmQgOsRcRwv1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626906; c=relaxed/simple;
	bh=Xnp0dnC4m060HAwKIhEIcT0waTkGTxWFIAlMG37i5a8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AP/zaSuBzaI0Kmx6iiQyD+oP8ostNf0tZFBBONZZRGJpa8KGUsS4LpWmmMLzWG4wBfD7d8cVJtoXWn65sy5D05l8yH5BhUjgbJqxs16Xb1TEsMRjubenRU6I8VRI64dxWCvzSMJA9SbmU5hDtNz68IwYJyCVMPfgvqlTvKJ9nyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mhnZ2Kq6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mhnZ2Kq6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 991DCC4CEE5;
	Mon, 10 Mar 2025 17:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626906;
	bh=Xnp0dnC4m060HAwKIhEIcT0waTkGTxWFIAlMG37i5a8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mhnZ2Kq6q0njDDxJFQPIT8u9/8P7waCNJLBQbsra8/jWJ7HGg/f29FLWAbHtX1OR4
	 6h9UNKiWDgHxOMFmYAmdctcPh+8NCpuvdAglHr7zirn04ssjmlNIzhSnLPsh8DgeSQ
	 VU1UqDf+RS290wZaFGLaZeTMDKIEpe/5RQy7Pk2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Subject: [PATCH 6.13 154/207] usb: renesas_usbhs: Use devm_usb_get_phy()
Date: Mon, 10 Mar 2025 18:05:47 +0100
Message-ID: <20250310170453.916702369@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
 


