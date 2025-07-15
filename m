Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B232E62CF;
	Tue, 15 Jul 2025 13:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586986; cv=none; b=ciqBJSthLVxX2I0zJ5PbiWDUsZwM8xDeP8tU/RAUdhE49nX8WETSEjssLFdlUPPiFggNsmHSqXURWzAI6yBWhLlBKXFdx/lJfcQk35ldr/39jzC8z/+xsqQnDmj1j2gYkA13adDRe0SMBl6BLIgbts6pAXy1TMewILxkEJWzZd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586986; c=relaxed/simple;
	bh=LOT6fMaHD1m5HnJ3ecY6h1xzPWp2suB8OuShk7PtQ4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hvk0wmGY+1C9+MuNxc/I0HopIoHe+tletP4QsMgTmwPBpfQekNuHtv2W0fhKaRvvmCHzxSAAW5My2niuhl0w/3zCk3d/EejX2AADrod6VpONlK3WnivUQ/o4pooYhq7vmwwlcMNlGxh4Tq0xrQiR6FDT8fAfEQyFIAcnKKQYkHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WBp95nIc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WBp95nIc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 583A9C4CEE3;
	Tue, 15 Jul 2025 13:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586986;
	bh=LOT6fMaHD1m5HnJ3ecY6h1xzPWp2suB8OuShk7PtQ4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WBp95nIcjo/9hDQTJK0iEt+vFBD0fGnIx/FjtSQYrOQMR6GYkRr6r4nYYDJmMB5O7
	 uZGRBBSy8R85foKwKv4eRmEVNWutp5Hmxvw0R2NiRGMryF85vEGP+kVWa1s/9W5GFS
	 d8WBA3LgTz27vYIriqodYWizRcp2mOWMjwDm10ok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Kuen-Han Tsai <khtsai@google.com>,
	Prashanth K <prashanth.k@oss.qualcomm.com>
Subject: [PATCH 6.15 092/192] usb: gadget: u_serial: Fix race condition in TTY wakeup
Date: Tue, 15 Jul 2025 15:13:07 +0200
Message-ID: <20250715130818.598766572@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuen-Han Tsai <khtsai@google.com>

commit c529c3730bd09115684644e26bf01ecbd7e2c2c9 upstream.

A race condition occurs when gs_start_io() calls either gs_start_rx() or
gs_start_tx(), as those functions briefly drop the port_lock for
usb_ep_queue(). This allows gs_close() and gserial_disconnect() to clear
port.tty and port_usb, respectively.

Use the null-safe TTY Port helper function to wake up TTY.

Example
  CPU1:			      CPU2:
  gserial_connect() // lock
  			      gs_close() // await lock
  gs_start_rx()     // unlock
  usb_ep_queue()
  			      gs_close() // lock, reset port.tty and unlock
  gs_start_rx()     // lock
  tty_wakeup()      // NPE

Fixes: 35f95fd7f234 ("TTY: usb/u_serial, use tty from tty_port")
Cc: stable <stable@kernel.org>
Signed-off-by: Kuen-Han Tsai <khtsai@google.com>
Reviewed-by: Prashanth K <prashanth.k@oss.qualcomm.com>
Link: https://lore.kernel.org/linux-usb/20240116141801.396398-1-khtsai@google.com/
Link: https://lore.kernel.org/r/20250617050844.1848232-2-khtsai@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/u_serial.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/gadget/function/u_serial.c
+++ b/drivers/usb/gadget/function/u_serial.c
@@ -295,8 +295,8 @@ __acquires(&port->port_lock)
 			break;
 	}
 
-	if (do_tty_wake && port->port.tty)
-		tty_wakeup(port->port.tty);
+	if (do_tty_wake)
+		tty_port_tty_wakeup(&port->port);
 	return status;
 }
 
@@ -578,7 +578,7 @@ static int gs_start_io(struct gs_port *p
 		gs_start_tx(port);
 		/* Unblock any pending writes into our circular buffer, in case
 		 * we didn't in gs_start_tx() */
-		tty_wakeup(port->port.tty);
+		tty_port_tty_wakeup(&port->port);
 	} else {
 		/* Free reqs only if we are still connected */
 		if (port->port_usb) {


