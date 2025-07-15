Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46CC92EB5A6;
	Tue, 15 Jul 2025 13:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586589; cv=none; b=SnXp66M4LavG9nL+6POM3ETorEjturBangeV9OsI7X2TiOAyN9GZRHhQtgfrl/YvXzV1zzfsiRvnk/zopQ9nr3f11fctcpZGq6tD0KRymX/yWZ7bCwr3wDZ3xvMjygN2+T6KBsGPLO6ticazrGiFNAeLIe9eZAk0+CH11fsm7nE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586589; c=relaxed/simple;
	bh=1XLaTBSZZgHPe2uhaoBGsweHHQMr9asMCTADyBeGoAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X5Jaxuqifi2cXUU/Crs+WKFvsQUPqWJP+zxVPHnnU9HY7BfSGLl7UQGfSJrqnvtlblpSN/UeHXwHxjPwXnwg4koTcVikYPmJ3S0ewsLXSccoy5C/8EdpXyByC9ecK7/8g0dwuzng9V66d4s74heE9xN9MlDj2tzBM6dGHtaGiDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2aZOpKlX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2aZOpKlX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE0A7C4CEE3;
	Tue, 15 Jul 2025 13:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586589;
	bh=1XLaTBSZZgHPe2uhaoBGsweHHQMr9asMCTADyBeGoAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2aZOpKlXAZpYlMgJ++w2Byd75ZdWsp2IoRblAG0BOz+JVGuJzFuGquYQ/Z43/HHTz
	 C2LyJQrK284cCIu68590BVMidAGanFRYdxxb35Fjcri+yhBp3ytvc6ZkIa4faesdll
	 IW2EinVrbqpbgWzMxF3aPY2mVgvxsTynrwJ8RJso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Kuen-Han Tsai <khtsai@google.com>,
	Prashanth K <prashanth.k@oss.qualcomm.com>
Subject: [PATCH 5.4 122/148] usb: gadget: u_serial: Fix race condition in TTY wakeup
Date: Tue, 15 Jul 2025 15:14:04 +0200
Message-ID: <20250715130805.184504920@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -286,8 +286,8 @@ __acquires(&port->port_lock)
 			break;
 	}
 
-	if (do_tty_wake && port->port.tty)
-		tty_wakeup(port->port.tty);
+	if (do_tty_wake)
+		tty_port_tty_wakeup(&port->port);
 	return status;
 }
 
@@ -564,7 +564,7 @@ static int gs_start_io(struct gs_port *p
 		gs_start_tx(port);
 		/* Unblock any pending writes into our circular buffer, in case
 		 * we didn't in gs_start_tx() */
-		tty_wakeup(port->port.tty);
+		tty_port_tty_wakeup(&port->port);
 	} else {
 		/* Free reqs only if we are still connected */
 		if (port->port_usb) {


