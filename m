Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3781E3C0B;
	Tue, 11 Mar 2025 15:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707549; cv=none; b=KCRsFK7TKgfXk5btsInP2E5Y1T6aNTkubum1hJX49AFuR5SAOGD71KRIOJC/N98LUilCE0vDuIAht5h/tElIs0D36wOZV20yiwXsPaOb3MEvPXi/artIOkPrUvi9H5RGxUlglWMOmHBIhMVblGUooof5AbQ/Y9iNjTv8uJXrAr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707549; c=relaxed/simple;
	bh=Pqk+mdQOjGATvldO+wEXpryQitMi7FNGL0vVOgZnU/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gA0zmZfmdHfTwl/aR4d+Ckla4HaXG8HgAtLu3V6dqCChrGNrGQFbcrcja4sUWxfp5BuL/v4cA5kZsKGTWXz7j555JAmW5mLvQjXjHd/pO8nqDpoXh2F3Ad7I7nq3+PDljKMAsn7j0QZ1w5wAk6vuwACgwveuLbENbmQ6zSGQTcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cyXnXLLs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cyXnXLLs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B043EC4CEEC;
	Tue, 11 Mar 2025 15:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707549;
	bh=Pqk+mdQOjGATvldO+wEXpryQitMi7FNGL0vVOgZnU/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cyXnXLLsjj0X//Fi0h9v57nU/wI0uzNmOH4PuYBkRJNDWlKLIRXkOArd8yBzowm1A
	 z4XsIo63ba5NQloCrawDWzSqcvfRO0AbFrBThdhH7jtCxXUXJKvatp8jYmCKqWgu3t
	 PvtVM7YnFSpYgckWklhq1IC66nYiWP2yKWwhMOzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Subject: [PATCH 5.10 427/462] usb: renesas_usbhs: Use devm_usb_get_phy()
Date: Tue, 11 Mar 2025 16:01:33 +0100
Message-ID: <20250311145815.204518290@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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
 


