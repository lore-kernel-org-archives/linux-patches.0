Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062276;
	b=IPiMnfEbxl8JD4CWC4Hwdblakq81Im7wKkcT/RnqoGrBYb7zYP6NwRE1O9sVjOq1J8XZ
	 sZ3cONPAyKmQLko/JKyi4KuMpwtOedrJmpSY80O71s6QR6ahE7RKwfTDOmHdElfPBk3WX
	 LcWD06/5o5C2C7V/k6Tq+K7pmVpG2R+0ftRubHJ93inGG3mM7xtm/ShtgjQ3a9Hc0n9J9
	 BvTEQHyhuSVfA7lQrFJfWr+uz7rsWY+Pkj8U0i5SqzTMGsZadGxBFEwt+KZVkiq+j2AUR
	 gtUWqYqPradZoPZ7xACk7sjTWKZo0GDQ7aY0sv8MgrMNAHtr7nsr7xRV/cEcf4XfcLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062276;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LCGd8AP2I0+fWR3XpL8OFOrs/ALXMAJvVBJuWRIJJVc=;
	b=kCdnJfW5dcbekRSHFH77DVcOp3kAacp23JuHafZ/OIwMLBR7E6ImDMREzOvxGUmvxhny
	 1e2orp57Ao4O+cZbvNi7dSUyw+GSkq8b2qe4EUHIv9aTA8nmTHtz6X+X5Nr8teX+oK26o
	 3dxiSQMdNMPeaRXPciuX/0R9LeFZ9t8pOwpRdiFcNJHIhowj1pBBZiYyUwBba0bD7vwZT
	 qwfRuF+Mk7zJ+5ZJxODNxbgywnQI0zgqofksveWNfkLtnAKY10EGBC+6/LovvmN6h84Pg
	 oREMYJcNQewqNN5B9+krtjrqQexRUKjvuF0r7j+vhCJQ285EtnN+H2QwqkCfhX+bh7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VxIFf+DA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02115606D804;
	Sat,  7 Nov 2026 14:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VxIFf+DA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A43881F0089F;
	Sat,  7 Nov 2026 14:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062275;
	bh=LCGd8AP2I0+fWR3XpL8OFOrs/ALXMAJvVBJuWRIJJVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VxIFf+DANyy3U1oR9odGW1Iw1WuHbMupvcvRUfnpdspwZFodpYHtbxsbuabjs5/P9
	 zsakoueiVlLbq1U3szyRiVFiFqk01L27iFDmsfGAZ50CqUd8jbusGDJIBPcaDeTbI1
	 6lmCP3J6F8jKJxiNqdC/HkP8y/TZnagebvLBbzVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Oliver Neukum <oliver@neukum.org>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1216/1536] USB: serial: usb_wwan: fix urb leak on disconnect
Date: Sat,  7 Nov 2026 08:53:52 -0500
Message-ID: <20261107135031.910285582@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 0017f6e969e12..67e1820bbbafe 100644
--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -402,6 +402,7 @@ void usb_wwan_close(struct usb_serial_port *port)
 		urb = usb_get_from_anchor(&portdata->delayed);
 		if (!urb)
 			break;
+		usb_put_urb(urb);
 		unbusy_queued_urb(urb, portdata);
 		usb_autopm_put_interface_async(serial->interface);
 	}
@@ -579,6 +580,8 @@ static int usb_wwan_submit_delayed_urbs(struct usb_serial_port *port)
 		if (!urb)
 			break;
 
+		usb_put_urb(urb);
+
 		err = usb_submit_urb(urb, GFP_ATOMIC);
 		if (err) {
 			dev_err(&port->dev, "%s: submit urb failed: %d\n",
-- 
2.53.0



