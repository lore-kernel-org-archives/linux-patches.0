Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064583;
	b=aJmD3CkQpeFG/wHHbpZLAa4BY1K0OoNXAGgYsx/GKlJuSoI2A9XeTywj0MBNmPnlz5Il
	 HdSx5SNXLsXQkElDGQm33lQbyvn2brcbXfXmKiVmd2JN5zDfOfhR7U6rfRZWCni2C6mBv
	 BSXQvG9tYYdBEEvN42mkeat4YEFHNtyHDxm83z3Z9F9nGUj7ijekhr16iEfvVEip3e7Om
	 GVLtp6WFypjSX6nF00YTyJTRGM8p3zPyuXEz06r+CpKHl2rbo4TX7CIycNVTBuNBJAPNy
	 fMUs0Kzv9uPvpiWCNUh3wkTJQQCwmxXItQF0nQF8M0u2H9GdTHJblyA+h0s8ANx9uNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064583;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zdEGZECUaCTGmZPI295pDGjGBzph4pBq6lGeVik5Nxc=;
	b=lAhidUCeD01e7hHoErTbfRp9jzxT1uEIsbQ5vkpFSShbipO2RX9YrDYnNm1nhOWZSm4e
	 uLdR6vmX8vauYqJbzMva9A136AVqhfh9lDJ7GTqqIzXfSyCa2TVb0WkK+kCmqOaOvIASB
	 tHxPOpCdzj/bKMGTgWhjvBnxeq5ETSLkLUdgRBz8pbBrn48/g2HMvHPX2C1qfZCADbrLz
	 39C4HOWY++5lgs4ObX6aSOwAH53GlWZYZYz1DNf2jGSuQxUp/hw4iXmP6zwprR5k8xqcX
	 r7FKjzKib83W8weiX3PsxQGFITAqUjzLgr6CtNNnur7GoZujl2c+u/mxmhlLvHkFJPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WaxI3JlZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02963606D833;
	Sat,  7 Nov 2026 15:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WaxI3JlZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B9CC1F008A1;
	Sat,  7 Nov 2026 15:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064582;
	bh=zdEGZECUaCTGmZPI295pDGjGBzph4pBq6lGeVik5Nxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WaxI3JlZcpE9gyjP55jFpai5yiZO/Z27m1B7YU9F9hZADcj92YTE7jF4kg7GjIUE9
	 HdyyjsQlv94l3KN3k6aVLQD3HB+NnbNXMuWa17CzfXZZYCSCwJtDvZZ0rZ6jD7Ypu2
	 yaqoKvmoiMe5ZaOVsPoyxZXO7KHG//ziwF+QYF38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0601/1257] USB: cdc-acm: fix urb leak on disconnect
Date: Sat,  7 Nov 2026 08:48:17 -0500
Message-ID: <20261107134955.917059125@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

[ Upstream commit 648b08aa37c1b24a61662ad78964f2bca659ca26 ]

Make sure to drop the reference taken by usb_anchor_urb() when removing
URBs from the delayed URB anchor to prevent them from leaking when the
device is later disconnected.

Fixes: 140cb81ac8c6 ("USB: cdc-acm: fix broken runtime suspend")
Reported-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://lore.kernel.org/20260917161217.2161883-1-vulab@iscas.ac.cn/
Cc: stable@vger.kernel.org	# 3.16
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20261009122934.464142-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/class/cdc-acm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 0d3f815b2f1e8..6a1c574634949 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -782,6 +782,7 @@ static void acm_port_shutdown(struct tty_port *port)
 		urb = usb_get_from_anchor(&acm->delayed);
 		if (!urb)
 			break;
+		usb_put_urb(urb);
 		wb = urb->context;
 		wb->use = false;
 		usb_autopm_put_interface_async(acm->control);
@@ -1710,7 +1711,7 @@ static int acm_resume(struct usb_interface *intf)
 			urb = usb_get_from_anchor(&acm->delayed);
 			if (!urb)
 				break;
-
+			usb_put_urb(urb);
 			acm_start_wb(acm, urb->context);
 		}
 
-- 
2.53.0



