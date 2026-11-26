Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704721;
	b=yzUrXFgmM37I7Y0t9oUl0VHIPBlfKMQXSsQ3QhsFyhFAo7Vz1CHBpEzzoz3Ff/OdUJvj
	 tGPIDPg14q8KD6/8u9bbr3yQD80JEkO5MiRBQUhnAwnSI39HTwBnU+ajFqYOulXQEECxT
	 72pTxGuEV1VPUmu15cnvCSViL7F61SSLfdFwR7K3ErvM/VonJCiV8Kd89JBkhPoKlX21M
	 bBOar6LTelwVybQAc8IIo139DjTj/l4RxOVKDyDftDvNN8fIhaDhmOQFVVxEE0ZyrODVa
	 JPWKElnTe4YUXgl8dfOX2DWs/2QwP4nEf1GShRkmfM043iV9zOPqSGTilFi2aXnSWGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704721;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+3y1ym9e9b+wlSDfAhOyz3lnb1zaz9krx+4l0MaWpdo=;
	b=TLp6NzEypf/nPk4h35Exf42gQnblOKcUItWlfnogGAJzxKZeXGe0QRTZUkj0E7Gx8XyG
	 0sdOzAbe04OyKYqBBgTuG0TC9k8t/rfpgDd6Qhf9O//1fHVxJXLdFpozmqAhaflBvJorI
	 22ObOZYz7im0Fr7rDZcVVUR2/RvJ0UFk4iMfIs7/vXeyiTh0dRhf98miViz8eDnoiAzRs
	 W6OnyItwWbETDxT5Q+z/kWAuooGf/PS8KlBlgpCBQMx84R80AgOlCfhta2BanEzgMy9jY
	 EoGeBPBE/8srB2/VtmttIkDeUH7A/RWsyB6CEtuxtUF/GayZqYUMMHal7LXJ77NGjtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y1Bgyt3D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C0F2606A321;
	Thu, 26 Nov 2026 14:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y1Bgyt3D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 990831F00A00;
	Thu, 26 Nov 2026 14:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704720;
	bh=+3y1ym9e9b+wlSDfAhOyz3lnb1zaz9krx+4l0MaWpdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y1Bgyt3DPUnPCoy5WEp79qN2k2dT25N0nex5o62oavLIxzWEvG+kuuPFmASc4KprM
	 L8Ph5e+Ch8z385dNpW3z2ymV8Qn3TeNI1LERfneo730C22WnEY04HqgWftrIXNbOOq
	 kql5Ux68ooZ7qmbSzTeUpxPwrXJedgihRArlkwls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 220/265] USB: serial: garmin_gps: fix deadlock on reset request
Date: Thu, 26 Nov 2026 15:39:10 +0100
Message-ID: <20261126143620.632137384@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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
@@ -822,10 +822,9 @@ static void priv_status_resp(struct usb_
  * Garmin specific driver functions
  ******************************************************************************/
 
-static int process_resetdev_request(struct usb_serial_port *port)
+static void process_resetdev_request(struct usb_serial_port *port)
 {
 	unsigned long flags;
-	int status;
 	struct garmin_data *garmin_data_p = usb_get_serial_port_data(port);
 
 	spin_lock_irqsave(&garmin_data_p->lock, flags);
@@ -834,13 +833,8 @@ static int process_resetdev_request(stru
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
 
 


