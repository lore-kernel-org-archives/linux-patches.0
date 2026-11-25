Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623562;
	b=WLU0/dSjsamFoHr04zFsRM9Qjd8ieHuF6QwYP+3oQ6MDSYHZLBT1PxkmMJnw99S+tKJW
	 OHfege6DqjcMbqeHv43ijMrvT5ef98M4yTIF7jMcrd67oGhKYaK0f1diA/PrtqYEJ0EFi
	 mBRc3mapUQzuTE5+3BpyTVywH2d1Lx3aRYQ0FMSZIH4gQScedcAGIYXouqernKkZ6Sllf
	 DNH3DR2YfpKSxhC3aXwq5JlYt87oPiYxa0S7luoG2LTTqZm/4m54ErBt6vLXEnB+vvsXv
	 4zeFgeao5gOtrvetZq5K82W/dv/yOrbOlvTwJtofUVb2pgnZZGydaZOS/RvF0UgLlqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623562;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=znfHUceQKDi0opIddpQO8mafWphG0gKDjceh+iGRonk=;
	b=SEvQTgyyvYqAS5DNGrk+gAZ6VJmOpAWCYMm/7wN9LDqNuNnqbMHpIExRtNZBn+ZkT10w
	 XyHeMDLDU3pSoxUoIsF1cdw8v9rhh7skO1u26RDklx8F9ynEMlAW3VDjmHAV2fZ7pQACH
	 YH2ibaBEPyu7rSy8UI3I97VYAuCP4PkRgtJhqcNyQBShyUdpTMWBRp0TkGBcJFyfIGgYh
	 Y7ncJPgkQUTzUDzV8acKdiy8tvELVeD6HHmwiOjxAfnfgz3UcTsCngLTu8eHNdRsUcxGI
	 +37EEWs0GbYsgBMnfmw57ziV4FzCcnrTpynQAkOtOZMVra5hRhSLUIuiMkDrk6ksUew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bw3Cp0MD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79650606A321;
	Wed, 25 Nov 2026 16:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bw3Cp0MD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68DFD1F000CA;
	Wed, 25 Nov 2026 16:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623561;
	bh=znfHUceQKDi0opIddpQO8mafWphG0gKDjceh+iGRonk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bw3Cp0MDHIhiSXJhEoD9ZOqR+MfndPCW78jfoaRiwMH5CFxqOD2eu1/QZ0e5e5vMM
	 ZDIxmvUsfMXqQbyBpmUIj3PXJEgO/uxgOetibHF1rHp47Fap4tXHp5jL4bIOeryxNt
	 exUpNXS1bnsNtJTUOECI/GW8kgThCnQP0RtYT6ec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Dan Drown <dan-netdev@drown.org>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.18 900/990] USB: cdc-acm: fix NULL-deref on hangup
Date: Wed, 25 Nov 2026 15:37:47 +0100
Message-ID: <20261125143843.092828405@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit bc9dd21ec61acd152d9e7c12cb07db37c63ad41a upstream.

Make sure to take a reference to the port tty when processing carrier
detect changes to avoid dereferencing a NULL pointer when the port is
being hung up.

Fixes: 3b563b901eef ("usb: cdc-acm: add PPS support")
Cc: stable <stable@kernel.org>
Cc: Dan Drown <dan-netdev@drown.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20261019123755.2008384-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-acm.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -294,6 +294,7 @@ static void acm_process_notification(str
 	unsigned long flags;
 	struct usb_cdc_notification *dr = (struct usb_cdc_notification *)buf;
 	unsigned char *data = buf + sizeof(struct usb_cdc_notification);
+	struct tty_struct *tty;
 
 	switch (dr->bNotificationType) {
 	case USB_CDC_NOTIFY_NETWORK_CONNECTION:
@@ -320,12 +321,17 @@ static void acm_process_notification(str
 
 		difference = acm->ctrlin ^ newctrl;
 
-		if ((difference & USB_CDC_SERIAL_STATE_DCD) && acm->port.tty) {
-			struct tty_ldisc *ld = tty_ldisc_ref(acm->port.tty);
-			if (ld) {
-				if (ld->ops->dcd_change)
-					ld->ops->dcd_change(acm->port.tty, newctrl & USB_CDC_SERIAL_STATE_DCD);
-				tty_ldisc_deref(ld);
+		if (difference & USB_CDC_SERIAL_STATE_DCD) {
+			tty = tty_port_tty_get(&acm->port);
+			if (tty) {
+				struct tty_ldisc *ld = tty_ldisc_ref(tty);
+
+				if (ld) {
+					if (ld->ops->dcd_change)
+						ld->ops->dcd_change(tty, newctrl & USB_CDC_SERIAL_STATE_DCD);
+					tty_ldisc_deref(ld);
+				}
+				tty_kref_put(tty);
 			}
 		}
 


