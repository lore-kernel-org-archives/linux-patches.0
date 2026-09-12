Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 474F82FDC30;
	Sat, 12 Sep 2026 13:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220725; cv=none; b=aLrAduhC1O+tgjDgpG13djku9w3wujZnykx3pJ6BUhofYVhHmTTO/9rg9sqCAoK2kC/LJ+d++69VeuLk6E3n7XDpiAIZFUXDC+QTzv34ZlgjyoIj66+tizor0xOnVFP1P6NTAvSbutGOy8H8vwPUCORZuEqRAh2xt4DV+nT5gf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220725; c=relaxed/simple;
	bh=lKMufhd8H40FZz9C70DrpdW0XbV/pBGHR3+qCe8dyXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k0A+BGIWowZ8x06KqLJ5fjt3fzJ8goW3nHTSxLE/KSFrzj3B4GyY5BYqloa6bOEtx/+vNTTnEZvc0q7Tsx+gDuw3A3UT1qXE0Swk3mTfFDqyi71tTeXpYmkbxynG+SOJqp4rc4ZmscI6lUDtzOzw43iKekAFcCcET9nPNFRwa+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wb9Szerf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wb9Szerf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0CC41F000FF;
	Sat, 12 Sep 2026 13:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220724;
	bh=1/jV84oJfdUtbr6j4PCs7Kr1kGBCrJsA83W5969rVEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wb9Szerf2CENis1sYWeaDUeCm3pycbct2bDcTx9VDwZ1wlr7MAJ1xVDGcHvEZPTCm
	 QCRHSEekbRnUH8lWeFxX7f1QWeL+2kOUFd8f38pWrg6GORwNWk4eVsm7mYu5wdaWUJ
	 Q5axnxaymGGOvgJaWf/NGiwLj3r1lUoP8lFtJd/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.6 0209/1424] power: supply: cros_usbpd-charger: bound the EC-reported port count
Date: Sat, 12 Sep 2026 08:44:01 +0200
Message-ID: <20260912065611.967991197@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Bryam Vargas <hexlabsecurity@proton.me>

commit 48355ce49359740f52e94d3623f6fc557ce341f0 upstream.

cros_usbpd_charger_probe() reads two port counts from the EC and uses
one of them, num_charger_ports, as the loop bound when populating a
fixed-size array:

	struct port_data *ports[EC_USB_PD_MAX_PORTS];	/* 8 entries */
	...
	for (i = 0; i < charger->num_charger_ports; i++)
		charger->ports[charger->num_registered_psy++] = port;

Both num_usbpd_ports (from EC_CMD_USB_PD_PORTS) and num_charger_ports
(from EC_CMD_CHARGE_PORT_COUNT) are u8 values reported by the EC. The
only validation is a sanity check that compares the two EC-reported
values against each other:

	if (num_charger_ports < num_usbpd_ports ||
	    num_charger_ports > num_usbpd_ports + 1)
		return -EPROTO;

It never checks either count against EC_USB_PD_MAX_PORTS, the size of
the ports[] array. A malfunctioning, malicious or compromised EC that
reports num_usbpd_ports == num_charger_ports == N for any N > 8 (for
example both 255) passes this check, and the loop then writes N pointers
into the 8-entry ports[] array embedded in the devm_kzalloc()'d
charger_data, overflowing it by up to 255 - 8 = 247 entries (~1976
bytes): a slab out-of-bounds write.

Reject a port count larger than the ports[] array can hold.

Fixes: f68b883e8fad ("power: supply: add cros-ec USBPD charger driver.")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Reviewed-by: Tzung-Bi Shih <tzungbi@kernel.org>
Link: https://patch.msgid.link/20260616-b4-disp-5e197080-v2-1-8aa5bffce945@proton.me
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/cros_usbpd-charger.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/power/supply/cros_usbpd-charger.c
+++ b/drivers/power/supply/cros_usbpd-charger.c
@@ -600,10 +600,13 @@ static int cros_usbpd_charger_probe(stru
 
 	/*
 	 * Sanity checks on the number of ports:
-	 *  there should be at most 1 dedicated port
+	 *  there should be at most 1 dedicated port, and the count must
+	 *  not exceed the maximum number of supported ports
+	 *  (EC_USB_PD_MAX_PORTS).
 	 */
 	if (charger->num_charger_ports < charger->num_usbpd_ports ||
-	    charger->num_charger_ports > (charger->num_usbpd_ports + 1)) {
+	    charger->num_charger_ports > (charger->num_usbpd_ports + 1) ||
+	    charger->num_charger_ports > EC_USB_PD_MAX_PORTS) {
 		dev_err(dev, "Unexpected number of charge port count\n");
 		ret = -EPROTO;
 		goto fail_nowarn;


