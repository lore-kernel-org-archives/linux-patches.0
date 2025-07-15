Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A0A1B4231;
	Tue, 15 Jul 2025 13:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586219; cv=none; b=kWQzPxSObT+wFPa4JLyNNunP1l3Ch2ea1j1QbJn3ZSl9DPK/3iMS8i60FHsif0xL/77dr2kW8zAUNqwJg8v1v8TovHpBAnfQdojx32f/kmwtLqedt2SSy43IUBSE3mXa7q0YeNWz764uXNXa8OixjyDNX3lYSFtCWPO6DrMOotE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586219; c=relaxed/simple;
	bh=g27ymKmGVlGV4h9k28ih/pK8lqhJ3IHutalOMG/e4KI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DLme59/yObejG4XOeTLXLAcfWj9Cp1pV3NVCbsz/Shf935vS9GsgpFdf5VeTpQU2jvN7lxDwkIXwabHbJ5v7q+FOrqzmoXwo7+wPyZOLLbMkMvqb9WiQTD7SpcrnI2oQ9u5X0dEG6cx9gyg0jsZokUiFwT87ZoSIBb/DamtabAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JkvdoFQ2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JkvdoFQ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 785C5C4CEE3;
	Tue, 15 Jul 2025 13:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586218;
	bh=g27ymKmGVlGV4h9k28ih/pK8lqhJ3IHutalOMG/e4KI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JkvdoFQ2Y5GxqTog92eyYej2SBqojwY928oHj4IzOJggGXl/flDRn+dR5sz6mKJz/
	 EanDVC9oRHzl7X1K+72guH3KLdxb05E8FDz6dUPJ/bee5WnBRNaHE8IkskUE/9dXNE
	 Ew/YL22BoQwD0PqqMeVSacDn9yPcbTQhFUH/73DU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Kuen-Han Tsai <khtsai@google.com>,
	Prashanth K <prashanth.k@oss.qualcomm.com>
Subject: [PATCH 5.15 33/77] usb: gadget: u_serial: Fix race condition in TTY wakeup
Date: Tue, 15 Jul 2025 15:13:32 +0200
Message-ID: <20250715130753.035907965@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130751.668489382@linuxfoundation.org>
References: <20250715130751.668489382@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -290,8 +290,8 @@ __acquires(&port->port_lock)
 			break;
 	}
 
-	if (do_tty_wake && port->port.tty)
-		tty_wakeup(port->port.tty);
+	if (do_tty_wake)
+		tty_port_tty_wakeup(&port->port);
 	return status;
 }
 
@@ -568,7 +568,7 @@ static int gs_start_io(struct gs_port *p
 		gs_start_tx(port);
 		/* Unblock any pending writes into our circular buffer, in case
 		 * we didn't in gs_start_tx() */
-		tty_wakeup(port->port.tty);
+		tty_port_tty_wakeup(&port->port);
 	} else {
 		/* Free reqs only if we are still connected */
 		if (port->port_usb) {


