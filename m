Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704724;
	b=QPJJk+K1Rqzjxre/Ht3xm9x8xChU3rullW86vaRLfY+fTj0RQ7AZHk+bvCLte0x0V+6v
	 v6TU3qVWRnm7WH75WzrC2HZm8TZT8jvh+CyGaFN+lyvzbMlYNYqjRNPB1CucdX2IwErkq
	 nnYAWoKCIRa/Sy1HZARPbjSeVQcPAsCEiHh3t8Z6BWBa9AfGUbGMpJ1uzH0r/5vTc4gH7
	 H+P7DsNV1vpyONo5ygvI6IF3iUUuS5JyoAD69PT8/VRXkODa42lUY5l/nNz4uaeMeZJOq
	 O6eJnZxByVq3har1Ynh2DBzsu32dN2myKjkvQvF+GbKGuOv3fnRkuErYQEBZFBs5UdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704724;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6YYJIjgl9altfYY9RmwtWs6pHNiSygSmHMfR2QaDlUQ=;
	b=YEAtoIhKma+e/abOezwDDCDpd6vqhS9ufUbZ64ZBqdi9lVJ/nYfh4eWA7UNC75uKXd5a
	 8623OqcJG/oe05AmgVdm3YCzGg/wGYSWGYVo5M87L9mxD2tXOZ3PNATkqwZIk8rZNqL8P
	 GXs61/O6/vS7fTDaByY2RSrSN2fV+I/GwXHfc8b3yXUtG6mvfsPY/y9dXuqLlZv4+48v/
	 k5p1ey1Kk+exMhJ3TbqhxLe61CJ0M5guqczh8cTpOTpOv3GzA7pGSaVNE9vlG0tSsVfQQ
	 LTMMI9LUMyIVEaEG8btsXGczw4O8aZDMJkcULjmcljjCSMFy7BelONX1l7h0dKii1hA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HrElZWZ7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A66606A31C;
	Thu, 26 Nov 2026 14:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HrElZWZ7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 776761F000EE;
	Thu, 26 Nov 2026 14:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704723;
	bh=6YYJIjgl9altfYY9RmwtWs6pHNiSygSmHMfR2QaDlUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HrElZWZ7qdLj3xW+9NzTjpbgTRehaHXcuabtg3PtB5wnE0PySLWJF/irjb9XxsSsB
	 6CN/E6GasigwAYw7fvy+dYJe8ieNy+EWpO5grFP86u4/mEXroH+SX9/ZV7mxX7AN98
	 zZJ24zStpAEHd4+MUz/Fj4vfY80c33hk+TumuoC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 5.10 221/265] USB: serial: oti6858: fix the teardown order in close
Date: Thu, 26 Nov 2026 15:39:11 +0100
Message-ID: <20261126143620.688699105@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

commit f184ae84a5d19554d980a918a9c8baaef87ac301 upstream.

The driver passes a baton around: the completion handler of the
interrupt urb either resubmits the urb, submits the read urb or
schedules one of the two delayed works, and the works and the bulk
completion handlers submit the interrupt urb again.

oti6858_close() cancels the works first and kills the urbs afterwards.
An interrupt urb that completes in between schedules a work again:

	oti6858_close()
	  cancel_delayed_work_sync(setup)
	  cancel_delayed_work_sync(write)
				oti6858_read_int_callback()
				  schedule_delayed_work(setup)
	  usb_kill_urb(interrupt_in_urb)	/* not in flight */
				setup_line()
				  usb_submit_urb(interrupt_in_urb)

The port is now closed with the baton still going round. The next open
fails because the interrupt urb is already submitted, and if the device
is unplugged, oti6858_port_remove() frees the private data while a work
may be pending or running.

Poison the interrupt urb first: that waits for the handler and makes all
further submissions fail, so nothing schedules the works any more. Then
cancel the works, after which only the bulk urbs are left, kill those,
and make the interrupt urb usable again for the next open. Don't print
an error for the submissions that fail with -EPERM in this window, as
oti6858_read_bulk_callback() already does.

Fixes: 49cdee0ed0fc ("USB: oti6858 usb-serial driver (in Nokia CA-42 cable)")
Cc: stable <stable@kernel.org>
Cc: Johan Hovold <johan@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/oti6858.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/drivers/usb/serial/oti6858.c
+++ b/drivers/usb/serial/oti6858.c
@@ -251,7 +251,7 @@ static void setup_line(struct work_struc
 
 	dev_dbg(&port->dev, "%s(): submitting interrupt urb\n", __func__);
 	result = usb_submit_urb(port->interrupt_in_urb, GFP_KERNEL);
-	if (result != 0) {
+	if (result != 0 && result != -EPERM) {
 		dev_err(&port->dev, "%s(): usb_submit_urb() failed with error %d\n",
 			__func__, result);
 	}
@@ -303,7 +303,7 @@ static void send_data(struct work_struct
 
 		dev_dbg(&port->dev, "%s(): submitting interrupt urb\n", __func__);
 		result = usb_submit_urb(port->interrupt_in_urb, GFP_NOIO);
-		if (result != 0) {
+		if (result != 0 && result != -EPERM) {
 			dev_err(&port->dev, "%s(): usb_submit_urb() failed with error %d\n",
 				__func__, result);
 		}
@@ -566,6 +566,13 @@ static void oti6858_close(struct usb_ser
 
 	dev_dbg(&port->dev, "%s(): after buf_clear()\n", __func__);
 
+	/*
+	 * The interrupt urb schedules the works, and the works and the bulk
+	 * urbs resubmit the interrupt urb: keep it from being submitted until
+	 * all of them are gone.
+	 */
+	usb_poison_urb(port->interrupt_in_urb);
+
 	/* cancel scheduled setup */
 	cancel_delayed_work_sync(&priv->delayed_setup_work);
 	cancel_delayed_work_sync(&priv->delayed_write_work);
@@ -574,7 +581,8 @@ static void oti6858_close(struct usb_ser
 	dev_dbg(&port->dev, "%s(): shutting down urbs\n", __func__);
 	usb_kill_urb(port->write_urb);
 	usb_kill_urb(port->read_urb);
-	usb_kill_urb(port->interrupt_in_urb);
+
+	usb_unpoison_urb(port->interrupt_in_urb);
 }
 
 static int oti6858_tiocmset(struct tty_struct *tty,
@@ -831,7 +839,7 @@ static void oti6858_write_bulk_callback(
 	/* schedule the interrupt urb if we are still open */
 	dev_dbg(&port->dev, "%s(): submitting interrupt urb\n", __func__);
 	result = usb_submit_urb(port->interrupt_in_urb, GFP_ATOMIC);
-	if (result != 0) {
+	if (result != 0 && result != -EPERM) {
 		dev_err(&port->dev, "%s(): failed submitting int urb,"
 					" error %d\n", __func__, result);
 	}


