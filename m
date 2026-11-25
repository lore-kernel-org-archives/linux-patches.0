Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620435;
	b=fmSoKUSyc3DHz796xkIEp7ALfp3onO/L6ADCs6GuJKiUouWrrgKrIK2nI7tSOkEYr1ly
	 Wx49n6lp734z9kdQUQCxFUtz2afz1ZQFVDcHB0LeOOsEUeGdOqloIsAjBdpH3AK/AcGbS
	 IxSfVE/JPF6tXgXAxvsW3L5V5PwTzkdKccf9zPmaAqIzCe4rzFnuzaCxfTfhzPk0NhkWk
	 4NfL9JEJVk3JFeZoMq314Dk8cKH+KdfenhSBzMSXxUdZYrbr3YSESEWECqUzRNoOWuzVg
	 ndu8Gyhr+PfRM9nfh6DQXVDAa07HpKhQwEgjdpvMmxmrtS4/mmdbkLw+87ZPfKIqiEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620435;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EXbrC4MprlhS0EYU9GoX5XzitpoHmPiSRticwmPqaW8=;
	b=RLbZ3wHdzaINFiXb5jZBKKiFcHhqCeirrbY9Eo5ZPcNNvHWx8SCeRkQkncv+5/Ugjypf
	 sDGBySkE3R53ND0emnzCisgHxTWw5w+TGJhGjlw3hwkbx8bD7OOKUef7VkX/dB62+iAdS
	 bN2gc7gW98YVZBk0lDbPHY+vFEZ5BYJUx2YlATavNx7i9RFjTA1zQcswO9YmH1f7gpD5H
	 Kxk17ARy19tX3EhmXCdBYWTje0fXgzZR+g8xN05wXCeyyzp9vXd7hPEe7wSCJkxOcxF81
	 oMKWniA0U+8S4e1g7dp/gLk2+K+EH/bgIiPsDA89OeSMKmRVjiCxQFzmbUJRoZED3ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OwtQviuL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9647606A321;
	Wed, 25 Nov 2026 15:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OwtQviuL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F31A1F000D3;
	Wed, 25 Nov 2026 15:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620435;
	bh=EXbrC4MprlhS0EYU9GoX5XzitpoHmPiSRticwmPqaW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OwtQviuL37VgYPT6KbkkACZsHxEhxv41k2hRN1imO/z4wNqFwwp49g2d/9NPfqiu9
	 7CCVuHYW2y8l73WnQMUG+EgQDhuOW2UenUQdOD9HZch5KOSOET6HDdiQPbe/wvlYiO
	 UYwp2D5F6LpGWiZ4dq48Qza6XvMoH0hor67tmnNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 7.3 0916/1005] USB: serial: garmin_gps: fix deadlock on reset request
Date: Wed, 25 Nov 2026 15:37:34 +0100
Message-ID: <20261125143843.149614853@linuxfoundation.org>
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
@@ -818,10 +818,9 @@ static void priv_status_resp(struct usb_
  * Garmin specific driver functions
  ******************************************************************************/
 
-static int process_resetdev_request(struct usb_serial_port *port)
+static void process_resetdev_request(struct usb_serial_port *port)
 {
 	unsigned long flags;
-	int status;
 	struct garmin_data *garmin_data_p = usb_get_serial_port_data(port);
 
 	spin_lock_irqsave(&garmin_data_p->lock, flags);
@@ -830,13 +829,8 @@ static int process_resetdev_request(stru
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
 
 


