Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07C07275103;
	Tue, 15 Jul 2025 13:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585551; cv=none; b=c+b6aKu76HExySCVUjCAKDREx3LJJ1estJTT6gg1QXE/BG8ydAwWKEw+MM+SQ8Ln/u1kIxUKYhyVw609xDFSbBUNaQQq88+Ynkt/FqiwhYjXLpyQLGZV2+7DGSYe/YSsYdyOLCHRbEkN/ic1rwjOCINwAtgXp1zz/khS+j9xgo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585551; c=relaxed/simple;
	bh=d/AYu+TMC/R0tkPU2UW+uQDpz95USbEfaaFtrctDhKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=et/SUd9ew+IjVhj/0ojI3/1si5kmTGOdYOQoO2wSBaqw6OLG3LOUyF0mUSnO+1/ywPGN0H7nwOiFNgQR1F5E8eTmGibMuxxG3fjCbzJys0V518kU/bNP2hVTRIOsZmVXIuMB4K1bW19tbxRamIw5Ftua/dfQpKmgbctdrS9GkUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yxDyDMmV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yxDyDMmV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D484C4CEE3;
	Tue, 15 Jul 2025 13:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585550;
	bh=d/AYu+TMC/R0tkPU2UW+uQDpz95USbEfaaFtrctDhKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yxDyDMmVfInLnPcgU6tSTlq/BlxaVzEDQbayFdOytpFTT/tUPR7zMgSb4JUJe6Nfw
	 Te/9t4t3PoaM8GRoaAM0wewm6LtO9TObwS+FwKSvZZnd3gojIvMGhtNHkTH2tiH02f
	 5Q91vE+D1uj8PuoQHPh5qtwtTTib3pWzRJ9UkB5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Kuen-Han Tsai <khtsai@google.com>,
	Prashanth K <prashanth.k@oss.qualcomm.com>
Subject: [PATCH 6.12 081/163] Revert "usb: gadget: u_serial: Add null pointer check in gs_start_io"
Date: Tue, 15 Jul 2025 15:12:29 +0200
Message-ID: <20250715130811.981172951@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuen-Han Tsai <khtsai@google.com>

commit f6c7bc4a6823a0a959f40866a1efe99bd03c2c5b upstream.

This reverts commit ffd603f214237e250271162a5b325c6199a65382.

Commit ffd603f21423 ("usb: gadget: u_serial: Add null pointer check in
gs_start_io") adds null pointer checks at the beginning of the
gs_start_io() function to prevent a null pointer dereference. However,
these checks are redundant because the function's comment already
requires callers to hold the port_lock and ensure port.tty and port_usb
are not null. All existing callers already follow these rules.

The true cause of the null pointer dereference is a race condition. When
gs_start_io() calls either gs_start_rx() or gs_start_tx(), the port_lock
is temporarily released for usb_ep_queue(). This allows port.tty and
port_usb to be cleared.

Fixes: ffd603f21423 ("usb: gadget: u_serial: Add null pointer check in gs_start_io")
Cc: stable <stable@kernel.org>
Signed-off-by: Kuen-Han Tsai <khtsai@google.com>
Reviewed-by: Prashanth K <prashanth.k@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250617050844.1848232-1-khtsai@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/u_serial.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/usb/gadget/function/u_serial.c
+++ b/drivers/usb/gadget/function/u_serial.c
@@ -543,20 +543,16 @@ static int gs_alloc_requests(struct usb_
 static int gs_start_io(struct gs_port *port)
 {
 	struct list_head	*head = &port->read_pool;
-	struct usb_ep		*ep;
+	struct usb_ep		*ep = port->port_usb->out;
 	int			status;
 	unsigned		started;
 
-	if (!port->port_usb || !port->port.tty)
-		return -EIO;
-
 	/* Allocate RX and TX I/O buffers.  We can't easily do this much
 	 * earlier (with GFP_KERNEL) because the requests are coupled to
 	 * endpoints, as are the packet sizes we'll be using.  Different
 	 * configurations may use different endpoints with a given port;
 	 * and high speed vs full speed changes packet sizes too.
 	 */
-	ep = port->port_usb->out;
 	status = gs_alloc_requests(ep, head, gs_read_complete,
 		&port->read_allocated);
 	if (status)


