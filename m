Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B08E2EA481;
	Tue, 22 Jul 2025 13:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192329; cv=none; b=aE6Abw6CVcELYkUd9SpfwxwgTIWrHdXsDZEU6mS6TmCGtbn5/8enQNXR1RGoDTYlFlrnqKIz6DU7AJdjTV2dVA3ZbOHYe0Bqr/it0seaovhFBFS5MvDFpt/tLb8NfyWGHygLrpXl6XnXFrDIm4jc/fythKseS7Ly2YJzOeQuRP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192329; c=relaxed/simple;
	bh=3oR8L3udfiS9iUmWi3nH+OgjR0IRXFQ/c3WV9bqLmVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CzfoWs347jylUOde9Gt0Q4R0NzwSskE92FvRiHmwCDKezOuyultzm92P6gs7MM7uSJ0jvUAz0rSqgyDqO2zHyU9U0eN7/GdhW8irckmYDUtYLUueCJZfOoFDKYVcA8uLrhAkPX7WbBTUEwUsJIzVVahrMsRsnk3nVA3tdu81YdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UkRXYdyW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UkRXYdyW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E4ACC4CEEB;
	Tue, 22 Jul 2025 13:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192329;
	bh=3oR8L3udfiS9iUmWi3nH+OgjR0IRXFQ/c3WV9bqLmVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UkRXYdyWFVdnMcwmoVuhsNaScLNjVBInIRY8amtvVdF5+ZstuKmf7gH00r9HMsxtJ
	 1lRF4vKEwiE62hF98L4crlX8JqRDN6VmBZTbQttkNtDbluuN0SVSgrs4iaOPq2YacQ
	 2dFxvmgUImK7ehPMH+Bb1c86QtS5AGh5b+85GH60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yehowshua Immanuel <yehowshua.immanuel@twosixtech.com>,
	Drew Hamilton <drew.hamilton@zetier.com>
Subject: [PATCH 6.6 007/111] usb: musb: fix gadget state on disconnect
Date: Tue, 22 Jul 2025 15:43:42 +0200
Message-ID: <20250722134333.655730920@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
References: <20250722134333.375479548@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Drew Hamilton <drew.hamilton@zetier.com>

commit 67a59f82196c8c4f50c83329f0577acfb1349b50 upstream.

When unplugging the USB cable or disconnecting a gadget in usb peripheral mode with
echo "" > /sys/kernel/config/usb_gadget/<your_gadget>/UDC,
/sys/class/udc/musb-hdrc.0/state does not change from USB_STATE_CONFIGURED.

Testing on dwc2/3 shows they both update the state to USB_STATE_NOTATTACHED.

Add calls to usb_gadget_set_state in musb_g_disconnect and musb_gadget_stop
to fix both cases.

Fixes: 49401f4169c0 ("usb: gadget: introduce gadget state tracking")
Cc: stable@vger.kernel.org
Co-authored-by: Yehowshua Immanuel <yehowshua.immanuel@twosixtech.com>
Signed-off-by: Yehowshua Immanuel <yehowshua.immanuel@twosixtech.com>
Signed-off-by: Drew Hamilton <drew.hamilton@zetier.com>
Link: https://lore.kernel.org/r/20250701154126.8543-1-drew.hamilton@zetier.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/musb/musb_gadget.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/musb/musb_gadget.c
+++ b/drivers/usb/musb/musb_gadget.c
@@ -1925,6 +1925,7 @@ static int musb_gadget_stop(struct usb_g
 	 * gadget driver here and have everything work;
 	 * that currently misbehaves.
 	 */
+	usb_gadget_set_state(g, USB_STATE_NOTATTACHED);
 
 	/* Force check of devctl register for PM runtime */
 	pm_runtime_mark_last_busy(musb->controller);
@@ -2031,6 +2032,7 @@ void musb_g_disconnect(struct musb *musb
 	case OTG_STATE_B_PERIPHERAL:
 	case OTG_STATE_B_IDLE:
 		musb_set_state(musb, OTG_STATE_B_IDLE);
+		usb_gadget_set_state(&musb->g, USB_STATE_NOTATTACHED);
 		break;
 	case OTG_STATE_B_SRP_INIT:
 		break;


