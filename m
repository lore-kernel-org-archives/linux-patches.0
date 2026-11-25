Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626226;
	b=jKEg7+EOkgvOpsbfrxVAu2LkbwMjglv7EVxLZC/ZSatxtwkog8NDRL9/v4yPvneaIDfi
	 XohxpfPFum7EvOT2GcjzF4X5WcE/pSLSf7jYGG16U+2O+L479RbQa9CmXCv8rhxscnY97
	 nlFn6D+zvqcx8OHz9AmPn6C5sB1rKHNzNgYRc2P5QK50x5N+YS1MscpUsAoY5G+IID9ff
	 eJ4+MJGwuilC8U01EEmfnfj7hXr9gRcAJCaz6rRgwv5ekEsfE5T456FQw2GhjO+6XNaFZ
	 Um3XHM7LsMfHQObK4Tlo+ZBHifZWjrhWbRl+LR5rRqxVy7TULeoGENxznow6WNye+Xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626226;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=37S+Kc42Lf9C2TTvvKYyrNxn2T593AUoc7EzfYrf0U0=;
	b=DD2qrUO5X5CULCU6/X9y/SUsCJ0Y4ilnja6DzVv18RouhP0jC+MZzdmIBRo8RwKklSM7
	 Er+DlfBSqGnLm5hfWJfJSGHrRpLAkLP6ZHMJktqfqsS4UgVFWhTZ3MAHZT1visU/A0Npz
	 ukjuQ7b4JkUzGTqhJP5c++BlSaMXlHygv4ssIg2tZisgpBObvjr67+iylrRkgUQuZIE2Z
	 rpWvHJyuJamfPWs4J2X4fNCFGNV+Y4Ry72QSkPeiQT9l1EPCCC9Argm36HbYpMEnRweDB
	 5M6NrsLyxWSZgizdBRDbac3t+57cNOoukOGg/bO0jWWGoiTVcu32XDtOmLaqZYsDYEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LaHswXD5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF8D606A327;
	Wed, 25 Nov 2026 17:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LaHswXD5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D2C21F000C0;
	Wed, 25 Nov 2026 17:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626226;
	bh=37S+Kc42Lf9C2TTvvKYyrNxn2T593AUoc7EzfYrf0U0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LaHswXD5n3xND3ZJ9MXS92K3AJi5y7t+gXP3fin9HMR2h/LI8QtyDhlC5kicT3VqG
	 XcWeqa4f+4mmmFQ3zFt1W7uTEynILrgap5cVpGNBWfxRGBhXKbcWQONWoGpRY1rjeH
	 lOogKH8jsGdf6pQrxAl2K16JEyDbhI1sMyTr0ur4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.12 774/816] USB: serial: io_edgeport: fix potential close() use-after-free
Date: Wed, 25 Nov 2026 15:38:42 +0100
Message-ID: <20261125143907.087692268@linuxfoundation.org>
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

commit 839ff5fa30995c40cd5fba15fd976ad63416738a upstream.

Add the missing open check on write() and locking when updating the port
status during close() to prevent a racing interrupt completion handler
from trying to submit more data for the port while its write URB and
FIFO are being deallocated.

This issue was flagged by Sashiko when reviewing a related fix.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Link: https://sashiko.dev/#/patchset/20260714101316.823942-1-shpark061104%40gmail.com?part=1
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/io_edgeport.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@ -1085,7 +1085,9 @@ static void edge_close(struct usb_serial
 
 	/* port->close = true; */
 	edge_port->closePending = false;
+	spin_lock_irq(&edge_port->ep_lock);
 	edge_port->open = false;
+	spin_unlock_irq(&edge_port->ep_lock);
 	edge_port->openPending = false;
 
 	usb_kill_urb(edge_port->write_urb);
@@ -1127,6 +1129,12 @@ static int edge_write(struct tty_struct
 
 	spin_lock_irqsave(&edge_port->ep_lock, flags);
 
+	/* avoid accessing freed fifo if tty_wakeup() races with close() */
+	if (!edge_port->open) {
+		spin_unlock_irqrestore(&edge_port->ep_lock, flags);
+		return 0;
+	}
+
 	/* calculate number of bytes to put in fifo */
 	copySize = min((unsigned int)count,
 				(edge_port->txCredits - fifo->count));


