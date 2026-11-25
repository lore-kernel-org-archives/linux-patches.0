Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626238;
	b=CfgFv8Vh8ndKQv8wtgnNukEmz1H3onnb1dYWmYkF5LWQMr6Pp7Ic0KhHr9HnfW0E/3O0
	 Civ99BiFwygcQoRDZFBqeuyjO2j7Y9+AeX80JlkjkvotNmU6f3iy/lKOn5N8bvjk0Khzo
	 nuFzbB4Sv4jgDYKBLbKisIOZmQIOE7sxnLeStgt6G2HklWVGDP0RnC/h1gE2JfpqXfR5X
	 fAYTZ0GqZ2mt2v0fhR6q/G4D/p70PS2wodl+Gyx6NzRluAonIEeADfN1VrZQSsCiP0KD2
	 8WtAlK8fnkZ6xraJCOdvABrbd9QueYgvRJpZZWAgHohQ5vUfC/OBGDzFczNtVQ7XQSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626238;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gY6lLYkw2fM3oKAU63rioSNU4FH0DzyjD7UY0IwHKOA=;
	b=JAUpHIReloC3v+sjLtJS5n5d3paEtTx/4BZs6r5QSMVeenXsAOUHWII6UfWhiZ0HeyL0
	 I+p7KSqhEgcqJj+KUhiyQ+FhGXIgScVuD92FcGRo8oIX7gEITPi0+EdnPDPbf7leyd20u
	 P3WXv/i4T2MaUhv1N8DblJlw9o6bszYtge8wfp94OFsAFKd2WjcVSPox438MTJogWg66N
	 UQ05SyhOGIwwpCRGul4Z30+jH1yrfqynJeikzYa5pksngl+jAcX//ydr7bG33zUBcHqpI
	 X8oOPxipf4KH3/EFtJRTwLLaHU2MPAiBC9a5XsE5umJr0ZBRV/9xtZfozFLty/w3hkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s+G6gFej;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33601606A684;
	Wed, 25 Nov 2026 17:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s+G6gFej
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 847901F000D0;
	Wed, 25 Nov 2026 17:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626238;
	bh=gY6lLYkw2fM3oKAU63rioSNU4FH0DzyjD7UY0IwHKOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s+G6gFejR5nZkNI4mqHgrf4DExMaR/saYFpDh8SN1767HwDwIgOn1dF1b0Z/g1bi8
	 p+6ICTZmSvZE8JTU0+TAntihQlD4qSRi6p8OG4MpU5BdCqII5msqU6bu+lgLmh2tTc
	 wpAQdy3jq8oapLrRVvVs0XOc8D8WiU1sOHkhJ5i0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.12 778/816] USB: serial: io_edgeport: fix potential use-after-free on disconnect
Date: Wed, 25 Nov 2026 15:38:46 +0100
Message-ID: <20261125143907.182528840@linuxfoundation.org>
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


