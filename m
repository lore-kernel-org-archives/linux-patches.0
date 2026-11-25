Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623568;
	b=I/i4UT56SYaVW/e/i9ZWZLP9hO4gOsf2maROYshy+Za+4vRB5WN0d/SPpc8/jJx0Flvg
	 7bI09bYfhbmtQRj/y2ZwT4vYK4kdCpHxRtQpKChgoBvCzMWVU5Y950Dm/ZkUFf4K/fUD9
	 WIUzGanWW6x6IHtcjWEeALDpbwz2xNsK9jtjRplWMTZYLSKc4ES/mwhEilyvM+aXQAZjT
	 luwRqK+SgyoGPkqvosw7U9r8ame16H9ibXFJ8MkJFhJeMQp4mucyZ9PHeDxZ8Zf5D3Xec
	 yM7iwVAc+cphIh4pzfMmxiKe7HqjNH0bQsn/o5aP0dy8z6HUD7WmBLNwRjQ/0Hf7GxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623568;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=45QzGUlzmrvzOeISQibImwhvKYeMBb4PbEJhglYfTJY=;
	b=OlFi/kzSm2LX/gw0y5lDAV9SIMZJ1e43Ou+8/nIZhAdCivHXMu0cxemVlRT6EBOq4Qus
	 1sI1RMceTQo8Rnz8Esn3KM46VP/2rmluQkgwARbOjKqfcmcR3YdykMjC1OAuPRBLKRa5o
	 Dou+B9cjEQHikvNaW6mNv0SaZ3kPzwMjo/FXrfS+lt0moduaipf4zYPbnAck23XZ21nri
	 lVibOI1CdFUMqPJH9krleUwuWGdPPyYZwc1br0XJ9+7i1yoz5Wi6kKt7BUUygkyQpdW9I
	 u0BiVinuFGVqndwcRAFCOoatUVxXRfuYd+5ajQYfMAuhIgbPfQMM5erNaokeO+JHsLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HxqOU9O7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 324E6606A31E;
	Wed, 25 Nov 2026 16:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HxqOU9O7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DC9B1F000CA;
	Wed, 25 Nov 2026 16:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623568;
	bh=45QzGUlzmrvzOeISQibImwhvKYeMBb4PbEJhglYfTJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HxqOU9O7kKS0KSibhUMiTHVIlAyaHmujd7A47E6pf/zv5U1/iCymHPHbc92EjuzrB
	 K891eIB8Z/Q6eZMxa1Q0wTFyOajyFCDoUIvIjssQrNCD14OXJIVyhxaglYic/k3zLt
	 QHO71ljh5zPzBHS0O5smK+LvOdVd/UT3FAbw2pFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.18 902/990] USB: serial: garmin_gps: fix deadlock on reset request
Date: Wed, 25 Nov 2026 15:37:49 +0100
Message-ID: <20261125143843.138439620@linuxfoundation.org>
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

commit ab89a9dab02d9553eb0cc27fd3e4a4998acbc8e9 upstream.

The garmin_gps driver has a reset feature that is supposed to reset the
device when writing a private reset request packet. The reset is however
done synchronously from the write() callback (and without holding the
required device lock) which leads to a deadlock in the line discipline
when hanging up the port as part of disconnect.

Switch to using the asynchronous reset interface while dropping the
redundant and synchronous stopping of the interrupt urb (write()
callbacks are supposed to be atomic and USB core, USB serial core and
the driver itself will unlink and kill all URBs during disconnect).

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Josef Bacik <josef@toxicpanda.com>
Link: https://lore.kernel.org/2026102733-prayer-drainer-56f3@gregkh
Cc: stable@vger.kernel.org
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/garmin_gps.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

--- a/drivers/usb/serial/garmin_gps.c
+++ b/drivers/usb/serial/garmin_gps.c
@@ -821,10 +821,9 @@ static void priv_status_resp(struct usb_
  * Garmin specific driver functions
  ******************************************************************************/
 
-static int process_resetdev_request(struct usb_serial_port *port)
+static void process_resetdev_request(struct usb_serial_port *port)
 {
 	unsigned long flags;
-	int status;
 	struct garmin_data *garmin_data_p = usb_get_serial_port_data(port);
 
 	spin_lock_irqsave(&garmin_data_p->lock, flags);
@@ -833,13 +832,8 @@ static int process_resetdev_request(stru
 	garmin_data_p->serial_num = 0;
 	spin_unlock_irqrestore(&garmin_data_p->lock, flags);
 
-	usb_kill_urb(port->interrupt_in_urb);
-	dev_dbg(&port->dev, "%s - usb_reset_device\n", __func__);
-	status = usb_reset_device(port->serial->dev);
-	if (status)
-		dev_dbg(&port->dev, "%s - usb_reset_device failed: %d\n",
-			__func__, status);
-	return status;
+	dev_dbg(&port->dev, "%s - usb_queue_reset_device\n", __func__);
+	usb_queue_reset_device(port->serial->interface);
 }
 
 


