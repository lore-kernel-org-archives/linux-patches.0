Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0221B87CF;
	Tue,  8 Apr 2025 12:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115819; cv=none; b=XvI6aJxCswjMl7leR0xV1XshNpfjpAcdXVXr6LgNwLSx/IpCAQ3+CgG7SgNWpa4ikKduDydRDCGLpbQJW30iIS37VnM+qPcOPyxemdZSpuIABJ7u3YXKwj6YRJifgOT3/BmQGEq1G2FQ/Tc3ScX++AmjebcaMMrysF7p1YHN3/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115819; c=relaxed/simple;
	bh=uu8OD0TeuO7WfRBgvlZSD8TslnE0M4oVFmubUxik8Vw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E0oT1gI/tLZQAsrXtBZphXcCih/osIHJTEBY7gxTX107Db4rhCzKAvRjvNgkczvGJoUn1qTCKGHI0xr3caGlQcPxGWg37xiHZy9zSzaxVMgWYrTSnVo/R5jQlf4YirRFs5JZa8KVYjRL1NnlgAdAyULvlv3dH5ReHISxFSTyNhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ohk9TT2R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ohk9TT2R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AD1FC4CEE5;
	Tue,  8 Apr 2025 12:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115819;
	bh=uu8OD0TeuO7WfRBgvlZSD8TslnE0M4oVFmubUxik8Vw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ohk9TT2RxV8+lFtA8suMYykmHnRdVEsKNNlU/qEHO2VoYCll9iWx6+2kRiWUYSDBw
	 VFO89txI7CQ8j91SqrrMUR/yUAfcQei1GTlpvKp/bUPkcJbu8L0CSPmMlG2XXjMDte
	 XuqxveKj1+0vucuH5n5HjVDfYGGpEP9MK99Y515Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lubomir Rintel <lkundrak@v3.sk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 114/204] rndis_host: Flag RNDIS modems as WWAN devices
Date: Tue,  8 Apr 2025 12:50:44 +0200
Message-ID: <20250408104823.666505361@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lubomir Rintel <lkundrak@v3.sk>

[ Upstream commit 67d1a8956d2d62fe6b4c13ebabb57806098511d8 ]

Set FLAG_WWAN instead of FLAG_ETHERNET for RNDIS interfaces on Mobile
Broadband Modems, as opposed to regular Ethernet adapters.

Otherwise NetworkManager gets confused, misjudges the device type,
and wouldn't know it should connect a modem to get the device to work.
What would be the result depends on ModemManager version -- older
ModemManager would end up disconnecting a device after an unsuccessful
probe attempt (if it connected without needing to unlock a SIM), while
a newer one might spawn a separate PPP connection over a tty interface
instead, resulting in a general confusion and no end of chaos.

The only way to get this work reliably is to fix the device type
and have good enough version ModemManager (or equivalent).

Fixes: 63ba395cd7a5 ("rndis_host: support Novatel Verizon USB730L")
Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Link: https://patch.msgid.link/20250325095842.1567999-1-lkundrak@v3.sk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/rndis_host.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/rndis_host.c b/drivers/net/usb/rndis_host.c
index 7b3739b29c8f7..bb0bf14158727 100644
--- a/drivers/net/usb/rndis_host.c
+++ b/drivers/net/usb/rndis_host.c
@@ -630,6 +630,16 @@ static const struct driver_info	zte_rndis_info = {
 	.tx_fixup =	rndis_tx_fixup,
 };
 
+static const struct driver_info	wwan_rndis_info = {
+	.description =	"Mobile Broadband RNDIS device",
+	.flags =	FLAG_WWAN | FLAG_POINTTOPOINT | FLAG_FRAMING_RN | FLAG_NO_SETINT,
+	.bind =		rndis_bind,
+	.unbind =	rndis_unbind,
+	.status =	rndis_status,
+	.rx_fixup =	rndis_rx_fixup,
+	.tx_fixup =	rndis_tx_fixup,
+};
+
 /*-------------------------------------------------------------------------*/
 
 static const struct usb_device_id	products [] = {
@@ -666,9 +676,11 @@ static const struct usb_device_id	products [] = {
 	USB_INTERFACE_INFO(USB_CLASS_WIRELESS_CONTROLLER, 1, 3),
 	.driver_info = (unsigned long) &rndis_info,
 }, {
-	/* Novatel Verizon USB730L */
+	/* Mobile Broadband Modem, seen in Novatel Verizon USB730L and
+	 * Telit FN990A (RNDIS)
+	 */
 	USB_INTERFACE_INFO(USB_CLASS_MISC, 4, 1),
-	.driver_info = (unsigned long) &rndis_info,
+	.driver_info = (unsigned long)&wwan_rndis_info,
 },
 	{ },		// END
 };
-- 
2.39.5



