Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623692;
	b=OipbmXEooba6hGL+LwrsFWgp6j3DXzkJpDZQLn4gqGt453xFEOWUPQUONqpmoMQkAQrC
	 WyiUULR/vLJ9c9qr274vJIVIrLyHLOvLFPGXpvLMOZ/Etl5GbnRI3vR1uMOsiE0pX8wtj
	 C73ubshVl6qPBjzzkAsDuqRazwcc8VNInHj5jJJ/ZxGT8V/ax/dt1ywx1tFqWQeW7ANVW
	 DuykXeWsg3zEjAIYDYtWNzMWFLc8MDStKPg4GMDa8sgTxLZDbT7RhJQNYqwjCurWCAc31
	 6v9eqwyKsTKQBxMMsoATISmxp5Vd4NnIy3Z9HXE9gtyiKdCVhlMMNYWaKZ/5K9n/jTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623692;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V7TO5DxkLbTG/cBpLzQYi1SuR7/WT4xM850Rr37RvH0=;
	b=AeaKYK7Xrfx5KPfbaZ2pjuiA5HLR2Bu8twVvEduatDrjaPrR+0V6TO6HiegkliYID4Zq
	 WrOM1JsOgiBLksBqBHdfyE/fIMFV/wHKXoGxZtkCPG7SpQ4s5Mnu642H0AwsljYIC2a5M
	 hjn3Wywl+nOAstLFNqsPakdjCxjVh9XR3yyqL/7994g0aciG51ySUMd8ymQZXOi96s24T
	 5B9nXB2Py14Jbe2LbIo46QI5O1Lq8gjohanhqLOvX6JKpF0mGq3KvW6E0bBqYI6SAdV6F
	 +osT1cKYv1vxCvetk1gpqcQ7eE0k7FdC+NcOLbDTT9ftkBY+d3Bl5Ucro976hzeN9/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0RrSVMls;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD4A606A327;
	Wed, 25 Nov 2026 16:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0RrSVMls
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED41E1F000CF;
	Wed, 25 Nov 2026 16:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623691;
	bh=V7TO5DxkLbTG/cBpLzQYi1SuR7/WT4xM850Rr37RvH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0RrSVMls5NZxxcbEpHTnaZju6PxQqu+R3ZSoB//COEZrh87WRqbsgc6G8Y87P15x6
	 l+OQvcZCliCl0vnEbwsAgSg7NmlJGDlJ16iC9AKKOI+kjAIuC0uD2iWfBj2Pf6E8F7
	 WnnhIEhrfAkDLO6THTxItmvUOkn3H6CPmj6NgKpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.18 941/990] USB: serial: io_edgeport: fix potential use-after-free on disconnect
Date: Wed, 25 Nov 2026 15:38:28 +0100
Message-ID: <20261125143844.033650173@linuxfoundation.org>
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

commit 50613e6380db7a904ef15c60ed0c436baf308f0a upstream.

The driver submits command URBs asynchronously but fails to stop them on
disconnect, something which could lead to a use-after-free when
accessing driver data in the completion handler after a port has been
unbound.

Add an URB anchor to track and kill outstanding command URBs on
disconnect.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/io_edgeport.c |   19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@ -225,6 +225,7 @@ struct edgeport_serial {
 	__u8			rxStatusParam;			/* the receive status parameter */
 	__s16			rxBytesRemaining;		/* the number of port bytes left to read */
 	struct usb_serial	*serial;			/* loop back to the owner of this object */
+	struct usb_anchor	cmd_anchor;
 };
 
 /* baud rate information */
@@ -261,9 +262,6 @@ static const struct divisor_table_entry
 	{   230400,	1},
 };
 
-/* Number of outstanding Command Write Urbs */
-static atomic_t CmdUrbs = ATOMIC_INIT(0);
-
 
 /* function prototypes */
 
@@ -776,11 +774,6 @@ static void edge_bulk_out_cmd_callback(s
 	struct device *dev = &urb->dev->dev;
 	int status = urb->status;
 
-	atomic_dec(&CmdUrbs);
-	dev_dbg(dev, "%s - FREE URB %p (outstanding %d)\n", __func__, urb,
-		atomic_read(&CmdUrbs));
-
-
 	/* clean up the transfer buffer */
 	kfree(urb->transfer_buffer);
 
@@ -2127,24 +2120,21 @@ static int write_cmd_usb(struct edgeport
 	if (!urb)
 		return -ENOMEM;
 
-	atomic_inc(&CmdUrbs);
-	dev_dbg(dev, "%s - ALLOCATE URB %p (outstanding %d)\n",
-		__func__, urb, atomic_read(&CmdUrbs));
-
 	usb_fill_bulk_urb(urb, edge_serial->serial->dev,
 			usb_sndbulkpipe(edge_serial->serial->dev,
 					edge_serial->bulk_out_endpoint),
 			buffer, length, edge_bulk_out_cmd_callback, edge_port);
 
 	edge_port->commandPending = true;
+	usb_anchor_urb(urb, &edge_serial->cmd_anchor);
 	status = usb_submit_urb(urb, GFP_ATOMIC);
 
 	if (status) {
 		/* something went wrong */
 		dev_err(dev, "%s - usb_submit_urb(write command) failed, status = %d\n",
 			__func__, status);
+		usb_unanchor_urb(urb);
 		usb_free_urb(urb);
-		atomic_dec(&CmdUrbs);
 		return status;
 	}
 
@@ -2696,6 +2686,7 @@ static int edge_startup(struct usb_seria
 
 	spin_lock_init(&edge_serial->es_lock);
 	edge_serial->serial = serial;
+	init_usb_anchor(&edge_serial->cmd_anchor);
 	usb_set_serial_data(serial, edge_serial);
 
 	/* get the name for the device from the device */
@@ -2900,6 +2891,8 @@ static void edge_disconnect(struct usb_s
 {
 	struct edgeport_serial *edge_serial = usb_get_serial_data(serial);
 
+	usb_kill_anchored_urbs(&edge_serial->cmd_anchor);
+
 	if (edge_serial->is_epic) {
 		usb_kill_urb(edge_serial->interrupt_read_urb);
 		usb_kill_urb(edge_serial->read_urb);


