Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E312745E;
	Fri, 21 Nov 2025 13:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732169; cv=none; b=mRa/Pk1vayb812kVShm+4/MxitSKRaj3orN1LrLoSABR3HTFfn/I9Ga8HRuN0PNbVvF3ONmtE7cGnAFFScTS9D2q/BKSkHu8AwHV1cw+2spO0poOnmnfYCUO5XHwiyMoF3bm6J+TbVdOWnqshly0FZRKnryO7GfWY2o+o290iek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732169; c=relaxed/simple;
	bh=H3aD3LtK9BXGubrFuc5SpBTQCj+xbgGaBWccqMAiYoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DErN1ntpGkqcZAZpR3HT3SfYpAcJGuv29uSoP6r/ge9GAuROaXXFVnZDo6rj1PSQy3T/QKDDsPmdDVHZfrhwLINtLZUImgY4UlS9QZTyd/T6F16c+EdSZlcEPc9ExyQ6MH9dyiefl8LyTg0xdAQF8NiIzkNnSKqlan+FJwuknnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cSXzxP2F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cSXzxP2F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05DF3C4CEFB;
	Fri, 21 Nov 2025 13:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732169;
	bh=H3aD3LtK9BXGubrFuc5SpBTQCj+xbgGaBWccqMAiYoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cSXzxP2FENLkmiC9nGyqSnjjwRa+NlFnRLRD33dxF6QxZ62OdwehPaEbQURX6hWOP
	 Jqwfb4A5jdSgsbLabKmpm1VWzB1Pn4xtCq8QNS2fRdP2oYlMlvqlcmxPA4XPj/0jTV
	 py2k8g6iGn10unCOzfGZd9rCNCUlRuYlmaRjCBCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 008/529] Bluetooth: rfcomm: fix modem control handling
Date: Fri, 21 Nov 2025 14:05:07 +0100
Message-ID: <20251121130231.294236100@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 91d35ec9b3956d6b3cf789c1593467e58855b03a upstream.

The RFCOMM driver confuses the local and remote modem control signals,
which specifically means that the reported DTR and RTS state will
instead reflect the remote end (i.e. DSR and CTS).

This issue dates back to the original driver (and a follow-on update)
merged in 2002, which resulted in a non-standard implementation of
TIOCMSET that allowed controlling also the TS07.10 IC and DV signals by
mapping them to the RI and DCD input flags, while TIOCMGET failed to
return the actual state of DTR and RTS.

Note that the bogus control of input signals in tiocmset() is just
dead code as those flags will have been masked out by the tty layer
since 2003.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/rfcomm/tty.c |   26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -651,8 +651,8 @@ static void rfcomm_dev_modem_status(stru
 		tty_port_tty_hangup(&dev->port, true);
 
 	dev->modem_status =
-		((v24_sig & RFCOMM_V24_RTC) ? (TIOCM_DSR | TIOCM_DTR) : 0) |
-		((v24_sig & RFCOMM_V24_RTR) ? (TIOCM_RTS | TIOCM_CTS) : 0) |
+		((v24_sig & RFCOMM_V24_RTC) ? TIOCM_DSR : 0) |
+		((v24_sig & RFCOMM_V24_RTR) ? TIOCM_CTS : 0) |
 		((v24_sig & RFCOMM_V24_IC)  ? TIOCM_RI : 0) |
 		((v24_sig & RFCOMM_V24_DV)  ? TIOCM_CD : 0);
 }
@@ -1063,10 +1063,14 @@ static void rfcomm_tty_hangup(struct tty
 static int rfcomm_tty_tiocmget(struct tty_struct *tty)
 {
 	struct rfcomm_dev *dev = tty->driver_data;
+	struct rfcomm_dlc *dlc = dev->dlc;
+	u8 v24_sig;
 
 	BT_DBG("tty %p dev %p", tty, dev);
 
-	return dev->modem_status;
+	rfcomm_dlc_get_modem_status(dlc, &v24_sig);
+
+	return (v24_sig & (TIOCM_DTR | TIOCM_RTS)) | dev->modem_status;
 }
 
 static int rfcomm_tty_tiocmset(struct tty_struct *tty, unsigned int set, unsigned int clear)
@@ -1079,23 +1083,15 @@ static int rfcomm_tty_tiocmset(struct tt
 
 	rfcomm_dlc_get_modem_status(dlc, &v24_sig);
 
-	if (set & TIOCM_DSR || set & TIOCM_DTR)
+	if (set & TIOCM_DTR)
 		v24_sig |= RFCOMM_V24_RTC;
-	if (set & TIOCM_RTS || set & TIOCM_CTS)
+	if (set & TIOCM_RTS)
 		v24_sig |= RFCOMM_V24_RTR;
-	if (set & TIOCM_RI)
-		v24_sig |= RFCOMM_V24_IC;
-	if (set & TIOCM_CD)
-		v24_sig |= RFCOMM_V24_DV;
 
-	if (clear & TIOCM_DSR || clear & TIOCM_DTR)
+	if (clear & TIOCM_DTR)
 		v24_sig &= ~RFCOMM_V24_RTC;
-	if (clear & TIOCM_RTS || clear & TIOCM_CTS)
+	if (clear & TIOCM_RTS)
 		v24_sig &= ~RFCOMM_V24_RTR;
-	if (clear & TIOCM_RI)
-		v24_sig &= ~RFCOMM_V24_IC;
-	if (clear & TIOCM_CD)
-		v24_sig &= ~RFCOMM_V24_DV;
 
 	rfcomm_dlc_set_modem_status(dlc, v24_sig);
 


