Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620429;
	b=XOIgw4DYTBGOZqfCBYQaoxD7V9loV8Xvvd8H7lEM57JNUBVobExjoWiPjSELhFeJ7Lbl
	 yoOMC1HDBWuXgXqfWaatyKyyjz6LLQkNejwGWX3kwaZ0d129aYhANucaJJF3J6iXCO9Uj
	 RbsftyR/0kKSEVvVETsMekaUChneRxzYJGiuYxqtWskn9Ghs07Cul7ZgWBSFNwUbxga8L
	 zZVXH89MWxzABjMZmv8km6VfWznRi6rDxbFCGUcgoBYmtSS7ww/NY0Z+5MeU4uSfum5k1
	 8tGVon7KdYqYY0lKiHE7zNcLpYdL7DPhZW6moTTRl818Z2y2RNVNauXsUyEyEFmMCzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620429;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uH+ZMnOO2GXRfAq3v7OeSpB5WHumG6rQz62ECWzReDA=;
	b=R4EFuGJ6kp3/jAo2YYooe6yIue292ra+H4T5ENQaWcw4laX0wbEs8R5UwLya+dCTHtIC
	 uGX5oV3btnbPjoH2gW4iMaXcu9t4PzhnENSg+V9adebvGm0dSJTuLi7tCiVOPmlm5TFyO
	 CM4aTa3Fct0ZnSz/kCapjU7yEWIPdYCnrLgZuOXIuPEwLeuE6Hnrl5TyEE0UehDOKk4av
	 E9oGt+k3N/Ul+Gzubwnx7O0binigYC42lfxzesFcun07nEsyOEkDFrZZXULAHFNUAHeEN
	 Bpx7bH1i3hZbucNvdjmg4PAzw7aVqHbMNRPf0FBUdfEfxW9QX8SDHbklntCI6YqxaGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gK7xWh33;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F90606A31E;
	Wed, 25 Nov 2026 15:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gK7xWh33
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D47D1F000E0;
	Wed, 25 Nov 2026 15:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620429;
	bh=uH+ZMnOO2GXRfAq3v7OeSpB5WHumG6rQz62ECWzReDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gK7xWh33Fk/xgBgSJgK/q/3rmB1lfTmyx8cb8Js97PLvmpn5HbFTzcKBdA5An91NM
	 XuQylIDdLSaGX2blQEDHZqRlDrEtkgvLJnceRGlOlntexEXxTi8ZggR201u435TVWa
	 XC2NK9++YgFOm3WN7u44cxx7w0UKIEZYSUY74hp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Dan Drown <dan-netdev@drown.org>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 7.3 0914/1005] USB: cdc-acm: fix NULL-deref on hangup
Date: Wed, 25 Nov 2026 15:37:32 +0100
Message-ID: <20261125143843.102868174@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
 


