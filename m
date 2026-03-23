Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D4E93C07A;
	Mon, 23 Mar 2026 14:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275451; cv=none; b=MIuBLDcDk10bpTjNr3rKJ0qJm4+MPXeMt2I0D4ixZvj1deyUhyb2dnZzNfc6V4JuZr8aCsJZBkUs1XnwGGgah8brUWF2fqG1zsTvsMLWcAPuYq1lAtSXCn/Vz6qAbWz6RasNcyo74qaMQxdW7eY+BENC7O87yTGqFQ3wKplkVUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275451; c=relaxed/simple;
	bh=CK4lZ5YnTJ+4Ib4DZkFwoh2qLdH8VG3h7GOMy34KurQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xd+LdX46akyHSwQxwYaeuaPD1L4qTcCISXqJzeS8KbViXd0/dProhLHnsyZWQPBsEug8YEo3csw/1hgBtXINoE+FT5uYGI9MG83e27Nslxi2eXziAh6ubF842mw7bVZZOwDTOhO5anBsBAyXC6gHem+ctdCoDLuCYwv4SWG98DU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AlPptVB2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AlPptVB2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D37DFC4CEF7;
	Mon, 23 Mar 2026 14:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275451;
	bh=CK4lZ5YnTJ+4Ib4DZkFwoh2qLdH8VG3h7GOMy34KurQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AlPptVB2RAT+tRhg2Zi+cgegKY03X0UgtAIwRnG3XrGwFEQ71h7aPYo27Mo0kfsHX
	 rwad+Hj5rHa/5SH2bJAIgrEQKMyxMk8mU/Cjvn816heXXhDhZKmHE2AaPT1r5AGdRw
	 XAoSLdZKROSU48KtmH3A2gpEsgKwaqnmhAr/ne2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	A1RM4X <dev@a1rm4x.com>
Subject: [PATCH 6.12 098/460] USB: add QUIRK_NO_BOS for video capture several devices
Date: Mon, 23 Mar 2026 14:41:34 +0100
Message-ID: <20260323134529.064791889@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: A1RM4X <dev@a1rm4x.com>

commit 93cd0d664661f58f7e7bed7373714ab2ace41734 upstream.

Several USB capture devices also need the USB_QUIRK_NO_BOS set for them
to work properly, odds are they are all the same chip inside, just
different vendor/product ids.

This fixes up:
  - ASUS TUF 4K PRO
  - Avermedia Live Gamer Ultra 2.1 (GC553G2)
  - UGREEN 35871
to now run at full speed (10 Gbps/4K 60 fps mode.)

Link: https://lore.kernel.org/r/CACy+XB-f-51xGpNQFCSm5pE_momTQLu=BaZggHYU1DiDmFX=ug@mail.gmail.com
Cc: stable <stable@kernel.org>
Signed-off-by: A1RM4X <dev@a1rm4x.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -377,6 +377,9 @@ static const struct usb_device_id usb_qu
 	/* SanDisk Extreme 55AE */
 	{ USB_DEVICE(0x0781, 0x55ae), .driver_info = USB_QUIRK_NO_LPM },
 
+	/* Avermedia Live Gamer Ultra 2.1 (GC553G2) - BOS descriptor fetch hangs at SuperSpeed Plus */
+	{ USB_DEVICE(0x07ca, 0x2553), .driver_info = USB_QUIRK_NO_BOS },
+
 	/* Realforce 87U Keyboard */
 	{ USB_DEVICE(0x0853, 0x011b), .driver_info = USB_QUIRK_NO_LPM },
 
@@ -434,6 +437,9 @@ static const struct usb_device_id usb_qu
 	{ USB_DEVICE(0x0b05, 0x17e0), .driver_info =
 			USB_QUIRK_IGNORE_REMOTE_WAKEUP },
 
+	/* ASUS TUF 4K PRO - BOS descriptor fetch hangs at SuperSpeed Plus */
+	{ USB_DEVICE(0x0b05, 0x1ab9), .driver_info = USB_QUIRK_NO_BOS },
+
 	/* Realtek Semiconductor Corp. Mass Storage Device (Multicard Reader)*/
 	{ USB_DEVICE(0x0bda, 0x0151), .driver_info = USB_QUIRK_CONFIG_INTF_STRINGS },
 
@@ -562,6 +568,9 @@ static const struct usb_device_id usb_qu
 
 	{ USB_DEVICE(0x2386, 0x350e), .driver_info = USB_QUIRK_NO_LPM },
 
+	/* UGREEN 35871 - BOS descriptor fetch hangs at SuperSpeed Plus */
+	{ USB_DEVICE(0x2b89, 0x5871), .driver_info = USB_QUIRK_NO_BOS },
+
 	/* APTIV AUTOMOTIVE HUB */
 	{ USB_DEVICE(0x2c48, 0x0132), .driver_info =
 			USB_QUIRK_SHORT_SET_ADDRESS_REQ_TIMEOUT },


