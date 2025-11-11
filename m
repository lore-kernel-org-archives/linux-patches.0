Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC46D4C97;
	Tue, 11 Nov 2025 00:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822095; cv=none; b=EK4lDp5GLF60LYIjU+BX4xMk8bfOFlS1EGJUcRLD9L3rjgYnVlcJtv4eLjy7G/swzCfVpG+G8vlAU1QU4YHGmkQopxgUtUhSOstU6wUtsX70f26fhWofFm2oX+0pNph/GMO4d1LcIgpfI+96i6oH6YnfZzAKYfcLj1UwjIcIjE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822095; c=relaxed/simple;
	bh=dxphBdHXjSjImXPzMEpuNYn4pkmT2auTk6k7j+9oHkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=epT45ZfpWrrEaOcQ/oG5mtxCteQx8RUBXfqlTq24eXnxaUR3lvHsMtY4ne5mRnaCYdFRsObaAP/QxII+2waQczlpBrcM8Fx7E1+q2NrSS/qMRN5OviCdK5blvLvG0CzmpAt2wu2jn1oO4TH9rKT2nWNysxHYJW11ryFMr7bP8UE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mzYTB+ue; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mzYTB+ue"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06209C4CEF5;
	Tue, 11 Nov 2025 00:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822095;
	bh=dxphBdHXjSjImXPzMEpuNYn4pkmT2auTk6k7j+9oHkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mzYTB+ueL3Fh/vyfYv5o9pFiuyk7ZNDUvB2dsMdF3heR1s6P4dEjhMmoagaY05Jv4
	 cnmgl8DMlztFu4A9LPt2FZB1Of/htL3tt7j/OtKyFwtO/FopGZuqncVtJ42fE8gKAS
	 Nc/9m/PJGRdOFPTpsfdblMGWPTIqfZVmsC3yYpUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.17 015/849] Bluetooth: rfcomm: fix modem control handling
Date: Tue, 11 Nov 2025 09:33:05 +0900
Message-ID: <20251111004536.829973850@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -643,8 +643,8 @@ static void rfcomm_dev_modem_status(stru
 		tty_port_tty_hangup(&dev->port, true);
 
 	dev->modem_status =
-		((v24_sig & RFCOMM_V24_RTC) ? (TIOCM_DSR | TIOCM_DTR) : 0) |
-		((v24_sig & RFCOMM_V24_RTR) ? (TIOCM_RTS | TIOCM_CTS) : 0) |
+		((v24_sig & RFCOMM_V24_RTC) ? TIOCM_DSR : 0) |
+		((v24_sig & RFCOMM_V24_RTR) ? TIOCM_CTS : 0) |
 		((v24_sig & RFCOMM_V24_IC)  ? TIOCM_RI : 0) |
 		((v24_sig & RFCOMM_V24_DV)  ? TIOCM_CD : 0);
 }
@@ -1055,10 +1055,14 @@ static void rfcomm_tty_hangup(struct tty
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
@@ -1071,23 +1075,15 @@ static int rfcomm_tty_tiocmset(struct tt
 
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
 


