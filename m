Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626119;
	b=3HkVGrB08EDnmQNPCz+UwQhxICbi62L2YJIOmVALNP9fP5ZdqOeU+oKZSHMq1kJrbVfX
	 3AxI1IG/DqQdcHUERrcrdleBF7uCSWj749V6Tox+s/De+4wBt30WkN2HHkxDoTMBg++nW
	 wXaCCp7A9MNGTThIdj2+8UiFpnezxUiFZeMVLVIx2nzI31u0t4Ma+nfC8nd0omvDmUHde
	 HoYq3x0U+PMZXNTKUY0Di0G4bLe8y8hW3U3e/auwhs1oHj3BJETXbY+8DPeekxwIyFRx3
	 OJ7+Yc7z5jq8wAU6aRXpL0vEluUmuxvRnaw795mxy6QEKaHhlmq17gTshODhH3KoBUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626119;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dOd13ECX+zIwaNSV5EQA+KF1P8Fiv0DSZK+vzvY9tsg=;
	b=ECYRS9bi34YxhvO9jL/1Yj6+DvlKN8lZSlfawLGxnTGzyk6es9IwJmySOCjeuKDBeLr9
	 7HjMu9CccwFEet8fZabHE72bp4uuUmxCl/UwIp/TsS/CTD1LWmmjSdqZsf/RdaAK5BBIO
	 EYSZJ3wAkxrt47yrlzdUmk/W5FvEoPVAco5EONda6tHSFBJFYPlzqLvYHUoqkruo+sFkA
	 fhCGiZYhMLSJlH2znorzE/TfxVVPHVsCCKohlxLkaditZEZtXsr4Uolgv+LhK5w5V9e41
	 gcMjELpdzNb8fzWNmTDVAmW+XdTtxmjP34YM9Apq539IFzZQxY5mgZ4IqpkkzaqBc5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gRzSEY15;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66B98606A321;
	Wed, 25 Nov 2026 17:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gRzSEY15
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B71091F000C0;
	Wed, 25 Nov 2026 17:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626119;
	bh=dOd13ECX+zIwaNSV5EQA+KF1P8Fiv0DSZK+vzvY9tsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gRzSEY15Uvlbq56j1CrRD0m7IBInR8F5z0AMW9u4jAqVETh469Sizdh+PNyaQtpBI
	 bsG8Bya/1P9IMU21+ZMM3T9RKVCbJlTvHWjR1Bya4Ro8HAyX3dqDQOSbZou/sfZXoN
	 qAVtswD8LUHG6vjMdocLTPjpwZO39gmVHdzjhsH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Dan Drown <dan-netdev@drown.org>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.12 737/816] USB: cdc-acm: fix NULL-deref on hangup
Date: Wed, 25 Nov 2026 15:38:05 +0100
Message-ID: <20261125143906.239137668@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


