Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058471;
	b=BaSMeSfmI8bVZcJ5nZVy+n+rL3YoOuLS5NQ2xFwu2h0L/nZJOKDmHQ4fPGgxkxSBrQCg
	 NIIMtMT9u3/emT3mTYOCWU8nB0IhUi2LLUhBWhpVOxDgZAL0SwOktaWi0OV9VIbL8Nce9
	 asjQdoMDYmZSKdRl76YPN/mF2ERJ/RdeXrnpCZyA52DNV8MFtq8HxR+jdTlPlhoqv3o1j
	 mH7dzvwzruU5Q+wJkI4jGHsOwfiMYTHlxuP9E/mHuduicQu8owmurSZj3JGIMxsGP6eUb
	 Au82/dtLv+QB4WhF6aj2JEg4i8hX25nlxeAjXZZQkismSTxhtaOIaMIY6V/gCDTXd4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058471;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LzoXcypijk5+wzzwtSZaAjv+EDkS5xGgdtoLW2esBJI=;
	b=gsIOlsTDkjTJwEIPzS6r35f/6oyhKo2faIMQUeKTNQ2yA3UUwm+miJDpjZv9L7FxdU5t
	 KGY2pso4TMxSVQTkWkkgRsMdrBPSvRZlZZsDLuIyk2W1VW5mlZG4LMvNI3LoREMO0O1Ym
	 apPQq/tV2EyX73WZXEk1Hf/BC3HsfxkeeM646iuRg2IGWerregYOAbmCUiLgM1oAcLA0l
	 02Sp5g6toZn8eHzaJVgAPZLZaIOYj1zPUKLPlVrey+ifnxq7S50s5wJJ2toP4u3Sy0vn4
	 DXHh34ZtfUOPjCjGskxvZheaUXa/XxCzk/tL+wJ63inM1x652gb3ZEubOjJLLD/7HVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VRKRkfVx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F67606A320;
	Thu, 19 Nov 2026 03:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VRKRkfVx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F21E1F000C4;
	Thu, 19 Nov 2026 03:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058470;
	bh=LzoXcypijk5+wzzwtSZaAjv+EDkS5xGgdtoLW2esBJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VRKRkfVxjZ7bee8f07t7tJU671Xh6vn2ek3rT1XIbMOjoRbX7+zkd8jpbDdy2jqti
	 g7uski95qTWvhW+hgOiuG2BnhX9M9f3UOAcv4whvPcbvnBDRYyeyfxwu9K5kSFqshd
	 nt4PexGM0caBThwZNFJ6O9uOUyMR/+HknuGXzmjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Oliver Neukum <oliver@neukum.org>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0498/1848] USB: serial: usb_wwan: fix urb leak on disconnect
Date: Wed, 18 Nov 2026 15:42:16 +0100
Message-ID: <20261118145935.391276297@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit c78dd373b5c56a5a02da591b583c6b48d0d62954 ]

Make sure to drop the reference taken by usb_anchor_urb() when removing
URBs from the delayed URB anchor to prevent them from leaking when the
device is later disconnected.

Fixes: 383cedc3bb43 ("USB: serial: full autosuspend support for the option driver")
Reported-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://lore.kernel.org/20260916165608.2085613-1-vulab@iscas.ac.cn
Cc: stable@vger.kernel.org	# 2.6.32
Cc: Oliver Neukum <oliver@neukum.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/serial/usb_wwan.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/serial/usb_wwan.c b/drivers/usb/serial/usb_wwan.c
index b91eaaad9fabc..97e8015af4a8b 100644
--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -445,6 +445,7 @@ void usb_wwan_close(struct usb_serial_port *port)
 		urb = usb_get_from_anchor(&portdata->delayed);
 		if (!urb)
 			break;
+		usb_put_urb(urb);
 		unbusy_queued_urb(urb, portdata);
 		usb_autopm_put_interface_async(serial->interface);
 	}
@@ -624,6 +625,8 @@ static int usb_wwan_submit_delayed_urbs(struct usb_serial_port *port)
 		if (!urb)
 			break;
 
+		usb_put_urb(urb);
+
 		err = usb_submit_urb(urb, GFP_ATOMIC);
 		if (err) {
 			dev_err(&port->dev, "%s: submit urb failed: %d\n",
-- 
2.53.0



