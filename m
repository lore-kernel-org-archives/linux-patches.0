Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620569;
	b=Ng1Q57cnPUQzzDzSu4K0ft4bSlyQLjWjNLWezA66//HQwKKvieFLiJgtskrW0sT6m3Cm
	 Xnggtuojz5QSMhJhvDjamfrhjtfT3JLslqjZZwnwS/jreDWLXEjBqBJKbbdIfUAgm+K92
	 GH5dfFZm3vpIidnxIr11xrKcUhbuakb8AwVLrFG3jZ8Ud1zgOo/0y/nfSVQcjFNE4PCKr
	 75s/2aGqivxsMO0hbC+m4WJvpA+fvWl8j2WZgP6tZ3CPa1A1TDYQcYw7wbbLvoA7ih1Nl
	 dcQQKrxG07dc6s2qe402R3wK2KAl7qfjPvFU4NLSqg4JzAp6YW16OrhVhkPO5we2lQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620569;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=49vF4k1HxLVT+2aUR+ugRLeo4XyhGyjJgbFKATzxu5Y=;
	b=dKqEg2DVE4BwA1E/ZiiH919NrikjANRR9bIRGFe6gD4FxvsQc9fvIF3tdLg9hs2bVX23
	 MUoQuWPcS6fCqlvbcaQIrGHBFHLQNh3sW/c8NspMKADLswFACRgjMSSkp713UPCW7KX+o
	 CcaRKEYaWOLzcpnAKp+IVJB3vs6PE7u2u/sps0iIlxxHwnvCKVBi1y+QVTiRxKP9fz1Lr
	 8uME3IK/GV5dSq6P/mB47oWXuqOPJLarBEgqOWmE8SOjE4yuQy6EUffzowckNAv2edG4p
	 9K7kuIuNiXs45tIIBYvIc/SJFDlWtGNiLX4XBAtV6Q2F/aqybG5OUwUWR+Qwwbh3NvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vy652Ue1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7550B606A31E;
	Wed, 25 Nov 2026 15:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vy652Ue1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 851071F000CF;
	Wed, 25 Nov 2026 15:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620569;
	bh=49vF4k1HxLVT+2aUR+ugRLeo4XyhGyjJgbFKATzxu5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vy652Ue1LIUn0taV/mmKKKj2VJYqEUdIHZ/L153JE2ryynIxXHrHAxuhdgfEk3Mr6
	 qzxl4X5TBNY+O2PiwOLbZH4R1Vt2eQ3WD4mvek8MUKd9H4vW+XBqAUl/GKQL2LeIct
	 yGlftj5nqIrwBW7gthj2aW2L6TXDx8YnZR98hMlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 7.3 0961/1005] USB: serial: io_edgeport: fix potential use-after-free on disconnect
Date: Wed, 25 Nov 2026 15:38:19 +0100
Message-ID: <20261125143844.181971872@linuxfoundation.org>
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


