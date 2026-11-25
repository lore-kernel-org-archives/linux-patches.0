Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626125;
	b=y3f3JeO2gWDC4NpMqUkWDrs3ulij60NJtBqNoUN4U+RjSV3ON1wxNsD0nb1Pd6avwOXQ
	 nMLjUHTWZj7vEJoehqpv+V8mMh0USQwdlJU6LUFespAM1jliNsac8loHAyYZ9XbgY1UND
	 EnrDgc6oAQaD8w8foNZ2e3GHZECsL4mKoF5/uxp4BHsXp++1eoSzcqt9y3H0S+sfB5fN9
	 eokKFn/MM9sxfYEEzLFRgxVazb7L0UEro6NjNtyXbds1puyjRFRLBegokNH7HHDgXTNk6
	 Egm+diSWQeGvS/D1HLlYM4f8uOI7hgohYv7VsBnIxdbv8bWRg81p5wrTgiz+gAp6gqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626125;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CdGlavCUzMbF6dEQ0OhmDK9zmmUjUfC/Yun8Am7R/W8=;
	b=PAFEzOE4mIJajBD3AdgGyFL+9QhYD6Q9NwTyopCG45HKAbGGtS0WZIXiWHa1u3etkoDF
	 GFacAws6p4YCo8d/TQpoNKAJ+kavZ84MiZNUUL6i0Bfb+xaIeM7l6Wa2LBITkfvQWMLuA
	 G5u78WRLa9AHd+BdoGTtH++EUiBeTcLFv2UaTqcoebXDwF38qdmJq0SuhC4+63OA0QEUI
	 /7gsUoa33yaBMWRmIQ4/D61JUMKQNFfDg6Q2UjaIvEEDP2Fr7ApeFmXK16Pm5DnlU6IYz
	 GSchLi4fF94nYg8XKzhoO10DHo6WVqW8GUonSia+rqH79sjLH76Y3mqLgynPUKqukJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vIsKVhPV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10773606A323;
	Wed, 25 Nov 2026 17:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vIsKVhPV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 604EF1F000CA;
	Wed, 25 Nov 2026 17:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626124;
	bh=CdGlavCUzMbF6dEQ0OhmDK9zmmUjUfC/Yun8Am7R/W8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vIsKVhPVpfbH2l3lJVJF+nSDkHvSsgAWY4O7jppAIVVM+DHDYNyi+ggiKW+KmbZXj
	 y9Zw8Sjaykd0fFjWzgwyk5pKSl7Ul2xdATU5Oa1EtX0N2k7JHuqecHpoikcbTC/9Gs
	 05QmxXhkE9rNp6RvopbUs0FEIopZf2ouJnDhh6PQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.12 739/816] USB: serial: garmin_gps: fix deadlock on reset request
Date: Wed, 25 Nov 2026 15:38:07 +0100
Message-ID: <20261125143906.285622804@linuxfoundation.org>
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
 
 


